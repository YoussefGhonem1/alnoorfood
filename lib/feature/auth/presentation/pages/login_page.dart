import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/logo_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/auth_provider.dart';
class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          body: Consumer<AuthenticationProvider>(
            builder: (context,auth,_) {
              return SizedBox(
                width: 100.w,
                height: 100.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // SizedBox(height: 3.h,),
                      // SizedBox(
                      //   height: 37.h,
                      //   width: 100.w,
                      //   child: Stack(
                      //     children: [
                      //       SizedBox(child: Image.asset(Images.backgroundLogin,)),
                      //       Center(child: LogoWidget(width: 80.w,)),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: 1.5.h,),
                      Center(child: LogoWidget(width: 40.w,)),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 1.5.h,),
                            // Wrap(
                            //   children: [
                            //     Text(LanguageProvider.translate("login", "contact"),style: TextStyleClass.normalStyle(),),
                            //     InkWell(
                            //       onTap: (){
                            //         final Uri emailLaunchUri = Uri(
                            //           scheme: 'mailto',
                            //           path: 'info@gelateriamargherita.ch',
                            //           query: encodeQueryParameters(<String, String>{
                            //             'subject': LanguageProvider.translate("login", "register_help"),
                            //           }),
                            //         );
                            //         launchUrl(emailLaunchUri);
                            //       },
                            //       child: Text(' info@gelateriamargherita.ch',style: TextStyleClass.normalStyle(
                            //         color: AppColor.defaultColor,
                            //       ),),
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 1.5.h,),
                            Text(LanguageProvider.translate("login", "hi"),style: TextStyleClass.headBoldStyle(),),
                            SizedBox(height: 1.h,),
                            Text(LanguageProvider.translate("login", "welcome"),
                              style: TextStyleClass.normalStyle(color: AppColor.greyColor),),
                            SizedBox(height: 1.5.h,),
                            ...List.generate(auth.loginInputs.length, (index) =>
                                TextFieldWidget(controller: auth.loginInputs[index]['value'],
                                  obscureText: auth.loginInputs[index]['label'] == "pass" ?true:false,
                                  hintText: auth.loginInputs[index]['label'],
                                  next: index==0,
                                  onEditingComplete: (){
                                    if(index==1){
                                      FocusScope.of(context).unfocus();
                                      if(formKey.currentState!.validate()){
                                        auth.loginButton();
                                      }
                                    }
                                  },
                                  suffix: SvgWidget(svg: auth.loginInputs[index]['image'],width: 5.w,height: 5.w,
                                      ),),),
                            SizedBox(height: 1.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(child: Text(
                                  LanguageProvider.translate("login", "forget"),
                                  style: TextStyleClass.smallStyle(color: AppColor.defaultColor
                                  ),),onPressed: (){
                                  auth.forgetPass();
                                },),
                              ],
                            ),
                            SizedBox(height: 1.5.h,),
                            ButtonWidget(onTap: (){
                              if(formKey.currentState!.validate()){
                                auth.loginButton();
                              }
                            }, text: 'login'),
                            SizedBox(height: 1.5.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  child: Text(LanguageProvider.translate("login", "guest"),
                                    style: TextStyleClass.normalStyle(color: AppColor.defaultColor),),
                                  onPressed: (){
                                    auth.guestLogin(fromLogin: true);
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 1.5.h,),
                            InkWell(
                                onTap: () {
                                  auth.goToRegisterPage();
                                },
                                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(
                                    LanguageProvider.translate('login', 'not_have'),
                                    style: TextStyleClass.smallStyle(color: Colors.grey).copyWith(height: 1),
                                  ),
                                  SizedBox(width: 2.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1.w),
                                      color: AppColor.defaultColor,
                                    ),
                                    child: Text(LanguageProvider.translate('buttons', 'new_reg'), style: TextStyleClass.smallStyle(color: Colors.white).copyWith(height: 1)),
                                  )
                                ])),
                            SizedBox(height: 1.5.h,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}