import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/asset_controller.dart';
import 'package:shop_verse/controllers/theme_controller.dart';
import 'package:shop_verse/pages/root_page.dart';
import 'package:shop_verse/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow only portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  initGetIt();

  // Initialize theme with user preferences
  final themeController = GetIt.instance<ThemeController>();
  await themeController.init();

  runApp(const AppRoot());
}

/// Initialize GetIt dependency injection
void initGetIt() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<AssetController>(AssetController());
  getIt.registerSingleton<ThemeController>(ThemeController());
}

/// Root application wrapper with dependency injection providers
class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final getIt = GetIt.instance;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AssetController>.value(
          value: getIt<AssetController>(),
        ),
        ChangeNotifierProvider<ThemeController>.value(
          value: getIt<ThemeController>(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

/// Main application widget with routing and theme configuration
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ShopVerse',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: context.watch<ThemeController>().themeMode,
      initialRoute: '/',
      routes: {'/': (context) => const RootPage()},
    );
  }
}
