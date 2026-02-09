import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';
import '../models/address_model.dart';

class AddressRemoteDataSource{


  static Future<Either<DioException,List<AddressModel>>> getAddress(int pageIndex)async{
    var response = await ApiHandel.getInstance.get('user/userAddresses?pagination_status=on&records_number=20&page=$pageIndex');
    return response.fold((l) => Left(l), (r) {
      List<AddressModel> list = [];
      for(var i in r.data['data']){
        list.add(AddressModel.fromJson(i));
      }
      return Right(list);
    });
  }
  static Future<Either<DioException,AddressModel>> addAddress(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/addAddress',data);
    return response.fold((l) => Left(l), (r) {
      return Right(AddressModel.fromJson(r.data['data']));
    });
  }
  static Future<Either<DioException,bool>> deleteAddress(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/deleteAddress',data);
    return response.fold((l) => Left(l), (r) {
      return const Right(true);
    });
  }
  static Future<Either<DioException,AddressModel>> updateAddress(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/editAddress',data);
    return response.fold((l) => Left(l), (r) {
      return Right(AddressModel.fromJson(r.data['data']));
    });
  }
}