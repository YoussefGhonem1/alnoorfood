import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/use_cases/notification_usecase.dart';
import '../pages/notification_page.dart';

class NotificationProvider extends ChangeNotifier implements PaginationClass {
  List<NotificationEntity>? notifications;
  @override
  int pageIndex = 1;
  @override
  bool paginationFinished = false;
  @override
  bool paginationStarted = false;
  void clear(){
    notifications = null;
    pageIndex = 1;
    paginationFinished = false;
    paginationStarted = false;
    notifyListeners();
  }

  Future getUserNotification()async{

    Either<DioException,List<NotificationEntity>> data =
    await NotificationUseCase(sl()).getNotifications(pageIndex);
    data.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      notifications ??= [];
      notifications!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }
  Future getDeliveryNotification()async{

    Either<DioException,List<NotificationEntity>> data =
    await NotificationUseCase(sl()).getDeliveryNotifications(pageIndex);
    data.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      notifications ??= [];
      notifications!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }
  void goNotificationPage(){
    refresh();
    navP(NotificationPage());
  }
  void refresh()async{
    clear();
    if(isUser){
      getUserNotification();
    }else{
      getDeliveryNotification();
    }
  }
  @override
  void pagination(ScrollController controller){
    if(notifications!=null){
      controller.addListener(() async{
        if(controller.position.atEdge&&controller.position.pixels>50){
          if(!paginationFinished&&!paginationStarted){
            paginationStarted = true;
            notifyListeners();
            if(isUser){
              await getUserNotification();
            }else{
              await getDeliveryNotification();
            }
          }
        }
      });
    }
  }
}