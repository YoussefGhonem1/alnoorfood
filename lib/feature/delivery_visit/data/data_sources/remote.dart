import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';
import '../models/delivery_visit_model.dart';

class DeliveryVisitRemoteDataSource{


  static Future<Either<DioException,List<DeliveryVisitModel>>> getDeliveryVisit(int pageIndex)async{
    var response = await ApiHandel.getInstance.get('delivery/get_visits?pagination_status=on&records_number=20&page=$pageIndex');
    return response.fold((l) => Left(l), (r) {
      List<DeliveryVisitModel> list = [];
      for(var i in r.data['data']){
        list.add(DeliveryVisitModel.fromJson(i));
      }
      return Right(list);
    });
  }
  static Future<Either<DioException,DeliveryVisitModel>> addDeliveryVisit(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/create_visit',data);
    return response.fold((l) => Left(l), (r) {
      return Right(DeliveryVisitModel.fromJson(r.data['data']));
    });
  }
  static Future<Either<DioException,bool>> deleteDeliveryVisit(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/delete_visit',data);
    return response.fold((l) => Left(l), (r) {
      return const Right(true);
    });
  }
  static Future<Either<DioException,DeliveryVisitModel>> updateDeliveryVisit(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('delivery/update_visit',data);
    return response.fold((l) => Left(l), (r) {
      return Right(DeliveryVisitModel.fromJson(r.data['data']));
    });
  }
}