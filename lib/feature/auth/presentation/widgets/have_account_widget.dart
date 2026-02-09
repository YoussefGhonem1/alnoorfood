import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../language/presentation/provider/language_provider.dart';

class HaveAccountWidget extends StatelessWidget {
  const HaveAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
        onTap: () {
         navPop();
        },
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                LanguageProvider.translate(
                    'register', 'have_account'),
                style: TextStyleClass.normalStyle(
                    color: Colors.grey).copyWith(height: 1),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w,vertical: 0.5.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(1.w),
                  color: AppColor.defaultColor,
                ),
                child: Text(
                    LanguageProvider.translate(
                        'register', 'login'),
                    style: TextStyleClass.normalStyle(color: Colors.white
                    ).copyWith(height: 1)),
              )
            ]));
  }
}
