import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:homsfood/core/helper_function/navigation.dart';
import 'package:homsfood/core/widget/img_preview_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/favorite_button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/product_entity.dart';
import 'counter_widget.dart';

class ProductWidget extends StatelessWidget {
  final ProductEntity productEntity;
  const ProductWidget({required this.productEntity,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:1.5.w),
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(color: AppColor.lightGreyColor)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w,vertical:1.5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 16.w,
                height: 20.w,
                child: Stack(
                  children: [
                    Positioned(top: 0,
                        left: 0,
                        child: InkWell(
                          onTap: (){
                            navP(ImagePreviewWidget(imgPath: productEntity.image));
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(imageUrl: productEntity.image,
                              width: 16.w,height: 20.w,fit: BoxFit.cover,),
                          ),
                        )),
                    if(productEntity.isNew)Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.defaultColor,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 0.7.w,vertical: 0.1.h),
                        child: Center(
                          child: Text(LanguageProvider.translate('main', 'new'),
                          style: TextStyleClass.tinyStyle(color: Colors.white),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 3.w,),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(productEntity.name,style: TextStyleClass.normalStyle(),)),
                        SizedBox(width: 3.w,),
                        if(productEntity.weight!=null)Text(productEntity.weight!,style: TextStyleClass.normalStyle(),)
                      ],
                    ),
                    if(productEntity.brand!=null)...[
                      SizedBox(height: 0.5,),
                      Text(productEntity.brand!,style: TextStyleClass.smallStyle(),),
                      SizedBox(height: 0.5,),
                    ],
                    Row(
                      children: [
                        CounterWidget(counter: productEntity),
                        FavoriteButtonWidget(favorite: productEntity),
                      ],
                    ),
                    SizedBox(height: 1.h,),
                    StatefulBuilder(
                      builder: (context,set) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // DropDownWidget(dropDownClass: productEntity,afterClick: (){
                            //   set((){});
                            // },),
                            // if(productEntity.showPrice())
                            //   Text("${addStringToPrice(productEntity.getPriceForUnit().toString())} chf",
                            //     style: TextStyleClass.semiStyle(),),
                            Text("${addStringToPrice(productEntity.price.toString())} CHF",style: TextStyleClass.semiStyle(color: AppColor.defaultColor),
                            maxLines: 1,),
                            ButtonWidget(onTap: (){
                              Provider.of<CartProvider>(context,listen: false).
                              addCartProduct(productEntity.cartProductEntity());
                            }, text: "add",
                              widget: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 1.5.w),
                                child: const SvgWidget(color: Colors.white, svg: Images.cartSVG),
                              ),
                              height: 4.8.h,
                              takeSmallestWidth: true,
                              borderRadius: 8,
                              textStyle: TextStyleClass.smallStyle(color: Colors.white),
                            ),
                          ],
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
