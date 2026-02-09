import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/repositories/product_repository.dart';
import '../data_sources/remote.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository{
  @override
  Future<Either<DioException, bool>> updateFavorite(int id)async {
    return await ProductRemoteDataSource().updateProductFavorite(id);
  }

  @override
  Future<Either<DioException, List<ProductModel>>> getNewProducts(int pageIndex,{int? seed}) async{
    return await ProductRemoteDataSource().getNewProduct(pageIndex,seed: seed);
  }

  @override
  Future<Either<DioException, List<ProductModel>>> getFavoriteProducts(int pageIndex) async{
    return await ProductRemoteDataSource().getFavoriteProduct(pageIndex);
  }
  @override
  Future<Either<DioException, List<ProductModel>>> getSearchProducts(String text,int pageIndex,int? catId,{int? seed}) async{
    return await ProductRemoteDataSource().getSearchProduct(text,pageIndex,catId,seed: seed);
  }
  @override
  Future<Either<DioException, List<ProductModel>>> getStockProducts(String text,int pageIndex) async{
    return await ProductRemoteDataSource().getStockProduct(text,pageIndex);
  }

  @override
  Future<Either<DioException, bool>> updateStockProduct(Map<String, dynamic> data)async {
    return await ProductRemoteDataSource().updateStockProduct(data);
  }

}