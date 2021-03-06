import 'package:flutter/material.dart';
import 'package:not_here/setting/setting_contact.dart';
import 'package:not_here/setting/setting_theme.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 50),
            child: Center(
              child: Text(
                'Preferences',
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
        ),
        Flexible(
          flex: 3,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              children: [
                ThemeSetting(),
                ContactSetting(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
