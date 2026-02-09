import '../../../../core/helper_function/convert.dart';
import '../../../option/data/models/option_model.dart';
import '../../../product/data/models/product_model.dart';
import '../../domain/entities/order_details_entity.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  OrderDetailsModel({required super.id, required super.count, required super.price,
    required super.isCompleted, required super.productEntity,
    required super.dateTime, required super.note, required super.isEnded});
  
  factory OrderDetailsModel.fromJson(Map data){
    // OptionModel optionModel = OptionModel(id: convertStringToInt(data['sub_category']['id']),
    //     price: convertDataToNum(data['price']),amount: convertDataToNum(data['sub_category']['amount']));
    ProductModel productModel = ProductModel.fromJson(data['product'],);
    return OrderDetailsModel(id: data['id'], count: convertStringToInt(data['amount']),
        price: convertDataToNum(data['price']),
        isCompleted: convertDataToBool(data['is_completed']),
        productEntity: productModel,isEnded: convertDataToBool(data['is_ended']),
        dateTime: data['date']==null?null:DateTime.parse(data['date']),
      note: data['notes']
    );
  }
  
}