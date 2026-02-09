import 'package:dartz/dartz.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import '../../../../core/constants/constants.dart';
import '../../domain/entities/cart_product_entity.dart';
import '../../presentation/provider/cart_provider.dart';
import '../models/cart_product_model.dart';

class CartProductLocalDataSource{
  String tableName = 'cart_product';
  Database database;
  CartProductLocalDataSource(this.database);


  Future<Either<String,List<CartProductEntity>>> getCartProducts()async{
    try{

      var result = await database.query(tableName,);
      List<CartProductEntity> list = [];
      for(var i in result){
        CartProductEntity cartProductEntity = CartProductModel.fromJson(i);
        list.add(cartProductEntity);
      }
      print('dddddddddd${list}');

      return Right(list);
    }catch(e){
      return Left(e.toString());
    }
  }

  Future<Either<String,CartProductEntity>> addCartProducts(CartProductEntity cartProductEntity)async{
    try{

      CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
      CartProductEntity? checkExist = cartProvider.checkExist(cartProductEntity.id,);
      if(cartProvider.cartProducts!=null&&checkExist!=null){
        cartProductEntity.count += checkExist.count;
        return await updateCartProducts(cartProductEntity);
      }
      var result = await database.insert(tableName,cartProductEntity.toJson(cartProductEntity));
      if(result!=0){
        return Right(cartProductEntity);
      }else{
        return const Left('Server Error');
      }

    }catch(e){
      return Left(e.toString());
    }
  }

  Future<Either<String,CartProductEntity>> updateCartProducts(CartProductEntity cartProductEntity)async{
    try{
      var result = await database.update(tableName,cartProductEntity.toJson(cartProductEntity)
          ,where: "id = ?", whereArgs: [cartProductEntity.id]);
      if(result!=0){
        return Right(cartProductEntity);
      }else{
        return const Left('Server Error');
      }

    }catch(e){
      return Left(e.toString());
    }
  }
  Future<Either<String,bool>> deleteCartProducts(CartProductEntity cartProductModel)async{
    try{
      print('dddddddddd${cartProductModel}');

      var result = await database.delete(tableName,where: "id = ?", whereArgs: [cartProductModel.id]);
      if(result!=0){
        return const Right(true);
      }else{
        return const Left('Server Error');
      }

    }catch(e){
      return Left(e.toString());
    }
  }

  Future<Either<String,bool>> deleteCart()async{
    try{
      var result = await database.delete(tableName);
      if(result!=0){
        return const Right(true);
      }else{
        return const Left('Server Error');
      }

    }catch(e){
      return Left(e.toString());
    }
  }
}