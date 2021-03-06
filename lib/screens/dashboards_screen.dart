import 'dart:async';
import 'dart:convert';

import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/providers/dashboards_provider.dart';
import 'package:cogboardmobileapp/screens/home_screen.dart';
import 'package:cogboardmobileapp/screens/widget_list_error_screen.dart';
import 'package:cogboardmobileapp/screens/widget_list_loading_screen.dart';
import 'package:cogboardmobileapp/screens/widgets_list_screen.dart';
import 'package:cogboardmobileapp/widgets/dashboards_screen_bottom_navigation_bar.dart';
import 'package:cogboardmobileapp/widgets/filters_widget.dart';
import 'package:cogboardmobileapp/widgets/screen_with_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';

import '../main.dart';

class DashboardsScreen extends StatefulWidget {
  static const routeName = '/dashboards';

  @override
  _DashboardsScreenState createState() => _DashboardsScreenState();
}

class _DashboardsScreenState extends State<DashboardsScreen> with WidgetsBindingObserver {
  AppLifecycleState _notification;

  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings _androidInitializationSettings;
  IOSInitializationSettings _iosInitializationSettings;
  InitializationSettings _initializationSettings;

  bool _appResumedBySelectingNotification = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    notificationSetup();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _notification = state;
    });
    if (_notification == AppLifecycleState.resumed) {
      Provider.of<ConfigProvider>(context, listen: false).removeWidgetsInNotificationPayload();
      if (_appResumedBySelectingNotification) {
        CogboardApp.navigatorKey.currentState.popUntil(ModalRoute.withName(DashboardsScreen.routeName));
        _appResumedBySelectingNotification = false;
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 0), () {
      showHintDialogs();
    });
    ConfigProvider configProvider =  Provider.of<ConfigProvider>(context, listen: false);
    return configProvider.currentConnection == null ? Container() : Scaffold(
      body: FutureBuilder(
        future: configProvider.fetchConfig(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return ScreenWithAppBar(body: WidgetListLoadingScreen());
          } else {
            if (dataSnapshot.error != null) {
              debugPrint('api error ${dataSnapshot.error}');
              return ScreenWithAppBar(
                appBarTitle: AppLocalizations.of(context).getTranslation('dashboardsScreen.boardError.title'),
                body: WidgetListErrorScreen(
                    message: AppLocalizations.of(context).getTranslation('dashboardsScreen.boardError.apiError.body'),
                    refresh: () {
                      setState(() {});
                    }),
              );
            } else if(configProvider.webSocketConnectionErrorPresent) {
              debugPrint('websocket error');
              return ScreenWithAppBar(
                appBarTitle: AppLocalizations.of(context).getTranslation('dashboardsScreen.boardError.title'),
                body: WidgetListErrorScreen(
                    message: AppLocalizations.of(context).getTranslation('dashboardsScreen.boardError.websocketError.body'),
                    refresh: () {
                      startWebSocketListening(context);
                      setState(() {});
                    }),
              );
            } else {
              startWebSocketListening(context);
              return Consumer<DashboardsProvider>(builder: (ctx, dashboardsProvider, child) {
                final dashboardTabs = dashboardsProvider.dashboardTabs;
                return dashboardTabs[dashboardsProvider.dashboardTabIndex].dashboardType == DashboardType.Home
                    ? HomeWidgetScreen(refresh: () {
                  startWebSocketListening(context);
                  setState(() {});
                },)
                    : ScreenWithAppBar(
                        appBarTitle: dashboardTabs[dashboardsProvider.dashboardTabIndex].getTitle(context),
                        body: WidgetsListScreen(
                            dashboardType: dashboardTabs[dashboardsProvider.dashboardTabIndex].dashboardType,
                          refresh: () {
                            startWebSocketListening(context);
                            setState(() {});
                          },
                        ),
                      );
              });
            }
          }
        },
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      bottomNavigationBar: DashboardsScreenBottomNavigationBar(),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            right: MediaQuery.of(context).size.width / 6 - kFloatingActionButtonMargin - FILTER_ICON_SIZE),
        child: Filters(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Future<void> showHintDialogs() async {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context, listen: false);
    if(configProvider.showHints) {
      if (configProvider.hints[Hints.REFRESH_FETCHING_CONFIG]) {
        await showHintDialog(
            AppLocalizations.of(context).getTranslation('dashboardsScreen.hintDialogTextRefreshFetchConfig'),
            Hints.REFRESH_FETCHING_CONFIG);
      }
      if (configProvider.hints[Hints.SWIPE_BOARDS]) {
        await showHintDialog(AppLocalizations.of(context).getTranslation('dashboardsScreen.hintDialogTextSwipeBoards'),
            Hints.SWIPE_BOARDS);
      }
    }
  }

  Future<void> showHintDialog(String dialogText, String hint) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Text(
          dialogText,
          textAlign: TextAlign.center,
        ),
        actions: [
          FlatButton(
            key: Key('dashboardScreenHintsConfirmButton'),
            textColor: Theme.of(context).colorScheme.primary,
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(0.0),
            child: Text(
              AppLocalizations.of(context).getTranslation('dashboardsScreen.hintDialogConfirm'),
            ),
            onPressed: () {
              Provider.of<ConfigProvider>(context, listen: false).setHintSeen(hint);
              Navigator.of(ctx).pop(false);
            },
          ),
        ],
      ),
    );
  }

  void startWebSocketListening(BuildContext context) {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context, listen: false);
    final channel = IOWebSocketChannel.connect('ws://${configProvider.currentIP}/ws');
    if(configProvider.webSocketConnectionErrorPresent) {
      configProvider.setWebSocketConnectionErrorPresent(false);
    }
    debugPrint('connected to ws channel');
    channel.stream.listen(
      (dynamic message) {
        Map<String, dynamic> decodedData = Map<String, dynamic>.from(jsonDecode(message));
        if (decodedData['eventType'] == 'widget-update') {
          Future.delayed(const Duration(milliseconds: 0), () {
            configProvider.updateWidget(decodedData);
            checkForNotifications();
          });
        }
      },
      onDone: () {
        Future.delayed(const Duration(milliseconds: 0), () {
          Provider.of<ConfigProvider>(context, listen: false).setWebSocketConnectionErrorPresent(true);
        });
        debugPrint('ws channel closed');
      },
      onError: (error) {
        Future.delayed(const Duration(milliseconds: 0), () {
          Provider.of<ConfigProvider>(context, listen: false).setWebSocketConnectionErrorPresent(true);
        });
        debugPrint('ws error $error');
      },
    );
  }

  void notificationSetup() async {
    _androidInitializationSettings = AndroidInitializationSettings('cogboard_icon');
    _iosInitializationSettings = IOSInitializationSettings();
    _initializationSettings =
        InitializationSettings(android: _androidInitializationSettings, iOS: _iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void checkForNotifications() async {
    ConfigProvider configProvider = Provider.of<ConfigProvider>(context, listen: false);
    if (_notification == AppLifecycleState.paused) {
      if (configProvider.shouldNotify()) {
        await showNotification();
        await configProvider.updateNotificationTimestamp();
      }
    }
  }

  Future<void> showNotification() async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'Channel ID',
      'Channel title',
      'channel body',
      priority: Priority.high,
      importance: Importance.max,
      ticker: 'test',
      styleInformation: BigTextStyleInformation(''),
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails, iOS: iosNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
        0,
        AppLocalizations.of(context).getTranslation('dashboardsScreen.widgetChangedNotification'),
        Provider.of<ConfigProvider>(context, listen: false).notificationPayload,
        notificationDetails);
  }

  Future<dynamic> onSelectNotification(String payLoad) async {
    _appResumedBySelectingNotification = true;
  }
}
