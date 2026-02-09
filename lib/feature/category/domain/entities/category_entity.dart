import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../product/domain/entities/product_entity.dart';

class CategoryEntity extends Equatable{
  int id;
  String name;
  GlobalKey key;
  List<ProductEntity> productEntity;
  CategoryEntity({required this.id, required this.name
    ,required this.productEntity,required this.key});

  @override
  List<Object?> get props => [id,name,productEntity,key];
}