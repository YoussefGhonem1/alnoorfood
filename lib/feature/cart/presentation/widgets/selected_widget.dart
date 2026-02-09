import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/models/selected_class.dart';
import '../../../../core/widget/svg_widget.dart';

class SelectedWidget extends StatelessWidget {
  final SelectedClass selectedClass;
  const SelectedWidget({Key? key, required this.selectedClass}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: selectedClass.onTap,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        child: ColoredBox(
          color: Colors.white,
          child: Container(
            width: 90.w,
            decoration: BoxDecoration(
              color: AppColor.lightDefaultColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: 3.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgWidget(svg: selectedClass.image),
                  SizedBox(width: 2.w,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedClass.title,style: TextStyleClass.normalStyle(),),
                        SizedBox(height: 0.5.h,),
                        Text(selectedClass.body,style: TextStyleClass.normalStyle(color: AppColor.greyColor),),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
