import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../data_sources/remote.dart';

class NotificationRepositoryImpl extends NotificationRepository{
  @override
  Future<Either<DioException, List<NotificationEntity>>> getNotifications(int pageIndex)async {
    return await NotificationRemoteDataSource().getNotifications(pageIndex);
  }
  @override
  Future<Either<DioException, List<NotificationEntity>>> getDeliveryNotifications(int pageIndex)async {
    return await NotificationRemoteDataSource().getDeliveryNotifications(pageIndex);
  }

}