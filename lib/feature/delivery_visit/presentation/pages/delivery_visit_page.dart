import 'package:flutter/material.dart';
import 'package:homsfood/config/app_color.dart';
import 'package:homsfood/feature/delivery_visit/domain/entities/delivery_visit_entity.dart';
import 'package:homsfood/feature/delivery_visit/presentation/provider/delivery_visit_provider.dart';
import 'package:homsfood/feature/language/presentation/provider/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/widget/loading_widget.dart';
import '../widgets/delivery_visit_widget.dart';

class DeliveryVisitPage extends StatelessWidget {
  DeliveryVisitPage({super.key});
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    DeliveryVisitProvider deliveryVisitProvider = Provider.of(context);
    deliveryVisitProvider.pagination(scrollController);
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate('settings', 'delivery_visits')),
        actions: [
          IconButton(onPressed: ()async{
            deliveryVisitProvider.goToAddPage(null);
          },icon: Icon(Icons.add_circle_outline,color: AppColor.defaultColor,),),
          SizedBox(width: 2.w,),
        ],
      ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.w),
          child: RefreshIndicator(
            onRefresh: ()async{
              deliveryVisitProvider.refresh();
            },
            child: Stack(
              children: [
                ListView.builder(
                  controller: scrollController,
                  itemCount: deliveryVisitProvider.visits?.length??8,
                  physics: deliveryVisitProvider.visits==null?const NeverScrollableScrollPhysics()
                      :const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (ctx,i){
                    if(deliveryVisitProvider.visits==null){
                      return const SizedBox();
                    }
                    DeliveryVisitEntity deliveryVisitEntity = deliveryVisitProvider.visits![i];
                    return DeliveryVisitWidget(deliveryVisitEntity: deliveryVisitEntity,);
                  },
                ),
                if(deliveryVisitProvider.paginationStarted)const LoadingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
