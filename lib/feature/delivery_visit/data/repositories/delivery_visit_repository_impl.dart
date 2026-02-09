import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homsfood/feature/delivery_visit/data/models/delivery_visit_model.dart';

import '../../domain/repositories/delivery_visit_repository.dart';
import '../data_sources/remote.dart';

class DeliveryVisitRepositoryImpl extends DeliveryVisitRepository{
  @override
  Future<Either<DioException, List<DeliveryVisitModel>>> getDeliveryVisit(int pageIndex) async{
    return await DeliveryVisitRemoteDataSource.getDeliveryVisit(pageIndex);
  }

  @override
  Future<Either<DioException, DeliveryVisitModel>> addDeliveryVisit(Map<String,dynamic> data) async{
    return await DeliveryVisitRemoteDataSource.addDeliveryVisit(data);
  }
  @override
  Future<Either<DioException, DeliveryVisitModel>> updateDeliveryVisit(Map<String,dynamic> data) async{
    return await DeliveryVisitRemoteDataSource.updateDeliveryVisit(data);
  }

  @override
  Future<Either<DioException, bool>> deleteDeliveryVisit(Map<String,dynamic> data) async{
    return await DeliveryVisitRemoteDataSource.deleteDeliveryVisit(data);
  }

}