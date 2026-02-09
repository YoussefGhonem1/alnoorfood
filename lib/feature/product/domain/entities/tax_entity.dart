
import 'package:equatable/equatable.dart';

class TaxEntity extends Equatable{
  int id;
  num tax;
  String name;
  TaxEntity({required this.id, required this.tax,required this.name});

  @override
  List<Object?> get props => [id,tax];
  Map toJson(){
    return {
      "id":id,
      "tax":tax,
      "name":name,
    };
  }

}