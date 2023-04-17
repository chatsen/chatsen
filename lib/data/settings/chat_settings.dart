import 'package:hive/hive.dart';

part 'chat_settings.g.dart';

enum ChatSettingsAutocompletionInput {
  nothing,
  character,
  both,
}

@HiveType(typeId: 15)
class ChatSettings extends HiveObject {
  @HiveField(0)
  int userAutocompletion = ChatSettingsAutocompletionInput.both.index;

  @HiveField(1)
  int emoteAutocompletion = ChatSettingsAutocompletionInput.both.index;
}
