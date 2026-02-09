import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../entities/address_entity.dart';
import '../repositories/address_repository.dart';

class AddressUseCases{
  final AddressRepository addressRepository;
  AddressUseCases(this.addressRepository);
  Future<Either<DioException,List<AddressEntity>>> getAddress(int pageIndex)async{
    return await addressRepository.getAddress(pageIndex);
  }

  Future<Either<DioException,AddressEntity>> addAddress(Map<String,dynamic> data)async{
    return await addressRepository.addAddress(data);
  }
  Future<Either<DioException,AddressEntity>> updateAddress(Map<String,dynamic> data)async{
    return await addressRepository.updateAddress(data);
  }
  Future<Either<DioException,bool>> deleteAddress(Map<String,dynamic> data)async{
    return await addressRepository.deleteAddress(data);
  }
}