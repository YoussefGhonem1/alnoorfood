import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/cities_repo.dart';
import '../data_sources/remote_cities_data.dart';
import '../models/city_model.dart';

class CitiesRepoImpl implements CitiesRepo {

  @override
  Future<Either<DioException, List<CityModel>>> getCities() async{
    return await RemoteCitiesDataSource.getCities();
  }
}