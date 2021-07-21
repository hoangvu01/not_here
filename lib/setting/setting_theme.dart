import 'package:flutter/material.dart';
import 'package:not_here/model.dart';
import 'package:provider/provider.dart';

class ThemeSetting extends StatefulWidget {
  const ThemeSetting({Key? key}) : super(key: key);

  @override
  _ThemeSettingState createState() => _ThemeSettingState();
}

class _ThemeSettingState extends State<ThemeSetting> {
  @override
  Widget build(BuildContext context) {
    final _appModel = Provider.of<AppModel>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.onBackground,
        boxShadow: [
          BoxShadow(
            offset: Offset(0.0, 5.0),
            color: Theme.of(context).shadowColor,
            blurRadius: 5.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 6),
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                'Dark Theme',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: !_appModel.isUsingSystemTheme,
                  child: IconButton(
                    onPressed: () => _appModel.toggleTheme(),
                    icon: _appModel.isDark
                        ? Icon(Icons.dark_mode_outlined)
                        : Icon(Icons.light_mode_outlined),
                  ),
                ),
                IconButton(
                  onPressed: () => _appModel.toggleSystemTheme(),
                  icon: Icon(Icons.phone_iphone,
                      color: _appModel.isUsingSystemTheme
                          ? Theme.of(context).accentIconTheme.color
                          : Theme.of(context).iconTheme.color),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
