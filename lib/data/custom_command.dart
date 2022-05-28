import 'package:hive/hive.dart';

part 'custom_command.g.dart';

@HiveType(typeId: 12)
class CustomCommand extends HiveObject {
  @HiveField(0)
  String trigger;

  @HiveField(1)
  String command;

  CustomCommand({
    required this.trigger,
    required this.command,
  });
}
