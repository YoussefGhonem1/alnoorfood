import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';
import '../models/city_model.dart';

class RemoteCitiesDataSource {

  static Future<Either<DioException, List<CityModel>>> getCities( ) async {
    var response =  await ApiHandel.getInstance.get('cities');
    return response.fold((l) => Left(l), (r) {
      List<CityModel> categoriesList = [];
      for (var i in r.data['data']) {
        categoriesList.add(CityModel.fromJson(i));
      }
      return Right(categoriesList);
    });
  }
}