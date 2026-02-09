import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';
import '../../../delivery_visit/data/models/delivery_visit_model.dart';
import '../models/coupon_model.dart';
import '../models/settings_model.dart';

class SettingsRemoteDataSource{
  Future<Either<DioException,SettingsModel>> getSettings()async{
    var response = await ApiHandel.getInstance.get('setting');
    return response.fold((l) => Left(l), (r) {
      return Right(SettingsModel.fromJson(r.data['data']));
    });
  }

  Future<Either<DioException,List<DeliveryVisitModel>>> deliveryVisits()async{
    var response = await ApiHandel.getInstance.get('user/delivery_visits');
    return response.fold((l) => Left(l), (r) {
      List<DeliveryVisitModel> list=[];
      for(var i in r.data['data']){
        list.add(DeliveryVisitModel.fromJson(i));
      }
      return Right(list);
    });
  }

  Future<Either<DioException,CouponModel>> addCoupon({required Map<String,dynamic> data})async{
    var response = await ApiHandel.getInstance.post('user/add_coupon',data);
    return response.fold((l) => Left(l), (r) {
      return  Right(CouponModel.fromJson(r.data['data']));
    });
  }

  Future<Either<DioException,CouponModel>> checkCoupon({required Map<String,dynamic> data})async{
    var response = await ApiHandel.getInstance.get('user/coupon',data);
    return response.fold((l) => Left(l), (r) {
      return  Right(CouponModel.fromJson(r.data['data']));
    });
  }
}