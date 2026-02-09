import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../../../../config/app_color.dart';
import '../../../../product/presentation/widgets/shimmer/shimmer_product_widget.dart';

class ShimmerCategoryWidget extends StatelessWidget {
  final int index;
  const ShimmerCategoryWidget({required this.index,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Shimmer.fromColors(
        baseColor: index.isEven?AppColor.defaultColor.withOpacity(0.3):Colors.grey.shade300,
        highlightColor: index.isEven?AppColor.lightDefaultColor:Colors.grey.shade200,
        child: Container(
          width: 100.w,
          color: index.isEven?AppColor.defaultColor.withOpacity(0.3):null,
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30.w,
                      height: 4.5.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.5.w,),
                ...List.generate(3, (index) => ShimmerProductWidget()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
