import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:not_here/model.dart';
import 'package:provider/provider.dart';

import 'package:not_here/setting/setting_page.dart';
import 'package:not_here/home/search_page.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(NotHere());
}

class NotHere extends StatefulWidget {
  const NotHere({Key? key}) : super(key: key);

  @override
  _NotHereState createState() => _NotHereState();
}

class _NotHereState extends State<NotHere> {
  AppModel _appModel = AppModel();

  @override
  void initState() {
    super.initState();
    _initAppTheme();
  }

  void _initAppTheme() async {
    await _appModel.fetchSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppModel>.value(
      value: _appModel,
      child: Consumer<AppModel>(
        builder: (ctx, app, child) {
          return MaterialApp(
              title: 'Not Here!',
              themeMode: app.themeMode,
              theme: _appModel.lightTheme,
              darkTheme: _appModel.darkTheme,
              home: LandingPage());
        },
      ),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController _pageController = PageController();
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final _searchPageKey = PageStorageKey<String>('searchPage');
  final _searchPageBucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            final CurvedNavigationBarState? navbarState =
                _bottomNavigationKey.currentState;
            navbarState?.setPage(index);
          },
          children: <Widget>[
            PageStorage(
              child: SearchPage(
                key: _searchPageKey,
                pageController: _pageController,
              ),
              bucket: _searchPageBucket,
            ),
            SettingsPage(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        backgroundColor: Theme.of(context).backgroundColor,
        buttonBackgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor!,
        animationDuration: Duration(milliseconds: 300),
        items: <Widget>[
          Icon(Icons.location_searching, size: 30),
          Icon(Icons.account_circle_sharp, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 70),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}
