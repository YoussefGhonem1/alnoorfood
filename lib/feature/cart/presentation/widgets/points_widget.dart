import 'package:flutter/material.dart';
import 'package:homsfood/config/text_style.dart';
import 'package:homsfood/core/widget/text_field.dart';
import 'package:homsfood/feature/settings/domain/entities/coupon_entity.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/confirm_dialog.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../settings/presentation/provider/settings_provider.dart';
import '../provider/cart_provider.dart';

class PointsWidget extends StatelessWidget {
  const PointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of(context);
    SettingsProvider settingsProvider = Provider.of(context);
    return Column(
      children: [
        if(isUser && cartProvider.settingsPoints <= cartProvider.points)
        Container(
            width: 90.w,
            padding: EdgeInsets.symmetric(horizontal:2.w,vertical: 2.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.defaultColor),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(LanguageProvider.translate("orders", "enough_points"),style: TextStyle(
                  color: AppColor.defaultColor,fontSize: 12.sp,
                ),),
                SizedBox(height: 1.h,),
                ButtonWidget(
                    width: 40.w,
                    height: 4.5.h,borderRadius: 1.w,
                    color: AppColor.defaultColor,text: "transfer",onTap: (){
                  String value= "";
                  if(settingsProvider.settingsEntity?.type == "value"){
                    value = "${settingsProvider.settingsEntity?.value??0} CHF";
                  }else{
                    value = "${settingsProvider.settingsEntity?.percentage??0}%";
                  }
                  confirmDialog(context, LanguageProvider.translate("orders", "convert_points").
                  replaceFirst("*input*", "${cartProvider.settingsPoints}")
                      .replaceFirst("*output*", value)
                      , LanguageProvider.translate("buttons", "confirm"), (){
                        cartProvider.addCoupon(context);
                      });
                }),
              ],
            ),
          ),
        SizedBox(height: 2.h,),
        TextFieldWidget(controller: cartProvider.couponController,hintText: "coupon",
            hintStyle:TextStyleClass.normalStyle(color: Colors.grey),
          suffix: Padding(
            padding: EdgeInsets.symmetric(vertical: 1.5.h,horizontal: 3.w),
            child: Builder(
              builder: (context){
                if(cartProvider.cartProducts!=null&&cartProvider.coupon != null){
                  return InkWell(
                    onTap: (){
                      cartProvider.setCoupon(null);
                    },
                    child: Icon(Icons.check_box,color: AppColor.defaultColor,size: 8.w,)
                  );
                }else{
                  return InkWell(
                    onTap: ()async{
                      if(cartProvider.couponController.text!=''){
                        CouponEntity? coupon = await CouponEntity.setCoupon(cartProvider.couponController.text,
                            cartProvider.orderEntity?.total??0);
                        if(coupon!=null){
                          cartProvider.setCoupon(coupon);
                        }
                      }
                    },
                      child: Icon(Icons.check_box_outline_blank,color: Colors.black54,size: 8.w,)
                  );
                }
              },
            ),

          ),
          readOnly: isGuest,
          onEditingComplete:  (){
            FocusScope.of(context).unfocus();
          },
        ),
      ],
    ) ;
  }
}
