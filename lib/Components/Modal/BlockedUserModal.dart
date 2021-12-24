import 'package:chatsen/Components/UI/BlurModal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../BlockedUsers/BlockedUsersCubit.dart';

class BlockedUserModal extends StatefulWidget {
  final String? blockedUser;

  const BlockedUserModal({
    Key? key,
    this.blockedUser,
  }) : super(key: key);

  @override
  State<BlockedUserModal> createState() => _BlockedUserModalState();

  static Future<void> show(
    BuildContext context, {
    String? blockedUser,
  }) async {
    await BlurModal.show(
      context: context,
      child: BlockedUserModal(
        blockedUser: blockedUser,
      ),
    );
  }
}

class _BlockedUserModalState extends State<BlockedUserModal> {
  late TextEditingController usernameController;

  @override
  void initState() {
    usernameController = TextEditingController(text: widget.blockedUser ?? '');
    super.initState();
  }

  @override
  void dispose() {
    usernameController.dispose();
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
                controller: usernameController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Username to block',
                ),
              ),
              SizedBox(height: 8.0),
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.blockedUser != null) {
                    BlocProvider.of<BlockedUsersCubit>(context).replace(widget.blockedUser!, usernameController.text);
                  } else {
                    BlocProvider.of<BlockedUsersCubit>(context).add(usernameController.text);
                  }
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.save),
                label: Text('Save'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(EdgeInsets.all(16.0)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0))),
                ),
              ),
            ],
          ),
        ),
      );
}
