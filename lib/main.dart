import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:not_here/about/about_page.dart';
import 'package:not_here/home/search_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final PageController _pageController = PageController();
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Not Here!',
      theme: ThemeData(
        fontFamily: 'Montserrat',
        scaffoldBackgroundColor: Colors.lightBlue.shade50,
      ),
      home: Scaffold(
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
              Dashboard(),
              AboutPage(),
              Dashboard(),
            ],
          ),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          backgroundColor: Colors.lightBlue.shade50,
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
                duration: Duration(milliseconds: 100),
                curve: Curves.easeInOut,
              );
            });
          },
        ),
      ),
    );
  }
}
