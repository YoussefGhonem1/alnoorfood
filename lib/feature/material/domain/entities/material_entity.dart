
import 'package:equatable/equatable.dart';

class MaterialEntity extends Equatable{
  int id;
  String image;
  int amount;
  String name;

  MaterialEntity({required this.id, required this.image, required this.amount, required this.name});

  @override
  // TODO: implement props
  List<Object?> get props => [id,image,amount,name];
}