import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/use_cases/product_usecases.dart';
import '../pages/stock_page.dart';

class StockProductProvider extends ChangeNotifier implements PaginationClass{
  List<ProductEntity>? searchProducts;
  bool startSearch = false;
  @override
  int pageIndex = 1;
  Map input = {};
  void clear(){
    input = {"key":"text","image":Images.searchSVG,
      "value":TextEditingController(),"label":"product_search","onChange":onTextChanged,
      "onComplete":search};
    searchProducts = [];
    startSearch = false;
    paginationStarted = false;
    paginationFinished = false;
    pageIndex = 1;
    input['value'].clear();
    notifyListeners();
    _timer?.cancel();
  }
  Timer? _timer;
  void onTextChanged(String val) {
    _timer?.cancel();
    searchProducts = null;
    startSearch = true;
    _timer = Timer(const Duration(seconds: 2), () async{
      search();
      _timer?.cancel();
    });
  }
  void search(){
    paginationStarted = false;
    paginationFinished = false;
    _timer?.cancel();
    pageIndex = 1;
    String text = input['value'].text;
    if(text.isNotEmpty){
      getStockProduct();
    }else{
      refresh();
    }
  }
  Future getStockProduct()async{
    if(!paginationStarted){
      startSearch = true;
      notifyListeners();
    }
    Either<DioException,List<ProductEntity>> value = await ProductUseCases(sl()).
    getStockProducts(input['value'].text??"",pageIndex);
    if(!paginationStarted)startSearch = false;
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      if(!paginationStarted){
        searchProducts ??=[];
      }
      searchProducts?.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }

  // Future getStockProduct()async{
  //   Either<DioException,List<ProductEntity>> data = await ProductUseCases(sl()).getStockProducts(pageIndex);
  //   data.fold((l) {
  //     showToast(l.message!);
  //   }, (r) {
  //     pageIndex++;
  //     stockProducts ??= [];
  //     stockProducts!.addAll(r);
  //     if(r.isEmpty){
  //       paginationFinished = true;
  //     }
  //     notifyListeners();
  //   });
  //   paginationStarted  = false;
  //   notifyListeners();
  // }
  void updateStockProduct(ProductEntity productEntity)async{
    loading();
    Map<String,dynamic> data = {};
    data['id'] = productEntity.id;
    data['stock'] = productEntity.count;
    Either<DioException,bool> value = await ProductUseCases(sl()).updateStockProduct(data);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      successDialog(msg: 'update_quantity');
    });
  }
  void refresh(){
    clear();
    getStockProduct();
  }
  void goToStockPage(){
    refresh();
    navP(StockPage());
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;


  @override
  void pagination(ScrollController controller) {
    if(searchProducts!=null){
      controller.addListener(() async{
        if(controller.position.atEdge&&controller.position.pixels>50){
          if(!paginationFinished&&!paginationStarted){
            paginationStarted = true;
            notifyListeners();
            await getStockProduct();
          }
        }
      });
    }
  }
}