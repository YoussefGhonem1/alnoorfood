
import 'package:equatable/equatable.dart';
import 'package:homsfood/feature/cities/domain/entities/city_entity.dart';

class DeliveryVisitEntity extends Equatable{
  int id;
  DateTime date;
  String? notes;
  String? title;
  String? message;
  CityEntity? cityEntity;

  DeliveryVisitEntity({required this.id,required this.date,required this.notes,
    required this.title,required this.message,required this.cityEntity});

  @override
  // TODO: implement props
  List<Object?> get props => [id,date,notes,title,message,cityEntity];
}