import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../repository/home_repositorry.dart';

class HomeUseCases{
  final HomeRepository homeRepository;
  HomeUseCases(this.homeRepository);
  Future<Either<DioException, List>> getHome() async{
    return await homeRepository.getHome();
  }
  Future<Either<DioException, List>> getHomeGuest() async{
    return await homeRepository.getHomeGuest();
  }
}