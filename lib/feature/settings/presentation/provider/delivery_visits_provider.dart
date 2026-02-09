import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../injection_container.dart';
import '../../../delivery_visit/domain/entities/delivery_visit_entity.dart';
import '../../domain/use_cases/settings_usecase.dart';
import '../pages/delivery_visits_page.dart';

class DeliveryVisitsProvider extends ChangeNotifier {
  List<DeliveryVisitEntity> deliveryVisitsList = [];

  Future deliveryVisits()async{
    deliveryVisitsList=[];
    loading();
    Either<DioException,List<DeliveryVisitEntity>> value = await SettingsUseCases(sl()).deliveryVisits();
    navPop();
    value.fold((l) {
      showToast("${l.message}");
    }, (r){
      deliveryVisitsList.addAll(r);
      notifyListeners();
    });
  }

  void goToDeliveryVisitsPage() async {
    await deliveryVisits();
    navP(const DeliveryVisitsPage());
  }




}