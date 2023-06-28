import 'package:encrypted_diary_app/services/app_services/app_services.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(color: Colors.redAccent),
                      children: [
                        const WidgetSpan(
                          child: Icon(Icons.warning, color: Colors.redAccent),
                          alignment: PlaceholderAlignment.middle,
                        ),
                        const WidgetSpan(
                          child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5)),
                        ),
                        TextSpan(
                          text: 'Dangerous',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    ),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Delete all',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  icon: const Icon(Icons.delete_forever),
                  color: Colors.red,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

showAlertDialog(BuildContext context) {
  Widget cancelButton = TextButton(
    child: const Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Confirm"),
    onPressed: () async {
      await DiaryAppServices.records.deleteAll();

      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    },
  );

  AlertDialog alert = AlertDialog(
    title: const Text("Are you sure?"),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Delete All Records?"),
        Text(
          'THIS CANNOT BE REVERSED',
          style: TextStyle(color: Colors.red),
        )
      ],
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) => alert,
  );
}
