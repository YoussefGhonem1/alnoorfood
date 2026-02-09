import 'package:flutter/material.dart';
import '../../../../core/helper_function/convert.dart';
import '../../domain/entities/product_entity.dart';
import 'tax_model.dart';

class ProductModel extends ProductEntity{
  ProductModel({required super.id, required super.categoryId, required super.name,
    required super.tax, required super.description, required super.image,
    required super.isNew, required super.isKilo, required super.isFavorite,
    required super.count, required super.price, required super.weight, required super.brand, required super.stock, required super.minLimit});
  
  
  factory ProductModel.fromJson(Map data,{int? count,}){
    TaxModel? taxModel;
    if(data.containsKey("tax")){
      taxModel = TaxModel.fromJson(data['tax']);
    }


    return ProductModel(id: data['id'], categoryId: convertStringToInt(data['category_id']),
        name: data['name'], tax: taxModel, description: data['description']??" ",
        image: data['image'], isNew: convertDataToBool(data['is_new']),
        count: count??1,
        stock: convertStringToInt(data['stock']),minLimit: convertStringToInt(data['min_limit']),
        isKilo: convertDataToBool(data['is_kilo']),
        isFavorite: convertDataToBool(data['is_favourite']),
        price: convertDataToNum(data['price']), weight: data['weight'],brand: data['brand']
    );
  }
  
}