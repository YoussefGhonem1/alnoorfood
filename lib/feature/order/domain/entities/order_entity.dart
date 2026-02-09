import 'package:equatable/equatable.dart';
import '../../../address/domain/entities/address_entity.dart';
import '../../../auth/domain/entities/delivery_entity.dart';
import '../../../auth/domain/entities/user_class.dart';
import '../../../cart/domain/entities/cart_product_entity.dart';
import 'order_details_entity.dart';
import 'order_status_type_entity.dart';

class OrderEntity extends Equatable{
  int id;
  OrderStatusTypeEntity orderStatus;
  AddressEntity? addressEntity;
  AddressEntity? addressBillingEntity;
  String? note;
  String phone;
  String date;
  String payType;
  num subTotal;
  num discount;
  num total;
  bool isPaid;
  DateTime createAt;
  List<OrderDetailsEntity> orderDetails;
  UserClass userClass;
  DeliveryEntity? delivery;
  String? endTime;
  double distance = 0;
  OrderEntity(
      {required this.id,
        required this.orderStatus,
        required this.addressEntity,
        required this.note,
        required this.date,
        required this.payType,
        required this.isPaid,
        required this.subTotal,
        required this.addressBillingEntity,
        required this.userClass,
        required this.discount,
        required this.phone,
        required this.delivery,
        required this.total,
        required this.endTime,
        required this.createAt,
        required this.orderDetails});

  @override
  // TODO: implement props
  List<Object?> get props => [id,orderStatus,addressEntity,note,date,payType,subTotal,
    isPaid,
  discount,total,createAt,orderDetails,delivery,userClass,endTime,addressBillingEntity,];

  num productTotal(){
    num total = 0;
    List<CartProductEntity> items = [];
    for(var i in orderDetails){
      items.add(i.productEntity.cartProductEntity
        (amount: i.count,isComplete: i.isCompleted,
          note: i.note,dateTime: i.dateTime,idOrderDetails: i.id));
    }
    for(var i in items){
      total += i.calcTotalPrice();
    }
    total = total*discountValue();
    return num.parse(total.toStringAsFixed(2));
  }
  num discountValue(){
    return ((100-discount)/100);
  }
  List<Map> taxes(){
    List<Map> taxes = [];
    List<CartProductEntity> items = [];
    for(var i in orderDetails){
      items.add(i.productEntity.cartProductEntity
        (amount: i.count,isComplete: i.isCompleted,
          note: i.note,dateTime: i.dateTime,idOrderDetails: i.id));
    }
    for(var i in items){
      bool find = false;
      for(var t in taxes){
        if(t.containsKey('name')&&t['name']==i.taxEntity.name){
          t['value'] += i.calcTotalTax();
          find = true;
          break;
        }
      }
      if(!find){
        taxes.add({"name":i.taxEntity.name,"value":i.calcTotalTax()});
      }
    }

    return taxes;
  }

}