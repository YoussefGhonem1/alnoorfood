import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/svg_widget.dart';


class ShimmerAddressWidget extends StatelessWidget {
  const ShimmerAddressWidget({Key? key,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.5.h),
      child: Shimmer.fromColors(
        baseColor: AppColor.defaultColor.withOpacity(0.3),
        highlightColor: AppColor.lightDefaultColor,
        child: Material(
          elevation: 3,
          borderRadius: BorderRadius.circular(12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColor.lightDefaultColor,
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
                              SvgWidget(svg: Images.activePersonSVG,width: 3.5.w,),
                            ],
                          ),
                          SizedBox(height: 1.5.h,),
                          Row(
                            children: [
                              SvgWidget(svg: Images.locationSVG,width: 5.w,),
                            ],
                          ),
                          SizedBox(height: 1.5.h,),
                          Row(
                            children: [
                              SvgWidget(svg: Images.phoneSVG,width: 5.w,),
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
    );
  }
}
