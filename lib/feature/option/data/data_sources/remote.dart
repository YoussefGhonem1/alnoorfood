// import 'package:dartz/dartz.dart';
// import 'package:dio/dio.dart';
// import '../../../../core/helper_function/api.dart';
// import '../models/option_model.dart';
//
// class OptionRemoteDataSource{
//
//
//   static Future<Either<DioException,List<OptionModel>>> getOptions()async{
//     var response = await ApiHandel.getInstance.get('sub_categories');
//     return response.fold((l) => Left(l), (r) {
//       List<OptionModel> list = [];
//       for(var i in r.data['data']){
//         list.add(OptionModel.fromJson(i));
//       }
//       return Right(list);
//     });
//   }
//
// }