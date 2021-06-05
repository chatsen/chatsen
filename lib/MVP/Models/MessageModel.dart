/// The [MessageModel] is a class that holds our settings for how messages are rendered.
class MessageModel {
  bool? timestamps;
  bool? imagePreview;

  MessageModel({
    this.timestamps = false,
    this.imagePreview = false,
  });
}
