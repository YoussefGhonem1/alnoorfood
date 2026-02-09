import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class NotificationUseCase{
  NotificationRepository notificationRepository;
  NotificationUseCase(this.notificationRepository);
  Future<Either<DioException,List<NotificationEntity>>> getNotifications(int pageIndex)async{
    return await notificationRepository.getNotifications(pageIndex);
  }
  Future<Either<DioException,List<NotificationEntity>>> getDeliveryNotifications(int pageIndex)async{
    return await notificationRepository.getDeliveryNotifications(pageIndex);
  }
}