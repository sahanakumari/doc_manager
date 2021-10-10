import 'package:doc_manager/providers/app_settings.dart';
import 'package:doc_manager/providers/doc_provider.dart';
import 'package:doc_manager/screens/home_screen.dart';
import 'package:doc_manager/screens/login_screen.dart';
import 'package:doc_manager/session_n_networking/session.dart';
import 'package:doc_manager/utils/app_localizations.dart';
import 'package:doc_manager/utils/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences pref;
  do {
    pref = await Session.init();
  } while (pref == null);
  String _route = Session.isLoggedIn ? "/home" : "/login";
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AppSettings>(create: (_) => AppSettings()),
        ChangeNotifierProvider<DocProvider>(create: (_) => DocProvider()),
      ],
      child: LandingScreen(initialRoute: _route),
    ),
  );
}

class LandingScreen extends StatelessWidget {
  final String? initialRoute;

  const LandingScreen({Key? key, this.initialRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: kSwatch[900],
      ),
    );
    return Consumer<AppSettings>(
      builder: (_, AppSettings settings, __) {
        AppTheme appTheme = AppTheme(settings);
        return MaterialApp(
          theme: appTheme.theme,
          darkTheme: appTheme.darkTheme,
          themeMode: settings.themeMode,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('hi', 'IN'),
          ],
          locale: settings.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          routes: {
            '/home': (context) => const HomeScreen(),
            '/login': (context) => const LoginScreen(),
          },
          debugShowCheckedModeBanner: false,
          initialRoute: initialRoute ?? "/login",
        );
      },
    );
  }
}
