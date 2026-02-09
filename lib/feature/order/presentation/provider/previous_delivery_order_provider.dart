import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/models/pagination_class.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/order_delivery_usecases.dart';
import 'order_delivery_provider.dart';

class PreviousDeliveryOrderProvider extends ChangeNotifier implements PaginationClass{
  List<OrderEntity>? previousOrders;
  num? sell_total,purchase_total,earn_total;
  void setMoney(Map? money){
    sell_total = money?['sell_total'];
    purchase_total = money?['purchase_total'];
    earn_total = money?['earn_total'];
    notifyListeners();
  }
  void clearMoney(){
    setMoney(null);
  }
  @override
  int pageIndex = 1;
  void clear(){
    clearMoney();
    previousOrders = null;
    pageIndex = 1;
    paginationFinished = false;
    paginationStarted = false;
    notifyListeners();
  }

  Future getPreviousOrders()async{
    OrdersDeliveryProvider ordersDeliveryProvider = Provider.of(Constants.globalContext(),listen: false);
    Either<DioException,List<OrderEntity>> data = await OrderDeliveryUseCases(sl()).
    previousOrders(pageIndex,ordersDeliveryProvider.from,ordersDeliveryProvider.to,
        ((ordersDeliveryProvider.pay['value']==null)?null:
        ordersDeliveryProvider.pay['value'].toString()));
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