import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/drop_down_widget.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/order_provider.dart';
import '../widgets/date_filter_widget.dart';
import '../widgets/order_widget.dart';
import '../widgets/shimmer_order_widget.dart';

class OrdersPage extends StatelessWidget {
  OrdersPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    OrdersProvider ordersProvider = Provider.of(context,listen: true);
    ordersProvider.pagination(scrollController);
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate('orders', 'title')),
      ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h),
          child: RefreshIndicator(
            onRefresh: ()async{
              ordersProvider.refresh();
            },
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  DateFilterWidget(from: ordersProvider.from, to: ordersProvider.to,
                      onFilter: (String from,String to){
                        ordersProvider.onFilter(from, to);
                      },reset: (){
                    ordersProvider.resetFilter();
                      }),
                  SizedBox(height: 1.h,),
                  // if(!ordersProvider.current)DropDownWidget(dropDownClass: ordersProvider,
                  //   afterClick: (){},width: 90.w,height: 5.h,),
                  // if(!ordersProvider.current)SizedBox(height: 2.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ButtonWidget(onTap: (){ordersProvider.enableCurrent();}, text: 'current_orders',width: 42.w,
                        textStyle: TextStyleClass.smallStyle(color: ordersProvider.current?Colors.white:Colors.black),
                        color: ordersProvider.current?null:AppColor.lightGreyColor,),
                      ButtonWidget(onTap: (){ordersProvider.disableCurrent();}, text: 'previous_orders',width: 42.w,
                        textStyle: TextStyleClass.smallStyle(color: !ordersProvider.current?Colors.white:Colors.black),
                        color: !ordersProvider.current?null:AppColor.lightGreyColor,),
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  ...List.generate(ordersProvider.showOrders()?.length??4, (index) {
                    if(ordersProvider.showOrders()==null){
                      return const ShimmerOrdersWidget();
                    }
                    return OrdersWidget(orderEntity: ordersProvider.showOrders()![index],);
                  }),
                  if(ordersProvider.showOrders()!=null
                      &&ordersProvider.showOrders()!.isEmpty)const EmptyWidget(title: 'orders'),
                  if(ordersProvider.showLoading)SizedBox(
                    width: 100.w,
                    height: 5.h,
                    child: const Stack(
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
