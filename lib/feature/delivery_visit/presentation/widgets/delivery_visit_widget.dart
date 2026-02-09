import 'package:flutter/material.dart';
import 'package:homsfood/config/text_style.dart';
import 'package:homsfood/core/helper_function/convert.dart';
import 'package:homsfood/feature/delivery_visit/presentation/provider/delivery_visit_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../domain/entities/delivery_visit_entity.dart';


class DeliveryVisitWidget extends StatelessWidget {
  final DeliveryVisitEntity deliveryVisitEntity;
  const DeliveryVisitWidget({Key? key, required this.deliveryVisitEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: InkWell(
        onTap: (){
          Provider.of<DeliveryVisitProvider>(context,listen: false).goToAddPage(deliveryVisitEntity);
        },
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColoredBox(
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.lightDefaultColor,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(deliveryVisitEntity.cityEntity?.name??"",),
                          Spacer(),
                          Text(convertDateToStringSort(deliveryVisitEntity.date)),
                          SizedBox(width: 2.w,),
                          InkWell(onTap: (){
                            Provider.of<DeliveryVisitProvider>(context,listen: false).goToAddPage(deliveryVisitEntity);
                          },child: Icon(Icons.edit,color: AppColor.defaultColor,size: 5.w,)),
                          SizedBox(width: 2.w,),
                          InkWell(onTap: (){
                            Provider.of<DeliveryVisitProvider>(context,listen: false).deleteVisit(deliveryVisitEntity);
                          },child: Icon(Icons.delete,color: Colors.red,size: 5.w,)),
                        ],
                      ),
                      SizedBox(height: 1.h,),
                      if(deliveryVisitEntity.title!=null)...[
                        Text(deliveryVisitEntity.title??"",style: TextStyleClass.normalStyle(color: Colors.black),),
                        SizedBox(height: 1.h,),
                      ],
                      if(deliveryVisitEntity.message!=null)...[
                        Text(deliveryVisitEntity.message??"",style: TextStyleClass.normalStyle(color: Colors.grey),),
                        SizedBox(height: 0.5.h,),
                      ],
                      Divider(color: AppColor.defaultColor,height: 5,),
                      SizedBox(height: 0.5.h,),
                      Text(deliveryVisitEntity.notes??"",style: TextStyleClass.normalStyle(color: Colors.grey),),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
