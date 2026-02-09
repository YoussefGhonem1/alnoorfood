import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';
import '../models/category_class.dart';

class CategoryRemoteDataSource{


  static Future<Either<DioException,List<CategoryModel>>> getCategories()async{
    var response = await ApiHandel.getInstance.get('categories');
    return response.fold((l) => Left(l), (r) {
      List<CategoryModel> list = [];
      for(var i in r.data['data']){
        list.add(CategoryModel.fromJson(i));
      }
      return Right(list);
    });
  }

}