import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/material_entity.dart';
import '../../domain/use_cases/material_usecases.dart';
import '../pages/material_page.dart';

class MaterialProvider extends ChangeNotifier implements PaginationClass{
  List<MaterialEntity>? materials;
  @override
  int pageIndex = 1;
  void clear(){
    materials = null;
    pageIndex = 1;
    paginationStarted = false;
    paginationFinished =false;
    notifyListeners();
  }

  Future getMaterial()async{
    Either<DioException,List<MaterialEntity>> data = await MaterialUseCases(sl()).getMaterial(pageIndex);
    data.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      materials ??= [];
      materials!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }

  void refresh(){
    clear();
    getMaterial();
  }

  void goToMaterialPage(){
    refresh();
    navP(MaterialsPage());
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  void pagination(ScrollController controller) {
    if(materials!=null){
      controller.addListener(() async{
        if(controller.position.atEdge&&controller.position.pixels>50){
          if(!paginationFinished&&!paginationStarted){
            paginationStarted = true;
            notifyListeners();
            await getMaterial();
          }
        }
      });
    }
  }
}