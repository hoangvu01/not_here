import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconsGenerator {
  static final Map<String, FaIcon> _BRANDS_ICON_MAPPING = {
    'youtube': FaIcon(FontAwesomeIcons.youtube),
    'facebook': FaIcon(FontAwesomeIcons.facebookF),
    'twitter': FaIcon(FontAwesomeIcons.twitter),
  };

  static bool hasBrand(String text) =>
      _BRANDS_ICON_MAPPING.containsKey(text.toLowerCase());

  static FaIcon generateBrandIcon(String text) {
    assert(hasBrand(text));
    return _BRANDS_ICON_MAPPING[text.toLowerCase()]!;
  }
}
