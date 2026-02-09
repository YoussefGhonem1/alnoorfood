import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homsfood/core/models/pagination_class.dart';
import 'package:homsfood/feature/cities/domain/entities/city_entity.dart';
import 'package:homsfood/feature/cities/presentation/provider/city_provider.dart';
import 'package:homsfood/feature/delivery_visit/domain/entities/delivery_visit_entity.dart';
import 'package:homsfood/feature/delivery_visit/domain/use_cases/delivery_visit_usecases.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/dialog/date_dialog.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/drop_down_class.dart';
import '../../../../injection_container.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../pages/add_delivery_visit_page.dart';
import '../pages/delivery_visit_page.dart';

class DeliveryVisitProvider extends ChangeNotifier implements PaginationClass,DropDownClass<CityEntity>{



  List<Map> inputs = [];

  List<DeliveryVisitEntity>? visits;
  DeliveryVisitEntity? deliveryVisitEntity;
  @override
  int pageIndex = 1;
  bool finish = false;


  void clear(){
    visits = null;
    paginationFinished = false;
    paginationStarted = false;
    pageIndex = 1;
    notifyListeners();
  }
  void refresh(){
    clear();
    getVisits();
  }
  Future getVisits()async{
    Either<DioException,List<DeliveryVisitEntity>> value = await DeliveryVisitUseCases(sl()).getDeliveryVisit(pageIndex);
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      visits ??= [];
      visits!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted  = false;
    notifyListeners();
  }

  void addVisit()async{

    Map<String,dynamic> data = {};

    for (var element in inputs) {
      data[element['key']] = element['value'].text;
    }
    data['city_id'] = cityEntity!.id;

    loading();
    Either<DioException, DeliveryVisitEntity> value = await DeliveryVisitUseCases(sl()).addDeliveryVisit(data);
    navPop();
    value.fold((l)  {
      showToast(l.message!);
    }, (r) async {
      visits??= [];
      visits!.insert(0,r);
      notifyListeners();
      successDialog(msg: 'success',then: (){
        navPop();
      });
    });
  }
  void updateVisit()async{

    Map<String,dynamic> data = {};

    for (var element in inputs) {
      data[element['key']] = element['value'].text;
    }
    data['city_id'] = cityEntity!.id;
    data['id'] = deliveryVisitEntity!.id;

    loading();
    Either<DioException, DeliveryVisitEntity> value = await DeliveryVisitUseCases(sl()).updateDeliveryVisit(data);
    navPop();
    value.fold((l)  {
      showToast(l.message!);
    }, (r) async {

      int index = visits!.indexWhere((element) => element.id==deliveryVisitEntity!.id);
      if(index!=-1){
        visits![index] = r;
      }
      notifyListeners();
      successDialog(msg: 'success',then: (){
        navPop();
      });
    });
  }
  void deleteVisit(DeliveryVisitEntity deliveryVisitEntity)async{
    Map<String,dynamic> data = {};
    data['id'] = deliveryVisitEntity.id;
    loading();
    Either<DioException, bool> value = await DeliveryVisitUseCases(sl()).deleteDeliveryVisit(data);
    navPop();
    value.fold((l)  {
      showToast(l.message!);
    }, (r) async {
      visits!.remove(deliveryVisitEntity);
      notifyListeners();
    });
  }


  void goToAddPage(DeliveryVisitEntity? deliveryVisitEntity){
    this.deliveryVisitEntity = deliveryVisitEntity;
    inputs = [
      {"key":"date","image":Images.dateSvg,"value":TextEditingController(text: deliveryVisitEntity==null?"": deliveryVisitEntity?.date.toLocal().toString().split(' ').first),
        "label":"date","readOnly":true,"onTap":()async{
        DateTime? time = await selectDate(init: DateTime(1990),currentDate: deliveryVisitEntity?.date!=null?deliveryVisitEntity!.date:null);
        if(time!=null){
          Provider.of<DeliveryVisitProvider>(Constants.globalContext(),listen: false)
              .addDate(time.toLocal().toString().split(' ').first);
        }
      }},
      {"key":"title","image":Images.noteSVG,"value":TextEditingController(text: deliveryVisitEntity?.title??""),
        "label":"subject",},
      {"key":"message","image":Images.noteSVG,"value":TextEditingController(text: deliveryVisitEntity?.message??""),
        "label":"description","max":6,},
      {"key":"notes","image":Images.noteSVG,"value":TextEditingController(text: deliveryVisitEntity?.notes??""),
        "label":"note","max":6,},
    ];
    if(deliveryVisitEntity!=null&&deliveryVisitEntity.cityEntity!=null){
      onTap(deliveryVisitEntity.cityEntity!);
    }else{
      cityEntity = null;
    }
    notifyListeners();
    navP(AddDeliveryVisitPage());
  }
  void addDate(String date){
    inputs.firstWhere((element) => element['key']=='date')['value'].text = date;
    notifyListeners();
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  void pagination(ScrollController controller) {
    if(visits!=null){
      controller.addListener(() async{
        if(controller.position.atEdge&&controller.position.pixels>50){
          if(!paginationFinished&&!paginationStarted){
            paginationStarted = true;
            notifyListeners();
            await getVisits();
          }
        }
      });
    }
  }

  void goToDeliveryVisitPage(){
    refresh();
    navP(DeliveryVisitPage());
  }

  CityEntity? cityEntity;

  @override
  String displayedName() {
    return LanguageProvider.translate('buttons', cityEntity?.name ??'choose') ;
  }

  @override
  String displayedOptionName(CityEntity type) {
    return LanguageProvider.translate('buttons', type?.name ??'choose') ;
  }

  @override
  List<CityEntity> list() {
    List<CityEntity> cityList = Provider.of<CityProvider>(Constants.globalContext(),listen: false).cityList;
    return cityList.where((item) => item.id != null).toList();
  }

  @override
  Future onTap(CityEntity data) async{
    cityEntity= data;
    notifyListeners();
  }

  @override
  CityEntity? selected() {
    return cityEntity;
  }

  void action() {
    deliveryVisitEntity==null?addVisit():updateVisit();
  }
}