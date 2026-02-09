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

class CurrentDeliveryOrderProvider extends ChangeNotifier implements PaginationClass{
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
    OrdersDeliveryProvider ordersDeliveryProvider = Provider.of(Constants.globalContext(),listen: false);
    Either<DioException,List<OrderEntity>> data = await OrderDeliveryUseCases(sl())
        .currentOrders(pageIndex,ordersDeliveryProvider.from,ordersDeliveryProvider.to);
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
    if(currentOrders!=null){
      int index = currentOrders!.indexWhere((element) => element.id==id);
      if(index!=-1){
        currentOrders!.removeWhere((element) => element.id==id);
        notifyListeners();
      }
    }
  }
  void updateOrder(OrderEntity orderEntity){
    if(currentOrders!=null){
      int index = currentOrders!.indexWhere((element) => element.id==orderEntity.id);
      if(index!=0){
        currentOrders![index] = orderEntity;
        notifyListeners();
      }
    }
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