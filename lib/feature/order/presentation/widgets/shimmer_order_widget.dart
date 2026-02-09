import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';

class ShimmerOrdersWidget extends StatelessWidget {
  const ShimmerOrdersWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: Container(
          width: 100.w,
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColor.lightGreyColor),
            color: const Color(0xffFCFEFC)
          ),
        ),
      ),
    );
  }
}
