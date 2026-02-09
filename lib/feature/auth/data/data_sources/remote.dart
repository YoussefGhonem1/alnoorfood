import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';
import '../../domain/entities/user_class.dart';
import '../models/driver_model.dart';
import '../models/user_class_model.dart';

class AuthRemoteDataSource{

  Future<Either<DioException,Either<UserClassModel,DeliveryModel>>> login(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('login', data);
    return response.fold((l) => Left(l), (r) {
      if(r.data['data']['type']=='user'){
        return Right(Left(UserClassModel.fromJson(r.data['data'])));
      }else{
        return Right(Right(DeliveryModel.fromJson(r.data['data'])));
      }
    });
    // return Left(response);
  }

  Future<Either<DioException,Either<UserClassModel,DeliveryModel>>> checkEmail(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/get_code', data);
    return response.fold((l) => Left(l), (r) {
      if(r.data['data']['type']=='user'){
        return Right(Left(UserClassModel.fromJson(r.data['data'])));
      }else{
        return Right(Right(DeliveryModel.fromJson(r.data['data'])));
      }
    });
    // return Left(response);
  }
  Future<Either<DioException,List<UserClass>>> getUsers(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.get('delivery/users',data);
    return response.fold((l) => Left(l), (r) {
      List<UserClass> users = [];
      for(var i in r.data['data']){
        users.add(UserClassModel.fromJson(i));
      }
      return Right(users);
    });
  }

  Future<Either<DioException,UserClassModel>> register(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/register',data);
    return response.fold((l) => Left(l), (r) {
      return Right(UserClassModel.fromJson(r.data['data']));
    });
  }
  Future<Either<DioException,bool>> checkCode(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/ConfirmCode', data);
    return response.fold((l) => Left(l), (r) =>
        const Right(true));
  }
  Future<Either<DioException,bool>> updatePass(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/UpdatePassword', data);
    return response.fold((l) => Left(l), (r) =>
    const Right(true));
  }

  Future<Either<DioException,bool>> checkDeliveryCode(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/ConfirmCode', data);
    return response.fold((l) => Left(l), (r) =>
    const Right(true));
  }
  Future<Either<DioException,bool>> updateDeliveryPass(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/UpdatePassword', data);
    return response.fold((l) => Left(l), (r) =>
    const Right(true));
  }

  Future<Either<DioException,UserClassModel>> updateProfile(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/update_profile', data);
    return response.fold((l) => Left(l), (r) =>
    Right(UserClassModel.fromJson(r.data['data'])));
  }
  Future<Either<DioException,DeliveryModel>> updateDeliveryProfile(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/update_profile', data);
    return response.fold((l) => Left(l), (r) =>
        Right(DeliveryModel.fromJson(r.data['data'])));
  }

  Future<Either<DioException,bool>> logout(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/logout', data);
    return response.fold((l) => Left(l), (r) =>
    const Right(true));
  }
  Future<Either<DioException,bool>> logoutDelivery(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/logout', data);
    return response.fold((l) => Left(l), (r) =>
    const Right(true));
  }
  Future<Either<DioException,bool>> deleteAccount(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/deleteAccount', data);
    return response.fold((l) => Left(l), (r) =>
    const Right(true));
  }
}