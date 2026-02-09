import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homsfood/feature/delivery_visit/domain/entities/delivery_visit_entity.dart';

abstract class DeliveryVisitRepository{
  Future<Either<DioException,List<DeliveryVisitEntity>>> getDeliveryVisit(int pageIndex);
  Future<Either<DioException,DeliveryVisitEntity>> addDeliveryVisit(Map<String,dynamic> data);
  Future<Either<DioException,bool>> deleteDeliveryVisit(Map<String,dynamic> data);
  Future<Either<DioException,DeliveryVisitEntity>> updateDeliveryVisit(Map<String,dynamic> data);
}