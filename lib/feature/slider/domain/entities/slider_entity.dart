
import 'package:equatable/equatable.dart';

import '../../../product/domain/entities/product_entity.dart';

class SliderEntity extends Equatable{
  int id;
  String image;
  int categoryId;
  int productId;
  ProductEntity? productEntity;
  SliderEntity({required this.id, required this.image, required this.categoryId, required this.productId,required this.productEntity});

  @override
  List<Object?> get props => [
    id,
    image,
    categoryId,
    productId,
  ];
}