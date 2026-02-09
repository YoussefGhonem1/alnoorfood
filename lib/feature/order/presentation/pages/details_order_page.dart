import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/models/order_provider.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/order_product_details.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../provider/order_delivery_provider.dart';
import '../provider/order_provider.dart';
import '../widgets/delivery_info_widget.dart';
import '../widgets/order_progress_widget.dart';

class DetailsOrderPage extends StatelessWidget {
  DetailsOrderPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    OrderProvider ordersProvider;
    if(isUser){
    ordersProvider = Provider.of<OrdersProvider>(context,listen: true);
    }else{
      ordersProvider = Provider.of<OrdersDeliveryProvider>(context,listen: true);
    }
    OrderEntity order = ordersProvider.orderEntity!;
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LanguageProvider.translate("orders", 'order_details')),
          actions: [
            InkWell(
              onTap: ()async{
                Uri link = Uri.parse('https://alnoorfood.online/admin/order_invoice/${order.id}?type=${isUser?"user":"delivery"}');
                await launchUrl(link);
                // if (await canLaunchUrl(link)) {
                // await launchUrl(link);
                // } else {
                // throw 'Could not launch $link';
                // }
                // navP(WebViewPage(title: "print", link: 'https://manger-margherita.online/admin/order_invoice/${order.id}?type=delivery'));
              },
              child: const Icon(Icons.local_printshop_rounded,size: 30,),
            ),
            if(ordersProvider.showEditButton())SizedBox(width: 2.w,),
            if(ordersProvider.showEditButton())InkWell(
              onTap: (){
                ordersProvider.editOrder();
              },
              child: const SvgWidget(svg: Images.editOrderSVG),
            ),
            SizedBox(width: 3.w,),
          ],
        ),
        body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
            child: RefreshIndicator(
              onRefresh: ()async{
                ordersProvider.refreshOrder();
              },
              child: SingleChildScrollView(
                controller: scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OrderProgressWidget(orderEntity: order),
                    if(ordersProvider.showTopButton())SizedBox(height: 1.h,),
                    if(ordersProvider.showTopButton())
                      ButtonWidget(onTap: (){
                        ordersProvider.topButtonAction();
                      }, text: ordersProvider.topButtonTitle()),
                    SizedBox(height: 1.h,),
                    DeliveryInfoWidget(order: order),
                    Text(LanguageProvider.translate("orders", "order_date")
                        .replaceAll('*input1*', convertDateToStringSort(DateTime.parse(order.date)))),
                    SizedBox(height: 1.h,),
                    for(var i in ordersProvider.data())
                      ListTile(
                        leading: SvgWidget(svg: i['image'],),
                        visualDensity: VisualDensity.compact,
                        horizontalTitleGap: 0,
                        contentPadding: EdgeInsets.zero,
                        title: Text(LanguageProvider.translate("orders", i['title']),style: TextStyleClass.normalBoldStyle(),),
                        subtitle: i['data']==null?null:Text(i['data'],style: TextStyleClass.
                        normalStyle(color: AppColor.greyColor),),
                        trailing: i['widget'],
                      ),
                    SizedBox(height: 1.h,),
                    OrderProductsDetailsWidget(total: order.total,cartProducts: ordersProvider.products(),
                    subTotal: order.productTotal(),tax: order.taxes(),discount: order.discountValue(),),
                    // if(ordersProvider.showReasons()
                    //     ||ordersProvider.showUpdatePaidButton())SizedBox(height: 2.h,),
                    // if(ordersProvider.showReasons()
                    //     ||ordersProvider.showUpdatePaidButton())StatefulBuilder(
                    //   builder: (context,set) {
                    //     return Row(
                    //       children: [
                    //         Text(LanguageProvider.translate('orders', 'paid'),
                    //             style: TextStyleClass.smallStyle()),
                    //         SizedBox(width: 2.w,),
                    //         Radio(value: true, groupValue: order.isPaid, onChanged: (val){
                    //           set((){
                    //             order.isPaid = val!;
                    //           });
                    //         },visualDensity: VisualDensity.compact,),
                    //         SizedBox(width: 5.w,),
                    //         Text(LanguageProvider.translate('orders', 'not_paid'),
                    //             style: TextStyleClass.smallStyle()),
                    //         SizedBox(width: 2.w,),
                    //         Radio(value: false, groupValue: order.isPaid, onChanged: (val){
                    //           set((){
                    //             order.isPaid = val!;
                    //           });
                    //         },visualDensity: VisualDensity.compact,),
                    //         const Spacer(),
                    //         if(ordersProvider.showUpdatePaidButton())ButtonWidget(onTap: (){
                    //           ordersProvider.updatePaidButton();
                    //         }, text: 'save',width: 30.w,height: 4.h,),
                    //       ],
                    //     );
                    //   }
                    // ),
                    if(ordersProvider.showReasons())SizedBox(height: 2.h,),
                    if(ordersProvider.showReasons())...List.generate(ordersProvider.reasons
                        .length, (index) =>
                        TextFieldWidget(controller: ordersProvider.reasons[index]['value'],
                          hintText: LanguageProvider.translate('orders',
                              ordersProvider.reasons[index]['label']),
                          minLines: 1,verticalPadding: 0.5.h,
                          contentPadding: 1.5.h,
                          maxLines: 7,validator: (val){
                          return null;
                          },),),

                    if(ordersProvider.showBottomButton())SizedBox(height: 2.h,),
                    if(ordersProvider.showBottomButton())Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(onTap: (){
                          ordersProvider.bottomButtonCancelAction();
                        }, text: 'canceled_order',textStyle: TextStyleClass.smallStyle(color: Colors.black),
                        borderColor: Colors.black,width: 42.w,color: Colors.white,),
                        ButtonWidget(onTap: (){
                          ordersProvider.bottomButtonAction();
                        }, text: ordersProvider.bottomButtonTitle(),width: 42.w,
                        textStyle: TextStyleClass.smallStyle(color: Colors.white),),
                      ],
                    ),
                    SizedBox(height: 1.h,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
