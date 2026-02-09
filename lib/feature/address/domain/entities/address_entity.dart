import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable{
  int id;
  String name;
  String recipientName;
  String recipientNumber;
  String address;
  double lat;
  double lng;

  AddressEntity(
      {required this.id,
      required this.name,
      required this.recipientName,
      required this.recipientNumber,
      required this.address,
      required this.lat,
      required this.lng});



  @override
  // TODO: implement props
  List<Object?> get props => [id,name,recipientName,recipientNumber,address,lat,lng];

  bool addBorderColor(AddressEntity? addressEntity){
    return id==(addressEntity?.id??0);
  }

}