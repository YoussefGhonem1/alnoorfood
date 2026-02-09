import '../../../../core/helper_function/convert.dart';
import '../../domain/entities/delivery_entity.dart';

class DeliveryModel extends DeliveryEntity{
  DeliveryModel({required super.id, required super.name,
    required super.phone, required super.email,
    required super.isAdmin, required super.token, required super.isChat});

  factory DeliveryModel.fromJson(Map data){
    return DeliveryModel(id: data['id'], name: data['name'],
        phone: data['phone'], email: data['email'],
        isChat: convertDataToBool(data['is_chat']),
        isAdmin: convertDataToBool(data['is_admin']), token: data['token']??"");
  }

}