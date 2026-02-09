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

class NewOrderProvider extends ChangeNotifier implements PaginationClass{
  List<OrderEntity>? newOrders;
  @override
  int pageIndex = 1;
  void clear(){
    newOrders = null;
    pageIndex = 1;
    paginationFinished = false;
    paginationStarted = false;
    notifyListeners();
  }

  Future getNewOrders()async{
    OrdersDeliveryProvider ordersDeliveryProvider = Provider.of(Constants.globalContext(),listen: false);
    Either<DioException,List<OrderEntity>> data = await OrderDeliveryUseCases(sl()).
    newtOrders(pageIndex,ordersDeliveryProvider.from,ordersDeliveryProvider.to);
    data.fold((l) {
      showToast(l.message!);
    }, (r) {
      pageIndex++;
      newOrders ??= [];
      newOrders!.addAll(r);
      if(r.isEmpty){
        paginationFinished = true;
      }
    });
    paginationStarted = false;
    notifyListeners();
  }
  void deleteOrder(int id){
    if(newOrders!=null){
      int index = newOrders!.indexWhere((element) => element.id==id);
      if(index!=-1){
        newOrders!.removeWhere((element) => element.id==id);
        notifyListeners();
      }
    }
  }
  void refresh(){
    clear();
    getNewOrders();
  }

  @override
  bool paginationFinished = false;

  @override
  bool paginationStarted = false;

  @override
  Future pagination(ScrollController controller) async{
    if(newOrders!=null){
      paginationStarted = true;
      notifyListeners();
      await getNewOrders();
    }
  }
}