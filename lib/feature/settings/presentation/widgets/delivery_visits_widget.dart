import 'package:flutter/material.dart';
import 'package:homsfood/core/constants/images.dart';
import 'package:homsfood/core/widget/svg_widget.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../delivery_visit/domain/entities/delivery_visit_entity.dart';

class DeliveryVisitsWidget extends StatelessWidget {
  final DeliveryVisitEntity deliveryVisit;
  final bool fromCart;
  const DeliveryVisitsWidget({Key? key,this.fromCart = false, required this.deliveryVisit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.lightGreyColor),
            color: AppColor.lightGreyColor
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("# ${deliveryVisit.id}",style: TextStyleClass.semiStyle(),),
              SizedBox(height: 2.h,),
              Text(deliveryVisit.notes??"",style: TextStyleClass.semiStyle(),),
              SizedBox(height: 2.h,),
              Row(
                children: [
                  SvgWidget(svg: Images.timeIconSVG,width: 5.w,),
                  SizedBox(width: 2.w,),
                  Text('${convertDateToStringSort(deliveryVisit.date)}  ${convertDateToDayName(deliveryVisit.date)}',style: TextStyleClass.semiStyle(),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
