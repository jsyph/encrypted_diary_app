import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

import '../services/storage/record_storage/models/diary_record.dart';
import 'record_card.dart';
import 'record_page.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
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

          if (!snapshot.hasData) {
            child = const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            child = ListView.separated(
              itemBuilder: (context, index) {
                return OpenContainer(
                  closedColor: Theme.of(context).scaffoldBackgroundColor,
                  openColor: Theme.of(context).scaffoldBackgroundColor,
                  closedBuilder: (context, action) {
                    return RecordCard(record: snapshot.data![index]);
                  },
                  openBuilder: (context, action) {
                    return RecordPage(record: snapshot.data![index]);
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
            );
          }

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: child,
          );
        },
        future: Future.delayed(
          const Duration(milliseconds: 10),
          () => List.generate(
            20,
            (index) => DiaryRecord(
              'id',
              'Pariatur consectetur enim dolor duis elit magna.$index',
              '''Enim pariatur velit laborum et non elit commodo minim fugiat minim irure consequat esse do. Proident ut non veniam id eiusmod proident ea ut. Aliquip culpa ex minim aute sint dolore reprehenderit elit qui non. Cupidatat minim voluptate minim adipisicing mollit qui esse veniam excepteur ut ad amet adipisicing.

Qui sint dolor consectetur minim dolore aute dolore fugiat. Dolor quis excepteur aliqua sit esse nulla ad ad adipisicing eu pariatur nisi laborum ex. Officia aute officia excepteur labore officia. Sint magna consectetur esse fugiat aliqua proident adipisicing excepteur incididunt occaecat id ea reprehenderit qui. Ad Lorem velit aute esse veniam Lorem ad labore mollit voluptate labore ipsum. Eiusmod nostrud laborum exercitation fugiat do nulla cillum laborum enim.

Eiusmod fugiat sunt reprehenderit enim sunt minim fugiat esse eu. Enim pariatur cillum ut laboris consequat proident tempor est. Minim voluptate consequat aute laboris minim incididunt minim minim deserunt qui sint amet eu occaecat.In culpa voluptate voluptate ullamco duis sint irure quis irure mollit adipisicing pariatur. Nulla dolor magna aliqua mollit voluptate. Eiusmod reprehenderit nisi anim laboris aliquip Lorem incididunt irure. Laborum anim magna tempor cillum consectetur enim nisi aliquip est nostrud elit fugiat eu exercitation.

Cupidatat aliquip eiusmod qui adipisicing ut commodo minim dolore tempor tempor. Veniam Lorem nulla velit laborum eiusmod culpa aliquip. Duis consectetur ipsum laboris laborum ex Lorem in et consectetur deserunt. Adipisicing exercitation ut velit occaecat magna magna. Veniam ut Lorem eiusmod id officia labore irure commodo consequat magna aute voluptate irure anim.

Proident reprehenderit officia dolore minim ea. Eu exercitation sit officia do enim quis. Incididunt aliqua enim do deserunt et excepteur consequat ad aute. Dolor sit labore magna sint reprehenderit pariatur occaecat est laboris. Irure laborum id nisi consequat. Ea pariatur do Lorem elit laboris.

Aliquip et nulla ipsum ullamco est laboris ad. Sunt occaecat Lorem ullamco sint adipisicing id. Incididunt dolor quis anim ex nostrud veniam quis proident laborum enim cillum minim. Consectetur nisi tempor deserunt culpa. Exercitation aliqua irure voluptate deserunt incididunt elit ex velit culpa qui esse mollit. Ad laboris id consequat tempor deserunt excepteur cillum laboris pariatur ad eiusmod pariatur. Velit dolor ipsum laboris voluptate ipsum sit irure velit magna.

Duis cillum Lorem officia duis occaecat labore qui eu quis anim aute laboris duis. Lorem consequat excepteur do do nostrud ea aute reprehenderit in qui nulla ipsum. Tempor nostrud cupidatat nulla culpa id. Dolore enim sit nostrud veniam magna occaecat ad.

Nostrud sunt ullamco ea qui officia deserunt quis enim ex eu nisi. Dolore dolore id elit dolore adipisicing sunt. Sunt Lorem laborum esse eu tempor occaecat amet fugiat adipisicing tempor ea cillum commodo. Sint minim exercitation mollit enim est cillum laborum pariatur magna aliquip.

Sit velit proident irure magna laborum deserunt irure enim voluptate officia fugiat aliqua in tempor. Ut dolore ad officia fugiat sunt nulla exercitation exercitation fugiat. Ut commodo ex irure ex est enim.

Eiusmod eu adipisicing sit pariatur laborum. Dolore culpa amet ea eu officia exercitation qui nisi aliquip eu veniam. Officia incididunt in aliqua reprehenderit ipsum laborum consectetur cupidatat. Aliqua laboris fugiat excepteur veniam Lorem nisi incididunt laborum voluptate. Nulla laborum veniam dolor sint qui magna laborum commodo ullamco laboris eu sunt. Labore sit sint incididunt consequat nostrud proident nostrud do elit nisi excepteur laborum.

Ea aute adipisicing sint exercitation eu esse commodo dolor qui minim aliquip pariatur id ipsum. Aliqua esse deserunt fugiat esse labore. Non consectetur veniam cillum velit. Duis velit anim laborum qui duis est aliqua. Velit culpa qui exercitation proident voluptate enim ullamco fugiat amet proident.

Proident et veniam mollit adipisicing sint est deserunt ipsum sint qui ut anim magna eiusmod. Officia Lorem irure do sint culpa consequat velit ullamco nulla nulla. Nostrud labore ea adipisicing ipsum ut anim occaecat esse laborum. Velit duis duis culpa minim labore laboris id culpa mollit aute irure sunt velit sunt. Pariatur esse cillum velit ipsum nulla anim do ex nostrud anim. Elit proident cupidatat eiusmod in minim deserunt.''',
              DateTime.now(),
              DateTime.now(),
            ),
          ),
        ),
      ),
    );
  }
}
