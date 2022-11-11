import '../providers/provider.dart';

class CustomBadge {
  String id;
  String name;
  String? description;
  List<String> mipmap;
  int flags;
  Provider provider;

  CustomBadge({
    required this.id,
    required this.name,
    this.description,
    required this.mipmap,
    this.flags = 0,
    required this.provider,
  });
}
