
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class SupportRepository{
  Future<Either<DioException,bool>> contactUs(Map<String,dynamic> data);
}