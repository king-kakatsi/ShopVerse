import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shop_verse/controllers/asset_controller.dart';
import 'package:shop_verse/controllers/theme_controller.dart';
import 'package:shop_verse/controllers/bitcoin_controller.dart';
import 'package:shop_verse/controllers/auth_controller.dart';
import 'package:shop_verse/controllers/store_controller.dart';
import 'package:shop_verse/controllers/cart_controller.dart';
import 'package:shop_verse/controllers/order_controller.dart';
import 'package:shop_verse/pages/root_page.dart';
import 'package:shop_verse/pages/auth/login_page.dart';
import 'package:shop_verse/themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow only portrait mode
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  initGetIt();

  // Initialize theme with user preferences
  final themeController = GetIt.instance<ThemeController>();
  await themeController.init();

  // Initialize Bitcoin controller and start polling
  final bitcoinController = GetIt.instance<BitcoinController>();
  await bitcoinController.init();

  runApp(const AppRoot());
}

/// Initialize GetIt dependency injection
void initGetIt() {
  final getIt = GetIt.instance;
  getIt.registerSingleton<AssetController>(AssetController());
  getIt.registerSingleton<ThemeController>(ThemeController());
  getIt.registerSingleton<BitcoinController>(BitcoinController());
  getIt.registerSingleton<AuthController>(AuthController());
  getIt.registerSingleton<StoreController>(StoreController());
  getIt.registerSingleton<CartController>(CartController());
  getIt.registerSingleton<OrderController>(OrderController());
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
        ChangeNotifierProvider<BitcoinController>.value(
          value: getIt<BitcoinController>(),
        ),
        ChangeNotifierProvider<AuthController>.value(
          value: getIt<AuthController>(),
        ),
        ChangeNotifierProvider<StoreController>.value(
          value: getIt<StoreController>(),
        ),
        ChangeNotifierProvider<CartController>.value(
          value: getIt<CartController>(),
        ),
        ChangeNotifierProvider<OrderController>.value(
          value: getIt<OrderController>(),
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
      themeMode: Provider.of<ThemeController>(context).themeMode,
      initialRoute: '/login',
      routes: {
        '/': (context) => const RootPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}
