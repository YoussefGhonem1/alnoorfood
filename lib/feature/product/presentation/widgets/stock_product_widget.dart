import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../provider/stock_product_provider.dart';

class StockProductWidget extends StatefulWidget {
  final ProductEntity productEntity;
  const StockProductWidget({required this.productEntity,Key? key}) : super(key: key);

  @override
  State<StockProductWidget> createState() => _StockProductWidgetState();
}

class _StockProductWidgetState extends State<StockProductWidget> {
  final TextEditingController counter = TextEditingController();
  @override
  void initState() {
    super.initState();
    counter.text = widget.productEntity.count.toString();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Padding(
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(imageUrl: widget.productEntity.image,
                    width: 16.w,height: 20.w,fit: BoxFit.cover,),
                ),
                // CachedNetworkImage(imageUrl: widget.productEntity.image,width: 16.w,fit: BoxFit.fitWidth,),
                SizedBox(width: 3.w,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(widget.productEntity.name,style: TextStyleClass.semiHeadStyle(),)),
                        ],
                      ),
                      SizedBox(height: 1.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('${widget.productEntity.weight??""}',
                            style: TextStyleClass.normalStyle(color: AppColor.greyColor),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(onPressed: (){
                                if(widget.productEntity.count>0){
                                  widget.productEntity.remove();
                                  counter.text = widget.productEntity.count.toString();
                                  setState(() {

                                  });
                                }
                              }, icon: const Icon(Icons.remove,)),
                              TextFieldWidget(controller: counter,
                              width: 20.w,height: 4.5.h,textAlign: TextAlign.center,
                              keyboardType: const TextInputType.numberWithOptions(),

                              onChange: (val){
                                if(!convertStringToInt(val).isNegative){
                                  widget.productEntity.count = convertStringToInt(val);
                                  counter.text = convertStringToInt(val).toString();
                                }else{
                                  widget.productEntity.count = convertStringToInt(0);
                                  counter.text = 0.toString();
                                }
                                setState(() {

                                });
                              },verticalPadding: 0,contentPadding: 0.8.h,),
                              IconButton(onPressed: (){
                                widget.productEntity.add();
                                counter.text = widget.productEntity.count.toString();
                                setState(() {

                                });
                              }, icon: const Icon(Icons.add,)),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 1.h,),
                      if(widget.productEntity.minLimit>=widget.productEntity.count)
                        Text(LanguageProvider.translate('validation', 'limit'),
                        style: TextStyleClass.normalStyle(color: Colors.red),),
                      if(widget.productEntity.minLimit>=widget.productEntity.count)SizedBox(height: 1.h,),
                      ButtonWidget(onTap: (){
                        FocusScope.of(context).unfocus();
                        Provider.of<StockProductProvider>(context,listen: false).
                        updateStockProduct(widget.productEntity);
                      }, text: "save",
                        height: 4.8.h,
                        borderRadius: 8,
                        width: 50.w,
                        textStyle: TextStyleClass.smallStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
