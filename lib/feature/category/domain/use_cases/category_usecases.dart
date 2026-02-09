import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/category_entity.dart';
import '../repository/category_repository.dart';


class CategoryUseCases{
  final CategoryRepository categoryRepository;
  CategoryUseCases(this.categoryRepository);
  Future<Either<DioException,List<CategoryEntity>>> getCategory()async{
    return await categoryRepository.getCategories();
  }
}