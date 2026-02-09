import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/helper_function/helper_function.dart';
import '../../core/helper_function/navigation.dart';
import '../auth/presentation/provider/auth_provider.dart';
import '../cities/presentation/provider/city_provider.dart';
import '../language/presentation/pages/language_page.dart';
import '../language/presentation/provider/language_provider.dart';
import '../settings/presentation/provider/settings_provider.dart';

class SplashProvider extends ChangeNotifier{
  bool start = false;
  void startApp(context)async{
    await delay(500);
    Provider.of<SettingsProvider>(context,listen: false).getSettings();
    Provider.of<CityProvider>(context,listen: false).getCities();
    String? currentLanguage =  await LanguageProvider().checkLanguageCode();
    if(currentLanguage==null){
      delay(2000).then((value) {
        navPARU(const LanguagePage());
      });
    }else{
      var login = Provider.of<AuthenticationProvider>(context,listen: false);
      bool isLogin = await login.checkLogin();
      if(isLogin){
        Provider.of<AuthenticationProvider>(context,listen: false).loginButton(fromSplash: true);
      }else{
        login.guestLogin();
      }
    }
  }
}