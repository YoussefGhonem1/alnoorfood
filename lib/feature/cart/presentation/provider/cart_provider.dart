import 'dart:async';
import 'dart:ffi';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:homsfood/core/constants/constants.dart';
import 'package:homsfood/feature/auth/presentation/provider/auth_provider.dart';
import 'package:homsfood/feature/settings/domain/entities/coupon_entity.dart';
import 'package:homsfood/feature/settings/domain/entities/settings_entity.dart';
import 'package:homsfood/feature/settings/domain/use_cases/settings_usecase.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/guest_dialog.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/drop_down_class.dart';
import '../../../../injection_container.dart';
import '../../../auth/domain/entities/user_class.dart';
import '../../../auth/domain/use_cases/auth_usecases.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../settings/presentation/provider/settings_provider.dart';
import '../../domain/entities/cart_product_entity.dart';
import '../../domain/use_cases/cart_usecases.dart';

class CartProvider extends ChangeNotifier implements DropDownClass<UserClass>{
  List<CartProductEntity>? cartProducts;
  List<UserClass> users = [];
  OrderEntity? orderEntity;
  UserClass? user;
  Map input = {};
  TextEditingController couponController= TextEditingController();
  void setOrder(OrderEntity? orderEntity){
    this.orderEntity = orderEntity;
    notifyListeners();
  }
  void clear(){
    input = {"key":"name","image":Images.searchSVG,
      "value":TextEditingController(),"label":"user_search","onChange":onTextChanged,
      "onComplete":search};
    cartProducts = null;
  }

  Timer? _timer;
  void onTextChanged(String val) {
    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 1), () async{
      search();
      _timer?.cancel();
    });
  }
  void search(){
    _timer?.cancel();
    getUsers();
  }
  void rebuild(){
    notifyListeners();
  }
  num settingsPoints =0;
  num points =0;

  void refresh()async{
    clear();
    points =Provider.of<AuthenticationProvider>(Constants.globalContext(),listen: false).userEntity?.points??0;
    settingsPoints = Provider.of<SettingsProvider>(Constants.globalContext(),listen: false).settingsEntity?.pointsNumber??0;
    getCartProducts();
  }
  CouponEntity? coupon;
  void setCoupon(CouponEntity? coupon){
    if(cartProducts!=null && cartProducts!.isNotEmpty){
      coupon = coupon;
      calcTotal();
    }
  }
  List<Map> taxes = [];


  void getUsers()async{
    Map<String,dynamic> data = {};
    if(input.containsKey('value')&&input['value'].text.toString().isNotEmpty){
      data['name'] = input['value'].text;
    }
    Either<DioException,List<UserClass>> value = await AuthUseCases(sl()).getUsers(data);
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      users = r;
      if(user!=null){
        int index = users.indexWhere((element) => element.id==user!.id);
        if(index==-1){
          user = null;
        }
      }
      notifyListeners();
    });
  }
  void setTaxes(){

    taxes.clear();
    for(var i in cartProducts!){
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
    notifyListeners();
  }
  num calcProductTotal(){
    num total = 0;
    for(var i in cartProducts!){
      total += i.calcTotalPrice();
    }
    return num.parse(total.toStringAsFixed(2));
  }
  num calcTaxTotal(){
    num total = 0;
    for(var i in taxes){
      total += i['value'];
    }
    total = num.parse(total.toStringAsFixed(2))*discountValue();
    return num.parse(total.toStringAsFixed(2));
  }
  num calcDiscount(){
    if(coupon!=null){
      if(coupon!.type == "value"){
        return coupon!.value;
      }else{
        return calcProductTotal()*(((coupon!.value))/100);
      }
    }
    return 0;
  }
  num calcSubTotal(){
    // AuthenticationProvider auth= Provider.of(Constants.globalContext(),listen: false);
    num total = (calcProductTotal()-calcDiscount())*discountValue();
    return num.parse(total.toStringAsFixed(2));
  }
  num discountValue(){
    AuthenticationProvider auth= Provider.of(Constants.globalContext(),listen: false);
    return ((100-(isUser?auth.userEntity!.discount:user!.discount))/100);
  }
  num calcTotal(){
    num total = calcSubTotal()+calcTaxTotal();
    return num.parse(total.toStringAsFixed(2));
  }
  void getCartProducts()async{
    Either<String,List<CartProductEntity>> value = await CartUseCases(sl()).getCartProduct();
    value.fold((l) {
      showToast(l);
    }, (r) {
      cartProducts ??= [];
      cartProducts = r;
      notifyListeners();
    });
  }
  CartProductEntity? checkExist(int id,){
    if(cartProducts!=null){

      int index = cartProducts!.indexWhere((element) => element.id==id);
      if(index!=-1){
        return cartProducts![index];
      }
    }
    return null;
  }
  void addCartProduct(CartProductEntity cartProductEntity, {bool fromOrder = false})async{
    // if(!isGuest){
    coupon = null;
    notifyListeners();
      Either<String,CartProductEntity> value = await CartUseCases(sl()).addCartProduct(cartProductEntity);
      value.fold((l) {
        print('${l}');
      print('cart error');
        getCartProducts();
      }, (r) {

        cartProducts ??= [];
        int index = cartProducts!.indexWhere((element) =>
        element.id==cartProductEntity.id);
        if(index!=-1){
          cartProducts![index] = r;
        }else{
          cartProducts!.add(r);
        }
        notifyListeners();
        if(!fromOrder)successDialog(msg: 'cart');
      });
    // }else{
    //   showGuestDialog();
    // }
  }

  Future addCoupon(context)async{
    navPop();
    loading();
    Map<String,dynamic> data={};
    SettingsEntity? settings =Provider.of<SettingsProvider>(context,listen: false).settingsEntity;
    data['used_points'] = settings?.pointsNumber;
    data['type'] = settings?.type;
    if(settings?.type == "value") {
      data['value'] = settings?.value;
    }
    if(settings?.type == "percentage") {
      data['percentage'] = settings?.percentage;
    }

    Either<DioException,CouponEntity> value = await SettingsUseCases(sl()).addCoupon(data);
    navPop();
    value.fold((l) {
      showToast("${l.message}");
    }, (r)async {
      // successDialog(msg: LanguageProvider.translate('success', 'success'));
      couponController.text = r.code;
      CouponEntity? coupon = await CouponEntity.setCoupon(couponController.text, (calcTotal()));
      if(coupon!=null){
        setCoupon(coupon);
      }
      notifyListeners();

    });

    // try{
    //   Map apiData = await handleApi( route: 'user/add_coupon',data: {
    //     'used_points':settings?.value,
    //     'type':settings?.type,
    //     if(settings?.type == "value")
    //       'value':settings?.type,
    //     if(settings?.type == "percentage")
    //       'percentage':settings?.percentage,
    //   },);
    //   navPop(context);
    //   if(apiData['status']==1){
    //     successDialog(msg: translate(context, 'success', 'success'));
    //   }else if(apiData['status']==2){
    //     showSnackBar(apiData['message']);
    //   }
    // }catch(e){
    //   navPop(context);
    // }
  }



  void updateCartProduct(CartProductEntity cartProductEntity)async{
    coupon = null;
    notifyListeners();
    Either<String,CartProductEntity> value = await CartUseCases(sl()).updateCartProduct(cartProductEntity);
    value.fold((l) {
      print('${l}');

      print('cart error');
      getCartProducts();
    }, (r) {
      notifyListeners();
    });
  }
  void deleteCartProduct(CartProductEntity cartProductEntity)async{
    coupon = null;
    notifyListeners();
    Either<String,bool> value = await CartUseCases(sl()).deleteCartProduct(cartProductEntity);
    value.fold((l) {
      print('${l}');
      print('cart error');
      getCartProducts();
    }, (r) {
      cartProducts?.remove(cartProductEntity);
      notifyListeners();
    });
  }
  void deleteCart()async{
    coupon = null;
    notifyListeners();
    Either<String,bool> value = await CartUseCases(sl()).deleteCart();
    value.fold((l) {
      print('${l}');
      print('cart error');
      getCartProducts();
    }, (r) {
      cartProducts = null;
      notifyListeners();
    });
  }

  @override
  String displayedName() {
    return user?.name?? LanguageProvider.translate('language', 'choose_user');
  }

  @override
  String displayedOptionName(UserClass type) {
    return type.name;
  }

  @override
  List<UserClass> list() {
    return users;
  }

  @override
  Future onTap(UserClass data)async {
    user = data;
    notifyListeners();
  }

  @override
  UserClass? selected() {
    return user;
  }

  void addUser(UserClass r) {
    users.insert(0, r);
    user = r;
    notifyListeners();
  }


}