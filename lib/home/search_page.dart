import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not_here/home/sliding_panel.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchBarController = TextEditingController();
  final PanelController _panelController = PanelController();

  String _enteredSearchText = "";
  bool _panelVisible = false;

  @override
  void initState() {
    super.initState();
    searchBarController.addListener(() {
      if (searchBarController.text.isEmpty) {
        _panelVisible = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      renderPanelSheet: false,
      backdropColor: Colors.blue.shade100,
      controller: _panelController,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 3,
            child: Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10.0),
                child: Text(
                  'Are you travelling through a safe neighbourhood?',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0.0, 15.0),
                    color: Colors.blueGrey.shade100,
                    blurRadius: 10.0,
                    spreadRadius: 3.0,
                  ),
                ],
                color: Colors.white,
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                child: TextField(
                  controller: searchBarController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.search),
                    border: UnderlineInputBorder(),
                    hintText: 'Town, city or postcode',
                    suffix: GestureDetector(
                      onTap: () {
                        searchBarController.clear();
                        _panelController.close();
                      },
                      child: Icon(Icons.clear, size: 14),
                    ),
                  ),
                  onEditingComplete: () {
                    setState(() {
                      _enteredSearchText = searchBarController.text;
                      FocusScope.of(context).unfocus();
                      _panelVisible = true;
                    });
                  },
                ),
              ),
            ),
          ),
          Flexible(
            flex: 8,
            child: Container(),
          ),
          Flexible(
            flex: 1,
            child: Container(),
          )
        ],
      ),
      panel: Visibility(
        visible: _panelVisible,
        child: CrimePanel(
          address: _enteredSearchText,
        ),
      ),
      maxHeight: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom -
          100,
    );
  }
}
