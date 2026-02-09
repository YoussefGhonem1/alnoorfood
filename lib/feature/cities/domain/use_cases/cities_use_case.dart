import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/city_entity.dart';
import '../repositories/cities_repo.dart';

class CitiesUseCase {
  final  CitiesRepo citiesRepo;
  CitiesUseCase(this.citiesRepo);

  Future<Either<DioException, List<CityEntity>>> getCities() async {
    return await citiesRepo.getCities();
  }
}
