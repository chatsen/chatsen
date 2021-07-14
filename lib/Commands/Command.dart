import 'package:hive/hive.dart';

part 'Command.g.dart';

@HiveType(typeId: 1)
class Command extends HiveObject {
  @HiveField(0)
  final String trigger;

  @HiveField(1)
  final String command;

  Command({
    required this.trigger,
    required this.command,
  });
}
