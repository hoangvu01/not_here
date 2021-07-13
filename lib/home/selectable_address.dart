import 'package:flutter/material.dart';
import 'package:not_here/web/google_api/geocoding/model/geocode_parts.dart';

class SelectableAddressList extends StatefulWidget {
  const SelectableAddressList(
      {Key? key, required this.addresses, required this.onSelect})
      : super(key: key);

  final List<GeoCodingAddress> addresses;

  final void Function(GeoCodingAddress) onSelect;

  @override
  _SelectableAddressListState createState() => _SelectableAddressListState();
}

class _SelectableAddressListState extends State<SelectableAddressList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Container(
              child: Text(
                'Select an address',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.addresses.length,
              itemBuilder: (BuildContext ctx, int index) {
                final address = widget.addresses[index];

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.0, 5.0),
                        color: Theme.of(context).shadowColor,
                        blurRadius: 5.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.onBackground,
                      onPrimary: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () => widget.onSelect(address),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                      leading: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).colorScheme.primaryVariant,
                        ),
                        child: Icon(Icons.location_pin, size: 16),
                      ),
                      title: Text(address.formattedAddress),
                      dense: true,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
