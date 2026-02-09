import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../category/presentation/provider/category_provider.dart';
import '../../../option/domain/entities/options_entity.dart';
import '../../../option/presentation/provider/options_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/use_cases/product_usecases.dart';
import '../pages/search_page.dart';

class SearchProductProvider extends ChangeNotifier implements PaginationClass{
  List<ProductEntity>? searchProducts;
  bool fromDelivery = false;
  bool startSearch = false;
  int random = 0;
  @override
  int pageIndex = 1;
  Map input = {};
  void clear(){
    input = {"key":"name","image":Images.searchSVG,
      "value":TextEditingController(),"label":"product_search","onChange":onTextChanged,
    "onComplete":search};
    searchProducts = null;
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
    searchProducts = null;
    CategoryProvider categoryProvider = Provider.of(Constants.globalContext(),listen: false);
    // OptionsProvider optionsProvider = Provider.of(Constants.globalContext(),listen: false);
    if(fromDelivery){
      getSearchData();
    }else{
      if(text.isNotEmpty||categoryProvider.categoryEntity!=null){
        getSearchData();
      }else{
        clear();
      }
    }
  }
  Future getSearchData()async{
    if(!paginationStarted){
      startSearch = true;
      notifyListeners();
    }
    CategoryProvider categoryProvider = Provider.of(Constants.globalContext(),listen: false);
    // OptionsProvider optionsProvider = Provider.of(Constants.globalContext(),listen: false);
    Either<DioException,List<ProductEntity>> value;
    value = await ProductUseCases(sl()).getSearchProducts(input['value'].text,pageIndex,categoryProvider.categoryEntity.id,seed: random);
    if(!paginationStarted)startSearch = false;
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      if(!paginationStarted){
        searchProducts ??=[];
      }
      searchProducts?.addAll(r);
      // if(optionsProvider.optionsEntity.id!=0){
      //   for(var i in searchProducts!){
      //     OptionsEntity optionsEntity = i.optionsEntity.firstWhere((element) => element.id==optionsProvider.optionsEntity.id);
      //     i.selectedOption = optionsEntity;
      //   }
      // }
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }
  void refresh(){
    random = DateTime.now().millisecondsSinceEpoch % 100000;
    clear();
    search();
  }
  void goToSearchPage({bool fromDelivery = false}){
    this.fromDelivery = fromDelivery;
    refresh();
    if(fromDelivery){
      Provider.of<CartProvider>(Constants.globalContext(),listen: false).refresh();
    }
    navP(SearchPage());
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  void pagination(ScrollController controller) {
    controller.addListener(() async{
      if(controller.position.atEdge&&controller.position.pixels>50){
        if(!paginationFinished&&!paginationStarted){
          paginationStarted = true;
          notifyListeners();
          await getSearchData();
        }
      }
    });
  }

}