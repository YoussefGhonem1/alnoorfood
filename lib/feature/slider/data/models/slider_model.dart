import '../../../../core/helper_function/convert.dart';
import '../../../product/data/models/product_model.dart';
import '../../domain/entities/slider_entity.dart';

class SliderModel extends SliderEntity{
  SliderModel({required super.id, required super.image,
    required super.categoryId, required super.productId, required super.productEntity});
  
  factory SliderModel.fromJson(Map data){
    ProductModel? productModel;
    if(data.containsKey('product')){
      productModel = ProductModel.fromJson(data['product']);
    }
    return SliderModel(id: convertStringToInt(data['id']), image: data['image']??data['product']['image'],
        categoryId: convertStringToInt(data['product']['category_id']),
        productId: convertStringToInt(data['product']['id']),productEntity: productModel);
  }
  
}