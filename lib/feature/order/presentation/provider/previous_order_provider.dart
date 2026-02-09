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

class PreviousOrderProvider extends ChangeNotifier implements PaginationClass{
  List<OrderEntity>? previousOrders;
  @override
  int pageIndex = 1;
  void clear(){
    previousOrders = null;
    pageIndex = 1;
    paginationFinished = false;
    paginationStarted = false;
    notifyListeners();
  }

  Future getPreviousOrders()async{
    OrdersProvider orderProvider = Provider.of(Constants.globalContext(),listen: false);
    Either<DioException,List<OrderEntity>> data = await OrderUseCases(sl()).previousOrders(pageIndex,
    orderProvider.from,orderProvider.to,((orderProvider.pay['value']==null)?null:
        orderProvider.pay['value'].toString()));
    data.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      previousOrders ??= [];
      previousOrders!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }

  void refresh(){
    clear();
    getPreviousOrders();
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  Future pagination(ScrollController controller) async{
    if(previousOrders!=null){
      paginationStarted = true;
      notifyListeners();
      await getPreviousOrders();
    }
  }
}