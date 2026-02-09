import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/api.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../splash_screen/splash_page.dart';
import '../../domain/use_cases/translate_text.dart';

class LanguageProvider extends ChangeNotifier {
  late Locale
      language; // use this var when control state of language widget then use it for change language
  Locale _appLocale = const Locale('ar');
  static const List<Locale> languages = [
    Locale('ar', ''),
    Locale('de', ''),
    Locale('fr', ''),
    // Locale("en",""),
    //Locale('it', ''),
  ];
  Locale get appLocal => _appLocale;

  Future<String?> checkLanguageCode() async {
    var prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('language_code');
    return language;
  }

  fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    String? code = prefs.getString('language_code');

    code ??= 'ar';

    final supported = languages.map((e) => e.languageCode).toSet();
    if (!supported.contains(code)) {
      code = 'ar';
      await prefs.setString('language_code', code);
    }

    _appLocale = Locale(code);
    notifyListeners();
  }

  Future changeLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    _appLocale = language;
    await prefs.setString('language_code', language.languageCode);
    notifyListeners();
    ApiHandel.getInstance.updateHeader('123', language: language.languageCode);
    afterChangeLanguage();
  }

  void setLanguage(Locale locale, {bool rebuild = true}) {
    language = locale;
    if (rebuild) notifyListeners();
  }

  void rebuild() {
    notifyListeners();
  }

  static String translate(String key, String value) {
    // return Translate.translate(key, value);
    return Translate.translate(key, value);
  }

  Future afterChangeLanguage() async {
    navPARU(const SplashPage());
    // var login = Provider.of<AuthenticationProvider>
    //   (Constants.globalContext(),listen: false);
    // if(await login.checkLogin()){
    //   loading();
    //   login.loginButton(fromSplash: true);
    // }else{
    //   login.guestLogin();
    // }
  }

  void showLangDialog() {
    var language =
        Provider.of<LanguageProvider>(Constants.globalContext(), listen: false);
    String oldLang = language.appLocal.languageCode;
    showModalBottomSheet(
      context: Constants.globalContext(),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              width: 100.w,
              constraints: BoxConstraints(
                maxHeight: 40.h,
                minHeight: 40.h,
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(36),
                  topRight: Radius.circular(36),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: StatefulBuilder(
                    builder: (ctx, setState2) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 3.h,
                          ),
                          RadioListTile<String>(
                            value: 'ar',
                            groupValue: oldLang,
                            onChanged: (val) {
                              setState2(() {
                                oldLang = val!;
                              });
                            },
                            title: Text(
                              'العربية',
                              style: TextStyle(fontSize: 12.sp, height: 1),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          RadioListTile<String>(
                            value: 'de',
                            groupValue: oldLang,
                            onChanged: (val) {
                              setState2(() {
                                oldLang = val!;
                              });
                            },
                            title: Text(
                              'Deutsch',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          // RadioListTile<String>(value: 'en', groupValue: oldLang, onChanged: (val){
                          //   setState2((){
                          //     oldLang = val!;
                          //   });
                          // },title: Text('English',style: TextStyle(fontSize: 12.sp),)
                          //   ,contentPadding: EdgeInsets.zero,),
                          // SizedBox(height: 1.h,),
                          RadioListTile<String>(
                            value: 'fr',
                            groupValue: oldLang,
                            onChanged: (val) {
                              setState2(() {
                                oldLang = val!;
                              });
                            },
                            title: Text(
                              'Français',
                              style: TextStyle(fontSize: 12.sp),
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          // RadioListTile<String>(value: 'it', groupValue: oldLang, onChanged: (val){
                          //   setState2((){
                          //     oldLang = val!;
                          //   });
                          // },title: Text('Italiano',style: TextStyle(fontSize: 12.sp),)
                          //   ,contentPadding: EdgeInsets.zero,),
                          SizedBox(
                            height: 3.h,
                          ),
                          ButtonWidget(
                              onTap: () {
                                language.setLanguage(
                                  Locale(oldLang),
                                  rebuild: true,
                                );
                                language.changeLanguage();
                              },
                              text: "save"),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }
}
