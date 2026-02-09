import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_delivery_repository.dart';
import '../data_sources/remote_delivery.dart';

class OrderDeliveryRepositoryImpl implements OrderDeliveryRepository{

  @override
  Future<Either<DioException, List<OrderEntity>>> newOrders(int pageIndex,String? from,String? to,)async{
    return await OrderDeliveryRemoteDataSource.newOrders(pageIndex,from,to);
  }
  @override
  Future<Either<DioException, OrderEntity>> updateOrder(Map<String, dynamic> data)async{
    return await OrderDeliveryRemoteDataSource.updateOrder(data);
  }

  @override
  Future<Either<DioException, List<OrderEntity>>> currentOrders(int pageIndex,String? from,String? to,{bool withPagination = true,int? cityId}) async{
    return await OrderDeliveryRemoteDataSource.currentOrders(pageIndex,from,to,cityId: cityId,withPagination: withPagination);
  }

  @override
  Future<Either<DioException, List<OrderEntity>>> previousOrders(int pageIndex,String? from,String? to,String? payed) async{
    return await OrderDeliveryRemoteDataSource.previousOrders(pageIndex,from,to,payed);
  }

  @override
  Future<Either<DioException, bool>> canceledOrder(int id)async {
    return await OrderDeliveryRemoteDataSource.cancelOrder(id);
  }

  @override
  Future<Either<DioException, OrderEntity>> orderDetails(int id) async{
    return await OrderDeliveryRemoteDataSource.orderDetails(id);
  }

  @override
  Future<Either<DioException, bool>> deliveryOrder(int id)async {
    return await OrderDeliveryRemoteDataSource.deliveryOrder(id);
  }

  @override
  Future<Either<DioException, bool>> endedOrder(int id)async {
    return await OrderDeliveryRemoteDataSource.endedOrder(id);
  }

  @override
  Future<Either<DioException, bool>> preparingOrder(int id)async {
    return await OrderDeliveryRemoteDataSource.preparingOrder(id);
  }
  @override
  Future<Either<DioException, bool>> updateAllOrders(Map<String, dynamic> data)async {
    return await OrderDeliveryRemoteDataSource.updateAllOrders(data);
  }

  @override
  Future<Either<DioException, OrderEntity>> createOrder(Map<String, dynamic> data) async{
    return await OrderDeliveryRemoteDataSource.createOrder(data);
  }

}