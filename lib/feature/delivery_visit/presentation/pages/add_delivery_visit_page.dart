import 'package:flutter/material.dart';
import 'package:homsfood/core/widget/drop_down_widget.dart';
import 'package:homsfood/feature/language/presentation/provider/language_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../provider/delivery_visit_provider.dart';

class AddDeliveryVisitPage extends StatelessWidget {
  const AddDeliveryVisitPage({super.key});

  @override
  Widget build(BuildContext context) {
    DeliveryVisitProvider deliveryVisitProvider = Provider.of(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(LanguageProvider.translate('settings', 'delivery_visits')),),
        body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropDownWidget(dropDownClass: deliveryVisitProvider, afterClick: (){},width: 90.w,height: 5.h,),
                  for(var i in deliveryVisitProvider.inputs)
                    TextFieldWidget(controller: i['value'],color: Colors.white,
                      borderColor: AppColor.lightGreyColor,
                      hintText: i['label'],maxLines: i['max'],readOnly: i['readOnly']??false,
                      keyboardType: i['type'],onTextTap: i['onTap'],
                      validator: i['validate'],titleWidget: Row(
                        children: [
                          SvgWidget(svg: i['image']),
                          SizedBox(width: 2.w,),
                          Text(LanguageProvider.translate('inputs', i['label']))
                        ],
                      ),),
                  SizedBox(height: 1.h,),
                  ButtonWidget(onTap: (){

                    deliveryVisitProvider.action();

                  }, text: 'save'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
