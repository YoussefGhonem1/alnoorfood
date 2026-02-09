import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class HomeRepository{
  Future<Either<DioException,List>> getHome();
  Future<Either<DioException,List>> getHomeGuest();
}