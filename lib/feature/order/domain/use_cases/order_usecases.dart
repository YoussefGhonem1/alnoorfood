import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class OrderUseCases{
  OrderRepository orderRepository;

  OrderUseCases(this.orderRepository);

  Future<Either<DioException,OrderEntity>> createOrder(Map<String,dynamic> data) async{
    return await orderRepository.createOrder(data);
  }
  Future<Either<DioException,OrderEntity>> updateOrder(Map<String,dynamic> data) async{
    return await orderRepository.updateOrder(data);
  }

  Future<Either<DioException,List<OrderEntity>>> currentOrders(int pageIndex,String? from,String? to,) async{
    return await orderRepository.currentOrders(pageIndex,from,to);
  }

  Future<Either<DioException,List<OrderEntity>>> previousOrders(int pageIndex,String? from,String? to,String? payed) async{
    return await orderRepository.previousOrders(pageIndex,from,to,payed);
  }

  Future<Either<DioException,OrderEntity>> orderDetails(int id) async{
    return await orderRepository.orderDetails(id);
  }
  Future<Either<DioException,bool>> cancelOrder(int id) async{
    return await orderRepository.cancelOrder(id);
  }
}