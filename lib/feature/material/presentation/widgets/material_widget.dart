import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../domain/entities/material_entity.dart';

class MaterialWidget extends StatelessWidget {
  final MaterialEntity materialEntity;
  const MaterialWidget({Key? key, required this.materialEntity}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: AppColor.lightGreyColor,spreadRadius: 1,blurRadius: 2)],
      ),
      child: Column(
        children: [
          SizedBox(height: 2.h,),
          CachedNetworkImage(imageUrl: materialEntity.image,width: 40.w,fit: BoxFit.contain,
          height: 8.h,),
          SizedBox(height: 2.h,),
          Text(materialEntity.name,style: TextStyleClass.normalStyle(),),
          SizedBox(height: 2.h,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SvgWidget(svg: Images.lengthSVG),
              SizedBox(width: 1.w,),
              Text(materialEntity.amount.toString(),style: TextStyleClass.normalStyle(),),
            ],
          ),
          SizedBox(height: 2.h,),
        ],
      ),
    );
  }
}
