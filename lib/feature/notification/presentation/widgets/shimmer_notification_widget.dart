import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

class ShimmerNotificationWidget extends StatelessWidget {
  const ShimmerNotificationWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade50,
        child: ColoredBox(
          color: Colors.white,
          child: SizedBox(
            width: 100.w,
            height: 15.h,
          ),
        ),
      ),
    );
  }
}
