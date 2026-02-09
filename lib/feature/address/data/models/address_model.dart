
import '../../../../core/helper_function/convert.dart';
import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity{
  AddressModel({required super.id, required super.name,
    required super.recipientName,
    required super.recipientNumber, required super.address,
    required super.lat, required super.lng});
  
  factory AddressModel.fromJson(Map data){
    return AddressModel(id: data['id'], name: data['name'],
        recipientName: data['recipient_name'],
        recipientNumber: data['recipient_number'], address: data['address'],
        lat: convertDataToDouble(data['latitude']), lng: convertDataToDouble(data['longitude']));
  }
}