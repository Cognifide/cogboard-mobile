import 'package:cogboardmobileapp/constants/constants.dart';
import 'package:cogboardmobileapp/models/board_model.dart';
import 'package:cogboardmobileapp/models/dashboard_tab_model.dart';
import 'package:cogboardmobileapp/providers/config_provider.dart';
import 'package:cogboardmobileapp/screens/widgets_list_screen.dart';
import 'package:cogboardmobileapp/translations/app_localizations.dart';
import 'package:cogboardmobileapp/utils/url_launcher.dart';
import 'package:cogboardmobileapp/widgets/screen_with_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeWidgetScreen extends StatefulWidget {
  final Function refresh;

  HomeWidgetScreen({this.refresh});

  @override
  _HomeWidgetScreenState createState() => _HomeWidgetScreenState();
}

class _HomeWidgetScreenState extends State<HomeWidgetScreen> with UrlLauncher {
  PageController _controller = PageController(
    initialPage: 0,
  );
  String boardTitle;
  int pageNumber = 0;

  bool isWidgetBoard(Board board) {
    return board.type == BoardTypes.WIDGET_BOARD;
  }

  String getIframeUrl(Board board) {
    return board.iframeUrl;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final configProvider = Provider.of<ConfigProvider>(context, listen: false);
    if (configProvider.currentBoard == null) {
      configProvider.setCurrentBoard(configProvider.boards[pageNumber]);
    } else {
      int currentBoardIndex =
          configProvider.boards.indexWhere((element) => element.id == configProvider.currentBoard.id);
      setState(() {
        pageNumber = currentBoardIndex >= 0 ? currentBoardIndex : 0;
      });
    }
    _controller = PageController(
      initialPage: pageNumber,
    );
    boardTitle = configProvider.boards[pageNumber].title;
    return ScreenWithAppBar(
      appBarTitle: boardTitle,
      body: PageView(
        controller: _controller,
        onPageChanged: (boardIndex) {
          configProvider.setCurrentBoard(configProvider.boards[boardIndex]);
          setState(() {
            pageNumber = boardIndex;
          });
        },
        children: configProvider.boards
            .map(
              (board) => isWidgetBoard(configProvider.boards[pageNumber])
                  ? WidgetsListScreen(
                      dashboardType: DashboardType.Home,
                      board: board,
                      refresh: widget.refresh,
                    )
                  : Center(
                      child: FlatButton(
                        color: Theme.of(context).colorScheme.primary,
                        onPressed: () => launchUrl(getIframeUrl(board), context),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(STANDARD_BORDER_RADIOUS),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppLocalizations.of(context).getTranslation('homeScreen.viewContent'),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
            )
            .toList(),
      ),
    );
  }
}
