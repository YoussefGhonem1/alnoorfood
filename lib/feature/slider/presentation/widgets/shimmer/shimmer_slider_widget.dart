
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
class ShimmerSliderWidget extends StatefulWidget {
  const ShimmerSliderWidget({Key? key}) : super(key: key);

  @override
  State<ShimmerSliderWidget> createState() => _ShimmerSliderWidgetState();
}

class _ShimmerSliderWidgetState extends State<ShimmerSliderWidget> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22.h,
      width: 100.w,
  
      child: StatefulBuilder(
          builder: (context,set) {
            return CarouselSlider(
              options: CarouselOptions(
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 0.9,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  onPageChanged: (i,p){
                    index = i;
                    setState(() {

                    });
                  }
              ),
              items: List.generate(3, (i) {
                return InkWell(
                  child: AnimatedPadding(
                    duration: const Duration(milliseconds: 500),
                    padding: EdgeInsets.symmetric(horizontal: 1.w,vertical: i==index?0:2.h),
                    child: Container(
                      width: 90.w,
                      height: 15.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade200,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  onTap: ()async{
                  },
                );
              }),
            );
          }
      ),
    );
  }
}
