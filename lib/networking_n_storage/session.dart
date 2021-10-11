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

//Preferences key names
const appThemeMode = "app_ThemeMode";
const appColorScheme = "app_ColorScheme";
const appCornerRadius = "app_CornerRadius";
const appFontName = "app_FontName";
const appFontSize = "app_FontSize";
const appLanguage = "app_Language";
const loginMobile = "login_Mobile";
const loginUUID = "login_UUID";

class Session {
  static late SharedPreferences _pref;

  static Future<SharedPreferences> init() async {
    var value = await SharedPreferences.getInstance();
    _pref = value;
    return _pref;
  }

  //App Settings
  static int get themeMode => _pref.getInt(appThemeMode) ?? _THEME_MODE;

  static int get colorScheme => _pref.getInt(appColorScheme) ?? _COLOR_SCHEME;

  static double get cornerRadius =>
      _pref.getDouble(appCornerRadius) ?? _CORNER_RADIUS;

  static String get fontName => _pref.getString(appFontName) ?? _FONT_NAME;

  static double get fontSize => _pref.getDouble(appFontSize) ?? _FONT_SIZE;

  static String? get language => _pref.getString(appLanguage) ?? _LANGUAGE;

  static set themeMode(int value) {
    _pref.setInt(appThemeMode, value);
  }

  static set colorScheme(int value) {
    _pref.setInt(appColorScheme, value);
  }

  static set cornerRadius(double value) {
    _pref.setDouble(appCornerRadius, value);
  }

  static set fontName(String value) {
    _pref.setString(appFontName, value);
  }

  static set fontSize(double value) {
    _pref.setDouble(appFontSize, value);
  }

  static set language(String? value) {
    if (value == null) {
      _pref.remove(appLanguage);
    } else {
      _pref.setString(appLanguage, value);
    }
  }

  static get isLoggedIn => sessionUser != null;

  static SessionUser? get sessionUser {
    var mobile = _pref.getString(loginMobile);
    var uuid = _pref.getString(loginUUID);
    if (mobile == null || uuid == null) return null;
    return SessionUser(uuid, mobile);
  }

  static set sessionUser(SessionUser? value) {
    if (value == null || value.mobile == null) {
      _pref.remove(loginMobile);
      _pref.remove(loginUUID);
    } else {
      _pref.setString(loginMobile, value.mobile!);
      _pref.setString(loginUUID, value.uuid);
    }
  }
}

class SessionUser {
  final String uuid;
  final String? mobile;

  SessionUser(this.uuid, this.mobile);
}
