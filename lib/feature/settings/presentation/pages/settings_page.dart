import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homsfood/config/app_color.dart';
import 'package:homsfood/config/text_style.dart';
import 'package:homsfood/core/helper_function/api.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/settings_provider.dart';
import '../widgets/settings_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authenticationProvider = Provider.of(context,listen: false);

    SettingsProvider settingsProvider = Provider.of(context);
    return Scaffold(
      appBar: isUser?null:AppBar(
        title: Text(LanguageProvider.translate('main', 'settings')),
      ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
            child: Column(
              children: [
                if(isUser)SizedBox(height: 1.h,),
                if(isUser)Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${LanguageProvider.translate('main', 'point')} : ${authenticationProvider.userEntity?.points??""}',
                      style: TextStyleClass.normalStyle()),
                  ],
                ),
                if(isUser)SizedBox(height: 1.h,),
                // if(isUser)Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 2.w),
                //   child: ButtonWidget(text:"ask_coupon",width: 70.w,height: 7.h,
                //       onTap: (){
                //         // UserClass.requestPoint();
                //       },),
                // ),

                if(!isGuest&&authenticationProvider.userEntity?.type=="admin") Divider(color: Colors.grey.shade300,endIndent: 1,indent: 1,thickness: 0.15.h,),
                // if(!isGuest&&user?.type=="admin")Row(
                //   children: [
                //     Text(LanguageProvider.translate('settings', 'status'),style: TextStyle(
                //         fontSize: 12.sp),),
                //     const Spacer(),
                //     Switch(value: settingsProvider.settingsEntity!.isOpen,activeTrackColor: AppColor.defaultColor.withOpacity(0.5)
                //         ,activeColor: AppColor.defaultColor, onChanged: (val)async{
                //       settingsProvider.changeMarketStatus();
                //         }),
                //   ],
                // ),
                for(Map i in settingsProvider.settings())
                  SettingsWidget(data: i),
                SizedBox(height: 3.h,),
                if(!isGuest&&!isUser&&!isGuest&&deliveryEntity!.isAdmin)Divider(color: Colors.grey.shade300,endIndent: 1,indent: 1,thickness: 0.15.h,),
                if(!isGuest&&!isUser&&!isGuest&&deliveryEntity!.isAdmin)Row(
                  children: [
                    Text(LanguageProvider.translate('settings', 'status'),style: TextStyle(
                        fontSize: 12.sp),),
                    Spacer(),
                    Switch(value: settingsProvider.settingsEntity!.isOpen,activeTrackColor: AppColor.defaultColor.withOpacity(0.5)
                        ,activeColor: AppColor.defaultColor, onChanged: (val)async{

                          loading();
                          await ApiHandel.getInstance.post('delivery/close_orders',{"is_open":val?"yes":"no"});

                          navPop();
                          settingsProvider.changeOpen();

                        }),
                  ],
                ),
                ButtonWidget(onTap: (){
                  Provider.of<AuthenticationProvider>(context,listen: false).confirmLogout();
                }, text: 'logout',widget: const SvgWidget(svg: Images.logoutSVG),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
