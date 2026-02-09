import 'package:equatable/equatable.dart';

import '../../../address/domain/entities/address_entity.dart';
import 'cart_product_entity.dart';

class CartEntity extends Equatable{
  AddressEntity? addressEntity;
  String phone;
  DateTime dateTime;
  String? note;
  List<CartProductEntity> products;
  CartEntity(
      {required this.addressEntity,
        required this.phone,
        required this.dateTime,
        required this.note,
        required this.products});

  @override
  // TODO: implement props
  List<Object?> get props => [addressEntity,phone,dateTime,note,products];

  num calcTotal(){
    num total = 0;
    for(var i in products){
      total += i.calcTotalPrice();
    }
    return num.parse(total.toStringAsFixed(2));
  }

  // @override
  // String body() {
  //   return addressEntity?.address??"";
  // }
  //
  // @override
  // String image() {
  //   return Images.locationSVG;
  // }
  //
  // @override
  // void Function()? onTap() {
  //   return (){
  //     Provider.of<AddressProvider>(Constants.globalContext(),listen: false).refresh();
  //     navP(AddressPage());
  //   };
  // }
  //
  // @override
  // String title() {
  //   return addressEntity?.name??LanguageProvider.translate('orders', 'location');
  // }
}