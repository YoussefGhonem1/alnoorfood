import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../config/app_color.dart';
import '../../feature/language/presentation/provider/language_provider.dart';
import '../constants/constants.dart';
import 'svg_widget.dart';

class ButtonWidget extends StatelessWidget {
  final double? width,height,borderRadius;
  final void Function() onTap;
  final Color? color,borderColor,textColor;
  final String text;
  final TextStyle? textStyle;
  final Widget? widget;
  final bool takeSmallestWidth,widgetAfterText;
  const ButtonWidget({this.widget,this.takeSmallestWidth = false,this.width,this.height,required this.onTap,
    this.borderRadius,required this.text,this.textStyle,
    this.borderColor,this.color,this.textColor,this.widgetAfterText = true,
    Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: takeSmallestWidth?null:(width??100.w),
        height: height??7.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius??12),
          color: color??AppColor.defaultColor,
          border: borderColor==null?null:Border.all(color: borderColor!),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!widgetAfterText)widget??const SizedBox(),
              Expanded(
                flex: widget==null?1:0,
                child: Text(LanguageProvider.translate("buttons", text),
                  style: textStyle??TextStyle(color: textColor??Colors.white,fontSize: 13.sp,
                  ),textAlign: TextAlign.center,),
              ),
              if(widgetAfterText)widget??const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

class IconButtonWidget extends StatelessWidget {
  final String icon;
  final void Function() onTap;
  const IconButtonWidget({required this.icon,required this.onTap,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: Constants.isTablet?8.w: 13.w,
              height: Constants.isTablet?8.w: 13.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColor.lightGreyColor,
              ),
              child: Center(
                child: SvgWidget(svg: icon,color: Colors.black,width: Constants.isTablet?3.w:null,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}