import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository{
  Future<Either<DioException,OrderEntity>> createOrder(Map<String,dynamic> data);
  Future<Either<DioException,OrderEntity>> updateOrder(Map<String,dynamic> data);
  Future<Either<DioException,List<OrderEntity>>> currentOrders(int pageIndex,String? from,String? to);
  Future<Either<DioException,List<OrderEntity>>> previousOrders(int pageIndex,String? from,String? to,String? payed);
  Future<Either<DioException,OrderEntity>> orderDetails(int id);
  Future<Either<DioException,bool>> cancelOrder(int id);


}