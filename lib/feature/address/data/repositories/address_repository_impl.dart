import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../data_sources/remote.dart';

class AddressRepositoryImpl extends AddressRepository{
  @override
  Future<Either<DioException, List<AddressEntity>>> getAddress(int pageIndex) async{
    return await AddressRemoteDataSource.getAddress(pageIndex);
  }

  @override
  Future<Either<DioException, AddressEntity>> addAddress(Map<String,dynamic> data) async{
    return await AddressRemoteDataSource.addAddress(data);
  }
  @override
  Future<Either<DioException, AddressEntity>> updateAddress(Map<String,dynamic> data) async{
    return await AddressRemoteDataSource.updateAddress(data);
  }

  @override
  Future<Either<DioException, bool>> deleteAddress(Map<String,dynamic> data) async{
    return await AddressRemoteDataSource.deleteAddress(data);
  }

}