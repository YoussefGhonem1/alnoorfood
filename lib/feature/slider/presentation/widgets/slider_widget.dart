import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../home/presentation/provider/home_provider.dart';
import '../../domain/entities/slider_entity.dart';
import 'shimmer/shimmer_slider_widget.dart';

class SliderWidget extends StatefulWidget {
  final List<SliderEntity>? sliders;
  final ScrollController scrollController;
  const SliderWidget({required this.sliders,required this.scrollController,Key? key}) : super(key: key);
  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 22.h,
      width: 100.w,
      child: Builder(
        builder: (context) {
          print("SLIDER URLS: ${widget.sliders}");
          if(widget.sliders==null){
            return const ShimmerSliderWidget();
          }
          return StatefulBuilder(
              builder: (context,set) {
                return CarouselSlider(
                  options: CarouselOptions(
                      autoPlayInterval: const Duration(seconds: 6),
                      viewportFraction: 0.9,
                      enableInfiniteScroll: true,
                      autoPlay: true,
                      onPageChanged: (i,p){
                        index = i;
                        setState(() {
                 
                        });
                      }
                  ),
                  items: List.generate(widget.sliders!.length, (i) {
                    SliderEntity sliderEntity = widget.sliders![i];
                    return InkWell(
                      child: AnimatedPadding(
                        duration: const Duration(milliseconds: 500),
                        padding: EdgeInsets.symmetric(horizontal: 1.w,vertical: i==index?0:2.h),
                        child: Container(
                          width: 90.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.transparent,
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(sliderEntity.image),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      onTap: ()async{
                        if(sliderEntity.productEntity!=null){
                          Provider.of<HomeProvider>(context,listen: false).showProductSheet(sliderEntity.productEntity!);
                        }
                        // HomeProvider homeProvider = Provider.of(context,listen: false);
                        // widget.scrollController.animateTo(homeProvider.calcHeight(
                        //     sliderEntity.categoryId,sliderEntity.productId
                        // ).toDouble(),
                        //     duration: Duration(milliseconds: 500), curve: Curves.easeIn);
                      },
                    );
                  }),
                );
              }
          );
        }
      ),
    );
  }
}
