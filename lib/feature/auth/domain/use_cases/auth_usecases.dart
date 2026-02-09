import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../entities/delivery_entity.dart';
import '../entities/user_class.dart';
import '../repositories/auth_repository.dart';

class AuthUseCases{
  final AuthRepository authRepository;
  AuthUseCases(this.authRepository);

  Future<Either<DioException, Either<UserClass,DeliveryEntity>>> login(Map<String,dynamic> data)async{
    return await authRepository.login(data);
  }

  Future<Either<DioException, Either<UserClass,DeliveryEntity>>> checkEmail(Map<String,dynamic> data)async{
    return await authRepository.checkEmail(data);
  }

  Future<Either<DioException, bool>> checkCode(Map<String,dynamic> data)async{
    return await authRepository.checkCode(data);
  }

  Future<Either<DioException, bool>> updatePass(Map<String,dynamic> data)async{
    return await authRepository.updatePass(data);
  }

  Future<Either<DioException, bool>> checkDeliveryCode(Map<String,dynamic> data)async{
    return await authRepository.checkDeliveryCode(data);
  }

  Future<Either<DioException, bool>> updateDeliveryPass(Map<String,dynamic> data)async{
    return await authRepository.updateDeliveryPass(data);
  }

  Future<Either<DioException, bool>> logout(Map<String,dynamic> data)async{
    return await authRepository.logout(data);
  }
  Future<Either<DioException, bool>> logoutDelivery(Map<String,dynamic> data)async{
    return await authRepository.logoutDelivery(data);
  }

  Future<Either<DioException, bool>> deleteAccount(Map<String,dynamic> data)async{
    return await authRepository.deleteAccount(data);
  }

  Future<Either<DioException, UserClass>> updateProfile(Map<String,dynamic> data)async{
    return await authRepository.updateProfile(data);
  }

  Future<Either<DioException, UserClass>> register(Map<String,dynamic> data)async{
    return await authRepository.register(data);
  }

  Future<Either<DioException, List<UserClass>>> getUsers(Map<String,dynamic> data)async{
    return await authRepository.getUsers(data);
  }
  Future<Either<DioException, DeliveryEntity>> updateDeliveryProfile(Map<String,dynamic> data)async{
    return await authRepository.updateDeliveryProfile(data);
  }

}