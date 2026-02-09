import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/order_usecases.dart';
import 'order_provider.dart';

class CurrentOrderProvider extends ChangeNotifier implements PaginationClass{
  List<OrderEntity>? currentOrders;

  @override
  int pageIndex = 1;
  void clear(){
    currentOrders = null;
    paginationStarted = false;
    paginationFinished = false;
    pageIndex = 1;
    notifyListeners();
  }

  Future getCurrentOrders()async{
    OrdersProvider orderProvider = Provider.of(Constants.globalContext(),listen: false);
    Either<DioException,List<OrderEntity>> data = await OrderUseCases(sl()).currentOrders(pageIndex,
        orderProvider.from,orderProvider.to);
    data.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      currentOrders ??= [];
      currentOrders!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }
  void deleteOrder(int id){
    currentOrders!.removeWhere((element) => element.id==id);
    notifyListeners();
  }
  void refresh(){
    clear();
    getCurrentOrders();
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  Future pagination(ScrollController controller) async{
    if(currentOrders!=null){
      paginationStarted = true;
      notifyListeners();
      await getCurrentOrders();
    }
  }
}