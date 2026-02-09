import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../domain/entities/address_entity.dart';
import '../provider/address_provider.dart';


class AddressWidget extends StatelessWidget {
  final AddressEntity addressEntity;
  const AddressWidget({Key? key, required this.addressEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: InkWell(
        onTap: (){
          Provider.of<AddressProvider>(context,listen: false).selectAddress(addressEntity);
          // Provider.of<CheckOutProvider>
          //   (context,listen: false).selectAddress(addressEntity);
        },
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: ColoredBox(
              color: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColor.lightDefaultColor,
                  border: addressEntity.addBorderColor(Provider.of<AddressProvider>
                    (context,listen: false).selectedAddress)?
                  Border.all(color: AppColor.defaultColor,width: 2):null,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.h),
                  child: Row(
                    children: [
                      Image.asset(Images.placeHolderMapImage),
                      SizedBox(width: 3.w,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(child: Text(addressEntity.name,style: TextStyleClass.normalBoldStyle(),)),
                                InkWell(
                                  onTap: (){
                                    Provider.of<AddressProvider>(context,listen: false).goMapPageUpdate(addressEntity);
                                  },
                                  child: const SvgWidget(svg: Images.editOrderSVG),
                                ),
                                SizedBox(width: 3.w,),
                                InkWell(
                                  onTap: (){
                                    Provider.of<AddressProvider>(context,listen: false).deleteAddress(addressEntity);
                                  },
                                  child: const SvgWidget(color: Colors.red, svg: Images.deleteSVG),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.5.h,),
                            Row(
                              children: [
                                SvgWidget(svg: Images.activePersonSVG,width: 3.5.w,),
                                SizedBox(width: 2.w,),
                                Expanded(child: Text(addressEntity.recipientName,style: TextStyleClass.smallStyle(),)),
                              ],
                            ),
                            SizedBox(height: 1.5.h,),
                            Row(
                              children: [
                                SvgWidget(svg: Images.locationSVG,width: 5.w,),
                                SizedBox(width: 1.w,),
                                Expanded(child: Text(addressEntity.address,style: TextStyleClass.smallStyle(),)),
                              ],
                            ),
                            SizedBox(height: 1.5.h,),
                            Row(
                              children: [
                                SvgWidget(svg: Images.phoneSVG,width: 5.w,),
                                SizedBox(width: 1.w,),
                                Expanded(child: Text(addressEntity.recipientNumber,style: TextStyleClass.smallStyle(),)),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
