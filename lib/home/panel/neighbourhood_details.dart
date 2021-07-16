import 'package:flutter/material.dart';
import 'package:not_here/utils/icons.dart';
import 'package:not_here/utils/launcher.dart';
import 'package:not_here/web/police_api/model/neighbourhood.dart';

class NeighbourhoodContacts extends StatelessWidget {
  const NeighbourhoodContacts(this.data, {Key? key}) : super(key: key);

  final NeighbourhoodForceData data;

  List<Widget> _buildEngagementMethods(BuildContext context) {
    List<Widget> widgets = data.engagementMethods
        .where((NeibourhoodForceEngagement item) =>
            IconsGenerator.hasBrand(item.type ?? ''))
        .map(
          (NeibourhoodForceEngagement item) => IconButton(
            icon: IconsGenerator.generateBrandIcon(item.type!),
            onPressed: () => launchInBrowser(item.url),
          ),
        )
        .toList();
    widgets.add(
      IconButton(
        tooltip: data.telephone,
        icon: Icon(Icons.phone),
        onPressed: () => makePhoneCall(data.telephone),
      ),
    );
    return widgets;
  }

  List<Widget> _buildDefaultFields(BuildContext context) {
    return [
      RichText(
        text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'Montserrat',
            color: Colors.black,
          ),
          text: data.name,
        ),
      ),
      GestureDetector(
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            text: data.url,
          ),
        ),
        onTap: () => launchInBrowser(data.url),
      ),
      GestureDetector(
        child: RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            text: "Hotline: ${data.telephone}",
          ),
        ),
        onTap: () => makePhoneCall(data.telephone),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._buildDefaultFields(context),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildEngagementMethods(context),
      )
    ]);
  }
}
