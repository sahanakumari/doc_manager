import 'package:shared_preferences/shared_preferences.dart';

/*Supported theme modes [0=> System default, 1=> Light, 2=> Dark]*/
const _THEME_MODE = 1;

/*Color code int value (decimal)*/
const _COLOR_SCHEME = 0xfffab206;

/*Card corner radius*/
const _CORNER_RADIUS = 5.0;

/*Supported fonts [Josefin Sans, Montserrat, Poppins, null=> System default]*/
const _FONT_NAME = "Poppins";

/*Supported font scale factors [0.8=> Tiny, 0.9=> Small, 1.0=> Normal, 1.1=> Large, 1.2=> Huge]*/
const _FONT_SIZE = 1.0;

/*Supported languages [en=> English, es=> Espanol (Spanish), null=> System default]*/
const _LANGUAGE = null;

class Session {
  static late SharedPreferences _pref;

  static Future<SharedPreferences> init() async {
    var value = await SharedPreferences.getInstance();
    _pref = value;
    return _pref;
  }

  //App Settings
  static int get themeMode => _pref.getInt("app_ThemeMode") ?? _THEME_MODE;

  static int get colorScheme =>
      _pref.getInt("app_ColorScheme") ?? _COLOR_SCHEME;

  static double get cornerRadius =>
      _pref.getDouble("app_CornerRadius") ?? _CORNER_RADIUS;

  static String get fontName => _pref.getString("app_FontName") ?? _FONT_NAME;

  static double get fontSize => _pref.getDouble("app_FontSize") ?? _FONT_SIZE;

  static String? get language => _pref.getString("app_Language") ?? _LANGUAGE;

  static set themeMode(int value) {
    _pref.setInt("app_ThemeMode", value);
  }

  static set colorScheme(int value) {
    _pref.setInt("app_ColorScheme", value);
  }

  static set cornerRadius(double value) {
    _pref.setDouble("app_CornerRadius", value);
  }

  static set fontName(String value) {
    _pref.setString("app_FontName", value);
  }

  static set fontSize(double value) {
    _pref.setDouble("app_FontSize", value);
  }

  static set language(String? value) {
    if (value == null) _pref.remove("app_Language");
    _pref.setString("app_Language", value!);
  }

  static get isLoggedIn => _pref.getBool("isLoggedIn") ?? false;
}
