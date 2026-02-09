import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:homsfood/core/constants/constants.dart';
import 'package:homsfood/core/helper_function/navigation.dart';
import 'package:provider/provider.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../injection_container.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../use_cases/settings_usecase.dart';
class CouponEntity extends Equatable{
  int id;
  String type;
  String code;
  dynamic value;
  num? maxPrice;
  num? percentage;
  CouponEntity({required this.id,required this.type,required this.value,required this.maxPrice,required this.percentage,required this.code});
  @override
  List<Object?> get props => [id,type,value,maxPrice,percentage,code];

  static Future setCoupon(String code,num total)async{
    loading();
    Map<String,dynamic> data={};
    data['code']=code;
    Either<DioException,CouponEntity> value = await SettingsUseCases(sl()).checkCoupon(data);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
      cartProvider.coupon = r;
      cartProvider.rebuild();
    });
  }
}