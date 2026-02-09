import 'package:flutter/material.dart';
import 'package:homsfood/core/widget/empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/var.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/delivery_visits_provider.dart';
import '../widgets/delivery_visits_widget.dart';

class DeliveryVisitsPage extends StatelessWidget {
  const DeliveryVisitsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DeliveryVisitsProvider deliveryVisitsProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate('settings', 'delivery_visits')),
        centerTitle: true,
      ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
            child: Builder(
              builder: (context) {
                if(deliveryVisitsProvider.deliveryVisitsList.isEmpty){
                  return const EmptyWidget(title: "delivery_visits");
                }
                return Column(
                  children: List.generate(deliveryVisitsProvider.deliveryVisitsList.length,
                        (index) =>DeliveryVisitsWidget(deliveryVisit: deliveryVisitsProvider.deliveryVisitsList[index],) ,),
                );
              }
            ),
          ),
        ),
      ),
    );
  }
}
