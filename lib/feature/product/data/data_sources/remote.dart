import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/helper_function/api.dart';
import '../../../../core/helper_function/convert.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource{
  Future<Either<DioException,bool>> updateProductFavorite(int id)async{
    var response = await ApiHandel.getInstance.get('user/changeFavourite?product_id=$id');
    return response.fold((l) => Left(l), (r) =>
        const Right(true));
  }

  Future<Either<DioException,List<ProductModel>>> getNewProduct(int pageIndex,{int? seed})async{
    var response = await ApiHandel.getInstance.get('user/new_products?pagination_status=on&records_number=20&page=$pageIndex${seed!=null?'&seed=$seed':''}');
    return response.fold((l) => Left(l), (r) {
      List<ProductModel> list = [];
      for(var i in r.data['data']){
        list.add(ProductModel.fromJson(i));
      }
      return Right(list);
    });
  }
  Future<Either<DioException,List<ProductModel>>> getFavoriteProduct(int pageIndex)async{
    var response = await ApiHandel.getInstance.get('user/userFavourite?pagination_status=on&records_number=20&page=$pageIndex');
    return response.fold((l) => Left(l), (r) {
      List<ProductModel> list = [];
      for(var i in r.data['data']){
        list.add(ProductModel.fromJson(i['product']));
      }
      return Right(list);
    });
  }

  Future<Either<DioException,List<ProductModel>>> getSearchProduct(String text,int pageIndex,int? catId,{int? seed})async{
    String url = '${(isGuest||!isUser)?"guest":"user"}/product_search?pagination_status=on&records_number=10&page=$pageIndex&name=$text${seed!=null?'&seed=$seed':''}';
    if(catId!=null&&catId!=0){
      url += '&category_id=$catId';
    }
    print(url);
    // if(optionId!=null&&optionId!=0){
    //   url += '&sub_category_id=$optionId';
    // }
    var response = await ApiHandel.getInstance.get(url);
    return response.fold((l) => Left(l), (r) {
      List<ProductModel> list = [];
      for(var i in r.data['data']){
        list.add(ProductModel.fromJson(i));
      }
      return Right(list);
    });
  }

  Future<Either<DioException,List<ProductModel>>> getStockProduct(String text,int pageIndex)async{
    var response = await ApiHandel.getInstance.get('delivery/stock_products?text=$text&pagination_status=on&records_number=20&page=$pageIndex');
    return response.fold((l) => Left(l), (r) {
      List<ProductModel> list = [];
      for(var i in r.data['data']){
        // OptionModel optionModel =OptionModel(id: convertStringToInt(i['id']),
        //     price: convertDataToNum(1), amount: convertDataToNum(i['sub_category']['amount']));
        list.add(ProductModel.fromJson(i,count: convertStringToInt(i['stock'])));
      }
      return Right(list);
    });
  }
  Future<Either<DioException,bool>> updateStockProduct(Map<String,dynamic> data)async{
    print(data);
    var response = await ApiHandel.getInstance.post('delivery/change_product_stock',data);
    return response.fold((l) => Left(l), (r) =>
    const Right(true));
  }
}