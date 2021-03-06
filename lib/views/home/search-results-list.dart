import 'package:Yatadabaron/blocs/mushaf-bloc.dart';
import 'package:Yatadabaron/helpers/global-colors.dart';
import 'package:Yatadabaron/views/mushaf/mushaf.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../blocs/search-session-bloc.dart';
import '../../dtos/search-session-payload.dart';
import '../../dtos/verse-dto-collection.dart';
import '../../dtos/verse-dto.dart';
import '../../helpers/localization.dart';
import '../../helpers/utils.dart';
import '../../views/shared-widgets/loading-widget.dart';

class SearchResultsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void navigateToMushaf(int chapterId, int verseId) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) {
          return Provider(
            child: MushafPage(),
            create: (_) => MushafBloc(chapterId,verseId),
          );
        }),
      );
    }

    SearchSessionBloc sessionBloc = Provider.of<SearchSessionBloc>(context);
    return StreamBuilder<SearchSessionPayload>(
      stream: sessionBloc.payloadStream,
      builder:
          (BuildContext context, AsyncSnapshot<SearchSessionPayload> snapshot) {
        if (!snapshot.hasData) {
          return LoadingWidget();
        }
        List<VerseDTO> results = snapshot.data.results;
        if (results.length == 0) {
          return Center(
            child: Text(
              Localization.EMPTY_SEARCH_RESULTS,
              style: Utils.emptyListStyle(),
            ),
          );
        }
        List<VerseCollection> collections = snapshot.data.verseCollections;
        if (collections.length == 1) {
          return ListView.separated(
            itemCount: results.length,
            separatorBuilder: (_, __) => Divider(
              thickness: 1,
            ),
            itemBuilder: (_, i) {
              VerseDTO verse = results[i];
              return ListTile(
                title: Text(
                  "${verse.verseTextTashkel} {${verse.verseID}}",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
                trailing: Text(
                  "${verse.chapterName}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  snapshot.data.copyVerse(verse);
                },
              );
            },
          );
        }
        return ListView.builder(
          itemCount: collections.length,
          itemBuilder: (BuildContext context, int i) {
            String collectionName = collections[i].collectionName;
            List<VerseDTO> verses = collections[i].verses;
            return ExpansionTile(
              title: Text(
                "$collectionName [${verses.length} ${Localization.VERSE}]",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              children: verses.map((VerseDTO verse) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        "${verse.verseTextTashkel} [${verse.chapterName}-${verse.verseID}]",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                      onTap: () {
                        navigateToMushaf(verse.chapterId, verse.verseID);
                      },
                      onLongPress: () {
                        snapshot.data.copyVerse(verse);
                      },
                    ),
                    Divider(
                      thickness: 1,
                    )
                  ],
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
