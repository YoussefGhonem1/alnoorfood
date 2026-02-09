
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TextStyleClass{
  static TextStyle headBoldStyle({Color? color}){
    return TextStyle(
        color: color??Colors.black,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
    );
  }
  static TextStyle headStyle({Color? color}){
    return TextStyle(
        color: color??Colors.black,
        fontSize: 18.sp,
    );
  }
  static TextStyle semiHeadBoldStyle({Color? color}){
    return TextStyle(
      color: color??Colors.black,
      fontSize: 16.sp,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle semiHeadStyle({Color? color}){
    return TextStyle(
        color: color??Colors.black,
        fontSize: 16.sp,
    );
  }
  static TextStyle semiStyle({Color? color}){
    return TextStyle(
      color: color??Colors.black,
      fontSize: 14.sp,
    );
  }
  static TextStyle semiDecorationStyle({Color? color}){
    return TextStyle(
      color: color??Colors.black,
      fontSize: 14.sp,
      decoration: TextDecoration.underline,
      decorationColor: color??Colors.black,
    );
  }
  static TextStyle semiBoldStyle({Color? color}){
    return TextStyle(
      color: color??Colors.black,
      fontSize: 14.sp,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle normalStyle({Color? color}) {
    return TextStyle(
        color: color??Colors.black,
        fontSize: 12.sp,
        fontWeight: FontWeight.w400,
    );
  }
  static TextStyle normalBoldStyle({Color? color}) {
    return TextStyle(
      color: color??Colors.black,
      fontSize: 12.sp,
      fontWeight: FontWeight.bold,
    );
  }
  static TextStyle smallStyle({Color? color}) {
    return TextStyle(
        color: color??Colors.black,
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
    );
  }
  static TextStyle tinyStyle({Color? color}) {
    return TextStyle(
      color: color??Colors.black,
      fontSize: 8.sp,
      fontWeight: FontWeight.w400,
    );
  }
  static TextStyle veryTinyStyle({Color? color}) {
    return TextStyle(
      color: color??Colors.black,
      fontSize: 6.sp,
      fontWeight: FontWeight.w400,
    );
  }


}