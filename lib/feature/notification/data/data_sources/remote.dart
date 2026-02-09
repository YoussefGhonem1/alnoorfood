import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/helper_function/api.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource{
  
  Future<Either<DioException,List<NotificationModel>>> getNotifications(int pageIndex)async{
    var response = await ApiHandel.getInstance.get('user/notifications?pagination_status=on&records_number=20&page=$pageIndex');
    return response.fold((l) => Left(l), (r) {
      List<NotificationModel> list = [];
      for(var i in r.data['data']){
        list.add(NotificationModel.fromJson(i));
      }
      return Right(list);
    });
  }
  Future<Either<DioException,List<NotificationModel>>> getDeliveryNotifications(int pageIndex)async{
    var response = await ApiHandel.getInstance.get('delivery/notifications?pagination_status=on&records_number=20&page=$pageIndex');
    return response.fold((l) => Left(l), (r) {
      List<NotificationModel> list = [];
      for(var i in r.data['data']){
        list.add(NotificationModel.fromJson(i));
      }
      return Right(list);
    });
  }
}