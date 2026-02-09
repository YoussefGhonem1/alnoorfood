import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../repositories/support_repository.dart';

class SupportUseCases{
  SupportRepository supportRepository;
  SupportUseCases(this.supportRepository);
  Future<Either<DioException,bool>> contactUs(Map<String,dynamic> data)async{
    return await supportRepository.contactUs(data);
  }
}