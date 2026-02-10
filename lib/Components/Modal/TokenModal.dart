import 'dart:convert';

import '/Commands/Command.dart';
import '/Commands/CommandsCubit.dart';
import '/Components/UI/BlurModal.dart';
import '/Components/UI/Tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;
import 'package:flutter_chatsen_irc/Twitch.dart' as twitch;

import '../../Accounts/AccountModel.dart';
import '../../Accounts/AccountsCubit.dart';

class TokenModal extends StatefulWidget {
  final twitch.Client client;
  final Command? command;

  const TokenModal({
    Key? key,
    this.command,
    required this.client,
  }) : super(key: key);

  @override
  State<TokenModal> createState() => _TokenModalState();

  static Future<void> show(
    BuildContext context, {
    Command? command,
    required twitch.Client client,
  }) async {
    await BlurModal.show(
      context: context,
      child: TokenModal(
        command: command,
        client: client,
      ),
    );
  }
}

class _TokenModalState extends State<TokenModal> {
  late TextEditingController tokenController;

  @override
  void initState() {
    tokenController = TextEditingController(text: widget.command?.trigger);
    super.initState();
  }

  @override
  void dispose() {
    tokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
          child: ListView(
            shrinkWrap: true,
            children: [
              TextField(
                controller: tokenController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Token',
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton.icon(
                onPressed: () async {
                  var cubit = BlocProvider.of<AccountsCubit>(context);

                  Navigator.of(context).pop();

                  print('Custom token is ${tokenController.text}');

                  var response = await http.get(
                    Uri.parse('https://id.twitch.tv/oauth2/validate'),
                    headers: {
                      'Authorization': 'Bearer ${tokenController.text}',
                    },
                  );
                  var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
                  print(jsonResponse);

                  var response2 = await http.get(
                    Uri.parse('https://api.twitch.tv/helix/users'),
                    headers: {
                      'Authorization': 'Bearer ${tokenController.text}',
                      'Client-Id': jsonResponse['client_id'],
                    },
                  );
                  var responseJson2 = jsonDecode(utf8.decode(response2.bodyBytes));
                  var imageBytes = (await http.get(Uri.parse(responseJson2['data'][0]['profile_image_url']))).bodyBytes;

                  var model = AccountModel(
                    clientId: jsonResponse['client_id'],
                    token: tokenController.text,
                    id: int.tryParse(jsonResponse['user_id'] ?? '0') ?? 0,
                    login: jsonResponse['login'],
                    avatarBytes: imageBytes,
                  );

                  await cubit.add(model);
                  await cubit.setActive(model);
                  await widget.client.swapCredentials(
                    twitch.Credentials(
                      clientId: model.clientId,
                      id: model.id,
                      login: model.login!,
                      token: model.token,
                    ),
                  );
                },
                icon: Icon(Icons.add),
                label: Text('Add account'),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(EdgeInsets.all(16.0)),
                  shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
              ),
            ],
          ),
        ),
      );
}
