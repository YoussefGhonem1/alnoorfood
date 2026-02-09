import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/auth_provider.dart';

class ResetPage extends StatelessWidget {
  ResetPage({Key? key}) : super(key: key);
  final form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Form(
        key: form,
        child: Scaffold(
          appBar: AppBar(
            title: Text(LanguageProvider.translate("forget_pass", "title")),
          ),
          body: Consumer<AuthenticationProvider>(
            builder: (context,auth,_) {
              return Center(
                child: SizedBox(
                  width: 94.w,
                  height: 100.h,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(Images.resetPassImage),
                          ],
                        ),
                        SizedBox(height: 7.h,),
                        ...List.generate(auth.updatePassInputs.length, (index) =>
                            TextFieldWidget(controller: auth.updatePassInputs[index]['value'],
                          hintText: '*******',titleWidget: Row(
                                children: [
                                  SvgWidget(svg: auth.updatePassInputs[index]['image']),
                                  SizedBox(width: 3.w,),
                                  Text(LanguageProvider.translate("inputs", auth.updatePassInputs[index]['label']))
                                ],
                              ),validator: (val){
                              if(index==1&&auth.updatePassInputs[0]['value'].text!=val){
                                return LanguageProvider.translate('validation', 'password');
                              }
                              return null;
                              },),),
                        SizedBox(height: 6.h,),
                        ButtonWidget(onTap: (){
                          if(form.currentState!.validate()){
                            auth.updatePass();
                          }
                        }, text: "login"),
                      ],
                    ),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
