import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'spaces.dart';

class TextDescription extends StatefulWidget {
  final String label;
  final quill.QuillController controller;
  final bool showLabel;

  const TextDescription({
    Key? key,
    required this.label,
    required this.controller,
    this.showLabel = true,
  }) : super(key: key);

  @override
  _TextDescriptionState createState() => _TextDescriptionState();
}

class _TextDescriptionState extends State<TextDescription> {
  @override
  Widget build(BuildContext context) {
    final quill.QuillController controller = quill.QuillController.basic();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showLabel) ...[
          Text(
            widget.label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SpaceHeight(12.0),
        ],
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
             quill.QuillToolbar.simple(configurations: quill.QuillSimpleToolbarConfigurations(
                 controller: controller,
               showCodeBlock: false,
               showSearchButton: false,
               showAlignmentButtons: false,
               showInlineCode: false,
               showDirection: false,
               showClipboardCut: false,
               showClipboardCopy: false,
               showClipboardPaste: false,
               showSubscript: false,
               showClearFormat: false,
               showDividers: false,
               showLink: false,
               showSuperscript: false,
               showBackgroundColorButton: false,
               showIndent: false,
               showQuote: false,
               showFontFamily: false,
               showStrikeThrough: false,
               showRightAlignment: false,
               showLeftAlignment: false,
               showFontSize: false,

             )),
              const SizedBox(height: 8.0),
              Container(
                height: 200, // Adjust the height as needed
                child: quill.QuillEditor.basic(configurations: quill.QuillEditorConfigurations(controller: controller))
              ),
            ],
          ),
        ),
      ],
    );
  }
}
