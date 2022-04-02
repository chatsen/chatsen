import 'package:hive/hive.dart';

part 'application_appearance.g.dart';

@HiveType(typeId: 7)
class ApplicationAppearance extends HiveObject {
  @HiveField(0)
  bool compact = false;
}
