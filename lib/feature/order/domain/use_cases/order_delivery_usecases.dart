import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../entities/order_entity.dart';
import '../repositories/order_delivery_repository.dart';

class OrderDeliveryUseCases{
  OrderDeliveryRepository orderDeliveryRepository;

  OrderDeliveryUseCases(this.orderDeliveryRepository);

  Future<Either<DioException,OrderEntity>> updateOrder(Map<String,dynamic> data) async{
    return await orderDeliveryRepository.updateOrder(data);
  }

  Future<Either<DioException,List<OrderEntity>>> currentOrders(int pageIndex,String? from,String? to, {bool withPagination = true,int? cityId}) async{
    return await orderDeliveryRepository.currentOrders(pageIndex,from,to,withPagination: withPagination,cityId: cityId);
  }
  Future<Either<DioException,List<OrderEntity>>> newtOrders(int pageIndex,String? from,String? to,) async{
    return await orderDeliveryRepository.newOrders(pageIndex,from,to);
  }
  Future<Either<DioException,List<OrderEntity>>> previousOrders(int pageIndex,String? from,String? to,String? payed) async{
    return await orderDeliveryRepository.previousOrders(pageIndex,from,to,payed);
  }

  Future<Either<DioException,OrderEntity>> orderDetails(int id) async{
    return await orderDeliveryRepository.orderDetails(id);
  }
  Future<Either<DioException,OrderEntity>> createOrder(Map<String,dynamic> data) async{
    return await orderDeliveryRepository.createOrder(data);
  }
  Future<Either<DioException,bool>> updateAllOrders(Map<String,dynamic> data) async{
    return await orderDeliveryRepository.updateAllOrders(data);
  }
  Future<Either<DioException,bool>> cancelOrder(int id) async{
    return await orderDeliveryRepository.canceledOrder(id);
  }
  Future<Either<DioException,bool>> preparingOrder(int id) async{
    return await orderDeliveryRepository.preparingOrder(id);
  }
  Future<Either<DioException,bool>> deliveryOrder(int id) async{
    return await orderDeliveryRepository.deliveryOrder(id);
  }
  Future<Either<DioException,bool>> endOrder(int id) async{
    return await orderDeliveryRepository.endedOrder(id);
  }
}