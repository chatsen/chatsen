import 'package:flutter/material.dart';
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;
import '/Components/ChatMessage.dart';

/// [SearchPage] is a page that will allow the user to search for any message in a provided [twitch.Channel] channel. It features a simple searchbox and fetches results as you type.
class SearchPage extends StatefulWidget {
  final twitch.Channel? channel;
  final twitch.User? user;

  const SearchPage({
    Key? key,
    required this.channel,
    this.user,
  }) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController? textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Search in channel'),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  reverse: true,
                  children: [
                    for (var message in widget.channel!.messages.where((message) => (widget.user != null ? message.user!.id == widget.user!.id : true) && message.body!.toLowerCase().contains((textEditingController?.text ?? '').toLowerCase())).toList().reversed)
                      ChatMessage(
                        message: message,
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: 'Search',
                    suffixIcon: IconButton(
                      onPressed: () async => setState(() {}),
                      icon: Icon(Icons.search),
                    ),
                  ),
                  onChanged: (text) async => setState(() {}),
                ),
              ),
            ],
          ),
        ),
      );
}
