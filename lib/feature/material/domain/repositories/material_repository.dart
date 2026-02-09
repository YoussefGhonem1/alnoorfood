import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/material_entity.dart';

abstract class MaterialRepository{
  Future<Either<DioException,List<MaterialEntity>>> getMaterial(int pageIndex);
}