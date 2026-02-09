import 'package:flutter/material.dart';
import 'package:homsfood/config/text_style.dart';
import 'package:homsfood/feature/language/presentation/provider/language_provider.dart';
import 'package:sizer/sizer.dart';

class StaticsWidget extends StatelessWidget {
  const StaticsWidget({super.key, required this.title, required this.value, required this.color});
  final String title,value;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 2.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(child: Text(LanguageProvider.translate('orders', title),style: TextStyleClass.smallStyle(color: Colors.white).copyWith(height: 1),)),
            Text(value,style: TextStyleClass.smallStyle(color: Colors.white).copyWith(height: 1),),
          ],
        ),
      ),
    );
  }
}
