import 'package:url_launcher/url_launcher.dart';

Future<void> launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch('tel:$url');
  } else {
    throw 'Could not launch $url';
  }
}
