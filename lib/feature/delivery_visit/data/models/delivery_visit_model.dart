
import 'package:homsfood/feature/cities/data/models/city_model.dart';
import 'package:homsfood/feature/cities/domain/entities/city_entity.dart';

import '../../domain/entities/delivery_visit_entity.dart';

class DeliveryVisitModel extends DeliveryVisitEntity{
  DeliveryVisitModel({required super.id, required super.date, required super.notes, required super.title,
    required super.message, required super.cityEntity});

  factory DeliveryVisitModel.fromJson(Map data){
    CityEntity? cityEntity;
    print(data);
    if(data.containsKey('city')&&data['city']!=null){
      cityEntity = CityModel.fromJson(data['city']);
    }
    return DeliveryVisitModel(
      id:data['id'] ,date: DateTime.parse(data['date']) , notes:data['notes'] ,
      title:data['title'] , message:data['message'] , cityEntity:cityEntity
    );
  }

}