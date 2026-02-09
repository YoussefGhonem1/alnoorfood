import 'package:equatable/equatable.dart';

import '../../../product/domain/entities/product_entity.dart';

class OrderDetailsEntity extends Equatable{
  int id;
  int count;
  num price;
  bool isCompleted;
  ProductEntity productEntity;
  String? note;
  DateTime? dateTime;
  bool isEnded;
  OrderDetailsEntity(
      {required this.id, required this.count, required this.price,
        required this.isCompleted, required this.productEntity,
      required this.dateTime,required this.note,required this.isEnded});

  @override
  // TODO: implement props
  List<Object?> get props => [id,count,price,isCompleted,productEntity,
  dateTime,note,isEnded];
}