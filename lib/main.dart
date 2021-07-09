import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:not_here/about/about_page.dart';
import 'package:not_here/home/search_page.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:not_here/theme.dart';

Future main() async {
  await dotenv.load(fileName: ".env");

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Here!',
      theme: AppTheme.lightTheme(),
      home: LandingPage(),
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
            SearchPage(pageController: _pageController),
            AboutPage(),
            Placeholder(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        backgroundColor: Theme.of(context).backgroundColor,
        buttonBackgroundColor: Colors.white,
        animationDuration: Duration(milliseconds: 400),
        items: <Widget>[
          Icon(Icons.location_searching, size: 30),
          Icon(Icons.account_circle_sharp, size: 30),
          Icon(Icons.line_style_rounded, size: 30),
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
