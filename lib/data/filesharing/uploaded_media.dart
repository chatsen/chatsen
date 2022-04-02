import 'package:hive/hive.dart';

part 'uploaded_media.g.dart';

@HiveType(typeId: 5)
class UploadedMedia extends HiveObject {
  @HiveField(0)
  final String url;

  @HiveField(1)
  final String? deletionUrl;

  @HiveField(2)
  final DateTime time;

  UploadedMedia({
    required this.url,
    this.deletionUrl,
    required this.time,
  });
}
