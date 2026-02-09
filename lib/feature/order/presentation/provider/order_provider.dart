import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:homsfood/feature/cart/presentation/provider/check_out_provider.dart';
import 'package:provider/provider.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/dialog/confirm_dialog.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/helper_function/helper_function.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/drop_down_class.dart';
import '../../../../core/models/order_provider.dart';
import '../../../../injection_container.dart';
import '../../../cart/domain/entities/cart_product_entity.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../main/main_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status_type_entity.dart';
import '../../domain/use_cases/order_usecases.dart';
import '../pages/details_order_page.dart';
import '../pages/orders_page.dart';
import 'current_order_provider.dart';
import 'previous_order_provider.dart';

class OrdersProvider extends ChangeNotifier implements OrderProvider,DropDownClass<Map>{
  bool current = true;
  bool showLoading = false;
  String? from;
  String? to;
  List<Map> payed = [
    {"name":"all","value":null},
    {"name":"paid","value":1},
    {"name":"not_paid","value":0},
  ];
  late Map pay;
  @override
  OrderEntity? orderEntity;
  void resetOrders(){
    pay = payed.first;
    from = null;
    to = null;
    current = true;
    notifyListeners();
  }
  @override
  void refreshOrder()async{
    if(orderEntity!=null){
      await getOrderDetails(orderEntity!.id);
    }
  }
  Future getOrderDetails(int id)async{
    Either<DioException,OrderEntity> value = await OrderUseCases(sl()).orderDetails(id);
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      orderEntity = r;
      notifyListeners();
    });
  }
  void enableCurrent(){
    if(!current){
      current = true;
      CurrentOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      currentOrderProvider.clear();
      currentOrderProvider.getCurrentOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }
  }
  void onFilter(String fromText,String toText){
    List<String> fromDate = fromText.split('-');
    List<String> toDate = toText.split('-');
    DateTime from = DateTime(int.parse(fromDate[0]),int.parse(fromDate[1])
        ,int.parse(fromDate[2]));
    DateTime to = DateTime(int.parse(toDate[0]),int.parse(toDate[1])
        ,int.parse(toDate[2]));
    if(from.isBefore(to)){
      this.from = fromText;
      this.to = toText;
    }else{
      this.from = toText;
      this.to = fromText;

    }
    navPop();
    notifyListeners();
    getOrdersFilter();

  }
  void resetFilter(){
    from = null;
    to = null;
    notifyListeners();
    getOrdersFilter();
  }
  void getOrdersFilter(){
    if(current){
      CurrentOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      currentOrderProvider.clear();
      currentOrderProvider.getCurrentOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }else{
      PreviousOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      previousOrderProvider.clear();
      previousOrderProvider.getPreviousOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }
  }


  void refresh(){
    if(current){
      current = false;
      enableCurrent();
    }else{
      current = true;
      disableCurrent();
    }
  }
  void disableCurrent(){
    if(current){
      current = false;
      PreviousOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      previousOrderProvider.clear();
      previousOrderProvider.getPreviousOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }
  }
  List<OrderEntity>? showOrders(){
    if(current){
      CurrentOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      return currentOrderProvider.currentOrders;
    }else{
      PreviousOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      return previousOrderProvider.previousOrders;
    }
  }
  void goOrdersPage(){
    resetOrders();
    CurrentOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
    PreviousOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
    currentOrderProvider.clear();
    previousOrderProvider.clear();
    currentOrderProvider.getCurrentOrders().then((value) {
      notifyListeners();
    });
    navP(OrdersPage());
  }
  void goDetailsPage(OrderEntity orderEntity)async{
    loading();
    await getOrderDetails(orderEntity.id);
    navPR(DetailsOrderPage());
  }
  void cancelUserOrder()async{
    loading();
    Either<DioException,bool> value = await OrderUseCases(sl()).cancelOrder(orderEntity!.id);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      successDialog(msg: 'order_cancel');
      orderEntity!.orderStatus = OrderStatusTypeEntity.canceled;
      CurrentOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      currentOrderProvider.deleteOrder(orderEntity!.id);
      CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
      if(cartProvider.orderEntity!=null&&cartProvider.orderEntity!.id==orderEntity!.id){
        cartProvider.setOrder(null);
        cartProvider.deleteCart();
      }
      notifyListeners();
    });
  }


  void pagination(ScrollController controller) {
    controller.addListener(() async{
      if(controller.position.atEdge&&controller.position.pixels>50){
        if(current){
          CurrentOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
          if(!currentOrderProvider.paginationFinished&&!currentOrderProvider.paginationStarted){
            showLoading = true;
            notifyListeners();
            await currentOrderProvider.pagination(controller);
            showLoading = false;
            notifyListeners();
          }
        }else{
          PreviousOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
          if(!previousOrderProvider.paginationFinished&&!previousOrderProvider.paginationStarted){
            showLoading = true;
            notifyListeners();
            await previousOrderProvider.pagination(controller);
            showLoading = false;
            notifyListeners();
          }
        }

      }
    });
  }


  @override
  bool showTopButton(){
    if((orderEntity!.orderStatus==OrderStatusTypeEntity.newOrder)){
      return true;
    }
    return false;
  }
  @override
  bool showBottomButton(){
    return false;
  }


  void reOrder(OrderEntity orderEntity)async{
    CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
    if(cartProvider.cartProducts!=null&&cartProvider.cartProducts!.isNotEmpty){
      cartProvider.deleteCart();
    }
    // cartProvider.setOrder(orderEntity);
    cartProvider.onTap(orderEntity.userClass);
    await delay(100);
    for(var i in orderEntity.orderDetails){
      cartProvider.addCartProduct(i.productEntity.cartProductEntity(
          amount: i.count),fromOrder: true);
    }
    MainProvider mainProvider = Provider.of(Constants.globalContext(),listen: false);
    mainProvider.setIndex(3);
    navPU();
    await delay(100);
    Provider.of<CheckOutProvider>(Constants.globalContext(),listen: false).goToReOrderCheckOutPage(orderEntity!);
  }

  void editUserOrder()async{
    CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
    if(cartProvider.cartProducts!=null&&cartProvider.cartProducts!.isNotEmpty){
      cartProvider.deleteCart();
    }
    cartProvider.setOrder(orderEntity);
    await delay(100);
    for(var i in orderEntity!.orderDetails){
      cartProvider.addCartProduct(i.productEntity.cartProductEntity(
      amount: i.count),fromOrder: true);
    }
    MainProvider mainProvider = Provider.of(Constants.globalContext(),listen: false);
    mainProvider.setIndex(3);
    navPU();
  }
  @override
  void editOrder(){
    CartProvider cartProvider = Provider.of(Constants.globalContext(),listen: false);
    if(cartProvider.cartProducts!=null&&cartProvider.cartProducts!.isNotEmpty){
      confirmDialog(Constants.globalContext(), LanguageProvider.translate("validation", "full_cart"),
          LanguageProvider.translate("buttons", "delete_cart"), () {
        navPop();
            editUserOrder();
          });
    }else{
      editUserOrder();
    }
  }

  @override
  void bottomButtonAction() {

  }

  @override
  void bottomButtonCancelAction() {

  }

  @override
  void topButtonAction() {
    cancelUserOrder();
  }

  @override
  String bottomButtonTitle() {
    return '';
  }

  @override
  String topButtonTitle() {
    return 'canceled_order';
  }

  @override
  List<CartProductEntity> products() {
    List<CartProductEntity> items = [];
    for(var i in orderEntity!.orderDetails){
      items.add(i.productEntity.cartProductEntity
        (amount: i.count,isComplete: i.isCompleted,
          note: i.note,dateTime: i.dateTime));
    }
    return items;
  }

  @override
  List<Map> data() {
    return [
      {"image":Images.orderSVG,"title":"order_id","widget":Text('# ${orderEntity!.id}',
        style: TextStyleClass.semiBoldStyle(),)},
      {"image":Images.locationSVG,"title":orderEntity!.addressEntity?.name??"location",
        "data":orderEntity!.addressEntity?.address,},
      {"image":Images.phoneSVG,"title":"phone","data":orderEntity!.phone,},
      {"image":Images.dateSvg,"title":"date","data":convertDateToStringSort(orderEntity!.createAt)},
      {"image":Images.deliveryDateSVG,"title":"delivery_date","data":convertDateToStringSort(DateTime.parse(orderEntity!.date))},
      if(orderEntity!.orderStatus==OrderStatusTypeEntity.ended&&
      orderEntity!.endTime!=null){"image":Images.deliveryDateSVG,
        "title":"end_time","data":orderEntity!.endTime},
      {"image":Images.walletSVG,"title":"payment","data":
      LanguageProvider.translate('orders', 'cash')},
      if(orderEntity!.note!=null){"image":Images.noteSVG,"title":"note","data":orderEntity!.note},
    ];
  }

  @override
  bool showEditButton() {
    return (orderEntity!.orderStatus==OrderStatusTypeEntity.newOrder);
  }

  @override
  List<Map> reasons = [];

  @override
  bool showReasons() {
    return false;
  }

  @override
  bool showUpdatePaidButton() {
    return false;
  }

  @override
  void updatePaidButton() {
  }

  @override
  String displayedName() {
    return LanguageProvider.translate('orders', pay['name']);
  }

  @override
  String displayedOptionName(Map type) {
    return LanguageProvider.translate('orders', type['name']);
  }

  @override
  List<Map> list() {
    return payed;
  }

  @override
  Future onTap(Map data)async {
    pay = data;
    PreviousOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
    previousOrderProvider.clear();
    previousOrderProvider.getPreviousOrders().then((value) {
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  Map? selected() {
    return pay;
  }

}