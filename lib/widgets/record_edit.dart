import 'dart:convert';

import 'package:encrypted_diary_app/widgets/record_view.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../services/app_services/app_services.dart';
import '../services/storage/storage.dart';
import 'flutter_quill/flutter_quill.dart' as quill;

class RecordEdit extends StatelessWidget {
  RecordEdit({super.key, required this.record}) {
    _titleTextController = TextEditingController(text: record?.title);
    if (record != null) {
      _contentQuillController = quill.QuillController(
        document: quill.Document.fromJson(
          jsonDecode(record!.content),
        ),
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _contentQuillController = quill.QuillController.basic();
    }
  }

  final DiaryRecord? record;

  late final quill.QuillController _contentQuillController;
  late final TextEditingController _titleTextController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton.filledTonal(
            onPressed: () async {
              final contentJson = jsonEncode(
                _contentQuillController.document.toDelta().toJson(),
              );
              late final String title;
              final contentPlainText =
                  _contentQuillController.document.toPlainText().trim();

              if (_titleTextController.text.trim().isEmpty) {
                if (contentPlainText.length >= 20) {
                  title = contentPlainText.substring(0, 20);
                } else {
                  title = contentPlainText;
                }
              } else {
                title = _titleTextController.text.trim();
              }

              late final String recordId;

              // if a record is found, then modify else create a new one
              if (record != null) {
                await DiaryAppServices.records.modify(
                  id: record!.id,
                  title: title,
                  content: contentJson,
                );
                recordId = record!.id;
              } else {
                // if title and content are empty when creating a new record, then show snackbar
                if (_titleTextController.text.trim().isEmpty &&
                    contentPlainText.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Cannot create empty record.',
                      ),
                    ),
                  );
                  return;
                }
                recordId = await DiaryAppServices.records.add(
                  title: title,
                  content: contentJson,
                );
              }

              if (context.mounted) {
                Navigator.of(context).pushReplacement(
                  PageTransition(
                    child: RecordView(
                      recordId: recordId,
                      key: super.key,
                    ),
                    type: PageTransitionType.rightToLeft,
                    duration: const Duration(milliseconds: 000),
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                enableIMEPersonalizedLearning: false,
                controller: _titleTextController,
                style: Theme.of(context).textTheme.displayMedium,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                  isCollapsed: true,
                ),
              ),
              quill.AnonQuillEditor(
                focusNode: FocusNode(),
                controller: _contentQuillController,
                scrollController: ScrollController(),
                scrollable: false,
                padding: const EdgeInsets.only(bottom: 250, top: 10),
                autoFocus: true,
                readOnly: false,
                expands: false,
                placeholder: 'Content',
              ),
            ],
          ),
        ),
      ),
      bottomSheet: quill.QuillToolbar.basic(
        controller: _contentQuillController,
        toolbarIconSize: 20,
        multiRowsDisplay: false,
        showBackgroundColorButton: false,
        showSubscript: false,
        showSuperscript: false,
        showFontFamily: false,
        showFontSize: false,
        showColorButton: false,
        showAlignmentButtons: false,
        showDirection: false,
        showCenterAlignment: false,
        showIndent: false,
        showRightAlignment: false,
        showSmallButton: false,
        showJustifyAlignment: false,
        showDividers: false,
      ),
    );
  }
}
