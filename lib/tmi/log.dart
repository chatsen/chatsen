class Log {
  dynamic data;
  bool outgoing;
  late DateTime dateTime;

  Log({
    required this.data,
    this.outgoing = false,
    DateTime? dateTime,
  }) {
    this.dateTime = dateTime ?? DateTime.now();
  }
}
