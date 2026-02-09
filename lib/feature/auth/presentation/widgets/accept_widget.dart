import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/checkbox_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../settings/presentation/pages/web_view.dart';
import '../../../settings/presentation/provider/settings_provider.dart';
import '../provider/auth_provider.dart';

class AcceptWidget extends StatelessWidget {
  const AcceptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SettingsProvider settingsProvider = Provider.of(context,listen: false);
    AuthenticationProvider authProvider = Provider.of(context);
    return FittedBox(
      child: Row(
        children: [
          CheckBoxWidget(check: authProvider.acceptTerms, onChange: (s){
            authProvider.changeAcceptTerms();
          }),
          SizedBox(width: 1.w,),
          Text(
            '${LanguageProvider.translate('register', 'accept1')} ',
            style: TextStyleClass.normalStyle(color: AppColor.greyColor),
            textAlign: TextAlign.center,
          ),
          InkWell(
            onTap: () {
              navP(WebViewPage(
                  title: 'terms',
                  link: settingsProvider.settingsEntity?.terms ?? ""));
            },
            child: Text(
              '${LanguageProvider.translate('register', 'accept2')} ',
              style: TextStyleClass.smallStyle(color: AppColor.defaultColor),
              textAlign: TextAlign.center,
            ),
          ),
          Text('${LanguageProvider.translate('register', 'accept3')} ',
              style: TextStyleClass.smallStyle(color: AppColor.greyColor),
              textAlign: TextAlign.center),
          InkWell(
            onTap: () {
              navP(WebViewPage(
                  title: 'privacy',
                  link: settingsProvider.settingsEntity?.privacy ?? ""));
            },
            child: Text('${LanguageProvider.translate('register', 'accept4')} ',
                style: TextStyleClass.smallStyle(color: AppColor.defaultColor),
                textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}
