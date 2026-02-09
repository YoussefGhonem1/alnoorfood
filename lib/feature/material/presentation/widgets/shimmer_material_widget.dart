import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';

class ShimmerMaterialWidget extends StatelessWidget {
  const ShimmerMaterialWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade200,
      child: Container(
        width: 45.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: AppColor.lightGreyColor,spreadRadius: 1,blurRadius: 2)],
        ),
      ),
    );
  }
}
