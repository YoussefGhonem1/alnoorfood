import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/support_provider.dart';

class SupportPage extends StatelessWidget {
  SupportPage({Key? key}) : super(key: key);
  final formField = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Form(
        key: formField,
        child: Consumer<SupportProvider>(
            builder: (context,support,_) {
              return GestureDetector(
                onTap: (){
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(LanguageProvider.translate('settings', "support")),
                  ),
                  body: SizedBox(
                    width: 100.w,
                    height: 100.h,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            for(var i in support.inputs)
                              TextFieldWidget(controller: i['value'],
                                hintText: i['hint']??LanguageProvider.translate("inputs", i['label']),titleWidget: Row(
                                  children: [
                                    SvgWidget(svg: i['image'],width: 5.w,),
                                    SizedBox(width: 3.w,),
                                    Text(LanguageProvider.translate("inputs", i['label'])),
                                  ],
                                ),keyboardType: i['type'],next: i['next']!=false,
                                maxLines: i['max'],
                                borderColor: AppColor.lightGreyColor,),
                            SizedBox(height: 10.h,),
                          ],
      
                        ),
                      ),
                    ),
                  ),
      
                  bottomSheet: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
                      child: ButtonWidget(onTap: (){
                        if(formField.currentState!.validate()){
                          FocusScope.of(context).unfocus();
                          support.contactUs();
                        }
                      }, text: "send_request",),
                    ),
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
