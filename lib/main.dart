import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gausampada/app/providers.dart';
import 'package:gausampada/backend/providers/locale_provider.dart';
import 'package:gausampada/firebase_options.dart';
import 'package:gausampada/l10n/l10n.dart';
import 'package:gausampada/screens/home/home_screen.dart';
import 'package:gausampada/screens/onboarding/onboarding_main.dart';
import 'package:gausampada/const/colors.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences prefs;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: ChangeNotifierProvider(
          create: (context) => LocaleProvider(),
          builder: (context, child) {
            return MaterialApp(
              title: 'GauSampada',
              debugShowCheckedModeBanner: false,
              theme: ThemeData().copyWith(
                scaffoldBackgroundColor: Colors.white,
                textTheme: GoogleFonts.dmSansTextTheme(
                  Theme.of(context).textTheme,
                ),
                appBarTheme: const AppBarTheme(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                ),
              ),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Provider.of<LocaleProvider>(context).locale,
              supportedLocales: L10n.locales,

              home: StreamBuilder(
                  stream: FirebaseAuth.instance.authStateChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      //  await prefs.setString('user_id', user?.uid ?? "id----");
                      return const HomeScreen();
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text("error will loading the data"),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: themeColor,
                        ),
                      );
                    }

                    return const OnboardingMainScreen();
                    // return const LoginScreen();
                  }),
              // home: const HomeScreen(),
              // home: const OnboardingMainScreen(),
            );
          }),
    );
  }
}

/// For generating local files translations use "flutter gen-l10n"
