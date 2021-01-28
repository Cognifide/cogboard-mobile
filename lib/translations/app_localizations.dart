import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String getTranslation(String key) {
    return _localizedValues[locale.languageCode][key];
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'loginScreen.connect': 'CONNECT',
      'loginScreen.add.new.connection': 'ADD NEW CONNECTION',
      'addConnectionScreen.title': 'New Connection',
      'addConnectionScreen.name': 'Name',
      'addConnectionScreen.name.emptyError': 'This field is required',
      'addConnectionScreen.name.duplicateError': 'This connection name is occupied.',
      'addConnectionScreen.url': 'Url',
      'addConnectionScreen.url.emptyError': 'This field is required',
      'addConnectionScreen.url.duplicateError': 'This connection name is occupied.',
      'addConnectionScreen.url.validationError': 'Url is not valid.',
      'addConnectionScreen.addConnection': 'ADD CONNECTION',
      'urlSelect.noConnections': 'Welcome. Start by adding a connection.',
      'dashboardsProvider.Home': 'Dashboard',
      'dashboardsProvider.Favourites': 'Favourites',
      'dashboardsProvider.Quarantine': 'Quarantine',
      'dashboardsScreen.boardError.title': 'Board error',
      'dashboardsScreen.boardError.apiError.body': 'API connection error occurred!',
      'dashboardsScreen.boardError.websocketError.body': 'Websocket connection error occurred!',
      'dashboardsScreen.widgetChangedNotification': 'Some widgets have changed their status:',
      'dashboardsScreen.hintDialogTextRefreshFetchConfig': 'Swipe up to fetch config again',
      'dashboardsScreen.hintDialogTextSwipeBoards': 'Swipe left and right to switch between boards',
      'dashboardsScreenBottomNavigationBar.Home': 'Home',
      'dashboardsScreenBottomNavigationBar.Favourites': 'Favourites',
      'dashboardsScreenBottomNavigationBar.Quarantine': 'Quarantine',
      'dashboardsScreen.hintDialogConfirm': 'Ok',
      'emptyWidgetList.body': 'This list is empty.',
      'settingsHints.hints': 'Hints',
      'settingsHints.showHints': 'Show hints',
      'settingsNotifications.notifications': 'Notifications',
      'settingsNotifications.showNotifications': 'Show notifications',
      'settingsNotifications.notificationsFrequencyInput': 'Show notifications',
      'settingsProjectList.projects': 'Projects',
      'settingsScreen.title': 'Settings',
      'settingsSortBy.widgets': 'Widgets',
      'settingsSortBy.sortBy': 'Sort by',
      'settingsSortBy.none': 'NONE',
      'settingsSortBy.name': 'NAME',
      'settingsSortBy.status': 'STATUS',
      'widgetScreen.errorTitle': 'Widget details',
      'widgetScreen.hintDialogText': 'Swipe left and right to switch between widget details',
      'widgetScreen.hintDialogConfirm': 'Ok',
      'widgetScreen.alertDialog.message':
          'How do you want to add a widget to quarantine(With or without expiration date)?',
      'widgetScreen.alertDialog.cancel': 'CANCEL',
      'widgetScreen.alertDialog.withExpirationDate': 'WITH',
      'widgetScreen.alertDialog.withoutExpirationDate': 'WITHOUT',
      'widgetListScreen.errorTitle': 'Dashboard',
      'widgetListErrorScreen.retry': 'RETRY',
      'widgetListScreen.errorBody': 'Websocket connection error occurred!',
      'widgetListScreen.hintDialogText': 'Swipe left to remove widget from list',
      'widgetListScreen.hintDialogConfirm': 'Ok',
      'homeScreen.viewContent': 'VIEW CONTENT',
      'aemBundleInfo.excludedBundles': 'Excluded bundles',
      'aemBundleInfo.noExcludedBundles': 'No excluded bundles',
      'aemBundleInfo.inactiveBundles': 'Inactive bundles',
      'aemBundleInfo.noInactiveBundles': 'No inactive bundles',
      'aemHealthcheck.healthchecks': 'Healthchecks',
      'bambooDeployment.details': 'Details',
      'bambooDeployment.deploymentState': 'Deployment state: ',
      'bambooDeployment.lifecycleState': 'Lifecycle state: ',
      'bambooPlan.details': 'Details',
      'bambooPlan.state': 'State: ',
      'jenkinsJob.details': 'Details',
      'jiraBuckets.bucket': 'Bucket',
      'jiraBuckets.issues': 'Issues',
      'jiraBuckets.noBuckets': 'No buckets available',
      'sonarQube.details': 'Details',
      'widgetStatus.errorConfiguration': 'Configuration Error',
      'worldClock.loading': 'Loading...',
      'dissmisibleWidgetList.removed': 'Removed ',
      'dissmisibleWidgetList.undo': 'UNDO',
      'serviceCheck.response': 'Response',
      'urlLauncher.toast': 'URL error occurred',
      'iframeEmbed.blankUrl': 'URL is blank',
      'zabbix.history': 'HISTORICAL DATA',
      'zabbix.date': 'Date',
      'widget.notUpdated': 'Not updated yet',
      'settingsScreen.projects': 'Projects',
      'settingsScreen.general': 'General',
      'settingsProjectsScreen.title': 'Projects',
      'settingsProjectsScreen.alert.title': 'Are you sure?',
      'settingsProjectsScreen.alert.confirm': 'YES',
      'settingsProjectsScreen.alert.decline': 'NO',
      'settingsGeneralScreen.title': 'General',
      'settingsGeneralScreen.widgetSorting': 'Widgets Sorting',
      'settingsGeneralScreen.notifications': 'Notifications',
      'settingsGeneralScreen.notificationFrequency': 'Notification Frequency',
      'settingsGeneralScreen.hints': 'Hints',
      'settingsGeneralScreen.alert.confirm': 'OK',
      'settingsSortByWidget.sortBy': 'Sort By',
      'settingsSortByWidget.none': 'None',
      'settingsSortByWidget.name': 'Name',
      'settingsSortByWidget.status': 'Status',
      'settingsSortByWidget.order': 'Order',
      'settingsSortByWidget.asc': 'Ascending',
      'settingsSortByWidget.desc': 'Descending',
      'addConnectionScreen.title.edit': 'Edit Connection',
      'addConnectionScreen.save': 'SAVE'
    }
  };
}
