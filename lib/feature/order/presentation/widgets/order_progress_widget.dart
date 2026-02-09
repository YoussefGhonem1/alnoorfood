import 'package:flutter/material.dart';
import 'package:homsfood/core/models/order_provider.dart';
import 'package:homsfood/core/widget/button_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/var.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status_type_entity.dart';
import '../provider/order_provider.dart';

class OrderProgressWidget extends StatelessWidget {
  final OrderEntity orderEntity;
  const OrderProgressWidget({Key? key, required this.orderEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(orderStatusImage[orderEntity.orderStatus]!,),
            SizedBox(width: 2.w,),
            Expanded(child: Text(LanguageProvider.translate(isUser?'order_status_user':"order_status_delivery",
                orderStatusString[orderEntity.orderStatus]!),style: TextStyleClass.semiStyle(),)),
            if(isUser||(deliveryEntity!=null&&deliveryEntity!.isAdmin))...[
              SizedBox(width: 2.w,),
              ButtonWidget(onTap: (){
                Provider.of<OrdersProvider>(context,listen: false).reOrder(orderEntity);
              }, text: "re_order",width: 30.w,textStyle: TextStyle(fontSize: 12,color: Colors.white),height: 5.h,),
            ],
          ],
        ),
        SizedBox(height: 1.h,),
        Container(
          width: 90.w,
          height: 1.5.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.lightGreyColor,
          ),
          child:  Row(
            children: [
              Builder(
                builder: (context) {
                  int length = orderEntity.orderStatus.index+1;
                  if(length>4) length = 4;
                  return Container(
                    width: (90.w)*((length/4)),
                    height: 1.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: AppColor.defaultColor,
                    ),
                  );
                }
              ),
            ],
          ),
        ),
      ],
    );
  }
}
