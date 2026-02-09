import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homsfood/core/constants/constants.dart';
import 'package:homsfood/feature/order/presentation/provider/previous_delivery_order_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/helper_function/api.dart';
import '../models/order_model.dart';

class OrderDeliveryRemoteDataSource{
  static Future<Either<DioException,OrderModel>> updateOrder(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/update_order', data);
    print(response);
    return response.fold((l) => Left(l), (r) {
      return Right(OrderModel.fromJson(r.data['data']));
    });
  }
  static Future<Either<DioException,List<OrderModel>>> currentOrders(int pageIndex,String? from,
      String? to, {bool withPagination = true,int? cityId})async{
    String url = 'delivery/current_orders?pagination_status=${withPagination?"on":"off"}&records_number=20&page=$pageIndex';
    if(from!=null){
      url += '&from_date=$from&to_date=$to';
    }
    if(cityId!=null){
      url += '&city_id=$cityId';
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
    String url = 'delivery/previous_orders?pagination_status=on&records_number=20&page=$pageIndex';
    if(from!=null){
      url += '&from_date=$from&to_date=$to';
    }
    if(payed!=null){
      url += '&is_paid=$payed';
    }
    var response = await ApiHandel.getInstance.get(url);
    return response.fold((l) => Left(l), (r) {
      List<OrderModel> list = [];
      if(r.data['extra']!=null){
        Provider.of<PreviousDeliveryOrderProvider>(Constants.globalContext(),listen: false).setMoney(r.data['extra']);
      }
      for(var i in r.data['data']){
        list.add(OrderModel.fromJson(i));
      }

      return Right(list);
    });
  }
  static Future<Either<DioException,List<OrderModel>>> newOrders(int pageIndex,String? from,String? to,)async{
    String url = 'delivery/new_orders?pagination_status=on&records_number=20&page=$pageIndex';
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

  static Future<Either<DioException,OrderModel>> orderDetails(int id)async{
    var response = await ApiHandel.getInstance.get('delivery/order_details?id=$id');
    return response.fold((l) => Left(l), (r) {
      return Right(OrderModel.fromJson(r.data['data']));
    });
  }
  static Future<Either<DioException,OrderModel>> createOrder(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/store_order',data);
    return response.fold((l) => Left(l), (r) {
      return Right(OrderModel.fromJson(r.data['data']));
    });
  }
  static Future<Either<DioException,bool>> cancelOrder(int id)async{
    var response = await ApiHandel.getInstance.post('delivery/change_order_status_canceled',{"id":id});
    return response.fold((l) => Left(l), (r) {
      return const Right(true);
    });
  }
  static Future<Either<DioException,bool>> preparingOrder(int id)async{
    var response = await ApiHandel.getInstance.post('delivery/change_order_status_preparing',{"id":id});
    return response.fold((l) => Left(l), (r) {
      return const Right(true);
    });
  }
  static Future<Either<DioException,bool>> deliveryOrder(int id)async{
    var response = await ApiHandel.getInstance.post('delivery/change_order_status_delivery',{"id":id});
    return response.fold((l) => Left(l), (r) {
      return const Right(true);
    });
  }
  static Future<Either<DioException,bool>> endedOrder(int id)async{
    var response = await ApiHandel.getInstance.post('delivery/change_order_status_ended',{"id":id});
    return response.fold((l) => Left(l), (r) {
      return const Right(true);
    });
  }
  static Future<Either<DioException,bool>> updateAllOrders(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/update_all_orders',data);
    return response.fold((l) => Left(l), (r) {
      return const Right(true);
    });
  }
}