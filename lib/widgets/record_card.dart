import '../services/storage/storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/services.dart';

final _dateTimeFormat = DateFormat('MMMM dd, yyyy');

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record});

  final DiaryRecord record;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        record.content,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),
                Text(
                  style: Theme.of(context).textTheme.labelSmall,
                  _dateTimeFormat.format(record.dateCreated),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
