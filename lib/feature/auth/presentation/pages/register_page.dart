import 'package:flutter/material.dart';
import 'package:homsfood/core/constants/var.dart';
import 'package:homsfood/core/helper_function/navigation.dart';
import 'package:homsfood/core/widget/button_widget.dart';
import 'package:homsfood/core/widget/drop_down_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../cities/presentation/provider/city_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/auth_provider.dart';
import '../widgets/have_account_widget.dart';
import '../widgets/register_fields_widget.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider auth = Provider.of(context);
    // CityProvider cityProvider = Provider.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        top: auth.fromAuthRegister ? true : false,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: auth.fromAuthRegister ? 5.h : 8.h,
            backgroundColor: auth.fromAuthRegister ? Colors.transparent : AppColor.defaultColor,
            title: Text(LanguageProvider.translate("register", auth.titleText())),
            leadingWidth: 10.w,
          ),
          body: Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              width: 100.w,
              height: 100.h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // if (auth.fromAuthRegister) const BackButtonWidget(),
                    if (auth.fromAuthRegister&&deliveryEntity==null) Text(LanguageProvider.translate("register", auth.titleText()), style: TextStyleClass.semiStyle()),
                    if (auth.fromAuthRegister&&deliveryEntity==null)
                      Text(
                        LanguageProvider.translate("register", "after_register"),
                        style: TextStyleClass.smallStyle(color: const Color(0xff5C5C5C)),
                      ),
                    SizedBox(height: 1.h),
                    const RegisterFieldsWidget(),
                    SizedBox(height: 3.h),
                    ButtonWidget(
                        onTap: () {
                          print('register1');
                          FocusScope.of(context).unfocus();
                          print([formKey.currentState!.validate(), auth.fromAuthRegister, auth.acceptTerms,deliveryEntity!=null]);
                          if ((formKey.currentState!.validate() && auth.fromAuthRegister
                              && auth.acceptTerms) || (formKey.currentState!.validate() && !auth.fromAuthRegister) || (formKey.currentState!.validate() && deliveryEntity!=null)) {
                            if (auth.fromAuthRegister) {
                              print('register2');
                              // auth.registerButton();
                              auth.goToAddAddressPage();
                            } else {
                              print('register3');
                              auth.updateProfileButton();
                            }
                          }
                          // else {
                          //   auth.submitRegisterForm();
                          // }
                        },
                        text: auth.fromAuthRegister ? 'register' : 'save_editing'),
                    SizedBox(height: 3.h),
                    if (auth.fromAuthRegister&&deliveryEntity==null) const HaveAccountWidget(),
                    SizedBox(height: 6.h)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
