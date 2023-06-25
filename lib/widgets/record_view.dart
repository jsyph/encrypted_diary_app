import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../services/services.dart';
import '../services/storage/storage.dart';
import 'flutter_quill/flutter_quill.dart' as quill;
import 'record_edit.dart';

final _dateTimeFormat = DateFormat('MMMM dd, yyyy').add_jms();

class RecordView extends StatefulWidget {
  const RecordView({super.key, required this.recordId});

  final String recordId;

  @override
  State<RecordView> createState() => _RecordViewState();
}

class _RecordViewState extends State<RecordView> {
  late final quill.QuillController _quillController;
  final _quillFocusNode = FocusNode();
  final _quillScrollController = ScrollController();
  late final DiaryRecord _record;
  late final TextEditingController _titleTextController;

  @override
  void initState() {
    _record = DiaryAppServices.records.getRecord(widget.recordId)!;
    _titleTextController = TextEditingController(text: _record.title);
    _quillController = quill.QuillController(
      document: quill.Document.fromJson(
        jsonDecode(_record.content),
      ),
      selection: const TextSelection.collapsed(offset: 0),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Delete Forever',
            icon: const Icon(Icons.delete_forever),
          ),
          IconButton(
            onPressed: () {},
            tooltip: 'Export',
            icon: const Icon(Icons.ios_share),
          ),
          IconButton.filledTonal(
            tooltip: 'Edit',
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(
                PageTransition(
                  child: RecordEdit(record: _record),
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 400),
                ),
              )
                  .whenComplete(
                () {
                  if (mounted) {
                    setState(() {});
                  }
                },
              );
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _titleTextController,
                    style: Theme.of(context).textTheme.displayMedium,
                    maxLines: null,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Title',
                      isCollapsed: true,
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    enabled: false,
                  ),
                  quill.AnonQuillEditor(
                    focusNode: _quillFocusNode,
                    controller: _quillController,
                    scrollController: _quillScrollController,
                    scrollable: false,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    autoFocus: false,
                    readOnly: true,
                    expands: false,
                    placeholder: 'Content',
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'Created: \n${_dateTimeFormat.format(_record.dateCreated)}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const VerticalDivider(),
                        Text(
                          'Last modified: \n${_dateTimeFormat.format(_record.lastModified)}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
