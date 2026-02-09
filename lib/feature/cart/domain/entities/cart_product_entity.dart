import 'dart:convert';
import 'package:equatable/equatable.dart';
import '../../../../core/models/counter_class.dart';
import '../../../product/domain/entities/tax_entity.dart';

class CartProductEntity extends Equatable implements CounterClass {
  int id;
  // int optionId;
  String name;
  String description;
  String? brand;
  String? weight;
  @override
  num count;
  // OptionsEntity optionsEntity;
  TaxEntity taxEntity;
  num price;
  bool showPrice;
  bool isComplete;
  bool? isEnded;
  String image;
  String? note;
  DateTime? dateTime;
  int? idOrderDetails;
  CartProductEntity(
      {required this.id,
      // required this.optionId,
      required this.name,
      required this.description,
      required this.count,
      required this.showPrice,
      required this.brand,
      required this.weight,
      // required this.optionsEntity,
      required this.taxEntity,
      required this.price,
      this.isEnded,
      required this.isComplete,
      required this.note,
      required this.dateTime,
      required this.idOrderDetails,
      required this.image});

  @override
  Future add() async{
    count++;
  }

  @override
  Future remove() async{
    count--;
  }

  num calcTotalPrice(){
    return num.parse((count*price).toStringAsFixed(2));
  }
  num calcTotalTax(){
    return num.parse((count*(price*(taxEntity.tax/100))).toStringAsFixed(2));
  }

  @override
  List<Object?> get props => [id,name,count,price,image,taxEntity,showPrice,isComplete,note,dateTime,idOrderDetails,isEnded];

  Map<String,dynamic> toJson(CartProductEntity cartProductModel){
    return {
      "id":cartProductModel.id,
      "name":cartProductModel.name,
      "brand":cartProductModel.brand,
      "weight":cartProductModel.weight,
      "description":cartProductModel.description.isEmpty?" ":cartProductModel.description,
      "count":cartProductModel.count,
      // "optionsEntity":jsonEncode(cartProductModel.optionsEntity.toJson()),
      "taxEntity":jsonEncode(cartProductModel.taxEntity.toJson()),
      "price":cartProductModel.price.toDouble(),
      "image":cartProductModel.image,
      // "optionId":cartProductModel.optionId,
      "showPrice":cartProductModel.showPrice?1:0,
    };
  }

}