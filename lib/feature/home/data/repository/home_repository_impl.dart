import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repository/home_repositorry.dart';
import '../data_sources/remote.dart';

class HomeRepositoryImpl implements HomeRepository{
  @override
  Future<Either<DioException, List>> getHome() async{
    return await HomeRemoteDataSource().getHome();
  }

  @override
  Future<Either<DioException, List>> getHomeGuest() async{
    return await HomeRemoteDataSource().getHomeGuest();
  }

}