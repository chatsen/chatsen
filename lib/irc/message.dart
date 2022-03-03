class Message {
  String raw;
  Map<String, String> tags;
  String? prefix;
  String command;
  List<String> parameters;

  Message({
    required this.raw,
    required this.tags,
    required this.prefix,
    required this.command,
    required this.parameters,
  });

  factory Message.fromEvent(String event) {
    final parts = event.split(' ');
    // if (parts.length < 2) {
    //   throw 'invalid irc message: $event';
    // }

    var tags = <String, String>{};
    if (parts.isNotEmpty && parts.first.startsWith('@')) {
      tags = <String, String>{
        for (final tag in parts.first.substring(1).split(';'))
          if (tag.contains('=')) tag.split('=').first: tag.split('=').skip(1).join('='),
      };

      parts.removeAt(0);
    }

    String? prefix;
    if (parts.isNotEmpty && parts.first.startsWith(':')) {
      prefix = parts.first.substring(1);
      parts.removeAt(0);
    }

    if (parts.isEmpty) {
      throw 'invalid irc message: $event';
    }

    final command = parts.first;
    parts.removeAt(0);

    final parameters = <String>[];
    for (int i = 0; i < parts.length; ++i) {
      final part = parts[i];
      if (part.startsWith(':')) {
        parameters.add(parts.skip(i).join(' ').substring(1));
        break;
      } else {
        parameters.add(part);
      }
    }

    return Message(
      raw: event,
      tags: tags,
      prefix: prefix,
      command: command,
      parameters: parameters,
    );
  }
}
