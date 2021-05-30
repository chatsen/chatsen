import 'package:flutter/material.dart';
import '/MVP/Views/AutocompleteView.dart';

/// [AutocompleteSettingsPage] is the Page scaffold representing our app's autocompletion settings. It allows changing the look and feel of autocompletion.
class AutocompleteSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Autocomplete Settings'),
        ),
        body: AutocompleteView(),
      );
}
