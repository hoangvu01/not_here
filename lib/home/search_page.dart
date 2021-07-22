import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:not_here/home/panel/sliding_panel.dart';
import 'package:not_here/home/search_bar.dart';
import 'package:not_here/home/selectable_address.dart';
import 'package:not_here/utils/location.dart';
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

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  /// Components to control animation of the [SelectableAddressList]'s flex
  /// attribute to enlarge search box size on focus.
  late final AnimationController _animationController;
  late final Animation _animation;

  /// Panel components
  final PanelController _panelController = PanelController();

  /// Create a google map query session
  final GoogleMapQueryService _googleMapQuery = GoogleMapQueryService();

  /// Data required to populate this page
  late final SearchPageData _data;

  @override
  void initState() {
    super.initState();

    _initData();
    _initAnimation();
  }

  void _initData() {
    SearchPageData? p = PageStorage.of(context)?.readState(
      context,
      identifier: ValueKey('searchPage'),
    ) as SearchPageData?;
    _data = p ?? SearchPageData();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      duration: Duration(milliseconds: 100),
      reverseDuration: Duration(milliseconds: 150),
      vsync: this,
    );

    _animation = IntTween(begin: 8, end: 3).animate(_animationController);
    _animation.addListener(() => setState(() {}));
  }

  void _useUserLocation() async {
    getUserLocation((LocationData _locationData) {
      setState(() {
        _data.geoAddresses = _googleMapQuery.reverseGeocode(
          _locationData.latitude!,
          _locationData.longitude!,
        );
        _data.isAddressListVisible = true;
      });

      PageStorage.of(context)?.writeState(
        context,
        _data,
        identifier: ValueKey('searchPage'),
      );
    });
  }

  Widget _buildSearchBar(BuildContext context) => SearchBar(
        onTap: () => _animationController.forward(),
        onEditComplete: (String text) {
          setState(() {
            _data.enteredSearchText = text;
            _data.geoAddresses = _googleMapQuery.forwardGeocode(text);
            _data.isAddressListVisible = true;
            PageStorage.of(context)?.writeState(
              context,
              _data,
              identifier: ValueKey('searchPage'),
            );
          });
        },
        onClear: () => setState(() {
          _data.enteredSearchText = "";
          _data.geoAddresses = null;
          _data.isAddressListVisible = false;
          _panelController.close();
          _data.isPanelVisible = false;

          PageStorage.of(context)?.writeState(
            context,
            _data,
            identifier: ValueKey('searchPage'),
          );
        }),
        onFocus: _animationController.forward,
        onUnFocus: _animationController.reverse,
      );

  Widget _buildSelectableAddressList(BuildContext context) => Visibility(
        visible: _data.isAddressListVisible,
        child: FutureBuilder(
          future: _data.geoAddresses,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              final addresses = snapshot.data as List<GeoCodingAddress>;
              if (addresses.isEmpty)
                return Container(
                  padding: const EdgeInsets.all(50),
                  child: Text(
                    'We cannot find a location that matches your search criteria',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );

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
              flex: 4,
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
              flex: 2,
              child: _buildSearchBar(context),
            ),
            Expanded(
              flex: _animation.value,
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
