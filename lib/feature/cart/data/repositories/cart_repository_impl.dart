import 'package:dartz/dartz.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/cart_product_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../data_sources/local.dart';

class CartRepositoryImpl implements CartRepository{
  @override
  Future<Either<String, CartProductEntity>> addCartProduct(CartProductEntity cartProductEntity)async{
    return await CartProductLocalDataSource(sl()).addCartProducts(cartProductEntity);
  }

  @override
  Future<Either<String, bool>> deleteCartProduct(CartProductEntity cartProductEntity) async{
    return await CartProductLocalDataSource(sl()).deleteCartProducts(cartProductEntity);
  }
  @override
  Future<Either<String, bool>> deleteCart() async{
    return await CartProductLocalDataSource(sl()).deleteCart();
  }

  @override
  Future<Either<String, List<CartProductEntity>>> getCartProduct() async{
    return await CartProductLocalDataSource(sl()).getCartProducts();
  }

  @override
  Future<Either<String, CartProductEntity>> updateCartProduct(CartProductEntity cartProductEntity)async {
    return await CartProductLocalDataSource(sl()).updateCartProducts(cartProductEntity);
  }

}