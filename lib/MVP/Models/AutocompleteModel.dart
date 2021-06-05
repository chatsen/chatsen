/// The [AutocompleteModel] is a class that holds our settings for the autocompletion.
class AutocompleteModel {
  bool? userPrefix;
  bool? emotePrefix;

  AutocompleteModel({
    this.userPrefix = false,
    this.emotePrefix = false,
  });
}
