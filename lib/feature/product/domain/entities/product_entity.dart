import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:homsfood/feature/auth/presentation/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/counter_class.dart';
import '../../../../core/models/drop_down_class.dart';
import '../../../../core/models/favorite_class.dart';
import '../../../auth/domain/entities/pay_type_class.dart';
import '../../../cart/domain/entities/cart_product_entity.dart';
import '../../../option/domain/entities/options_entity.dart';
import '../../presentation/provider/product_favorite_provider.dart';
import 'tax_entity.dart';

class ProductEntity extends Equatable implements  CounterClass , Favorite{
  int id;
  int categoryId;
  String name;
  String description;
  String image;
  String? brand;
  String? weight;
  bool isNew;
  bool isKilo;
  int stock;
  int minLimit;
  // num kiloPrice;
  num price;
  @override
  bool isFavorite;
  TaxEntity? tax;
  @override
  num count;
  ProductEntity(
      {required this.id,
        required this.categoryId,
        required this.name,
        required this.description,
        required this.image,
        required this.weight,
        required this.brand,
        required this.stock,
        required this.minLimit,
        this.count = 1,
        // required this.kiloPrice,
        required this.price,
        required this.isNew,
        required this.tax,
        required this.isKilo,
        required this.isFavorite,
        });

  @override
  List<Object?> get props => [id,categoryId,name,description,image,isNew,isKilo,
    isFavorite,price,tax,count,stock,minLimit];

  @override
  Future add() async{
    count++;
  }

  @override
  Future remove()async {
    count--;
  }
  bool showPrice(){
    AuthenticationProvider authenticationProvider = Provider.of(Constants.globalContext(),listen: false);
    if((!isKilo&&authenticationProvider.userEntity!=null&&authenticationProvider.userEntity!.payType!=PayType.bolla)||(!isUser&&!isGuest)){
      return true;
    }
    return false;
  }
  // num getPriceForUnit(){
  //   if(isKilo){
  //     return num.parse((p/1000).toStringAsFixed(2));
  //   }
  //   return 0;
  // }
  @override
  Future addFavorite() async{
    loading();
    Either<DioException,bool> value = await Provider.of<ProductFavoriteProvider>
      (Constants.globalContext(),listen: false).changeFavorite(id);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      isFavorite = true;
    });
  }

  @override
  Future removeFavorite() async{
    loading();
    Either<DioException,bool> value = await Provider.of<ProductFavoriteProvider>
      (Constants.globalContext(),listen: false).changeFavorite(id);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      isFavorite = false;
    });
  }

  // @override
  // String displayedName() {
  //   return ('${selectedOption?.amount} G');
  // }
  //
  // @override
  // List<OptionsEntity> list() {
  //   return optionsEntity;
  // }

  // @override
  // OptionsEntity? selected() {
  //   return selectedOption;
  // }
  //
  // @override
  // String displayedOptionName(OptionsEntity optionsEntity) {
  //   return '${optionsEntity.amount} G';
  // }

  // @override
  // Future  onTap(OptionsEntity data) async{
  //   selectedOption = data;
  // }

  CartProductEntity cartProductEntity({int? amount,
    bool isComplete = false,String? note,
  DateTime? dateTime,int? idOrderDetails,bool? isEnded,}){
    return CartProductEntity(id: id, name: name, count: amount??count,
        price: price, image: image,taxEntity: tax!,
    note: note,dateTime: dateTime,
    showPrice: showPrice(),
        isComplete: isComplete, idOrderDetails: idOrderDetails,isEnded: isEnded, description: description, brand: brand, weight: weight,
    );
  }




}