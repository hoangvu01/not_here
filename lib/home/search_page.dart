import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:not_here/home/panel/sliding_panel.dart';
import 'package:not_here/home/selectable_address.dart';
import 'package:not_here/web/google_api/geocoding/geocoding_query.dart';
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SearchPageData {
  /// The future contains address and coordinates of the locations that match
  /// the text in the search bar
  Future<List<GeoCodingAddress>>? geoAddresses;

  /// Address selected by user
  GeoCodingAddress? selectedAddress;

  /// Visibility of slide-up panel
  bool isPanelVisible = false;

  /// Visibility of list of addresses
  bool isAddressListVisible = false;

  /// Completed search bar after user has hit ENTER
  String enteredSearchText = "";
}

class SearchPage extends StatefulWidget {
  const SearchPage({required Key key, required this.pageController})
      : super(key: key);

  final PageController pageController;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with WidgetsBindingObserver {
  final TextEditingController searchBarController = TextEditingController();
  final PanelController _panelController = PanelController();

  /// Create a google map query session
  final GoogleMapQueryService _googleMapQuery = GoogleMapQueryService();

  /// Data required to populate this page
  late final SearchPageData _data;

  bool _isKeyboardClose = false;
  bool _isKeyboardOpen = false;
  double _prevBottomInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);

    SearchPageData? p = PageStorage.of(context)?.readState(
      context,
      identifier: ValueKey('searchPage'),
    ) as SearchPageData?;
    if (p != null) {
      _data = p;
    } else {
      _data = SearchPageData();
    }
    searchBarController.addListener(() {
      if (searchBarController.text.isEmpty) {
        _data.isPanelVisible = false;
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    searchBarController.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance!.window.viewInsets.bottom;
    setState(() {
      _isKeyboardOpen = bottomInset > 0;
      _isKeyboardClose = bottomInset == 0;
      _prevBottomInset = bottomInset;
    });
    print(_isKeyboardOpen);
  }

  void _useUserLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      developer.log("Checking if location service is enabled...");
      _serviceEnabled = await location.requestService();

      if (!_serviceEnabled) {
        developer.log("Location service disabled!");
        return;
      }
    }

    developer.log("Requesting access to user's location...");
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        developer.log("Location service denied...");
        return;
      }
    }

    developer.log("Trying to get location...");
    _locationData = await location.getLocation();

    if (_locationData.latitude == null || _locationData.longitude == null) {
      throw Exception("Unable to get device location");
    }

    developer.log("Acquired location sucessfully\n"
        "(Lat, Lng): (${_locationData.latitude}, ${_locationData.longitude})");
    setState(() {
      _data.geoAddresses = _googleMapQuery.reverseGeocode(
        _locationData.latitude!,
        _locationData.longitude!,
      );
      _data.isAddressListVisible = true;
    });
    PageStorage.of(context)
        ?.writeState(context, _data, identifier: ValueKey('searchPage'));
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
                _data.enteredSearchText = "";
                _data.geoAddresses = null;
                searchBarController.clear();
                _panelController.close();
                _data.isPanelVisible = false;
                _data.isAddressListVisible = false;
                PageStorage.of(context)?.writeState(context, _data,
                    identifier: ValueKey('searchPage'));
              });
            },
            child: Icon(Icons.clear, size: 14),
          ),
        ),
        onEditingComplete: () {
          setState(() {
            FocusScope.of(context).unfocus();
            _data.enteredSearchText = searchBarController.text;
            _data.geoAddresses =
                _googleMapQuery.forwardGeocode(_data.enteredSearchText);
            _data.isAddressListVisible = true;
            PageStorage.of(context)?.writeState(context, _data,
                identifier: ValueKey('searchPage'));
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

  Widget _buildSelectableAddressList(BuildContext context) => Visibility(
        visible: _data.isAddressListVisible,
        child: FutureBuilder(
          future: _data.geoAddresses,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              final addresses = snapshot.data as List<GeoCodingAddress>;
              return SelectableAddressList(
                  addresses: addresses,
                  onSelect: (GeoCodingAddress address) {
                    setState(() {
                      _data.selectedAddress = address;
                      _data.isPanelVisible = true;
                      _panelController.open();
                    });
                    PageStorage.of(context)?.writeState(context, _data,
                        identifier: ValueKey('searchPage'));
                  });
            } else if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Unable to process data at the moment...',
              ));
            }

            return Center(
              child: SizedBox(
                height: 2,
                width: 100,
                child: LinearProgressIndicator(),
              ),
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: _isKeyboardOpen ? 1 : 2,
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 50, vertical: 10.0),
                  child: Text(
                    'Are you travelling through a safe neighbourhood?',
                    style: Theme.of(context).textTheme.headline1,
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
              child: _buildSelectableAddressList(context),
            ),
          ],
        ),
        SlidingUpPanel(
          renderPanelSheet: false,
          backdropColor: Theme.of(context).scaffoldBackgroundColor,
          controller: _panelController,
          panel: Visibility(
            visible: _data.isPanelVisible,
            child: _data.selectedAddress == null
                ? Text("Invalid address")
                : CrimePanel(
                    key: Key(_data.enteredSearchText),
                    data: CrimePanelData(_data.selectedAddress!),
                  ),
          ),
          maxHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              MediaQuery.of(context).padding.bottom -
              100,
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 15, 20),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _panelController.close();
                  _data.isPanelVisible = false;
                  PageStorage.of(context)?.writeState(
                    context,
                    _data,
                    identifier: ValueKey('searchPage'),
                  );
                });
                FocusScope.of(context).unfocus();
                _useUserLocation();
              },
              child: Icon(Icons.my_location, size: 26),
              style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
