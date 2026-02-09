import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';
import '../../../category/data/models/category_class.dart';
import '../../../slider/data/models/slider_model.dart';

class HomeRemoteDataSource{
  Future<Either<DioException, List>> getHome()async{
    var response = await ApiHandel.getInstance.get('user/home');
    return response.fold((l) => Left(l), (r) {
      List list = [];
      List<SliderModel> sliders = [];
      List<CategoryModel> categories = [];
      Map data = r.data['data'];
      Map slider = data['sliders'];
      // Map category = data['categories'];
      for(var s in slider['data']){
        sliders.add(SliderModel.fromJson(s));
      }
      // for(var c in category['data']){
      //   categories.add(CategoryModel.fromJson(c));
      // }
      list.add(sliders);
      list.add(categories);
      return Right(list);
    });
  }
  Future<Either<DioException, List>> getHomeGuest()async{
    var response = await ApiHandel.getInstance.get('guest/home');
    return response.fold((l) => Left(l), (r) {
      List list = [];
      List<SliderModel> sliders = [];
      // List<CategoryModel> categories = [];
      Map data = r.data['data'];
      Map slider = data['sliders'];
      // Map category = data['categories'];
      for(var s in slider['data']){
        sliders.add(SliderModel.fromJson(s));
      }
      // for(var c in category['data']){
      //   categories.add(CategoryModel.fromJson(c));
      // }
      list.add(sliders);
      list.add([]);
      return Right(list);
    });
  }
}