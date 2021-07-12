import 'package:flutter/material.dart';
import 'package:not_here/utils/icons.dart';
import 'package:not_here/web/police_api/model/neighbourhood.dart';

class NeighbourhoodContacts extends StatelessWidget {
  const NeighbourhoodContacts(this.data, {Key? key}) : super(key: key);

  final NeighbourhoodForceData data;

  List<Widget> _buildEngagementMethods(BuildContext context) {
    return data.engagementMethods
        .map(
          (NeibourhoodForceEngagement item) => RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                WidgetSpan(child: IconsGenerator.generateBrandIcon(item.type)),
                TextSpan(text: item.url),
              ],
            ),
          ),
        )
        .toList();
  }

  List<Widget> _buildDefaultFields(BuildContext context) {
    return [
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          text: data.name,
        ),
      ),
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          text: data.url,
        ),
      ),
      RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            WidgetSpan(child: Icon(Icons.phone)),
            TextSpan(text: data.telephone),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ..._buildDefaultFields(context),
      ..._buildEngagementMethods(context),
    ]);
  }
}
