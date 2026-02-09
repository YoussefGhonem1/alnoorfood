import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../injection_container.dart';
import '../../../category/domain/entities/category_entity.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../../product/presentation/widgets/product_widget.dart';
import '../../../slider/domain/entities/slider_entity.dart';
import '../../domain/use_cases/home_usecases.dart';

class HomeProvider extends ChangeNotifier{
  List<CategoryEntity>? categories;
  List<SliderEntity>? sliders;
  void clearList(){
    categories = null;
    sliders = null;
    notifyListeners();
  }

  void getHomeData({bool showLoading = true,back = true})async{
    clearList();
    if(showLoading)loading();
    Either<DioException, List> data = await HomeUseCases(sl()).getHome();
    if(back)navPop();
    data.fold((l)  {

    }, (r)  {
      sliders = r[0];
      categories = r[1];
      notifyListeners();
    });
  }
  Future getHomeDataGuest({bool showLoading = true,back = true})async{
    clearList();
    if(showLoading)loading();

    Either<DioException, List> data = await HomeUseCases(sl()).getHomeGuest();

    if(back)navPop();
    data.fold((l)  {

    }, (r)  {
      sliders = r[0];
      categories = [];
      notifyListeners();
    });
  }

  void showProductSheet(ProductEntity productEntity) {
    showModalBottomSheet(
      context: Constants.globalContext(),
      backgroundColor: Colors.white,
      shape:  RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(4.w),
          topRight: Radius.circular(4.w),
        ),
      ),
      builder: (context) {
        return Container(
          height: 40.h,
          padding: EdgeInsets.symmetric(horizontal: 4.w,vertical: 1.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ProductWidget(productEntity: productEntity),
              ],
            ),
          ),
        );
      },
      isScrollControlled: true,
    );
  }

  // num calcHeight(int categoryId,int productId){
  //   num totalHeight = 0;
  //   if(categories!=null){
  //     int categoryIndex = categories!.indexWhere((element) => element.id==categoryId);
  //     if(categoryIndex!=-1){
  //       int productIndex = categories![categoryIndex].productEntity.
  //       indexWhere((element) => element.id==productId);
  //       if(productIndex!=-1){
  //         head : for(int i=0;i<categories!.length;i++){
  //           RenderBox renderBox = categories![i].key.currentContext!.findRenderObject() as RenderBox;
  //           Size size = renderBox.size;
  //           totalHeight += size.height;
  //           totalHeight += 6.w;
  //           totalHeight += 1.5.w;
  //           body : for(int p=0;p<categories![i].productEntity.length;p++){
  //             totalHeight += 3.w;
  //             if(i==categoryIndex&&p==productIndex){
  //               break head;
  //             }
  //             RenderBox renderBox = categories![i].productEntity[p].key.currentContext!.findRenderObject() as RenderBox;
  //             Size size = renderBox.size;
  //             totalHeight += size.height;
  //
  //           }
  //         }
  //       }
  //     }
  //   }
  //   return totalHeight+22.h+4.h-3.w-1.h-1.5.w;// slider height + (2*sized box height) - category padding - padding - product padding
  // }
}