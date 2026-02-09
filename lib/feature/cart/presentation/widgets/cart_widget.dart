import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../domain/entities/cart_product_entity.dart';
import '../provider/cart_provider.dart';

class CartWidget extends StatefulWidget {
  final CartProductEntity cartProductEntity;
  const CartWidget({required this.cartProductEntity,Key? key}) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  Widget build(BuildContext context) {
    final CartProvider cartProvider = Provider.of(context,listen: false);
    return SizedBox(
      width: 100.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w,vertical:1.5.w),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(imageUrl: widget.cartProductEntity.image,width: 16.w,fit: BoxFit.fitWidth,),
                SizedBox(width: 3.w,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(widget.cartProductEntity.name,maxLines: 1,style: TextStyleClass.normalBoldStyle(),)),
                                    SizedBox(width: 4.w,),
                                    Text("${widget.cartProductEntity.price} CHF",style: TextStyleClass.normalStyle(),),
                                  ],
                                ),
                                SizedBox(height: 1.h,),
                                Text(widget.cartProductEntity.description,style: TextStyleClass.normalStyle(color: AppColor.greyColor),),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w,),
                          InkWell(
                            onTap: (){
                              cartProvider.deleteCartProduct(widget.cartProductEntity);
                              setState(() {});
                            },
                            child: const SvgWidget(color: Colors.red, svg: Images.deleteSVG),
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h,),
                      Row(
                        children: [
                          ButtonWidget(onTap: (){
                            if(widget.cartProductEntity.count>1){
                              widget.cartProductEntity.remove();
                              cartProvider.updateCartProduct(widget.cartProductEntity);
                            }else{
                              cartProvider.deleteCartProduct(widget.cartProductEntity);
                            }
                            setState(() {

                            });
                          }, text: '',
                            widget: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              child: const Icon(Icons.remove,color: AppColor.greyColor,size: 25,),
                            ),
                            borderRadius: 20,
                            height: 6.2.h,
                            borderColor: AppColor.lightGreyColor,
                            color: Colors.white,
                            takeSmallestWidth: true,
                          ),
                          SizedBox(width: 4.w,),
                          Text(widget.cartProductEntity.count.toString(),style: TextStyleClass.semiHeadBoldStyle(),),
                          SizedBox(width: 4.w,),
                          ButtonWidget(onTap: (){
                            widget.cartProductEntity.add();
                            cartProvider.updateCartProduct(widget.cartProductEntity);
                            setState(() {

                            });
                          }, text: '',
                            widget: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.w),
                              child: Icon(Icons.add,color: AppColor.defaultColor,size: 25,),
                            ),
                            borderRadius: 20,
                            height: 6.2.h,
                            borderColor: AppColor.lightGreyColor,
                            color: Colors.white,
                            takeSmallestWidth: true,
                          ),
                          // Spacer(),
                          // if(widget.cartProductEntity.showPrice)Text(addStringToPrice(widget.cartProductEntity.price.toString()),style: TextStyleClass.semiHeadBoldStyle(),),
                          // if(widget.cartProductEntity.showPrice)Text("CHF",style: TextStyleClass.normalStyle(),),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h,),
            Divider(color: AppColor.lightGreyColor,thickness: 0.15.h,),
          ],
        ),
      ),
    );
  }
}
