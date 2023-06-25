import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:page_transition/page_transition.dart';

import '../services/services.dart';
import 'record_card.dart';
import 'record_edit.dart';
import 'record_view.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool _showFab = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your Encrypted Diary'),
        actions: [
          IconButton(
            onPressed: () {
              //? Open Settings Page
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          late final Widget child;

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
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
                setState(() {
                  if (direction == ScrollDirection.reverse) {
                    _showFab = false;
                  } else if (direction == ScrollDirection.forward) {
                    _showFab = true;
                  }
                });
                return true;
              },
              child: ListView.separated(
                itemBuilder: (context, index) {
                  return OpenContainer(
                    closedColor: Theme.of(context).scaffoldBackgroundColor,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    middleColor: Theme.of(context).scaffoldBackgroundColor,
                    closedBuilder: (context, action) {
                      return RecordCard(record: snapshot.data![index]);
                    },
                    openBuilder: (context, action) {
                      return RecordView(recordId: snapshot.data![index].id);
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    indent: 15,
                    endIndent: 15,
                  );
                },
                itemCount: snapshot.data!.length,
              ),
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: child,
          );
        },
        future: DiaryAppServices.records.allRecords(),
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
                  type: PageTransitionType.fade,
                  duration: const Duration(milliseconds: 400),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
