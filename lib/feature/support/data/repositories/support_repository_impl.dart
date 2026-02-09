import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../domain/repositories/support_repository.dart';
import '../data_sources/remote.dart';

class SupportRepositoryImpl extends SupportRepository{
  @override
  Future<Either<DioException, bool>> contactUs(Map<String, dynamic> data) async{
    return await SupportRemoteDataSource().contactUs(data);
  }

}