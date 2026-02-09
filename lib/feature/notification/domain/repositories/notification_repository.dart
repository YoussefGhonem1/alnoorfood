import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository{
  Future<Either<DioException,List<NotificationEntity>>> getNotifications(int pageIndex);
  Future<Either<DioException,List<NotificationEntity>>> getDeliveryNotifications(int pageIndex);
}