import 'package:flutter/material.dart';
import 'package:homsfood/feature/home/presentation/widgets/statics_widget.dart';
import 'package:homsfood/feature/order/presentation/provider/previous_delivery_order_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/widget/appbar_widget.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/drop_down_widget.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../order/presentation/provider/map_orders_provider.dart';
import '../../../order/presentation/provider/order_delivery_provider.dart';
import '../../../order/presentation/widgets/date_filter_widget.dart';
import '../../../order/presentation/widgets/order_widget.dart';
import '../../../order/presentation/widgets/shimmer_order_widget.dart';
import '../../../product/presentation/provider/search_product_provider.dart';

class HomeDeliveryPage extends StatelessWidget {
  HomeDeliveryPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    OrdersDeliveryProvider ordersDeliveryProvider = Provider.of(context,listen: true);
    ordersDeliveryProvider.pagination(scrollController);
    return Scaffold(
      appBar: appBarWidget(),
      bottomSheet: Padding(
        padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 5.w),
        child: ButtonWidget(onTap: (){
          Provider.of<CartProvider>(context,listen: false).getUsers();
          Provider.of<SearchProductProvider>(context,listen: false).goToSearchPage(fromDelivery: true);
        }, text: "create_order"),
      ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h),
          child: RefreshIndicator(
            onRefresh: ()async{
              ordersDeliveryProvider.refresh();
            },
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  DateFilterWidget(from: ordersDeliveryProvider.from, to: ordersDeliveryProvider.to,
                      onFilter: (String from,String to){
                        ordersDeliveryProvider.onFilter(from, to);
                      },reset: (){
                    ordersDeliveryProvider.resetFilter();
                      }),
                  if(ordersDeliveryProvider.orderProviderType!=OrderProviderType.previousProvider)
                    SizedBox(height: 1.h,),
                  // if(ordersDeliveryProvider.orderProviderType==OrderProviderType.previousProvider)DropDownWidget(dropDownClass: ordersDeliveryProvider,
                  //   afterClick: (){},width: 90.w,height: 5.h,),
                  // if(ordersDeliveryProvider.orderProviderType==OrderProviderType.previousProvider)SizedBox(height: 2.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWidget(onTap: (){
                        ordersDeliveryProvider.setNew();
                        }, text: deliveryEntity!.isAdmin?'new_orders':"new",width: 28.w,
                        textStyle: TextStyleClass.smallStyle
                          (color: ordersDeliveryProvider.orderProviderType==OrderProviderType.newProvider
                            ?Colors.white:Colors.black),
                        color: ordersDeliveryProvider.orderProviderType==OrderProviderType.newProvider
                            ?null:AppColor.lightGreyColor,),

                      ButtonWidget(onTap: (){
                        ordersDeliveryProvider.setCurrent();
                        }, text: 'delivering',width: 28.w,
                        textStyle: TextStyleClass.smallStyle(color:
                        ordersDeliveryProvider.orderProviderType==OrderProviderType.currentProvider?
                        Colors.white:Colors.black),
                        color: ordersDeliveryProvider.orderProviderType==OrderProviderType.currentProvider
                            ?null:AppColor.lightGreyColor,),

                      ButtonWidget(onTap: (){
                        ordersDeliveryProvider.setPrevious();
                      }, text: 'ended',width: 28.w,
                        textStyle: TextStyleClass.smallStyle(color:
                        ordersDeliveryProvider.orderProviderType==OrderProviderType.previousProvider?
                        Colors.white:Colors.black),
                        color: ordersDeliveryProvider.orderProviderType==OrderProviderType.previousProvider
                            ?null:AppColor.lightGreyColor,),
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Builder(
                      builder: (context) {
                        if(!isUser&&ordersDeliveryProvider.orderProviderType==OrderProviderType.currentProvider&&ordersDeliveryProvider.showOrders()!=null){
                          List<OrderEntity> orders = ordersDeliveryProvider.showOrders()!;
                          if(orders.isEmpty){
                            return SizedBox();
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(onTap: (){
                                Provider.of<MapOrdersProvider>(context,listen: false).goToMapOrdersPage();
                              },child: Icon(Icons.map_outlined,color: AppColor.defaultColor,size: 7.w,)),
                            ],
                          );
                        }
                        if(!isUser&&ordersDeliveryProvider.orderProviderType==OrderProviderType.previousProvider&&deliveryEntity!.isAdmin){
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StaticsWidget(title: 'purchase_price', value: (Provider.of<PreviousDeliveryOrderProvider>(context).purchase_total??0).toString(), color: Colors.orange),
                              StaticsWidget(title: 'sell_price', value: (Provider.of<PreviousDeliveryOrderProvider>(context).sell_total??0).toString(), color: Colors.red),
                              StaticsWidget(title: 'profit', value: (Provider.of<PreviousDeliveryOrderProvider>(context).earn_total??0).toString(), color: Colors.green),
                            ],
                          );
                        }
                        return SizedBox();
                      }
                  ),
                  ...List.generate(ordersDeliveryProvider.showOrders()?.length??4, (index) {
                    if(ordersDeliveryProvider.showOrders()==null){
                      return ShimmerOrdersWidget();
                    }
                    return OrdersWidget(orderEntity: ordersDeliveryProvider.showOrders()![index],);
                  }),
                  if(ordersDeliveryProvider.showOrders()!=null
                      &&ordersDeliveryProvider.showOrders()!.isEmpty)SizedBox(height: 5.h,),
                  if(ordersDeliveryProvider.showOrders()!=null
                      &&ordersDeliveryProvider.showOrders()!.isEmpty)const EmptyWidget(title: 'orders'),
                  SizedBox(height: 7.h,),
                  if(ordersDeliveryProvider.showLoading)SizedBox(
                    width: 100.w,
                    height: 5.h,
                    child: Stack(
                      children: [
                        LoadingWidget(),
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
