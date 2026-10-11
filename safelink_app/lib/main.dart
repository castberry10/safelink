import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:safelink_app/const/app_theme.dart';
import 'package:safelink_app/const/colors.dart';
import 'package:safelink_app/const/value_name.dart';
import 'package:safelink_app/screens/home_screen.dart';
import 'package:safelink_app/screens/splash_screen.dart';
import 'package:safelink_app/services/local_data_manager.dart';
import 'package:safelink_app/services/localization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await LocalDataManager.init();

  await LocalizationService.instance.load('en');

  runApp(const SafeLinkApp());
}

class SafeLinkApp extends StatefulWidget {
  const SafeLinkApp({super.key});

  @override
  State<SafeLinkApp> createState() => _SafeLinkAppState();
}

class _SafeLinkAppState extends State<SafeLinkApp>
    with WidgetsBindingObserver {
  // Provides access to Navigator context from async callbacks (e.g. update dialog)
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late final LocalDataManager _localDataManager;
  late final Future<Widget> _initialPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    LocalizationService.instance.addListener(_onLocaleChanged);

    _localDataManager = LocalDataManager();
    _initialPage = _decideInitialPage();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _updateSystemUiOverlay());

  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    LocalizationService.instance.removeListener(_onLocaleChanged);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() => _updateSystemUiOverlay();

  void _onLocaleChanged() {
    if (mounted) setState(() {});
  }

  void _updateSystemUiOverlay() {
    final isDark =
        WidgetsBinding.instance.platformDispatcher.platformBrightness ==
            Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor:
          isDark ? AppColors.darkBg : AppColors.lightBg,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
    ));
  }

  Future<Widget> _decideInitialPage() async {
    final username =
        await _localDataManager.getStringData(ValueName.username);
    return (username == null || username == 'Gest')
        ? const SplashScreen()
        : const SafeLinkHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeLink',
      navigatorKey: _navigatorKey,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _initialPage,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return snapshot.data!;
        },
      ),
    );
  }
}