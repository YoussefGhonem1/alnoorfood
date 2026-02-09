import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import 'convert.dart';

class ApiHandel{
  static ApiHandel? _instance;
  late Dio dio;
  ApiHandel._();
  String? lang;
  static ApiHandel get getInstance {
    _instance ??= ApiHandel._(); // Instantiate if null
    return _instance!;
  }
  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();
    String? language = prefs.getString('language_code');
    if(language!=null){
      lang = language;
      if(lang=='ar'){
        lang = 'en';
      }
    }
    dio = Dio(BaseOptions(
      baseUrl: Constants.domain,
      headers: {
        "lang":lang=='de'?"ge":(lang??"it"),
        'Content-Type': 'application/json'
      },
    ));
  }
  void updateHeader(String token,{String? language}){
    if(language!=null){
      lang = language;
      if(lang=='ar'){
        lang = 'en';
      }
    }
    dio.options = BaseOptions(
      baseUrl: Constants.domain,
      headers: {
        "Authorization":token,
        "lang":lang=='de'?"ge":lang,
        'Content-Type': 'application/json'
      },
    );
  }

  Future<Either<DioException,Response>> get(path,[Map<String,dynamic>? data])async{
    try{
      Response response = await dio.get(path,queryParameters: data);
      print(response.data);
      if(response.statusCode==200&&response.data['code']==200){
        return Right(response);
      }
      return Left(dioException(response));
    }on DioException catch (e){
      debugPrint('server errrrrrrrrror3 $path $data');
      debugPrint('Response data: ${e.response?.data}');
      return  Left(e.response==null?e:dioException(e.response!));
    }catch(e){
      return Left(DioException(requestOptions: RequestOptions(baseUrl: Constants.domain,path: path),
      message: 'Server Error'),);
    }
  }
  Future<Either<DioException,Response>> post(path,Map<String,dynamic> data)async{
    try{
      Response response = await dio.post(path,data: FormData.fromMap(data));
      if(response.statusCode==200&&response.data['code']==200){
        return Right(response);
      }
      return Left(dioException(response));
    }on DioException catch (e){
      debugPrint('server errrrrrrrrror3 $path $data');
      debugPrint('Response data: ${e.response?.data}');
      return  Left(e.response==null?e:dioException(e.response!));
    }catch(e){
      return Left(DioException(requestOptions: RequestOptions(baseUrl: Constants.domain,path: path),
          message: 'Server Error'),);
    }
  }
  DioException dioException(Response response){
    String msg = 'Server Error';
    if(response.data is Map){
      Map data = response.data;
      if(data['message'] is Map){
        msg = convertMapToString(data['message']);
      }else if(data['message'] is List){
        msg = data['message'].join('\n');
      }else{
        msg = data['message'];
      }
    }
    return DioException(
      requestOptions: response.requestOptions,
      message: msg,
      type: msg=='Server Error'?DioExceptionType.unknown:DioExceptionType.badResponse,
      response: response,
      error: 'Server Error',
    );
  }
}