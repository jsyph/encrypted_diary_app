import '../services/app_services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/storage/storage.dart';

final _dateTimeFormat = DateFormat('MMMM dd, yyyy').add_jms();

class RecordPage extends StatelessWidget {
  const RecordPage({super.key, required this.record});

  final DiaryRecord record;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 150,
          flexibleSpace: Row(
            children: [
              SizedBox(
                width: 310,
                child: FlexibleSpaceBar(
                  title: Text(
                    record.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
        SliverList.list(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Create On'),
                      Text(
                        style: Theme.of(context).textTheme.labelSmall,
                        _dateTimeFormat.format(
                          record.dateCreated,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Last Edited On'),
                      Text(
                        style: Theme.of(context).textTheme.labelSmall,
                        _dateTimeFormat.format(
                          record.lastModified,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                record.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            const Padding(padding: EdgeInsets.all(100))
          ],
        )
      ],
    );
  }
}
