import 'package:contri_app/sdk/functions/messaging_functions.dart';
import 'package:contri_app/auth/auth_bloc.dart';
import 'package:contri_app/global/bloc_observer.dart';
import 'package:contri_app/global/global_helpers.dart';
import 'package:contri_app/global/logger.dart';
import 'package:contri_app/ui/components/currency_helpers.dart';
import 'package:contri_app/ui/global/utils.dart';
import 'package:contri_app/ui/global/theme/app_themes.dart';
import 'package:contri_app/ui/global/theme/bloc/theme_bloc.dart';
import 'package:contri_app/ui/screens/complete_profile/complete_profile.dart';
import 'package:contri_app/ui/screens/detailed_expense_page/detail_expense_page.dart';
import 'package:contri_app/ui/screens/donation_page/donation_page.dart';
import 'package:contri_app/ui/screens/edit_expense_page/edit_expense_page.dart';
import 'package:contri_app/ui/screens/home_page/home_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/add_expense_page/add_expense_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/friends_page/friends_page.dart';
import 'package:contri_app/ui/screens/home_page/pages/groups_page/groups_page.dart';
import 'package:contri_app/ui/screens/login_page/login_page.dart';
import 'package:contri_app/ui/screens/profile_page/profile_page.dart';
import 'package:contri_app/ui/screens/register_page/register_page.dart';
import 'package:contri_app/ui/screens/settings_page/settings_page.dart';
import 'package:contri_app/ui/screens/verification_page/verification_page.dart';
import 'package:country_codes/country_codes.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await CountryCodes.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      BlocProvider<AuthBloc>(
        create: (context) => AuthBloc()..add(AppStarted()),
        child: JustSplitApp(),
      ),
    ),
  );
}

class JustSplitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) =>
            MainAppWithTheme(context: context, state: state),
      ),
    );
  }
}

class MainAppWithTheme extends StatefulWidget {
  const MainAppWithTheme({
    Key key,
    @required this.context,
    @required this.state,
  }) : super(key: key);

  final BuildContext context;
  final ThemeState state;

  @override
  _MainAppWithThemeState createState() => _MainAppWithThemeState();
}

class _MainAppWithThemeState extends State<MainAppWithTheme> {
  final FirebaseAnalytics _analytics = FirebaseAnalytics();

  /// To get preferred theme
  Future<void> loadSavedThemeData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final _appThemeIndex = _prefs.getInt('theme_id') ?? 1;
    final _appTheme = AppTheme.values[_appThemeIndex];
    BlocProvider.of<ThemeBloc>(context).add(ThemeChanged(appTheme: _appTheme));
  }

  Map<String, dynamic> _currencyData = {};

  @override
  void initState() {
    loadSavedThemeData().then((_) => logger.i("Got Saved Theme"));
    _analytics.logAppOpen().then((_) => logger.v("AnalyticsEvent: AppStarted"));
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    if (_currencyData.isEmpty) {
      final _d = await getCurrencyData(context);
      setState(() {
        _currencyData = _d;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthUnAuthenticated) {
          logger.d("state is AuthUnAuthenticated");
          if (state.justLoggedOut) {
            logger.d("Just logged out");
          }
        }
        if (state is AuthFailure) {
          Fluttertoast.showToast(
            msg: state.message,
            textColor: Theme.of(context).textTheme.bodyText2.color,
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Theme.of(context).backgroundColor
                : Colors.grey[800],
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 4,
            fontSize: screenHeight * 0.01511817,
          );
        }
      },
      child: MaterialApp(
        title: 'JustSplit',
        debugShowCheckedModeBanner: false,
        theme: widget.state.appThemeData,
        navigatorObservers: [
          FirebaseAnalyticsObserver(
            analytics: _analytics,
          ),
        ],
        routes: {
          LoginPage.id: (context) => LoginPage(),
          RegisterPage.id: (context) => RegisterPage(),
          VerificationPage.id: (context) => VerificationPage(),
          ProfileRegPage.id: (context) => ProfileRegPage(),
          HomePage.id: (context) => HomePage(),
          FriendsPage.id: (context) => FriendsPage(),
          AddExpensePage.id: (context) => AddExpensePage(),
          DetailExpPage.id: (context) => DetailExpPage(),
          EditExpensePage.id: (context) => EditExpensePage(),
          GroupsPage.id: (context) => GroupsPage(),
          ProfilePage.id: (context) => ProfilePage(),
          SettingsPage.id: (context) => SettingsPage(),
          DonationPage.id: (context) => DonationPage(),
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            logger.i("Configuring FCM");
            NotificationHandler().configureFcm(context);
            logger.i("FCM configured");
            initializeUtils(context);
            currencySymbol = getCurrencySymbol(currencyData: _currencyData);

            if (state is AuthUnInitialized)
              return LoginPage();
            else if (state is AuthUnAuthenticated)
              return LoginPage();
            else if (state is AuthAuthenticated) {
              _analytics.logEvent(name: "home_page_loaded");
              return HomePage();
            } else if (state is AuthNeedsVerification)
              return VerificationPage();
            else if (state is AuthNeedsProfileComplete)
              return ProfileRegPage();
            else
              return SafeArea(
                child: Scaffold(
                  //? Its hard coded, to fix the jank on transition from splash to loading screen
                  backgroundColor: Colors.white,
                  body: Container(
                    width: screenWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 70.0),
                        SvgPicture.asset(
                          'assets/icons/misc/JustSplit_logo_v3-08.svg',
                          width: screenWidth * 0.25,
                          placeholderBuilder: (context) => Container(),
                        ),
                        const SizedBox(height: 75.0),
                        const CircularProgressIndicator()
                      ],
                    ),
                  ),
                ),
              );
          },
        ),
      ),
    );
  }
}
