import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/helper_function/api.dart';
import '../models/material_model.dart';

class MaterialRemoteDataSource{
  static Future<Either<DioException,List<MaterialModel>>> getMaterial(int pageIndex)async{
   var response = await  ApiHandel.getInstance.get('user/materials?pagination_status=on&records_number=20&page=$pageIndex');
   return response.fold((l) {
     return Left(l);
   }, (r) {
     List<MaterialModel> list = [];
     for(var i in r.data['data']){
       list.add(MaterialModel.fromJson(i));;
     }
     return Right(list);
   });
  }
}