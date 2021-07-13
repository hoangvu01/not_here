import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not_here/home/panel/sliding_panel.dart';
import 'package:not_here/home/selectable_address.dart';
import 'package:not_here/web/google_api/geocoding/geocoding_query.dart';
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.pageController}) : super(key: key);

  final PageController pageController;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchBarController = TextEditingController();
  final PanelController _panelController = PanelController();

  /// The future contains address and coordinates of the locations that match
  /// the text in the search bar
  Future<List<GeoCodingAddress>>? _geoAddresses;

  /// Address selected by user
  GeoCodingAddress? _selectedAddress;

  /// Visibility of slide-up panel
  bool _isPanelVisible = false;

  /// Completed search bar after user has hit ENTER
  String _enteredSearchText = "";

  @override
  void initState() {
    super.initState();
    searchBarController.addListener(() {
      if (searchBarController.text.isEmpty) {
        _isPanelVisible = false;
      }
    });
  }

  Widget _buildSearchTextField(BuildContext ctx) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: TextField(
        controller: searchBarController,
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          border: UnderlineInputBorder(),
          hintText: 'Town, city or postcode',
          suffix: GestureDetector(
            onTap: () {
              setState(() {
                _enteredSearchText = "";
                _geoAddresses = null;
              });
              searchBarController.clear();
              _panelController.close();
            },
            child: Icon(Icons.clear, size: 14),
          ),
        ),
        onEditingComplete: () {
          setState(() {
            FocusScope.of(context).unfocus();
            _enteredSearchText = searchBarController.text;
            _geoAddresses = fetchCoordinates(_enteredSearchText);
          });
        },
      ),
    );
  }

  Widget _buildSearchBox(BuildContext context) => Container(
        margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 15.0),
              color: Theme.of(context).shadowColor,
              blurRadius: 10.0,
              spreadRadius: 3.0,
            ),
          ],
          color: Theme.of(context).colorScheme.onBackground,
        ),
        child: _buildSearchTextField(context),
      );

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      renderPanelSheet: false,
      backdropColor: Theme.of(context).scaffoldBackgroundColor,
      controller: _panelController,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 2,
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
            flex: 1,
            child: _buildSearchBox(context),
          ),
          Flexible(
            flex: 4,
            child: Visibility(
              visible: _enteredSearchText.isNotEmpty,
              child: FutureBuilder(
                future: _geoAddresses,
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    final addresses = snapshot.data as List<GeoCodingAddress>;
                    return SelectableAddressList(
                        addresses: addresses,
                        onSelect: (GeoCodingAddress address) {
                          setState(() {
                            _selectedAddress = address;
                            _isPanelVisible = true;
                            _panelController.open();
                          });
                        });
                  }

                  return Text("No results");
                },
              ),
            ),
          )
        ],
      ),
      panel: Visibility(
        visible: _isPanelVisible,
        child: _selectedAddress == null
            ? Text("Invalid address")
            : CrimePanel(
                key: Key(_enteredSearchText),
                data: CrimePanelData(_selectedAddress!),
              ),
      ),
      maxHeight: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom -
          100,
    );
  }
}
