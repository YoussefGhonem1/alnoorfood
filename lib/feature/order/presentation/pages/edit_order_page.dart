import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../cart/domain/entities/cart_product_entity.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/order_delivery_provider.dart';

class EditOrderPage extends StatefulWidget {
  final List<CartProductEntity> products;
  const EditOrderPage({required this.products,Key? key}) : super(key: key);

  @override
  State<EditOrderPage> createState() => _EditOrderPageState();
}

class _EditOrderPageState extends State<EditOrderPage> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LanguageProvider.translate("orders", "edit_order")),
        ),
        bottomSheet: Padding(
          padding: EdgeInsets.symmetric(vertical: 1.h,horizontal: 5.w),
          child: ButtonWidget(onTap: (){
            Provider.of<OrdersDeliveryProvider>(context,listen: false)
                .editOrderButton(widget.products);
          }, text: "save"),
        ),
        body: SizedBox(
          width: 100.w,
          height: 100.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 3.h).add(EdgeInsets.only(bottom: 9.h)),
            child: Column(
              children: [
                Consumer<OrdersDeliveryProvider>(
                  builder: (context,delivery,_) {
                    return TextFieldWidget(controller: delivery.dateInput['value'],color: Colors.white,
                      borderColor: AppColor.lightGreyColor,
                      hintText: delivery.dateInput['label'],maxLines: delivery.dateInput['max'],readOnly: delivery.dateInput['readOnly']??false,
                      keyboardType: delivery.dateInput['type'],onTextTap: delivery.dateInput['onTap'],
                      validator: delivery.dateInput['validate'],titleWidget: Row(
                        children: [
                          SvgWidget(svg: delivery.dateInput['image']),
                          SizedBox(width: 2.w,),
                          Text(LanguageProvider.translate('inputs', delivery.dateInput['label']))
                        ],
                      ),);
                  }
                ),
                SizedBox(height: 1.h,),
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.products.length,
                    itemBuilder: (ctx,i){
                      CartProductEntity product = widget.products[i];
                      final TextEditingController counter = TextEditingController(text: product.count.toString());
                      return StatefulBuilder(
                        builder: (context,set) {
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
                                              if(product.isComplete)const Icon(Icons.check_circle_rounded,color: Colors.green,size: 20,),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 2.w,),
                                        Text(addStringToPrice(product.calcTotalPrice().toString()),style: TextStyleClass.semiBoldStyle(),
                                          textAlign: TextAlign.end,),
                                        Text(' CHF',style: TextStyleClass.smallStyle(),
                                          textAlign: TextAlign.end,),
                                      ],
                                    ),
                                    SizedBox(height: 0.5.h,),
                                    Row(
                                      children: [
                                        Expanded(child: Text('IVA ${product.taxEntity.tax}%',style: TextStyleClass.normalBoldStyle(),)),
                                        // Text('+  ${product.count}x${product.taxEntity.tax}%',style: TextStyleClass.normalBoldStyle(),
                                        //   textAlign: TextAlign.end,),
                                        Text('${addStringToPrice(product.calcTotalTax().toString())}',style: TextStyleClass.normalBoldStyle(),
                                          textAlign: TextAlign.end,),
                                        Text(' CHF',style: TextStyleClass.smallStyle(),
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
                                          counter.text = product.count.toString();
                                          set(() {

                                          });
                                        }, icon: const Icon(Icons.remove)),
                                        SizedBox(width: 2.w,),
                                        TextFieldWidget(controller: counter,
                                          width: 30.w,height: 4.h,textAlign: TextAlign.center,
                                          keyboardType: const TextInputType.numberWithOptions(decimal: true,signed: false),
                                          borderColor: Colors.grey,
                                          color: Colors.transparent,
                                          contentPadding: 0.5.h,
                                          borderRadius: 10,
                                          onTextTap: (){
                                            if(counter.selection ==
                                                TextSelection.fromPosition(TextPosition(
                                                    offset: counter.text.length -1))||counter.selection ==
                                                TextSelection.fromPosition(const TextPosition(offset: 0))){
                                              set(() {
                                                counter.selection = TextSelection.
                                                fromPosition(TextPosition(offset:
                                                counter.text.length));
                                              });
                                            }
                                          },
                                          onChange: (val){
                                          print(val);
                                            if(val.endsWith('.')){

                                            }else{
                                              product.count = convertDataToNum(val);
                                              counter.text = convertDataToNum(val).toString();
                                            }
                                            set(() {

                                            });
                                          },verticalPadding: 0,),
                                        // Container(
                                        //   width: 30.w,
                                        //   decoration: BoxDecoration(
                                        //     borderRadius: BorderRadius.circular(10),
                                        //     border: Border.all(color: Colors.grey),
                                        //   ),
                                        //   child: Padding(
                                        //     padding: EdgeInsets.symmetric(vertical: 1.h),
                                        //     child: Center(
                                        //       child: Text(product.count.toString(),style: TextStyleClass.normalStyle(),),
                                        //     ),
                                        //   ),
                                        // ),
                                        SizedBox(width: 2.w,),
                                        IconButton(onPressed: (){
                                          product.add();
                                          counter.text = product.count.toString();
                                          set(() {

                                          });
                                        }, icon: const Icon(Icons.add,color: AppColor.defaultColor,)),
                                        const Spacer(),
                                        Container(
                                          width: 5.w,
                                          height: 5.w,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2),
                                            color: Colors.white,
                                            border: Border.all(color: AppColor.defaultColor),
                                          ),
                                          child: Checkbox(value: widget.products[i].isEnded, onChanged: (val){
                                            set(() {
                                           widget.products[i].isEnded = !widget.products[i].isEnded!;
                                          });
                                          },),
                                        ),
                                        SizedBox(width: 2.w,),
                                        InkWell(
                                          onTap: (){
                                            widget.products.removeAt(i);
                                            set(() {

                                            });
                                          },
                                          child: const SvgWidget(color: Colors.red, svg: Images.deleteSVG),
                                        ),
                                      ],
                                    ),
                                    // SizedBox(height: 1.h,),
                                    // Text(LanguageProvider.translate('orders', 'temperature'),
                                    //   style: TextStyleClass.normalStyle(),),
                                    // TextFieldWidget(hintText: '',
                                    // borderRadius: 8,width: 80.w,contentPadding: 1.h,color: Colors.white,
                                    // verticalPadding: 1.h,onChange: (val){
                                    //   product.temperature = val;
                                    //   set(() {
                                    //
                                    //   });
                                    //   }, controller: product.controller,),
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
                      );
                    },
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
