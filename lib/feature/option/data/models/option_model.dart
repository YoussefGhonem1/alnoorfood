// import '../../../../core/helper_function/convert.dart';
// import '../../domain/entities/options_entity.dart';
//
// class OptionModel extends OptionsEntity{
//   OptionModel({required super.id, required super.price, required super.amount});
//
//   factory OptionModel.fromJson(Map data){
//     dynamic amount,id;
//     if(data.containsKey('sub_category')){
//       amount = data['sub_category']['amount'];
//     }else{
//       amount = data['amount'];
//     }
//     if(data.containsKey('sub_category_id')){
//       id = data['sub_category_id'];
//     }else{
//       id = data['id'];
//     }
//     return OptionModel(id: convertStringToInt(id), price: convertDataToNum(data['price']),
//         amount: convertDataToNum(amount));
//   }
//
//   factory OptionModel.fromLocalJson(Map data){
//     return OptionModel(id: convertStringToInt(data['id']), price: convertDataToNum(data['price']),
//         amount: convertDataToNum(data['amount']));
//   }
// }