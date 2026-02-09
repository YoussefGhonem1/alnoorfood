import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../core/models/drop_down_class.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/use_cases/cities_use_case.dart';


class CityProvider extends ChangeNotifier  implements  DropDownClass,PaginationClass{

  List<CityEntity>cityList=[] ;
  CityEntity?cityEntity;
  bool isLoading=false;
  Future getCities() async {
    Either<DioException, List<CityEntity>> response = await CitiesUseCase(sl()).getCities();
    response.fold((l) {
    }, (r) {
      cityList =[];
      cityList.addAll(r);
      notifyListeners();
    });
  }

  void changeCity({ required CityEntity cityEntity})async{
    this.cityEntity =cityEntity;
    notifyListeners();
  }

  Color isSelectedCatColor({required int id}){
    if(cityEntity!.id == id){
      return Colors.white;
    }else{
      return Colors.transparent;
    }
  }
  CityEntity?cityFilterEntity;

  void selectCityFilter({required CityEntity cityFilterEntity}){
    this.cityFilterEntity = cityFilterEntity;
    notifyListeners();
  }

  @override
  String displayedName() {
    return LanguageProvider.translate('buttons', cityEntity?.name ??'choose') ;
  }

  @override
  String displayedOptionName(type) {
  return LanguageProvider.translate('buttons', type?.name ??'choose') ;

  }


  @override
  CityEntity? selected() {
    return cityEntity;
  }

  @override
  List list() {
    return cityList.where((item) => item.id != null).toList();
  }

  @override
  Future onTap(data) async{
    cityEntity= data;
    notifyListeners();
  }

  void clear(){
    cityList = [];
    paginationStarted = false;
    paginationFinished = false;
    pageIndex = 1;
    notifyListeners();
  }

  void refresh(){
    clear();
    notifyListeners();
    getCities();
  }
  void rebuild(){
    notifyListeners();
  }


  @override
  int pageIndex = 1;

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  void pagination(ScrollController controller) {
    // controller.addListener(() async{
    //   if(controller.position.atEdge&&controller.position.pixels>50){
    //     if(!paginationFinished&&!paginationStarted&&cityList!=null&&cityList!.isNotEmpty){
    //       paginationStarted = true;
    //       notifyListeners();
    //       await getCities();
    //     }
    //   }
    // });
  }
}
