import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repository/category_repository.dart';
import '../data_sources/remote.dart';
import '../models/category_class.dart';

class CategoryRepositoryImpl extends CategoryRepository{
  @override
  Future<Either<DioException, List<CategoryModel>>> getCategories() async{
    return await CategoryRemoteDataSource.getCategories();
  }
}