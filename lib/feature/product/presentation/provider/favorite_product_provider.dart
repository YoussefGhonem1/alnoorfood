import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/use_cases/product_usecases.dart';

class FavoriteProductProvider extends ChangeNotifier implements PaginationClass{
  List<ProductEntity>? favoriteProducts;
  @override
  int pageIndex = 1;
  void clear(){
    favoriteProducts = null;
    pageIndex = 1;
    paginationStarted = false;
    paginationFinished = false;
    notifyListeners();
  }

  Future getFavoriteProduct()async{
    Either<DioException,List<ProductEntity>> data = await ProductUseCases(sl()).getFavoriteProducts(pageIndex);
    data.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      favoriteProducts ??= [];
      favoriteProducts!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
      notifyListeners();
    });
    paginationStarted  = false;
    notifyListeners();
  }

  void refresh(){
    clear();
    getFavoriteProduct();
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  void pagination(ScrollController controller) {
    if(favoriteProducts!=null){
      controller.addListener(() async{
        if(controller.position.atEdge&&controller.position.pixels>50){
          if(!paginationFinished&&!paginationStarted){
            paginationStarted = true;
            notifyListeners();
            await getFavoriteProduct();
          }
        }
      });
    }
  }
}