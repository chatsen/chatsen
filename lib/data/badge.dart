import '../providers/provider.dart';

class Badge {
  String id;
  String name;
  String? description;
  List<String> mipmap;
  int flags;
  Provider provider;

  Badge({
    required this.id,
    required this.name,
    this.description,
    required this.mipmap,
    this.flags = 0,
    required this.provider,
  });
}
