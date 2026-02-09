
import 'package:flutter/material.dart';

class TextFieldModel{
  String? image,key,label,hint,titleText;
  TextInputType? textInputType;
  TextEditingController controller;
  bool next,obscureText,readOnly;
  bool?isLabel;
  
  String? Function(String?)? validator;
  Widget? suffix,prefix,title;
  void Function()? onTap;
  double? width;
  int? min,max;
  EdgeInsets? contentPadding;
  
  TextFieldModel(
      {this.image,
        this.key,
        this.label,
        this.isLabel,
        this.hint = "",
        this.textInputType,
        this.readOnly = false,
        required this.controller,
        this.next = true,
        this.validator,
        this.onTap,
        this.suffix,
        this.prefix,
        this.title,
        this.titleText,
        this.min,
        this.max,
        this.width,
        this.contentPadding,
        this.obscureText = false});

}