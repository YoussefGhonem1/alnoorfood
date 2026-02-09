import '../../../../core/helper_function/convert.dart';
import '../../domain/entities/tax_entity.dart';

class TaxModel extends TaxEntity{
  TaxModel({required super.id, required super.tax, required super.name});
  factory TaxModel.fromJson(Map data){
    return TaxModel(id: data['id'], tax: convertDataToNum(data['tax']),
    name: data['name']);
  }
}