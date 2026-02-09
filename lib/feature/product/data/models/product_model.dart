import 'package:flutter/material.dart';
import '../../../../core/helper_function/convert.dart';
import '../../domain/entities/product_entity.dart';
import 'tax_model.dart';

class ProductModel extends ProductEntity {
  ProductModel({
    required super.id,
    required super.categoryId,
    required super.name,
    required super.tax,
    required super.description,
    required super.image,
    required super.isNew,
    required super.isKilo,
    required super.isFavorite,
    required super.count,
    required super.price,
    required super.weight,
    required super.brand,
    required super.stock,
    required super.minLimit,
  });

  factory ProductModel.fromJson(Map data, {int? count}) {
    TaxModel? taxModel;
    if (data.containsKey("tax") && data['tax'] != null) {
      taxModel = TaxModel.fromJson(data['tax']);
    }

    return ProductModel(
      id: convertStringToInt(data['id']),
      categoryId: convertStringToInt(data['category_id']),

      name: (data['name'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      image: (data['image'] ?? '').toString(),

      isNew: convertDataToBool(data['is_new']),
      isKilo: convertDataToBool(data['is_kilo']),
      isFavorite: convertDataToBool(data['is_favourite']),
      count: count ?? 1,

      stock: convertStringToInt(data['stock']),
      minLimit: convertStringToInt(data['min_limit']),
      price: convertDataToNum(data['price']),

      weight: (data['weight'] ?? '').toString(),
      brand: (data['brand'] ?? '').toString(),

      tax: taxModel,
    );
  }
}
