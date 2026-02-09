import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/helper_function/api.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource{
  static Future<Either<DioException,OrderModel>> createOrder(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/store_order', data);
    return response.fold((l) => Left(l), (r) {
      return Right(OrderModel.fromJson(r.data['data']));
    });
  }
  static Future<Either<DioException,OrderModel>> updateOrder(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('user/update_order', data);
    return response.fold((l) => Left(l), (r) {
      return Right(OrderModel.fromJson(r.data['data']));
    });
  }
  static Future<Either<DioException,List<OrderModel>>> currentOrders(int pageIndex,String? from,String? to)async{
    String url = 'user/current_orders?pagination_status=on&records_number=20&page=$pageIndex';
    if(from!=null){
      url += '&from_date=$from&to_date=$to';
    }
    var response = await ApiHandel.getInstance.get(url);
    return response.fold((l) => Left(l), (r) {
      List<OrderModel> list = [];
      for(var i in r.data['data']){
        list.add(OrderModel.fromJson(i));
      }
      return Right(list);
    });
  }
  static Future<Either<DioException,List<OrderModel>>> previousOrders(int pageIndex,String? from,String? to,String? payed)async{
    String url = 'user/previous_orders?pagination_status=on&records_number=20&page=$pageIndex';
    if(from!=null){
      url += '&from_date=$from&to_date=$to';
    }
    if(payed!=null){
      url += '&is_paid=$payed';
    }
    var response = await ApiHandel.getInstance.get(url);
    return response.fold((l) => Left(l), (r) {
      List<OrderModel> list = [];
      for(var i in r.data['data']){
        list.add(OrderModel.fromJson(i));
      }
      return Right(list);
    });
  }

  static Future<Either<DioException,OrderModel>> orderDetails(int id)async{
    var response = await ApiHandel.getInstance.get('user/order_details?id=$id');
    return response.fold((l) => Left(l), (r) {
      return Right(OrderModel.fromJson(r.data['data']));
    });
  }
  static Future<Either<DioException,bool>> cancelOrder(int id)async{
    var response = await ApiHandel.getInstance.post('user/cancel_order',{"id":id});
    return response.fold((l) => Left(l), (r) {
      return const Right(true);
    });
  }
}