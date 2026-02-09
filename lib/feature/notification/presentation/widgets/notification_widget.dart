import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widget/divider_widget.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationWidget extends StatelessWidget {
  final NotificationEntity notificationEntity;
  const NotificationWidget({Key? key, required this.notificationEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(notificationEntity.title,style: TextStyleClass.semiBoldStyle(),),
              SizedBox(height: 1.h,),
              Text(notificationEntity.body,style: TextStyleClass.normalStyle(),),
              SizedBox(height: 1.h,),
              Text(convertDateTimeToString(notificationEntity.dateTime), style: TextStyleClass.smallStyle(color: AppColor.greyColor),),
            ],
          ),
        ),
        SizedBox(height: 0.5.h,),
        const DashedDivider(count: 50),
      ],
    );
  }
}
