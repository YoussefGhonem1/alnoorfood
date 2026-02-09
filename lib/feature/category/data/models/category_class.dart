import 'package:flutter/material.dart';
import '../../../product/data/models/product_model.dart';
import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity{
  CategoryModel({required super.id, required super.name, required super.productEntity, required super.key});
  
  factory CategoryModel.fromJson(Map data){
    List<ProductModel> products = [];
    if(data.containsKey('products')){
      for(var i in data['products']){
        products.add(ProductModel.fromJson(i));
      }
    }
    return CategoryModel(id: data['id'], name: data['name'], productEntity: products,
    key: GlobalKey());
  }
}