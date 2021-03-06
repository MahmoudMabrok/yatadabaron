import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/search-session-bloc.dart';
import '../../enums/enums.dart'; 
import '../../helpers/localization.dart';
import '../../helpers/utils.dart';
import '../../views/home/search-form.dart';
import '../../views/home/search-results-list.dart';
import '../../views/home/search-summary.dart';
import '../../views/shared-widgets/custom-page-wrapper.dart';
import '../../views/shared-widgets/loading-widget.dart';

class HomePage extends StatelessWidget {
  Widget customText(String text) {
    return Center(
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Utils.emptyListStyle(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SearchSessionBloc sessionBloc = Provider.of<SearchSessionBloc>(context,listen: false);
    sessionBloc.errorStream.listen((Exception e) {
      //ErrorDialog.show(context, TextProvider.SEARCH_ERROR);
    });
    Widget searchResultsArea = Column(
      children: <Widget>[
        SearchSummaryWidget(),
        Expanded(
          flex: 1,
          child: SearchResultsList(),
        )
      ],
    );

    Widget floatingButton = FloatingActionButton(
      onPressed: () {
        SearchForm.show(context, sessionBloc);
      },
      child: Icon(Icons.search),
      mini: true,
    );

    Widget initialMessage = customText(Localization.TAP_SEARCH_BUTTON);
    Widget invalidSettingsMessage =
        customText(Localization.INVALID_SEARCH_SETTINGS);

    return StreamBuilder<SearchState>(
      stream: sessionBloc.stateStream,
      builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
        SearchState state = snapshot.data;
        Widget body;
        Widget btn = floatingButton;
        switch (state) {
          case SearchState.INITIAL:
            body = initialMessage;
            break;
          case SearchState.IN_PROGRESS:
            body = LoadingWidget();
            btn = null;
            break;
          case SearchState.DONE:
            body = searchResultsArea;
            break;
          case SearchState.INVALID_SETTINGS:
            body = invalidSettingsMessage;
            break;
          default:
            break;
        }
        if (state == null) {
          return LoadingWidget();
        }
        return CustomPageWrapper(
          pageTitle: Localization.DRAWER_HOME,
          child: body,
          floatingButton: btn,
        );
      },
    );
  }
}
