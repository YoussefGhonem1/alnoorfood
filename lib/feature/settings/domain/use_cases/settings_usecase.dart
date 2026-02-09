import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../delivery_visit/domain/entities/delivery_visit_entity.dart';
import '../entities/coupon_entity.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

class SettingsUseCases{
  SettingsRepository settingsRepository;
  SettingsUseCases(this.settingsRepository);
  Future<Either<DioException,SettingsEntity>> getSettings()async{
    return await settingsRepository.getSettings();
  }

  Future<Either<DioException,List<DeliveryVisitEntity>>> deliveryVisits()async{
    return await settingsRepository.deliveryVisits();
  }

  Future<Either<DioException,CouponEntity>> addCoupon(Map<String,dynamic> data)async{
    return await settingsRepository.addCoupon(data);
  }

  Future<Either<DioException,CouponEntity>> checkCoupon(Map<String,dynamic> data)async{
    return await settingsRepository.checkCoupon(data);
  }

}