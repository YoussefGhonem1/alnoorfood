import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/text_style.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/logo_widget.dart';
import '../provider/language_provider.dart';
import '../widgets/language_widget.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {

  @override
  void initState() {
    super.initState();
    var language = Provider.of<LanguageProvider>(context,listen: false);
    language.setLanguage(language.appLocal,rebuild: false);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 94.w,
          height: 100.h,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 6.h,),
                LogoWidget(width: 45.w,),
                SizedBox(height: 2.h,),
                Text(LanguageProvider.translate("language", "choose"),style: TextStyleClass.headBoldStyle(),),
                SizedBox(height: 1.h,),
                const LanguageWidget(),
                SizedBox(height: 3.h,),
                ButtonWidget(onTap: (){
                  Provider.of<LanguageProvider>(context,listen: false).changeLanguage();
                }, text: "confirm"),
                SizedBox(height: 4.h,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
