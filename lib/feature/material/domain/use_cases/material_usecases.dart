import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/material_entity.dart';
import '../repositories/material_repository.dart';

class MaterialUseCases{
  MaterialRepository materialRepository;

  MaterialUseCases(this.materialRepository);

  Future<Either<DioException,List<MaterialEntity>>> getMaterial(int pageIndex)async{
    return await materialRepository.getMaterial(pageIndex);
  }
}