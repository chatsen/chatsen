import '/Components/UI/BlurModal.dart';
import '/Mentions/CustomMention.dart';
import '/Mentions/CustomMentionsCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomMentionModal extends StatefulWidget {
  final CustomMention? customMention;

  const CustomMentionModal({
    Key? key,
    this.customMention,
  }) : super(key: key);

  @override
  State<CustomMentionModal> createState() => _CustomMentionModalState();

  static Future<void> show(
    BuildContext context, {
    CustomMention? customMention,
  }) async {
    await BlurModal.show(
      context: context,
      child: CustomMentionModal(
        customMention: customMention,
      ),
    );
  }
}

class _CustomMentionModalState extends State<CustomMentionModal> {
  late TextEditingController patternController;
  late bool enableRegex;
  late bool caseSensitive;

  @override
  void initState() {
    patternController = TextEditingController(text: widget.customMention?.pattern);
    enableRegex = widget.customMention?.enableRegex ?? false;
    caseSensitive = widget.customMention?.caseSensitive ?? false;
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
                  labelText: 'Pattern',
                ),
              ),
              CheckboxListTile(
                value: enableRegex,
                onChanged: (v) => setState(() {
                  enableRegex = v!;
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
              // SizedBox(height: 8.0),
              // TextField(
              //   controller: CustomMentionController,
              //   maxLines: null,
              //   decoration: InputDecoration(
              //     filled: true,
              //     labelText: 'CustomMention',
              //   ),
              // ),
              SizedBox(height: 8.0),
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.customMention == null) {
                    BlocProvider.of<CustomMentionsCubit>(context).add(
                      CustomMention(
                        pattern: patternController.text,
                        enableRegex: enableRegex,
                        caseSensitive: caseSensitive,
                      ),
                    );
                  } else {
                    widget.customMention!.pattern = patternController.text;
                    widget.customMention!.enableRegex = enableRegex;
                    widget.customMention!.caseSensitive = caseSensitive;
                    BlocProvider.of<CustomMentionsCubit>(context).update(widget.customMention!);
                  }
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.save),
                label: Text('Save'),
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
