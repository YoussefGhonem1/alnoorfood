import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository{
  Future<Either<DioException,List<CategoryEntity>>> getCategories();
}