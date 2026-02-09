import 'package:dartz/dartz.dart';
import '../entities/cart_product_entity.dart';

abstract class CartRepository{
  Future<Either<String,List<CartProductEntity>>> getCartProduct();
  Future<Either<String,CartProductEntity>> addCartProduct(CartProductEntity cartProductEntity);
  Future<Either<String,CartProductEntity>> updateCartProduct(CartProductEntity cartProductEntity);
  Future<Either<String,bool>> deleteCartProduct(CartProductEntity cartProductEntity);
  Future<Either<String,bool>> deleteCart();
}