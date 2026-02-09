import 'package:equatable/equatable.dart';

class DeliveryEntity extends Equatable{
  int id;
  String name;
  String phone;
  String email;
  bool isAdmin;
  String token;
  bool isChat;
  DeliveryEntity(
      {required this.id, required this.name, required this.phone,
        required this.email, required this.isAdmin, required this.token,required this.isChat});

  @override
  // TODO: implement props
  List<Object?> get props => [id,name,phone,email,isAdmin,token,isChat];

}