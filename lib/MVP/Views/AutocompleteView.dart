import 'package:flutter/material.dart';
import '/MVP/Presenters/AutocompletePresenter.dart';

/// [AutocompleteView] is our settings view that allows to change settings related to the autocompletion. It uses the [AutocompletePresenter] to fetch and save a [AutocompleteModel] model that contains our configuration.
class AutocompleteView extends StatefulWidget {
  @override
  _AutocompleteViewState createState() => _AutocompleteViewState();
}

class _AutocompleteViewState extends State<AutocompleteView> {
  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: AutocompletePresenter.loadData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                SwitchListTile.adaptive(
                  title: Text('User Prefix'),
                  value: snapshot.data.userPrefix,
                  onChanged: (value) async {
                    snapshot.data.userPrefix = value;
                    AutocompletePresenter.saveData(snapshot.data);
                    setState(() {});
                  },
                ),
                SwitchListTile.adaptive(
                  title: Text('Emote Prefix'),
                  value: snapshot.data.emotePrefix,
                  onChanged: (value) async {
                    snapshot.data.emotePrefix = value;
                    AutocompletePresenter.saveData(snapshot.data);
                    setState(() {});
                  },
                ),
              ],
            );
          }
          return CircularProgressIndicator.adaptive();
        },
      );
}
