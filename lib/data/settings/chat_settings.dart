import 'package:hive/hive.dart';

part 'chat_settings.g.dart';

@HiveType(typeId: 15)
class ChatSettings extends HiveObject {
  @HiveField(0)
  bool userAutocompletionWithAt = false;

  @HiveField(1)
  bool emoteAutocompletionWithColon = false;
}
