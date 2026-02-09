import '../../../../core/helper_function/convert.dart';
import '../../../address/data/models/address_model.dart';
import '../../../auth/data/models/driver_model.dart';
import '../../../auth/data/models/user_class_model.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status_type_entity.dart';
import 'order_details_model.dart';

class OrderModel extends OrderEntity{
  OrderModel({required super.id, required super.orderStatus,
    required super.addressEntity, required super.note,
    required super.date, required super.payType,
    required super.subTotal, required super.discount,
    required super.total, required super.createAt,
    required super.orderDetails, required super.phone, required super.delivery,
    required super.userClass, required super.endTime, required super.addressBillingEntity,
    required super.isPaid,
    });

  factory OrderModel.fromJson(Map data){
    // String payType = LanguageProvider.translate("orders", );
    String payType = data['pay_type'];
    List<OrderDetailsModel> orderDetails = [];
    if(data.containsKey('order_details')){
      for(var i in data['order_details']){
        orderDetails.add(OrderDetailsModel.fromJson(i));
      }
    }
    DeliveryModel? delivery;
    if(data['delivery']!=null){
      delivery = DeliveryModel.fromJson(data['delivery']);
    }
    AddressModel addressModel = AddressModel.fromJson(data['address']);
    AddressModel? addressBillingModel;
    if(data['address2']!=null){
      addressBillingModel = AddressModel.fromJson(data['address2']);
    }
    UserClassModel userClassModel = UserClassModel.fromJson(data['user']);
    return OrderModel(id: data['id'], orderStatus: orderStatusMap[data['status']]!,
        addressEntity: addressModel,phone: data['phone'],
        userClass: userClassModel,endTime: data['end_time'],
        addressBillingEntity: addressBillingModel,
        isPaid: convertDataToBool(data['is_paid']),
        // temperature: data['temperature']==null?"":data['temperature'].toString(),
        note: data['notes'], date: data['date'],delivery: delivery,
        payType: payType, subTotal: convertDataToNum(data['subtotal']),
        discount: convertDataToNum(data['discount']), total: convertDataToNum(data['total']),
        createAt: DateTime.parse(data['created_at']), orderDetails: orderDetails);
  }
}
Map<String,OrderStatusTypeEntity> orderStatusMap = {
  "new":OrderStatusTypeEntity.newOrder,
  "preparing":OrderStatusTypeEntity.preparing,
  "delivery":OrderStatusTypeEntity.delivery,
  "ended":OrderStatusTypeEntity.ended,
  "canceled":OrderStatusTypeEntity.canceled,
};