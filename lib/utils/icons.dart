import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class IconsGenerator {
  static final Map<String, FaIcon> _icons = {
    'youtube': FaIcon(FontAwesomeIcons.youtube),
    'facebook': FaIcon(FontAwesomeIcons.facebookF),
    'twitter': FaIcon(FontAwesomeIcons.twitter),
  };

  static FaIcon generateBrandIcon(String text) {
    return _icons[text.toLowerCase()] ?? FaIcon(FontAwesomeIcons.adn);
  }
}
