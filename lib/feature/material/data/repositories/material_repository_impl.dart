import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/material_entity.dart';
import '../../domain/repositories/material_repository.dart';
import '../data_sources/remote.dart';

class MaterialRepositoryImpl implements MaterialRepository{
  @override
  Future<Either<DioException, List<MaterialEntity>>> getMaterial(int pageIndex)async {
    return await MaterialRemoteDataSource.getMaterial(pageIndex);
  }
}