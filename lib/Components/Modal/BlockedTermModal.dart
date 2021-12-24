import 'package:chatsen/BlockedTerms/BlockedTerm.dart';
import 'package:chatsen/Components/UI/BlurModal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../BlockedTerms/BlockedTerm.dart';
import '../../BlockedTerms/BlockedTermsCubit.dart';

class BlockedTermModal extends StatefulWidget {
  final BlockedTerm? blockedTerm;

  const BlockedTermModal({
    Key? key,
    this.blockedTerm,
  }) : super(key: key);

  @override
  State<BlockedTermModal> createState() => _BlockedTermModalState();

  static Future<void> show(
    BuildContext context, {
    BlockedTerm? blockedTerm,
  }) async {
    await BlurModal.show(
      context: context,
      child: BlockedTermModal(
        blockedTerm: blockedTerm,
      ),
    );
  }
}

class _BlockedTermModalState extends State<BlockedTermModal> {
  late TextEditingController patternController;
  late bool caseSensitive;
  late bool regex;

  @override
  void initState() {
    patternController = TextEditingController(text: widget.blockedTerm?.pattern ?? '');
    caseSensitive = widget.blockedTerm?.caseSensitive ?? false;
    regex = widget.blockedTerm?.regex ?? false;
    super.initState();
  }

  @override
  void dispose() {
    patternController.dispose();
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
                controller: patternController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Pattern to block',
                ),
              ),
              CheckboxListTile(
                value: regex,
                onChanged: (v) => setState(() {
                  regex = v!;
                }),
                title: Text('Enable regex'),
              ),
              CheckboxListTile(
                value: caseSensitive,
                onChanged: (v) => setState(() {
                  caseSensitive = v!;
                }),
                title: Text('Case sensitive'),
              ),
              SizedBox(height: 8.0),
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.blockedTerm != null) {
                    BlocProvider.of<BlockedTermsCubit>(context).update(
                      widget.blockedTerm!,
                      widget.blockedTerm!.copyWith(
                        caseSensitive: caseSensitive,
                        pattern: patternController.text,
                        regex: regex,
                      ),
                    );
                  } else {
                    BlocProvider.of<BlockedTermsCubit>(context).add(BlockedTerm(
                      caseSensitive: caseSensitive,
                      pattern: patternController.text,
                      regex: regex,
                    ));
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
