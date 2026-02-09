import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../injection_container.dart';
import '../../domain/use_cases/product_usecases.dart';

class ProductFavoriteProvider extends ChangeNotifier{
  Future<Either<DioException,bool>> changeFavorite(int id)async{
    return await ProductUseCases(sl()).updateFavorite(id);
  }
}