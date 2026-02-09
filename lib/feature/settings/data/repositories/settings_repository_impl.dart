import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../delivery_visit/data/models/delivery_visit_model.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../data_sources/remote.dart';
import '../models/coupon_model.dart';

class SettingsRepositoryImpl implements SettingsRepository{
  @override
  Future<Either<DioException, SettingsEntity>> getSettings() async{
    return await SettingsRemoteDataSource().getSettings();
  }

  @override
  Future<Either<DioException, List<DeliveryVisitModel>>> deliveryVisits() async{
    return await SettingsRemoteDataSource().deliveryVisits();
  }
  @override
  Future<Either<DioException, CouponModel>> addCoupon(Map<String, dynamic> data)async {
    return await SettingsRemoteDataSource().addCoupon(data: data);
  }
  @override
  Future<Either<DioException, CouponModel>> checkCoupon(Map<String, dynamic> data)async {
    return await SettingsRemoteDataSource().checkCoupon(data: data);
  }
}