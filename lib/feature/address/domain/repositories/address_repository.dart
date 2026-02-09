import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/address_entity.dart';

abstract class AddressRepository{
  Future<Either<DioException,List<AddressEntity>>> getAddress(int pageIndex);
  Future<Either<DioException,AddressEntity>> addAddress(Map<String,dynamic> data);
  Future<Either<DioException,AddressEntity>> updateAddress(Map<String,dynamic> data);
  Future<Either<DioException,bool>> deleteAddress(Map<String,dynamic> data);
}