import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/use_cases/product_usecases.dart';

class NewProductProvider extends ChangeNotifier implements PaginationClass{
  List<ProductEntity>? newProducts;
  int random = 0;
  @override
  int pageIndex = 1;
  void clear(){
    newProducts = null;
    pageIndex = 1;
    paginationFinished = false;
    paginationStarted = false;
    notifyListeners();
  }

  Future getNewData()async{
    Either<DioException,List<ProductEntity>> data = await ProductUseCases(sl()).getNewProducts(pageIndex,seed: random);
    data.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      newProducts ??= [];
      newProducts!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted  = false;
    notifyListeners();
  }

  void refresh(){
    random = DateTime.now().millisecondsSinceEpoch % 100000;
    clear();
    getNewData();
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  void pagination(ScrollController controller) {
    if(newProducts!=null){
      controller.addListener(() async{
        if(controller.position.atEdge&&controller.position.pixels>50){
          if(!paginationFinished&&!paginationStarted){
            paginationStarted = true;
            notifyListeners();
            await getNewData();
          }
        }
      });
    }
  }
}