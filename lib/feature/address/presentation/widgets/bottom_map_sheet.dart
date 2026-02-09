import 'package:flutter/material.dart';
import 'package:homsfood/feature/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../auth/presentation/provider/edit_account_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/address_provider.dart';
import '../provider/bottom_map_sheet.dart';
import '../provider/map_provider.dart';

class BottomMapSheetWidget extends StatefulWidget {
  const BottomMapSheetWidget({Key? key}) : super(key: key);

  @override
  State<BottomMapSheetWidget> createState() => _BottomMapSheetWidgetState();
}

class _BottomMapSheetWidgetState extends State<BottomMapSheetWidget> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<BottomMapSheetProvider>(
        builder: (context,bottom,_) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 100.w,
          height: bottom.expanded?60.h:18.h,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
            child: Consumer<MapProvider>(
              builder: (context,map,_) {
                if(bottom.expanded){
                  return GestureDetector(
                    onTap: (){
                      FocusScope.of(context).unfocus();
                    },
                    child: SingleChildScrollView(
                      child: Form(
                        key: formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 1.h,),
                              for(var i in bottom.inputs)
                                if(i['show']??true)TextFieldWidget(controller: i['value'],
                                  hintText: LanguageProvider.translate("inputs", i['label']),titleWidget: Row(
                                    children: [
                                      SvgWidget(svg: i['image'],width: 5.w,),
                                      SizedBox(width: 3.w,),
                                      Text(LanguageProvider.translate("inputs", i['label'])),
                                    ],
                                  ),keyboardType: i['type'],color: Colors.white,
                                borderColor: AppColor.lightGreyColor,),
                              SizedBox(height: 1.h,),
                              ButtonWidget(onTap: (){
                                if(formKey.currentState!.validate()){
                                  AuthenticationProvider auth =Provider.of(context,listen: false);
                                  EditAccountProvider edit =Provider.of(context,listen: false);
                                  if(auth.fromAuthRegister){
                                    print('1');
                                    auth.registerButton();
                                  }else{
                                    print('2');
                                    edit.updateProfile(addAddressField: true);
                                    // if(bottom.id==0){
                                    //   Provider.of<AddressProvider>(context,listen: false).addAddress();
                                    // }else{
                                    //   Provider.of<AddressProvider>(context,listen: false).updateAddress();
                                    // }
                                  }

                                }
                              }, text: "save_location",widgetAfterText: false,
                                widget:  SvgWidget(svg: Images.locationSVG,width: 8.w,color: Colors.white,),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 1.h,),
                    Row(
                      children: [
                        SvgWidget(svg: Images.locationSVG,width: 7.w,),
                        SizedBox(width: 1.w,),
                        Expanded(child: Text(map.description,style: TextStyleClass.normalStyle(color: Colors.black),
                        maxLines: 1,)),
                      ],
                    ),
                    SizedBox(height: 1.h,),
                    ButtonWidget(onTap: (){
                      bottom.enableExtend();
                    }, text: "confirm_location",widgetAfterText: false,
                      widget:  SvgWidget(svg: Images.locationSVG,width: 8.w,color: Colors.white,),),
                  ],
                );
              }
            ),
          ),
        );
      }
    );
  }
}
