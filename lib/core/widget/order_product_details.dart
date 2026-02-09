import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../config/app_color.dart';
import '../../config/text_style.dart';
import '../../feature/auth/domain/entities/pay_type_class.dart';
import '../../feature/auth/presentation/provider/auth_provider.dart';
import '../../feature/cart/domain/entities/cart_product_entity.dart';
import '../../feature/language/presentation/provider/language_provider.dart';
import '../constants/var.dart';
import '../helper_function/convert.dart';
import '../helper_function/navigation.dart';
import 'img_preview_widget.dart';

class OrderProductsDetailsWidget extends StatelessWidget {
  final List<CartProductEntity> cartProducts;
  final num total;
  final num subTotal;
  final num discount;
  final List<Map> tax;
  const OrderProductsDetailsWidget({required this.cartProducts,
    Key? key, required this.total, required this.subTotal, required this.tax,required this.discount,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // AuthenticationProvider auth = Provider.of(context,listen: false);

    return Container(
      width: 90.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColor.lightDefaultColor,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
        child: Column(
          children: [
            ...List.generate(cartProducts.length, (index) => Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if(cartProducts[index].isEnded==true&&!isUser)Container(
                            width: 4.w,
                            height: 4.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: Colors.white,
                              border: Border.all(color: AppColor.defaultColor),
                            ),
                            child: Checkbox(value: cartProducts[index].isEnded, onChanged: (val){

                            },),
                          ),
                          if(cartProducts[index].isEnded==true&&!isUser)SizedBox(width: 1.w,),
                          SizedBox(width: 10.w,child: InkWell(onTap: (){
                            navP(ImagePreviewWidget(imgPath: cartProducts[index].image,
                              heroTag: '${cartProducts[index].id}order_details',));
                          },child: Hero(tag: '${cartProducts[index].id}order_details',child: CachedNetworkImage(imageUrl: cartProducts[index].image,width: 10.w,height: 10.w,)))),
                          SizedBox(width: 2.w,),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${cartProducts[index].count} x ${cartProducts[index].name}',style: TextStyleClass.normalStyle(),),
                              Row(
                                children: [
                                  if(cartProducts[index].brand!=null)...[
                                    Text(cartProducts[index].brand!,style: TextStyleClass.smallStyle(),),
                                    Text(' - ',style: TextStyleClass.smallStyle(),),

                                  ],
                                  if(cartProducts[index].weight!=null)Text(cartProducts[index].weight!,style: TextStyleClass.normalStyle(),),

                                ],
                              ),
                            ],
                          )),
                          if(cartProducts[index].isComplete)SizedBox(width: 2.w,),
                          if(cartProducts[index].isComplete)const Icon(Icons.check_circle_rounded,
                            color: Colors.green,size: 20,),
                        ],
                      ),
                    ),
                    SizedBox(width: 4.w,),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 0.5.h),
                    //   child: Text('${cartProducts[index].count} x ${cartProducts[index].price} =',style: TextStyleClass.smallStyle(),
                    //     textAlign: TextAlign.start,),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 0.5.h),
                      child: Text('  ${addStringToPrice(cartProducts[index].calcTotalPrice().toString())} CHF',style: TextStyleClass.smallStyle(),
                        textAlign: TextAlign.end,),
                    ),
                  ],
                ),
                // if(cartProducts[index].showPrice)SizedBox(height: 1.h,),
                // if(cartProducts[index].showPrice)Row(
                //   children: [
                //     Expanded(child: Text('IVA ${cartProducts[index].taxEntity.tax}%',style: TextStyleClass.normalStyle(),)),
                //     SizedBox(width: 2.w,),
                //     // Text('${cartProducts[index].count} x ${cartProducts[index].taxEntity.tax}% =',style: TextStyleClass.smallStyle(),
                //     //   textAlign: TextAlign.start,),
                //     Text('  ${addStringToPrice(cartProducts[index].calcTotalTax().toString())} chf',style: TextStyleClass.normalStyle(),
                //       textAlign: TextAlign.end,),
                //   ],
                // ),
                if(cartProducts[index].note!=null)SizedBox(height: 1.h,),
                if(cartProducts[index].note!=null)Row(
                  children: [
                    Expanded(child: Text(cartProducts[index].note!,
                    style: TextStyleClass.smallStyle(color: Colors.red),)),
                  ],
                ),
                if(cartProducts[index].dateTime!=null)SizedBox(height: 1.h,),
                if(cartProducts[index].dateTime!=null)Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(convertDateToString(cartProducts[index].dateTime!),
                      style: TextStyleClass.smallStyle(color: AppColor.lightGreyColor),),
                  ],
                ),
                if((cartProducts.length-1!=index))
                  Divider(color: AppColor.defaultColor.withOpacity(0.3),height: 2.5.h,),
              ],
            ),),
            // if((isUser&&auth.userEntity!.payType!=PayType.bolla)||!isUser)
              Divider(color: AppColor.defaultColor.withOpacity(0.3),height: 2.5.h,),
            Column(
              children: [
                Row(
                  children: [
                    Text(LanguageProvider.translate('orders', 'sub_total'),
                      style: TextStyleClass.normalStyle(),),
                    const Spacer(),
                    Text('${addStringToPrice(subTotal.toString())} ',
                      style: TextStyleClass.smallStyle(),),
                    Text('CHF',style: TextStyleClass.smallStyle(),),
                  ],
                ),
                SizedBox(height:1.h,),
                ...List.generate(tax.length, (index) =>  Row(
                  children: [
                    Text(tax[index]['name'],
                      style: TextStyleClass.normalStyle(),),
                    const Spacer(),
                    Text('${(addStringToPrice((tax[index]['value']*discount).toString()))} ',
                      style: TextStyleClass.smallStyle(),),
                    Text('CHF',style: TextStyleClass.smallStyle(),),
                  ],
                ) ) ,
                SizedBox(height:1.h,),
                Row(
                  children: [
                    Text(LanguageProvider.translate('orders', 'total'),
                      style: TextStyleClass.normalStyle(),),
                    const Spacer(),
                    Text('${addStringToPrice(total.toString())} ',
                      style: TextStyleClass.smallStyle(),),
                    Text('CHF',style: TextStyleClass.smallStyle(),),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
