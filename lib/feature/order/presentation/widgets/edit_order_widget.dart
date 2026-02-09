import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../cart/domain/entities/cart_product_entity.dart';

class EditOrderWidget extends StatefulWidget {
  final CartProductEntity product;
  final void Function() delete;
  const EditOrderWidget({required this.product,Key? key, required this.delete}) : super(key: key);
  @override
  State<EditOrderWidget> createState() => _EditOrderWidgetState(product);
}

class _EditOrderWidgetState extends State<EditOrderWidget> {
  CartProductEntity product;
  _EditOrderWidgetState(this.product);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Container(
        width: 90.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.lightDefaultColor,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 5.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      children: [
                        Text('${product.count} x ${product.name}',style: TextStyleClass.normalBoldStyle(),),
                        if(product.isComplete)SizedBox(width: 2.w,),
                        if(product.isComplete)Icon(Icons.check_circle_rounded,color: Colors.green,size: 20,),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w,),
                  Text('${product.price}',style: TextStyleClass.semiBoldStyle(),
                    textAlign: TextAlign.end,),
                  Text(' CHF',style: TextStyleClass.smallStyle(),
                    textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 0.5.h,),
              Row(
                children: [
                  Expanded(child: Text('IVA ${product.taxEntity.tax}%',style: TextStyleClass.normalBoldStyle(),)),
                  Text('+  ${product.count}x${product.taxEntity.tax}%',style: TextStyleClass.normalBoldStyle(),
                    textAlign: TextAlign.end,),
                ],
              ),
              if(product.note!=null)SizedBox(height: 1.h,),
              if(product.note!=null)Row(
                children: [
                  Expanded(child: Text(product.note!,
                    style: TextStyleClass.smallStyle(color: Colors.red),)),
                ],
              ),
              SizedBox(height: 1.h,),
              Row(
                children: [
                  IconButton(onPressed: (){
                    product.remove();
                    setState(() {

                    });
                  }, icon: Icon(Icons.remove)),
                  SizedBox(width: 2.w,),
                  Container(
                    width: 30.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 1.h),
                      child: Center(
                        child: Text(product.count.toString(),style: TextStyleClass.normalStyle(),),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w,),
                  IconButton(onPressed: (){
                    product.add();
                    setState(() {

                    });
                  }, icon: Icon(Icons.add,color: AppColor.defaultColor,)),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      widget.delete();
                    },
                    child: const SvgWidget(color: Colors.red, svg: Images.deleteSVG),
                  ),
                ],
              ),
              if(product.dateTime!=null)SizedBox(height: 1.h,),
              if(product.dateTime!=null)Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(convertDateToString(product.dateTime!),
                    style: TextStyleClass.smallStyle(color: AppColor.lightGreyColor),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
