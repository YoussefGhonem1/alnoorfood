import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/list_text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/auth_provider.dart';
import '../provider/edit_account_provider.dart';

class EditPage extends StatelessWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authenticationProvider = Provider.of(context,listen: false);

    return Consumer<EditAccountProvider>(
      builder: (context,edit,_) {
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(LanguageProvider.translate('settings', "edit_profile")),
              actions: [
                Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text('# ${isUser?authenticationProvider.userEntity!.id:deliveryEntity!.id}',style: TextStyleClass.semiHeadBoldStyle(),),
                ),
                SizedBox(width: 3.w,),
              ],
            ),
            body: SizedBox(
              width: 100.w,
              height: 100.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // for(var i in edit.inputs())
                      //   TextFieldWidget(controller: i['value'],
                      //     hintText: i['hint']??LanguageProvider.translate("inputs", i['label']),titleWidget: Row(
                      //       children: [
                      //         SvgWidget(svg: i['image'],width: 5.w,),
                      //         SizedBox(width: 3.w,),
                      //         Text(LanguageProvider.translate("inputs", i['label'])),
                      //       ],
                      //     ),keyboardType: i['type'],next: i['next']!=false,
                      //     borderColor: AppColor.lightGreyColor,height: 5.5.h,),
                      ListTextFieldWidget(inputs: edit.inputs(),color: Colors.grey.shade300,
                        borderColor:Colors.grey.shade300 ,),
                      SizedBox(height: 1.h,),
                      ButtonWidget(onTap: (){
                        edit.updateProfile();
                      }, text: "save",),
                      SizedBox(height: 2.h,),
                      if(isUser)ButtonWidget(onTap: (){
                        Provider.of<AuthenticationProvider>(context,listen: false).goToAddAddressPage();
                      }, text: "update_address",color: Colors.white,borderColor: AppColor.defaultColor,textColor: AppColor.defaultColor,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
