import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:homsfood/feature/delivery_visit/domain/entities/delivery_visit_entity.dart';

import '../repositories/delivery_visit_repository.dart';

class DeliveryVisitUseCases{
  final DeliveryVisitRepository addressRepository;
  DeliveryVisitUseCases(this.addressRepository);

  Future<Either<DioException, List<DeliveryVisitEntity>>> getDeliveryVisit(int pageIndex) async{
    return await addressRepository.getDeliveryVisit(pageIndex);
  }


  Future<Either<DioException, DeliveryVisitEntity>> addDeliveryVisit(Map<String,dynamic> data) async{
    return await addressRepository.addDeliveryVisit(data);
  }

  Future<Either<DioException, DeliveryVisitEntity>> updateDeliveryVisit(Map<String,dynamic> data) async{
    return await addressRepository.updateDeliveryVisit(data);
  }


  Future<Either<DioException, bool>> deleteDeliveryVisit(Map<String,dynamic> data) async{
    return await addressRepository.deleteDeliveryVisit(data);
  }
}