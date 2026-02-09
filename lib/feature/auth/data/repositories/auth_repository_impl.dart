import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/delivery_entity.dart';
import '../../domain/entities/user_class.dart';
import '../../domain/repositories/auth_repository.dart';
import '../data_sources/remote.dart';
import '../models/driver_model.dart';
import '../models/user_class_model.dart';

class AuthRepositoryImpl implements AuthRepository{

  @override
  Future<Either<DioException, Either<UserClassModel,DeliveryModel>>> login(Map<String,dynamic> data) async{
    return await AuthRemoteDataSource().login(data);

  }

  @override
  Future<Either<DioException, Either<UserClassModel,DeliveryModel>>> checkEmail(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().checkEmail(data);
  }

  @override
  Future<Either<DioException, bool>> checkCode(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().checkCode(data);
  }

  @override
  Future<Either<DioException, bool>> updatePass(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().updatePass(data);
  }

  @override
  Future<Either<DioException, bool>> checkDeliveryCode(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().checkDeliveryCode(data);
  }

  @override
  Future<Either<DioException, bool>> updateDeliveryPass(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().updateDeliveryPass(data);
  }

  @override
  Future<Either<DioException, bool>> logout(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().logout(data);
  }

  @override
  Future<Either<DioException, bool>> deleteAccount(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().deleteAccount(data);
  }

  @override
  Future<Either<DioException, UserClassModel>> updateProfile(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().updateProfile(data);
  }


  @override
  Future<Either<DioException, UserClassModel>> register(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().register(data);
  }

  @override
  Future<Either<DioException, bool>> logoutDelivery(Map<String, dynamic> data)async {
    return await AuthRemoteDataSource().logoutDelivery(data);
  }

  @override
  Future<Either<DioException, DeliveryEntity>> updateDeliveryProfile(Map<String, dynamic> data) async{
    return await AuthRemoteDataSource().updateDeliveryProfile(data);
  }

  @override
  Future<Either<DioException, List<UserClass>>> getUsers(Map<String,dynamic> data) async{
    return await AuthRemoteDataSource().getUsers(data);
  }
}