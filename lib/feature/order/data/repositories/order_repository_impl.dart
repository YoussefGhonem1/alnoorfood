import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../data_sources/remote.dart';

class OrderRepositoryImpl implements OrderRepository{

  @override
  Future<Either<DioException, OrderEntity>> createOrder(Map<String, dynamic> data)async{
    return await OrderRemoteDataSource.createOrder(data);
  }
  @override
  Future<Either<DioException, OrderEntity>> updateOrder(Map<String, dynamic> data)async{
    return await OrderRemoteDataSource.updateOrder(data);
  }

  @override
  Future<Either<DioException, List<OrderEntity>>> currentOrders(int pageIndex,String? from,String? to) async{
    return await OrderRemoteDataSource.currentOrders(pageIndex,from,to);
  }

  @override
  Future<Either<DioException, List<OrderEntity>>> previousOrders(int pageIndex,String? from,String? to,String? payed) async{
    return await OrderRemoteDataSource.previousOrders(pageIndex,from,to,payed);
  }

  @override
  Future<Either<DioException, bool>> cancelOrder(int id)async {
    return await OrderRemoteDataSource.cancelOrder(id);
  }

  @override
  Future<Either<DioException, OrderEntity>> orderDetails(int id) async{
    return await OrderRemoteDataSource.orderDetails(id);
  }

}