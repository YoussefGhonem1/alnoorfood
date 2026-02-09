import '../../domain/entities/coupon_entity.dart';
class CouponModel extends CouponEntity{
  CouponModel({required super.id, required super.type,
    required super.value, required super.maxPrice, required super.percentage, required super.code});
  factory CouponModel.fromJson(Map data){
    return CouponModel(
      id:data['id'] ,value:data['value'] , percentage:data['percentage'] ,
      type:data['type'] , maxPrice:data['max_price'] , code: data['code'].toString()
    );
  }
}