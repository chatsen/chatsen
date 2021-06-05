class IRCMessage {
  String raw;
  Map<String, dynamic> tags;
  String prefix;
  String command;
  List<String> parameters;

  IRCMessage({
    this.raw = '',
    this.tags = const {},
    this.prefix = '',
    this.command = '',
    this.parameters = const [],
  });

  static IRCMessage? fromData(message) {
    if (message.length <= 0) return null;

    var ircMessage = IRCMessage(
      raw: message,
    );

    if (message[0] == '@') {
      List<String> messageSplit = message.substring(1).split(' ');
      if (messageSplit.length <= 1) return null;
      messageSplit[1] = messageSplit.sublist(1).join(' ').trim();
      var tags = messageSplit[0].split(';');
      ircMessage.tags = {for (var tag in tags) tag.split('=')[0]: tag.split('=')[1]};
      message = messageSplit[1];
    }

    if (message[0] == ':') {
      List<String> messageSplit = message.substring(1).split(' ');
      if (messageSplit.length <= 1) return null;
      messageSplit[1] = messageSplit.sublist(1).join(' ').trim();
      ircMessage.prefix = messageSplit[0];
      message = messageSplit[1];
    }

    List<String> messageSplit = message.split(' ');
    if (messageSplit.length > 1) messageSplit[1] = messageSplit.sublist(1).join(' ').trim();
    ircMessage.command = messageSplit[0];
    message = (messageSplit.length <= 1) ? null : messageSplit[1];

    if (message == null) return ircMessage;

    List<String> parametersSplit = message.split(':');
    ircMessage.parameters = parametersSplit[0].trim().split(' ');
    if (parametersSplit.length > 1) ircMessage.parameters.add(parametersSplit.sublist(1).join(':').trim());

    return ircMessage;
  }
}
