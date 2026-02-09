import 'package:flutter/material.dart';
import 'package:homsfood/feature/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/order_product_details.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/cart_provider.dart';
import '../provider/check_out_provider.dart';
import '../widgets/selected_widget.dart';
class CheckOutPage extends StatefulWidget {
  const CheckOutPage({Key? key}) : super(key: key);

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    AuthenticationProvider auth = Provider.of(context);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LanguageProvider.translate('check_out', "title")),
        ),
        body: Form(
          key: formKey,
          child: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
              child: Consumer<CheckOutProvider>(
                builder: (context,checkOutProvider,_) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if(!isUser&&deliveryEntity!.isAdmin)
                          Text(LanguageProvider.translate('global', 'ended_order'),
                          style: TextStyleClass.normalStyle(),),
                        if(!isUser&&deliveryEntity!.isAdmin)SizedBox(height: 1.h,),
                        // if(!isUser&&deliveryEntity!.isAdmin)Row(
                        //   children: [
                        //     Text(LanguageProvider.translate('buttons', 'yes'),
                        //         style: TextStyleClass.smallStyle()),
                        //     SizedBox(width: 2.w,),
                        //     Radio(value: true, groupValue: checkOutProvider.ended, onChanged: (val){
                        //       checkOutProvider.changeEnded();
                        //     },visualDensity: VisualDensity.compact,),
                        //     SizedBox(width: 5.w,),
                        //     Text(LanguageProvider.translate('buttons', 'no'),
                        //         style: TextStyleClass.smallStyle()),
                        //     SizedBox(width: 2.w,),
                        //     Radio(value: false, groupValue: checkOutProvider.ended, onChanged: (val){
                        //       checkOutProvider.changeEnded();
                        //     },visualDensity: VisualDensity.compact,),
                        //   ],
                        // ),
                        if(!isUser&&deliveryEntity!.isAdmin)SizedBox(height: 1.h,),
                        Builder(
                          builder: (context) {
                            var cart = Provider.of<CartProvider>
                              (context,listen: false);
                            return OrderProductsDetailsWidget(cartProducts: cart.cartProducts!,
                            total: cart.calcTotal(),subTotal: cart.calcSubTotal(),
                              discount: cart.discountValue(),
                              tax:cart.taxes,);
                          }
                        ),
                        SizedBox(height: 2.h,),
                        FormField(
                          builder: (state){
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SelectedWidget(selectedClass: checkOutProvider.selectedAddress()),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: state.errorText!=null?1.h:0),
                                  child: Text(
                                    state.errorText ?? '',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                      fontSize: 9.sp,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                          validator: (val){
                            if(checkOutProvider.addressEntity==null){
                              return LanguageProvider.translate("validation", "address");
                            }
                            return null;
                          },
                        ),
                        // if(userClass!.payType==PayType.fattura)FormField(
                        //   builder: (state){
                        //     return Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         SelectedWidget(selectedClass: checkOutProvider.selectedBillingAddress()),
                        //         Padding(
                        //           padding: EdgeInsets.symmetric(vertical: state.errorText!=null?1.h:0),
                        //           child: Text(
                        //             state.errorText ?? '',
                        //             style: TextStyle(
                        //               color: Theme.of(context).colorScheme.error,
                        //               fontSize: 9.sp,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     );
                        //   },
                        //   validator: (val){
                        //     if(checkOutProvider.addressBillingEntity==null){
                        //       return LanguageProvider.translate("validation", "address");
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // SelectedWidget(selectedClass:isUser?auth.userEntity!.selectedClass():
                        // Provider.of<CartProvider>(context,listen: false).user!.selectedClass()),
                        for(var i in checkOutProvider.inputs)
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
                        // if(!isUser&&deliveryEntity!.isAdmin&&checkOutProvider.ended)Row(
                        //   children: [
                        //     Text(LanguageProvider.translate('orders', 'paid'),
                        //         style: TextStyleClass.smallStyle()),
                        //     SizedBox(width: 2.w,),
                        //     Radio(value: true, groupValue: checkOutProvider.isPaid, onChanged: (val){
                        //       checkOutProvider.changePaid();
                        //     },visualDensity: VisualDensity.compact,),
                        //     SizedBox(width: 5.w,),
                        //     Text(LanguageProvider.translate('orders', 'not_paid'),
                        //         style: TextStyleClass.smallStyle()),
                        //     SizedBox(width: 2.w,),
                        //     Radio(value: false, groupValue: checkOutProvider.isPaid, onChanged: (val){
                        //       checkOutProvider.changePaid();
                        //     },visualDensity: VisualDensity.compact,),
                        //   ],
                        // ),
                        ButtonWidget(onTap: (){
                          if(formKey.currentState!.validate()){
                            checkOutProvider.showCheckOutSheet();
                          }
                        }, text: Provider.of<CartProvider>(context,listen: false)
                            .orderEntity==null?"check_out":"update_order"),
                      ],
                    ),
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
