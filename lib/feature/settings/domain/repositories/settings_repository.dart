import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../delivery_visit/domain/entities/delivery_visit_entity.dart';
import '../entities/coupon_entity.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository{
  Future<Either<DioException,SettingsEntity>> getSettings();
  Future<Either<DioException,CouponEntity>> addCoupon(Map<String,dynamic> data);
  Future<Either<DioException,CouponEntity>> checkCoupon(Map<String,dynamic> data);
  Future<Either<DioException,List<DeliveryVisitEntity>>> deliveryVisits();
}