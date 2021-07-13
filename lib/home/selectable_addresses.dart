import 'package:flutter/material.dart';
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';

class SelectableAddress extends StatefulWidget {
  const SelectableAddress({Key? key, required this.addresses})
      : super(key: key);

  final List<GeoCodingAddress> addresses;

  @override
  _SelectableAddressState createState() => _SelectableAddressState();
}

class _SelectableAddressState extends State<SelectableAddress> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
