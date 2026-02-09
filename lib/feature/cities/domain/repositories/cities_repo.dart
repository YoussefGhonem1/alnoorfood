import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/city_entity.dart';

abstract class CitiesRepo {
  Future<Either<DioException, List<CityEntity>>> getCities();
}
