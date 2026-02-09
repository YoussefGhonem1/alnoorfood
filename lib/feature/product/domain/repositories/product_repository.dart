import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository{
  Future<Either<DioException,bool>> updateFavorite(int id);
  Future<Either<DioException,List<ProductEntity>>> getNewProducts(int pageIndex,{int? seed});
  Future<Either<DioException,List<ProductEntity>>> getFavoriteProducts(int pageIndex);
  Future<Either<DioException,List<ProductEntity>>> getSearchProducts(String text,int pageIndex,int? catId,{int? seed});
  Future<Either<DioException,List<ProductEntity>>> getStockProducts(String text,int pageIndex);
  Future<Either<DioException,bool>> updateStockProduct(Map<String,dynamic> data);
}