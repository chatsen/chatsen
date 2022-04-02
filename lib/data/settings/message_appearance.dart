import 'package:hive/hive.dart';

part 'message_appearance.g.dart';

@HiveType(typeId: 6)
class MessageAppearance extends HiveObject {
  @HiveField(0)
  bool timestamps = true;

  @HiveField(1)
  bool compact = false;

  @HiveField(2)
  bool imageEmbeds = true;

  @HiveField(3)
  bool channelsEmbeds = false;

  @HiveField(4)
  bool fileEmbeds = true;

  @HiveField(5)
  double scale = 1.0;
}
