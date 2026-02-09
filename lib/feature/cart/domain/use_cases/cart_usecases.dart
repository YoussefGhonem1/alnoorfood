import 'package:dartz/dartz.dart';
import '../entities/cart_product_entity.dart';
import '../repositories/cart_repository.dart';

class CartUseCases{
  CartRepository cartRepository;
  CartUseCases(this.cartRepository);

  Future<Either<String,List<CartProductEntity>>> getCartProduct()async{
    return await cartRepository.getCartProduct();
  }
  Future<Either<String,CartProductEntity>> addCartProduct(CartProductEntity cartProductEntity)async{
    return await cartRepository.addCartProduct(cartProductEntity);
  }
  Future<Either<String,CartProductEntity>> updateCartProduct(CartProductEntity cartProductEntity)async{
    return await cartRepository.updateCartProduct(cartProductEntity);
  }
  Future<Either<String,bool>> deleteCartProduct(CartProductEntity cartProductEntity)async{
    return await cartRepository.deleteCartProduct(cartProductEntity);
  }
  Future<Either<String,bool>> deleteCart()async{
    return await cartRepository.deleteCart();
  }
}