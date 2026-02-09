import 'package:homsfood/core/helper_function/convert.dart';

import '../../domain/entities/settings_entity.dart';

class SettingsModel extends SettingsEntity{
  SettingsModel({required super.terms, required super.privacy, required super.about,
    required super.points, required super.value, required super.percentage, required super.pointsNumber, required super.type, required super.isOpen, required super.is_automatic_coupon});
  
  factory SettingsModel.fromJson(Map data){
    return SettingsModel(terms: data['terms_link'],
        points: convertDataToNum(data['points']) ,
        value:data['value'] ,
        is_automatic_coupon: convertDataToBool(data['is_automatic_coupon']),
        percentage:data['percentage'] ,
        pointsNumber:data['points_number'] ,
        type:data['type'] ,
        isOpen: convertDataToBool(data['is_open']),
        privacy: data['privacy_link'], about: data['about_link']);
  }
}