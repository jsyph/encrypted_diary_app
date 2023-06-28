import 'package:encrypted_diary_app/services/storage/record_storage/models/diary_record.dart';
import 'package:encrypted_diary_app/widgets/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';

import '../services/services.dart';
import 'record_card.dart';
import 'record_edit.dart';
import 'record_view.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with RouteAware {
  List<DiaryRecord> _allRecords = DiaryAppServices.records.all();
  bool _showFab = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    HomeWidget.routeObserver
        .subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    setState(() {
      _allRecords = DiaryAppServices.records.all();
    });
  }

  @override
  void dispose() {
    HomeWidget.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Encrypted Diary'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                PageTransition(
                  child: const Settings(),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          late final Widget child;

          if (_allRecords.isEmpty) {
            child = const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Its empty in here...'),
                  Text('Create a new record.')
                ],
              ),
            );
          } else {
            child = NotificationListener<UserScrollNotification>(
              onNotification: (notification) {
                final direction = notification.direction;
                // ignore notification if the list is empty
                if (_allRecords.isNotEmpty) {
                  setState(
                    () {
                      if (direction == ScrollDirection.reverse) {
                        _showFab = false;
                      } else if (direction == ScrollDirection.forward) {
                        _showFab = true;
                      }
                    },
                  );
                  // if the list is empty and _showFab is false, then set it to true
                } else if (!_showFab) {
                  setState(
                    () {
                      _showFab = true;
                    },
                  );
                }
                return true;
              },
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageTransition(
                          child: RecordView(recordId: _allRecords[index].id),
                          type: PageTransitionType.rightToLeft,
                          duration: const Duration(milliseconds: 200),
                        ),
                      );
                    },
                    child: RecordCard(record: _allRecords[index]),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    indent: 15,
                    endIndent: 15,
                  );
                },
                itemCount: _allRecords.length,
              ),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: child,
          );
        },
      ),
      floatingActionButton: AnimatedSlide(
        duration: const Duration(milliseconds: 250),
        offset: _showFab ? Offset.zero : const Offset(0, 2),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              Navigator.of(context).push(
                PageTransition(
                  child: RecordEdit(record: null),
                  type: PageTransitionType.rightToLeft,
                  duration: const Duration(milliseconds: 200),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
