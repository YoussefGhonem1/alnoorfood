import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import '../core/constants/constants.dart';
import '../feature/language/presentation/provider/language_provider.dart';
import 'app_color.dart';

ThemeData defaultTheme = ThemeData(
  useMaterial3: false,
  primaryColor: AppColor.defaultColor,
  unselectedWidgetColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  checkboxTheme:checkboxThemeData,
  radioTheme: radioThemeData,
  tabBarTheme: tabBarTheme,
  appBarTheme: appBarTheme,
  splashColor: Colors.transparent,
  fontFamily: "DIN",
);

AppBarTheme appBarTheme = AppBarTheme(
  color: Colors.white,
  foregroundColor: Colors.black,
  elevation: 0,
  toolbarHeight: 7.5.h,
  titleTextStyle: TextStyle(fontSize: 13.sp,color: Colors.black,
      fontWeight: FontWeight.bold,fontFamily: "DIN",),
);

CheckboxThemeData checkboxThemeData = CheckboxThemeData(
  fillColor: MaterialStateProperty.all<Color>(Colors.transparent),
  checkColor: MaterialStateProperty.all<Color>(AppColor.defaultColor),
  overlayColor: MaterialStateProperty.all<Color>(AppColor.defaultColor),
  visualDensity: VisualDensity.compact,
);

RadioThemeData radioThemeData = RadioThemeData(
  fillColor: MaterialStateProperty.all(AppColor.defaultColor),
);

TabBarTheme tabBarTheme = const TabBarTheme(
  labelColor: AppColor.defaultColor,
  indicatorSize: TabBarIndicatorSize.label,
  unselectedLabelColor: Colors.grey,
);