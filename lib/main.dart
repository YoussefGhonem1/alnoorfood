import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:homsfood/feature/chat/presentation/provider/chat_provider.dart';
import 'package:homsfood/feature/chat/presentation/provider/message_provider.dart';
import 'package:homsfood/feature/order/presentation/provider/map_orders_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'config/theme.dart';
import 'core/constants/constants.dart';
import 'core/helper_function/api.dart';
import 'core/helper_function/notifications.dart';
import 'core/models/local_notifications.dart';
import 'feature/address/presentation/provider/address_provider.dart';
import 'feature/address/presentation/provider/bottom_map_sheet.dart';
import 'feature/address/presentation/provider/map_provider.dart';
import 'feature/auth/presentation/provider/auth_provider.dart';
import 'feature/auth/presentation/provider/edit_account_provider.dart';
import 'feature/auth/presentation/provider/otp_provider.dart';
import 'feature/cart/presentation/provider/cart_provider.dart';
import 'feature/cart/presentation/provider/check_out_provider.dart';
import 'feature/category/presentation/provider/category_provider.dart';
import 'feature/cities/presentation/provider/city_provider.dart';
import 'feature/delivery_visit/presentation/provider/delivery_visit_provider.dart';
import 'feature/home/presentation/provider/home_provider.dart';
import 'feature/language/domain/entities/app_localizations.dart';
import 'feature/language/presentation/provider/language_provider.dart';
import 'feature/main/main_provider.dart';
import 'feature/material/presentation/provider/material_provider.dart';
import 'feature/notification/presentation/provider/notification_provider.dart';
import 'feature/order/presentation/provider/current_delivery_order_provider.dart';
import 'feature/order/presentation/provider/current_order_provider.dart';
import 'feature/order/presentation/provider/new_order_provider.dart';
import 'feature/order/presentation/provider/order_delivery_provider.dart';
import 'feature/order/presentation/provider/order_provider.dart';
import 'feature/order/presentation/provider/previous_delivery_order_provider.dart';
import 'feature/order/presentation/provider/previous_order_provider.dart';
import 'feature/product/presentation/provider/favorite_product_provider.dart';
import 'feature/product/presentation/provider/new_product_provider.dart';
import 'feature/product/presentation/provider/product_favorite_provider.dart';
import 'feature/product/presentation/provider/search_product_provider.dart';
import 'feature/product/presentation/provider/stock_product_provider.dart';
import 'feature/settings/presentation/provider/delivery_visits_provider.dart';
import 'feature/settings/presentation/provider/settings_provider.dart';
import 'feature/splash_screen/splash_page.dart';
import 'feature/splash_screen/splash_provider.dart';
import 'feature/support/presentation/provider/support_provider.dart';
import 'injection_container.dart';


@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage event) async {
  if(event.notification!=null){
    dataNoti = jsonEncode(event.data);
    remoteNotification = event.notification!;
    appNotifications(remoteNotification!,click: true,fromWhereClicked: 3,
        payload: jsonEncode(event.data));
  }
}

Future<void> localMessagingBackgroundHandler(NotificationResponse pay) async {
  clickNoti(pay.payload!);
}
late SharedPreferences sharedPreferences;
Future startSharedPref()async{
  SharedPreferences.resetStatic();
  sharedPreferences = await SharedPreferences.getInstance();
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationLocalClass.init();
  HttpOverrides.global = MyHttpOverrides();
  LanguageProvider language = LanguageProvider();
if (Firebase.apps.isEmpty) {
  if (Platform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBGzQ_TokHdlSd5HxOIvEvj-PDxzHTjEow', 
        appId: '1:439583572160:android:b6586a23063b53e723ad25', 
        messagingSenderId: '439583572160', 
        projectId: 'alnoorfood-d9379',
      ),
    );
  } else {
    await Firebase.initializeApp(); 
  }
}

FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  notificationsFirebase();
  language.fetchLocale();
  await initializeDependencies();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,overlays: [SystemUiOverlay.bottom]);
  await ApiHandel.getInstance.init();
  await startSharedPref();
  runApp(MyApp(language: language,));
}

class MyApp extends StatelessWidget {
  final LanguageProvider language;
  const MyApp({required this.language,super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LanguageProvider()),
        ChangeNotifierProvider(create: (context) => OTPProvider(),),
        ChangeNotifierProvider(create: (context) => MainProvider(),),
        ChangeNotifierProvider(create: (context) => AddressProvider(),),
        ChangeNotifierProvider(create: (context) => MapProvider(),),
        ChangeNotifierProvider(create: (context) => BottomMapSheetProvider(),),
        ChangeNotifierProvider(create: (context) => CheckOutProvider(),),
        ChangeNotifierProvider(create: (context) => SettingsProvider(),),
        ChangeNotifierProvider(create: (context) => EditAccountProvider(),),
        ChangeNotifierProvider(create: (context) => SupportProvider(),),
        ChangeNotifierProvider(create: (context) => OrdersProvider(),),
        ChangeNotifierProvider(create: (context) => SplashProvider(),),
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider(),),
        ChangeNotifierProvider(create: (context) => ProductFavoriteProvider(),),
        ChangeNotifierProvider(create: (context) => NewProductProvider(),),
        ChangeNotifierProvider(create: (context) => FavoriteProductProvider(),),
        ChangeNotifierProvider(create: (context) => CartProvider(),),
        ChangeNotifierProvider(create: (context) => MaterialProvider(),),
        ChangeNotifierProvider(create: (context) => CurrentOrderProvider(),),
        ChangeNotifierProvider(create: (context) => PreviousOrderProvider(),),
        ChangeNotifierProvider(create: (context) => SearchProductProvider(),),
        ChangeNotifierProvider(create: (context) => NotificationProvider(),),
        ChangeNotifierProvider(create: (context) => NewOrderProvider(),),
        ChangeNotifierProvider(create: (context) => CurrentDeliveryOrderProvider(),),
        ChangeNotifierProvider(create: (context) => PreviousDeliveryOrderProvider(),),
        ChangeNotifierProvider(create: (context) => OrdersDeliveryProvider(),),
        ChangeNotifierProvider(create: (context) => StockProductProvider(),),
        ChangeNotifierProvider(create: (context) => CategoryProvider(),),
        ChangeNotifierProvider(create: (context) => DeliveryVisitsProvider(),),
        ChangeNotifierProvider(create: (context) => CityProvider(),),
        ChangeNotifierProvider(create: (context) => MapOrdersProvider(),),
        ChangeNotifierProvider(create: (context) => DeliveryVisitProvider(),),
        ChangeNotifierProvider(create: (context) => ChatProvider(),),
        ChangeNotifierProvider(create: (context) => MessageProvider(),),
      ],
      child: ChangeNotifierProvider<LanguageProvider>(
        create: (_)=>language,
        child: Consumer<LanguageProvider>(
          builder: (context,lang,_){
            return AnnotatedRegion(
              value: barColor(),
              child: Sizer(
                builder: (context,orientation,deviceType){
                  Constants.isTablet = (deviceType==DeviceType.tablet);
                  return MaterialApp(
                    title: 'Homs Food GmbH',
                    debugShowCheckedModeBanner: false,
                    navigatorKey: Constants.navState,
                    locale: lang.appLocal,
                    supportedLocales: LanguageProvider.languages,
                    builder: (context, child) {
                      return Container(
                        color: Colors.white,
                        child: SafeArea(
                          child: child!,
                        ),
                      );
                    },
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    theme: defaultTheme,
                    home:  const SplashPage(),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

SystemUiOverlayStyle barColor() {
  if (Platform.isAndroid) {
    return const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,

        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Colors.black);
  }
  return SystemUiOverlayStyle.dark;
}
