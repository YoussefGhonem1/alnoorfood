import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import '../../config/app_color.dart';
import '../../feature/language/presentation/provider/language_provider.dart';

void showToast(String text){
  Fluttertoast.showToast(
    msg: LanguageProvider.translate('warning', text),
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 6,
    backgroundColor: AppColor.defaultColor,
    textColor: Colors.white,
    fontSize: 10.sp,
  );
}