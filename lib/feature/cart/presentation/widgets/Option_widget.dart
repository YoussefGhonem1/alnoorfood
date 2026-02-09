import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';

class OptionWidget extends StatelessWidget {
  final String image,title;
  final void Function() onTap;
  const OptionWidget({required this.onTap,required this.image,required this.title,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Container(
        width: 100.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppColor.defaultColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
          child: Row(
            children: [
              SvgWidget(svg: image,color: Colors.black,),
              SizedBox(width: 3.w,),
              Text(LanguageProvider.translate('check_out', title),
                style: TextStyleClass.semiStyle(),),
            ],
          ),
        ),
      ),
    );
  }
}
