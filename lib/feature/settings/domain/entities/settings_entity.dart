import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable{
  String terms;
  String privacy;
  String about;
  num value;
  num percentage;
  num points;
  num pointsNumber;
  String type;
  bool isOpen;
  bool is_automatic_coupon;

  SettingsEntity({required this.terms, required this.points,required this.value,required this.percentage,required this.privacy,
    required this.pointsNumber, required this.type,required this.about,required this.isOpen,required this.is_automatic_coupon});

  @override
  List<Object?> get props => [terms,privacy,about,privacy,isOpen];
}