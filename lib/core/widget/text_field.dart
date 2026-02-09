import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../config/app_color.dart';
import '../../feature/language/presentation/provider/language_provider.dart';

class TextFieldWidget extends StatelessWidget {
  final bool obscureText,autoFocus,next,otp,readOnly;
  final TextEditingController controller;
  final double? width,height,verticalPadding,borderRadius,contentPadding;
  final Widget? titleWidget,prefix,suffix;
  final void Function(String)? onChange;
  final void Function()? onTextTap,onEditingComplete,onSuffixTap;
  final int? maxLines,maxLength,minLines;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? counter,hintText;
  final Color? color,borderColor,cursorColor,focusedBorder,enabledBorder;
  final TextStyle? style,hintStyle;
  final TextAlign? textAlign;
  const TextFieldWidget({this.maxLines,this.hintText,this.cursorColor,this.minLines,
  required this.controller,this.height,this.width,this.style,this.focusedBorder,
    this.enabledBorder,
  this.color,this.borderColor,this.borderRadius,this.counter,
  this.autoFocus = false,this.keyboardType,this.maxLength,
  this.next = true,this.obscureText = false,this.textAlign,
  this.onChange,this.onEditingComplete,this.contentPadding,
  this.onSuffixTap,this.otp = false,this.prefix,this.readOnly = false,this.suffix,
  this.onTextTap,this.titleWidget,
  this.validator,this.verticalPadding,Key? key, this.hintStyle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding??1.5.h,),
      child: SizedBox(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            titleWidget??const SizedBox(),
            if(titleWidget!=null)SizedBox(height: 0.5.h,),
            SizedBox(
              width: width??100.w,
              height: height,
              child: TextFormField(
                textAlign: textAlign??TextAlign.start,
                obscureText: obscureText,
                onChanged: onChange,
                controller: controller,
                // cursorHeight: 25,
                onTap: onTextTap,
                cursorColor: cursorColor??Colors.black,
                readOnly: readOnly,
                autofocus: autoFocus,
                maxLines: maxLines??1,
                minLines: minLines,
                maxLength: maxLength,
                style: style??TextStyle(fontSize: 12.sp,color: Colors.black),
                validator: validator??(value){
                  if (value!.isEmpty) {
                    return LanguageProvider.translate('validation', 'field',);
                  }
                  return null;
                },
                onEditingComplete: onEditingComplete??(){
                  FocusScope.of(context).unfocus();
                  if(next){
                    FocusScope.of(context).nextFocus();
                  }
                },
                keyboardType: keyboardType,
                decoration: inputDecoration(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  InputDecoration inputDecoration(){
    return InputDecoration(
      // counterText: counter,
      isDense: true,
      hintText: hintText==null?null:LanguageProvider.translate('inputs', hintText!,),
      fillColor: color??const Color(0xffF2F3F2),
      filled: true,
      hintStyle:hintStyle?? TextStyle(fontSize: 11.sp,color: Colors.black,height: 1,),
      border: focusedBorder!=null?null:border(borderRadius: borderRadius,color: borderColor),
      disabledBorder:border(borderRadius: borderRadius,color: borderColor),
      focusedBorder: border(borderRadius: borderRadius,color: focusedBorder??borderColor,
      borderWidth: focusedBorder==null?0:3),
      enabledBorder: border(borderRadius: borderRadius,color: enabledBorder??borderColor),
      errorBorder: border(color: Colors.red,borderRadius: borderRadius),
      focusedErrorBorder: border(color: Colors.red,borderRadius: borderRadius),
      hoverColor: Colors.grey,
      prefixIcon: prefix,
      contentPadding: (maxLines==1||maxLines==null||minLines==1)?EdgeInsets.symmetric(horizontal: 3.w,
          vertical: contentPadding??2.5.h):EdgeInsets.symmetric(horizontal: 2.w,
          vertical: contentPadding??1.h),
      suffixIcon: suffix??(onSuffixTap==null?null:IconButton(onPressed:onSuffixTap,
          icon: Icon(obscureText?Icons.visibility_off_outlined:Icons.visibility,
            size: 20,color: obscureText?Colors.grey:AppColor.defaultColor,),
          splashColor: Colors.transparent,highlightColor: Colors.transparent)),
    );
  }
  InputBorder border({Color? color,double? borderRadius,double? borderWidth}){
    return OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius??12),
        borderSide: BorderSide(color: color??const Color(0xffF2F3F2),width: borderWidth??1),);
  }
}
