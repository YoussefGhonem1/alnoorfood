import '../../../../core/helper_function/convert.dart';
import '../../../address/data/models/address_model.dart';
import '../../domain/entities/pay_type_class.dart';
import '../../domain/entities/user_class.dart';

// ignore: must_be_immutable
class UserClassModel extends UserClass{

  UserClassModel(
      {required super.id,
        required super.name,
        required super.type,
        required super.userName,
        required super.email,
        required super.phone,
        required super.discount,
        required super.workTime,
        required super.payType,
        required super.points,
        required super.code,
        required super.token, required super.clientDirective,
        required super.addressEntity});

  factory UserClassModel.fromJson(Map data){
    return UserClassModel(id: convertStringToInt(data['id']),code: data['code']==null?null:convertStringToInt(data['code']),
        name: data['name'],userName: data['user_name']??"",email: data['email'],phone: data['phone'],
        discount: convertDataToNum(data['discount']),workTime: data['work_time']??"",
        clientDirective: data['client_directive'],
        points: convertDataToNum(data['points']??0), type: data['type']??"",
        payType: data['pay_type']=='bolla'?PayType.bolla:
        PayType.fattura,token: data['token']??"", addressEntity: AddressModel.fromJson(data['first_address']));
  }
}