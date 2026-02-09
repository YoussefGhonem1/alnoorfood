import 'package:flutter/material.dart';
import 'package:homsfood/feature/auth/presentation/provider/auth_provider.dart';
import 'package:homsfood/feature/settings/presentation/provider/settings_provider.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/helper_function.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/drop_down_widget.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../order/presentation/widgets/order_widget.dart';
import '../provider/cart_provider.dart';
import '../provider/check_out_provider.dart';
import '../widgets/cart_widget.dart';
import '../widgets/points_widget.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider auth = Provider.of(context);
    SettingsProvider settingsProvider = Provider.of(context,listen: false);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: isUser?null:AppBar(
          title: Text(LanguageProvider.translate("main", "cart")),
        ),
        body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
            child: Consumer<CartProvider>(
                builder: (context,cartProvider,_) {
                  if(cartProvider.cartProducts==null){
                    return SizedBox();
                  }
                  if(cartProvider.cartProducts!.isEmpty){
                    return const EmptyWidget(title: 'cart');
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        if(!isUser)TextFieldWidget(controller: cartProvider.input['value'],
                          prefix: SvgWidget(svg: cartProvider.input['image']),hintText: cartProvider.input['label'],
                          onChange: cartProvider.input['onChange'],
                          onEditingComplete: (){
                            FocusScope.of(context).unfocus();
                            cartProvider.input['onComplete'];
                          },),
                        if(!isUser)SizedBox(height: 1.h,),
                        if(!isUser)ButtonWidget(onTap: (){
                          Provider.of<AuthenticationProvider>(context,listen: false).goToRegisterPage();
                        }, text: LanguageProvider.translate('register', 'create_user')),
                        if(!isUser)SizedBox(height: 1.5.h,),
                        if(!isUser)DropDownWidget(dropDownClass: cartProvider,
                            afterClick: (){},width: 90.w,height: 5.h,),
                        if(!isUser)SizedBox(height: 3.h,),
                        if(cartProvider.orderEntity!=null)
                          OrdersWidget(orderEntity: cartProvider.orderEntity!,fromCart: true,),
                        if(cartProvider.orderEntity!=null)SizedBox(height: 3.h,),
                        ...List.generate(cartProvider.cartProducts!.length, (index) =>
                            CartWidget(cartProductEntity: cartProvider.cartProducts![index],)),
                        if(settingsProvider.settingsEntity!.is_automatic_coupon)const PointsWidget(),
                        SizedBox(height: 3.h,),
                        ButtonWidget(onTap: ()async{
                          if(cartProvider.cartProducts?.isNotEmpty??false){
                            if(!isUser&&cartProvider.user==null){
                              showToast(LanguageProvider.translate('language', 'choose_user'));
                            }else{
                              if(settingsProvider.settingsEntity?.isOpen??false){

                              }else{
                                showToast(LanguageProvider.translate( 'orders', 'close'));
                                await delay(2000);
                              }

                              Provider.of<CheckOutProvider>
                                (context,listen: false).
                              goToCheckOutPage(isUser?auth.userEntity!.addressEntity:
                              cartProvider.user!.addressEntity);

                            }
                          }

                        }, text: cartProvider.orderEntity==null?"check_out":"update_order"),
                      ],
                    ),
                  );
                }
            ),
          ),
        ),
      ),
    );
  }
}
