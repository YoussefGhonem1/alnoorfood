import '../../../../core/helper_function/convert.dart';
import '../../domain/entities/material_entity.dart';

class MaterialModel extends MaterialEntity{
  MaterialModel({required super.id, required super.image,
    required super.amount, required super.name});
  
  factory MaterialModel.fromJson(Map data){
    return MaterialModel(id: data['id'], image: data['image'],
        amount: convertStringToInt(data['amount']), name: data['material_category']['name']);
  }
  
}