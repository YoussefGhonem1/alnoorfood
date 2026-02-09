
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../entities/order_entity.dart';

abstract class OrderDeliveryRepository{

  Future<Either<DioException,List<OrderEntity>>> newOrders(int pageIndex,String? from,String? to);
  Future<Either<DioException,List<OrderEntity>>> currentOrders(int pageIndex,String? from,String? to, {bool withPagination = true,int? cityId});
  Future<Either<DioException,List<OrderEntity>>> previousOrders(int pageIndex,String? from,String? to,String? payed);
  Future<Either<DioException,OrderEntity>> orderDetails(int id);
  Future<Either<DioException,OrderEntity>> createOrder(Map<String,dynamic> data);
  Future<Either<DioException,bool>> updateAllOrders(Map<String,dynamic> data);
  Future<Either<DioException,bool>> preparingOrder(int id);
  Future<Either<DioException,bool>> deliveryOrder(int id);
  Future<Either<DioException,bool>> endedOrder(int id);
  Future<Either<DioException,bool>> canceledOrder(int id);
  Future<Either<DioException,OrderEntity>> updateOrder(Map<String,dynamic> data);

}