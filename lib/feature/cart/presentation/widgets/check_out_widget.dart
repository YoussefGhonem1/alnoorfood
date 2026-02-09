import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../auth/domain/entities/pay_type_class.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/cart_provider.dart';
import '../provider/check_out_provider.dart';

class CheckOutWidget extends StatelessWidget {
  const CheckOutWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authenticationProvider = Provider.of(context,listen: false);

    CheckOutProvider checkOutProvider = Provider.of(context,listen: false);
    CartProvider cartProvider = Provider.of(context,listen: false);
    List<Map> data = [
      if(!isUser){"image":Images.activePersonSVG,"title":cartProvider.user!.name,
        "data":cartProvider.user!.clientDirective??""},
      {"image":Images.locationSVG,"title":checkOutProvider.addressEntity!.name,
        "data":checkOutProvider.addressEntity!.address},
      // if(userClass!.payType==PayType.fattura){"image":Images.locationSVG,"title":checkOutProvider.addressBillingEntity!.name,
      //   "data":checkOutProvider.addressBillingEntity!.address},
      // if(userClass!.payType==PayType.fattura){"image":Images.activePersonSVG,"title":"client_directive","data":
      // checkOutProvider.inputs.firstWhere((element) => element['key']=='client_directive')['value'].text},
      {"image":Images.phoneSVG,"title":"phone","data":
      checkOutProvider.inputs.firstWhere((element) => element['key']=='phone')['value'].text},
      {"image":Images.dateSvg,"title":"date","data":
      checkOutProvider.inputs.firstWhere((element) => element['key']=='date')['value'].text},
      if(checkOutProvider.ended){"image":Images.dateSvg,"title":"ended","data":
      checkOutProvider.inputs.firstWhere((element) => element['key']=='end_date')['value'].text},
      if(checkOutProvider.ended){"image":Images.dateSvg,"title":"created_at","data":
      checkOutProvider.inputs.firstWhere((element) => element['key']=='created_at')['value'].text},
      if(checkOutProvider.ended){"image":Images.dateSvg,"title":"end_time","data":
      checkOutProvider.inputs.firstWhere((element) => element['key']=='end_time')['value'].text},
      // if(checkOutProvider.ended){"image":Images.walletSVG,"title":checkOutProvider.isPaid?"paid":"not_paid","data": ''},
      {"image":Images.walletSVG,"title":"payment","data": LanguageProvider.translate('orders', 'cash')},
      if(checkOutProvider.inputs.firstWhere((element) => element['key']=="notes",)['value'].text.isNotEmpty)
      {"image":Images.noteSVG,"title":"note","data":
      checkOutProvider.inputs.firstWhere((element) => element['key']=='notes')['value'].text},
    ];
    return SizedBox(
      width: 100.w,
      height: 55.h,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for(var i in data)
                      ListTile(
                        leading: SvgWidget(svg: i['image'],),
                        visualDensity: VisualDensity.compact,
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.zero,
                        title: Text(LanguageProvider.translate("orders", i['title']),style: TextStyleClass.normalBoldStyle(),),
                        subtitle: Text(i['data'],style: TextStyleClass.normalStyle(color: AppColor.greyColor),),
                      ),

                    SizedBox(height: 1.h,),
                    Container(
                      width: 90.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColor.lightDefaultColor,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(LanguageProvider.translate('orders', 'sub_total'),
                                  style: TextStyleClass.normalStyle(),),
                                Spacer(),
                                Text('${addStringToPrice(cartProvider.calcProductTotal().toString())} ',
                                  style: TextStyleClass.normalStyle(),),
                                Text('CHF',style: TextStyleClass.normalStyle(),),
                              ],
                            ),
                            Divider(color: AppColor.defaultColor,thickness: 0.1.h,),
                            Row(
                              children: [
                                Text(LanguageProvider.translate('orders', 'tax_total'),
                                  style: TextStyleClass.normalStyle(),),
                                Spacer(),
                                Text('${addStringToPrice(cartProvider.calcTaxTotal().toString())} ',
                                  style: TextStyleClass.normalStyle(),),
                                Text('CHF',style: TextStyleClass.normalStyle(),),
                              ],
                            ),
                            Divider(color: AppColor.defaultColor,thickness: 0.1.h,),
                            Row(
                              children: [
                                Text(LanguageProvider.translate('orders', 'total'),
                                  style: TextStyleClass.normalStyle(),),
                                Spacer(),
                                Text('${addStringToPrice(cartProvider.calcTotal().toString())} ',
                                  style: TextStyleClass.normalStyle(),),
                                Text('CHF',style: TextStyleClass.normalStyle(),),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 1.h,),
            ButtonWidget(onTap: (){
              checkOutProvider.createOrder();
            }, text: cartProvider
                .orderEntity==null?"confirm_order":"save",),
          ],
        ),
      ),
    );
  }
}
