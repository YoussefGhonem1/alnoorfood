import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class ProductUseCases{
  final ProductRepository productRepository;


  ProductUseCases(this.productRepository);

  Future<Either<DioException,bool>> updateFavorite(int id)async{
    return await productRepository.updateFavorite(id);
  }

  Future<Either<DioException,List<ProductEntity>>> getNewProducts(int pageIndex,{int? seed})async{
    return await productRepository.getNewProducts(pageIndex,seed: seed);
  }

  Future<Either<DioException,List<ProductEntity>>> getFavoriteProducts(int pageIndex)async{
    return await productRepository.getFavoriteProducts(pageIndex);
  }

  Future<Either<DioException,List<ProductEntity>>> getStockProducts(String text,int pageIndex)async{
    return await productRepository.getStockProducts(text,pageIndex);
  }

  Future<Either<DioException,List<ProductEntity>>> getSearchProducts(String text,int pageIndex,int? catId,{int? seed})async{
    return await productRepository.getSearchProducts(text,pageIndex,catId,seed: seed);
  }
  Future<Either<DioException,bool>> updateStockProduct(Map<String,dynamic> data)async{
    return await productRepository.updateStockProduct(data);
  }
}