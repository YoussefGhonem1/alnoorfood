import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/date_dialog.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/selected_class.dart';
import '../../../../injection_container.dart';
import '../../../address/domain/entities/address_entity.dart';
import '../../../auth/domain/entities/pay_type_class.dart';
import '../../../auth/domain/entities/user_class.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../main/main_provider.dart';
import '../../../order/domain/entities/order_entity.dart';
import '../../../order/domain/use_cases/order_delivery_usecases.dart';
import '../../../order/domain/use_cases/order_usecases.dart';
import '../../../order/presentation/provider/order_delivery_provider.dart';
import '../../../order/presentation/provider/order_provider.dart';
import '../pages/check_out_page.dart';
import '../widgets/check_out_widget.dart';
import 'cart_provider.dart';

class CheckOutProvider extends ChangeNotifier{
  List<Map> inputs = [];
  bool ended = false,isPaid = true;

  SelectedClass selectedAddress(){
   return SelectedClass(image: Images.locationSVG,
       title: addressEntity?.name??LanguageProvider.translate('orders', 'location'),
       onTap: (){

       }, body: addressEntity?.address??"");
  }
  // SelectedClass selectedBillingAddress(){
  //   return SelectedClass(image: Images.locationSVG,
  //       title: addressBillingEntity?.name??LanguageProvider.translate('orders', 'billing_location'),
  //       onTap: (){
  //         var address = Provider.of<AddressProvider>(Constants.globalContext(),listen: false);
  //         if(address.address==null){
  //           address.refresh();
  //         }
  //         address.selectAddress(addressBillingEntity);
  //         navP(const AddressPage(),then: (val){
  //           addressBillingEntity = address.selectedAddress;
  //           notifyListeners();
  //         });
  //       }, body: addressBillingEntity?.address??"");
  // }
  AddressEntity? addressEntity;
  // AddressEntity? addressBillingEntity;
  void setAllData(){
    CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
    if(cartProvider.orderEntity!=null){
      inputs.firstWhere((element) => element['key']=='date')['value'].text
      = cartProvider.orderEntity!.date;
      inputs.firstWhere((element) => element['key']=='phone')['value'].text
      = cartProvider.orderEntity!.phone;
      inputs.firstWhere((element) => element['key']=='notes')['value'].text
      = cartProvider.orderEntity!.note??"";
      // inputs.firstWhere((element) => element['key']=='client_directive')['value'].text
      // = cartProvider.orderEntity!.clientDirective??"";
      addressEntity = cartProvider.orderEntity!.addressEntity;
      // addressBillingEntity = cartProvider.orderEntity!.addressBillingEntity;
    }
  }
  void changeEnded(){
    ended = !ended;
    if(ended){
      inputs.insertAll(2,[createdOrderMap(), endedOrderMap(),]);
    }else{
      inputs.removeWhere((element) => element['key']=='end_date');
      inputs.removeWhere((element) => element['key']=='created_at');
    }
    notifyListeners();
  }
  //
  Map endedOrderMap(){
    return {"key":"end_date","image":Images.dateSvg,"value":TextEditingController(),
      "label":"ended","readOnly":true,"onTap":()async{
        DateTime? time = await selectDate(init: !isUser&&deliveryEntity!.isAdmin?DateTime(1990):null);
        if(time!=null){
          Provider.of<CheckOutProvider>(Constants.globalContext(),listen: false)
              .addEndDate(time.toLocal().toString().split(' ').first);
        }
      }};
  }
  Map createdOrderMap(){
    return {"key":"created_at","image":Images.dateSvg,"value":TextEditingController(),
      "label":"created_at","readOnly":true,"onTap":()async{
        DateTime? time = await selectDate(init: !isUser&&deliveryEntity!.isAdmin?DateTime(1990):null);
        if(time!=null){
          addCreatedDate('${time.toLocal().toString().split(' ').first} 00:00:00');
        }
      }};
  }
  // Map endedOrderTime(){
  //   return {"key":"end_time","image":Images.dateSvg,"value":TextEditingController(),
  //     "label":"end_time","readOnly":true,"onTap":()async{
  //       String? time = await selectTime();
  //       if(time!=null){
  //         Provider.of<CheckOutProvider>(Constants.globalContext(),listen: false)
  //             .addEndTime(time);
  //       }
  //     }};
  // }

  void changePaid(){
    isPaid = !isPaid;
    notifyListeners();
  }
  AuthenticationProvider authenticationProvider = Provider.of(Constants.globalContext(),listen: false);

  void clear({OrderEntity? orderEntity}){
    CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
    ended = false;
    UserClass user = isUser?authenticationProvider.userEntity!:cartProvider.user!;
    inputs = [
      if(user.payType==PayType.fattura)
        {"key":"client_directive","image":Images.activePersonSVG,"readOnly":true,
          "value":TextEditingController(text: user.clientDirective??""),
          "label":"client_directive","validate":(String? val){
          return null;
        }
        },
      {"key":"phone","image":Images.phoneSVG,"value":TextEditingController(text: orderEntity?.userClass.phone??user.phone),
        "label":"phone","type":TextInputType.phone,"readOnly":true,"validate":(String? val){
        return null;
      }},
      {"key":"date","image":Images.dateSvg,"value":TextEditingController(text: orderEntity?.date??""),
        "label":"date","readOnly":true,"onTap":()async{
        DateTime? time = await selectDate(init: !isUser&&deliveryEntity!.isAdmin?DateTime(1990):null);
        if(time!=null){
          addDate(time.toLocal().toString().split(' ').first);
        }
      }},
      {"key":"notes","image":Images.noteSVG,"value":TextEditingController(text: orderEntity?.note??""),
        "label":"note","max":6,"validate":(String? val){
        return null;
      }},
    ];
    // addressEntity = null;
    // addressBillingEntity = null;
    setAllData();
  }
  void addDate(String date){
    inputs.firstWhere((element) => element['key']=='date')['value'].text = date;
    notifyListeners();
  }
  void addEndDate(String date){
    inputs.firstWhere((element) => element['key']=='end_date')['value'].text = date;
    notifyListeners();
  }
  void addCreatedDate(String date){
    inputs.firstWhere((element) => element['key']=='created_at')['value'].text = date;
    notifyListeners();
  }
  // void addEndTime(String date){
  //   inputs.firstWhere((element) => element['key']=='end_time')['value'].text = date;
  //   notifyListeners();
  // }
  void goToCheckOutPage(AddressEntity addressEntity){
    this.addressEntity = addressEntity;
    CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
    cartProvider.setTaxes();
    clear();
    navP(const CheckOutPage());
    notifyListeners();
  }
  void goToReOrderCheckOutPage(OrderEntity orderEntity){
    addressEntity = orderEntity.addressEntity;
    CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
    cartProvider.setTaxes();
    clear(orderEntity: orderEntity);
    navP(const CheckOutPage());
    notifyListeners();
  }
  void selectAddress(AddressEntity? addressEntity){
    this.addressEntity = addressEntity;
    notifyListeners();
  }
  void selectBillingAddress(AddressEntity? addressEntity){
    // addressBillingEntity = addressEntity;
    notifyListeners();
  }

  void createOrder()async{
    Map<String,dynamic> data = {};
    CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
    UserClass user = isUser?authenticationProvider.userEntity!:cartProvider.user!;

    for(var i in inputs){
      data[i['key']] = i['value'].text;
    }
    if(cartProvider.orderEntity!=null){
      data['id'] = cartProvider.orderEntity!.id;
    }
    data['address_id'] = addressEntity!.id;
    // data['address2_id'] = addressBillingEntity?.id;
    data['date'] = inputs.firstWhere((element) => element['key']=='date')['value'].text;
    data['pay_type'] = user.getPayTypeString();
    data['subtotal'] = cartProvider.calcSubTotal();

    data['total'] = cartProvider.calcTotal();
    // if(cartProvider.coupon !=null) {
    //   data["coupon_id"] = cartProvider.coupon?.id;
    //   data['discount'] = cartProvider.calcDiscount();
    // }
    data['discount'] = user.discount;
    if(ended){
      data['status'] = 'ended';
      data['created_at'] = inputs.firstWhere((element) => element['key']=='date')['value'].text+' 00:00:00';
      data['end_date'] = inputs.firstWhere((element) => element['key']=='end_date')['value'].text;
      // data['end_time'] = '00:00:00';
      data['is_paid'] = isPaid?"1":"0";
    }
    List details = [];
    for(var i in cartProvider.cartProducts!){
      details.add({
        "product_id": i.id ,
        // "sub_category_id":  i.,
        "price": i.price,
        "amount": i.count,
      });
    }
    data['details'] = details;
    if(!isUser){print(user);
      data['user_id'] = user.id;
    }
    print(data);
    navPop();
    loading();
    Either<DioException,OrderEntity> value;
    if(cartProvider.orderEntity==null){
      if(isUser){
        value = await OrderUseCases(sl()).createOrder(data);
      }else{
        value = await OrderDeliveryUseCases(sl()).createOrder(data);
      }
    }else{
      value = await OrderUseCases(sl()).updateOrder(data);
    }
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      cartProvider.deleteCart();
      cartProvider.setOrder(null);
      successDialog(then: (){
        Provider.of<MainProvider>(Constants.globalContext(),listen: false).setIndex(0);
        navPU();
        if(isUser){
          Provider.of<OrdersProvider>(Constants.globalContext(),listen: false).goDetailsPage(r);
        }else{
          Provider.of<OrdersDeliveryProvider>(Constants.globalContext(),listen: false).goDetailsPage(r);
        }
      });
    });
  }

  void showCheckOutSheet(){
    showModalBottomSheet(context: Constants.globalContext(),isScrollControlled: true,
        enableDrag: true,shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
    ), builder: (ctx){
      return const CheckOutWidget();
    });
  }

}