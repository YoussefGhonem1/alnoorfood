import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';

class SupportRemoteDataSource{
  Future<Either<DioException,bool>> contactUs(Map<String,dynamic> data)async{
    var response = await ApiHandel.getInstance.post('contact_us', data);
    return response.fold((l) => Left(l), (r) => const Right(true));
  }
}