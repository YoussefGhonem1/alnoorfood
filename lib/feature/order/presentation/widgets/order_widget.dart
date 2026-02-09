import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status_type_entity.dart';
import '../provider/order_delivery_provider.dart';
import '../provider/order_provider.dart';

class OrdersWidget extends StatelessWidget {
  final OrderEntity orderEntity;
  final bool fromCart;
  const OrdersWidget({Key? key,this.fromCart = false, required this.orderEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<Map> data = [
      {"image":Images.orderSVG,"title":"order_id","widget":Text('# ${orderEntity.id}',style: TextStyleClass.semiBoldStyle(),)},
      {"image":Images.locationSVG,"title":orderEntity.addressEntity?.name??"",
        "widget":fromCart?InkWell(
          onTap: (){
            CartProvider cartProvider = Provider.of(context,listen: false);
            cartProvider.setOrder(null);
          },
          child: const SvgWidget(color: Colors.red, svg: Images.deleteSVG),
        ):(orderEntity.orderStatus==OrderStatusTypeEntity.ended?
        Text(LanguageProvider.translate('orders', 'cash'),
          style: TextStyleClass.smallStyle(color: AppColor.defaultColor),):null)},
      if(!isUser){"image":Images.activePersonSVG,"title":orderEntity.userClass.name,},
      if(!(orderEntity.orderStatus==OrderStatusTypeEntity.ended||
          orderEntity.orderStatus==OrderStatusTypeEntity.canceled)){"image":Images.walletSVG,"title":LanguageProvider.translate('orders', 'cash'),
        "widget":Text(LanguageProvider.translate('orders', "show_details"),
        style: TextStyleClass.semiDecorationStyle(color: AppColor.defaultColor),)},
      if((orderEntity.orderStatus==OrderStatusTypeEntity.ended||
          orderEntity.orderStatus==OrderStatusTypeEntity.canceled)){"image":Images.dateSvg,
        "title":orderEntity.createAt.toLocal().toString().split(' ').first,
        "widget":orderEntity.orderStatus==OrderStatusTypeEntity.canceled?Text(LanguageProvider.translate(isUser?'order_status_user':"order_status_delivery", orderStatusString[orderEntity.orderStatus]!),
          style: TextStyleClass.semiDecorationStyle(color: Colors.red),):null},
      if((orderEntity.orderStatus==OrderStatusTypeEntity.ended||
          orderEntity.orderStatus==OrderStatusTypeEntity.canceled)){"image":Images.deliveryDateSVG,"title":orderEntity.date,
        "widget":Text(LanguageProvider.translate('orders', "show_details"),
          style: TextStyleClass.semiDecorationStyle(color: AppColor.defaultColor),)},
    ];
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: InkWell(
        onTap: (){
          if(isUser){
            Provider.of<OrdersProvider>(context,listen: false).goDetailsPage(orderEntity);
          }else{
            Provider.of<OrdersDeliveryProvider>(context,listen: false).goDetailsPage(orderEntity);
          }
        },
        child: Container(
          width: 100.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.lightGreyColor),
            color: Color(0xffFCFEFC)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
            child: Column(
              children: [
                for(var i in data)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 1.h),
                    child: Row(
                      children: [
                        SvgWidget(svg: i['image'],),
                        SizedBox(width: 3.w,),
                        Expanded(child: Text(i['title'] == orderEntity.payType?i['title'] : LanguageProvider.translate("orders", i['title']),style: TextStyleClass.semiStyle(),)),
                        SizedBox(width: 2.w,),
                        i['widget']??const SizedBox(),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
