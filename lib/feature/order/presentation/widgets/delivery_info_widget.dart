import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../domain/entities/order_entity.dart';

class DeliveryInfoWidget extends StatelessWidget {
  final OrderEntity order;
  const DeliveryInfoWidget({required this.order,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if(order.delivery==null){
      return const SizedBox();
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.defaultColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.h),
          child: ListTile(
            title: Text(order.delivery!.name,style: TextStyleClass.semiBoldStyle(),),
            visualDensity: VisualDensity.compact,
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.zero,
            subtitle: Text(order.delivery!.phone,style: TextStyleClass.
            normalStyle(color: AppColor.greyColor),),
            trailing: InkWell(
              onTap: ()async{
                final Uri _url = Uri.parse('tel:${order.delivery!.phone}');
                if (!await launchUrl(_url)) throw 'Could not launch $_url';
              },
              child: const SvgWidget(svg: Images.phoneSVG,color: Colors.black,),
            ),
          ),
        ),
      ),
    );
  }
}
