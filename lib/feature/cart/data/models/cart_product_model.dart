import 'dart:convert';
import '../../../../core/helper_function/convert.dart';
import '../../../product/data/models/tax_model.dart';
import '../../domain/entities/cart_product_entity.dart';

class CartProductModel extends CartProductEntity{
  CartProductModel({required super.id, required super.name, required super.count, required super.price,
    required super.taxEntity, required super.image,
    required super.showPrice, required super.isComplete,
    required super.note, required super.dateTime, required super.idOrderDetails, required super.description, required super.brand, required super.weight,});

  factory CartProductModel.fromJson(Map data){
    // OptionModel optionModel = OptionModel.fromLocalJson(jsonDecode(data['optionsEntity']));
    TaxModel taxEntity = TaxModel.fromJson(jsonDecode(data['taxEntity']));
    return CartProductModel(id: convertStringToInt(data['id']), name: data['name'],
        count: convertStringToInt(data['count']),
        description: data['description']??"",
        isComplete: data['is_complete']??false,
        idOrderDetails: null,
        brand: data['brand'],
        weight: data['weight'],
        taxEntity: taxEntity,
        price: convertDataToNum(data['price']), image: data['image'],
        showPrice: convertDataToBool(data['showPrice']), note: data['note'],
        dateTime:data['date']==null?null:DateTime.parse(data['date']));
  }
}