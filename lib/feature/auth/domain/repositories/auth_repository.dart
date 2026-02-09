import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/delivery_entity.dart';
import '../entities/user_class.dart';

abstract class AuthRepository{
  Future<Either<DioException,Either<UserClass,DeliveryEntity>>> login(Map<String,dynamic> data);
  Future<Either<DioException,Either<UserClass,DeliveryEntity>>> checkEmail(Map<String,dynamic> data);
  Future<Either<DioException,bool>> checkCode(Map<String,dynamic> data);
  Future<Either<DioException,bool>> updatePass(Map<String,dynamic> data);
  Future<Either<DioException,bool>> checkDeliveryCode(Map<String,dynamic> data);
  Future<Either<DioException,bool>> updateDeliveryPass(Map<String,dynamic> data);
  Future<Either<DioException,bool>> logout(Map<String,dynamic> data);
  Future<Either<DioException,bool>> logoutDelivery(Map<String,dynamic> data);
  Future<Either<DioException,bool>> deleteAccount(Map<String,dynamic> data);
  Future<Either<DioException,UserClass>> updateProfile(Map<String,dynamic> data);
  Future<Either<DioException,UserClass>> register(Map<String,dynamic> data);
  Future<Either<DioException,List<UserClass>>> getUsers(Map<String,dynamic> data);
  Future<Either<DioException,DeliveryEntity>> updateDeliveryProfile(Map<String,dynamic> data);
}