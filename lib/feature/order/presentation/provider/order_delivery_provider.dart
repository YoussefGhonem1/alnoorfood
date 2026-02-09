import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/dialog/date_dialog.dart';
import '../../../../core/dialog/dialog_maps.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/dialog/success_dialog.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/helper_function/loading.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/models/drop_down_class.dart';
import '../../../../core/models/order_provider.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../injection_container.dart';
import '../../../cart/domain/entities/cart_product_entity.dart';
import '../../../home/presentation/pages/home_delivery_page.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/order_status_type_entity.dart';
import '../../domain/use_cases/order_delivery_usecases.dart';
import '../pages/details_order_page.dart';
import '../pages/edit_order_page.dart';
import 'current_delivery_order_provider.dart';
import 'new_order_provider.dart';
import 'previous_delivery_order_provider.dart';

enum OrderProviderType{
  newProvider,
  currentProvider,
  previousProvider;
}

class OrdersDeliveryProvider extends ChangeNotifier implements OrderProvider,DropDownClass<Map>{
  OrderProviderType orderProviderType = OrderProviderType.newProvider;
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
    orderProviderType = OrderProviderType.newProvider;
    notifyListeners();
  }
  @override
  void refreshOrder()async{
    if(orderEntity!=null){
      await getOrderDetails(orderEntity!.id);
    }
  }

  Future getOrderDetails(int id)async{
    Either<DioException,OrderEntity> value = await OrderDeliveryUseCases(sl()).orderDetails(id);
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      orderEntity = r;
      notifyListeners();
    });
  }
  void setNew(){
    if(orderProviderType!=OrderProviderType.newProvider){
      orderProviderType = OrderProviderType.newProvider;
      NewOrderProvider newOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      newOrderProvider.clear();
      newOrderProvider.getNewOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }
  }
  void setCurrent(){
    if(orderProviderType!=OrderProviderType.currentProvider){
      orderProviderType = OrderProviderType.currentProvider;
      CurrentDeliveryOrderProvider currentDeliveryOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      currentDeliveryOrderProvider.clear();
      currentDeliveryOrderProvider.getCurrentOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }
  }
  void setPrevious(){
    if(orderProviderType!=OrderProviderType.previousProvider){
      orderProviderType = OrderProviderType.previousProvider;
      PreviousDeliveryOrderProvider previousDeliveryOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      previousDeliveryOrderProvider.clear();
      previousDeliveryOrderProvider.getPreviousOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }
  }
  void refresh(){
    if(orderProviderType==OrderProviderType.newProvider){
      orderProviderType = OrderProviderType.previousProvider;
      setNew();
    }else if(orderProviderType==OrderProviderType.currentProvider){
      orderProviderType = OrderProviderType.previousProvider;
      setCurrent();
    }else{
      orderProviderType = OrderProviderType.newProvider;
      setPrevious();
    }
  }
  List<OrderEntity>? showOrders(){
    if(orderProviderType==OrderProviderType.currentProvider){
      CurrentDeliveryOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      return currentOrderProvider.currentOrders;
    }else if(orderProviderType==OrderProviderType.previousProvider){
      PreviousDeliveryOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      return previousOrderProvider.previousOrders;
    }else{
      NewOrderProvider newOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      return newOrderProvider.newOrders;
    }
  }
  void goOrdersPage(){
    resetOrders();
    CurrentDeliveryOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
    PreviousDeliveryOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
    NewOrderProvider newOrderProvider = Provider.of(Constants.globalContext(),listen: false);
    currentOrderProvider.clear();
    previousOrderProvider.clear();
    newOrderProvider.clear();
    newOrderProvider.getNewOrders().then((value) {
      notifyListeners();
    });
    navPARU(HomeDeliveryPage());
  }
  void goDetailsPage(OrderEntity order)async{
    for(var i in reasons){
      i['value'].clear();
    }
    loading();
    await getOrderDetails(order.id);
    navPR(DetailsOrderPage());
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
    if(orderProviderType==OrderProviderType.currentProvider){
      CurrentDeliveryOrderProvider currentDeliveryOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      currentDeliveryOrderProvider.clear();
      currentDeliveryOrderProvider.getCurrentOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }else if(orderProviderType==OrderProviderType.newProvider){
      NewOrderProvider newOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      newOrderProvider.clear();
      newOrderProvider.getNewOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }else{
      PreviousDeliveryOrderProvider previousDeliveryOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      previousDeliveryOrderProvider.clear();
      previousDeliveryOrderProvider.getPreviousOrders().then((value) {
        notifyListeners();
      });
      notifyListeners();
    }
  }

  void cancelOrder()async{
    loading();
    Either<DioException,bool> value = await OrderDeliveryUseCases(sl()).cancelOrder(orderEntity!.id);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      orderEntity!.orderStatus = OrderStatusTypeEntity.canceled;
      CurrentDeliveryOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      currentOrderProvider.deleteOrder(orderEntity!.id);
      NewOrderProvider newOrderProvider = Provider.of(Constants.globalContext(),listen: false);
      newOrderProvider.deleteOrder(orderEntity!.id);
      notifyListeners();
      successDialog(msg: 'order_cancel_delivery');
    });
  }
  void setPreparingOrder()async{
    loading();
    Either<DioException,bool> value = await OrderDeliveryUseCases(sl()).preparingOrder(orderEntity!.id);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {

      orderEntity!.orderStatus = OrderStatusTypeEntity.preparing;
      NewOrderProvider newOrderProvider =
      Provider.of(Constants.globalContext(),listen: false);
      newOrderProvider.deleteOrder(orderEntity!.id);
      notifyListeners();
      successDialog();
    });
  }
  void setDeliveryOrder()async{
    loading();
    print('hamza1');
    Either<DioException,bool> value = await OrderDeliveryUseCases(sl()).deliveryOrder(orderEntity!.id);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {

      orderEntity!.orderStatus = OrderStatusTypeEntity.delivery;
      if(!deliveryEntity!.isAdmin){
        NewOrderProvider newOrderProvider =
        Provider.of(Constants.globalContext(),listen: false);
        newOrderProvider.deleteOrder(orderEntity!.id);
      }else{
        CurrentDeliveryOrderProvider currentDeliveryOrderProvider =
        Provider.of(Constants.globalContext(),listen: false);
        currentDeliveryOrderProvider.updateOrder(orderEntity!);
        notifyListeners();
      }
      notifyListeners();
      successDialog();
    });
  }
  void setEndedOrder()async{
    loading();
    Map<String,dynamic> data = {};
    for(var i in reasons){
      data[i['key']] = i['value'].text;
    }
    data['id'] = orderEntity!.id;
    data['status'] = 'ended';
    print(data);
    // data['is_paid'] = orderEntity!.isPaid?1:0;
    Either<DioException,OrderEntity> value = await OrderDeliveryUseCases(sl()).updateOrder(data);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      orderEntity = r;
      orderEntity!.orderStatus = OrderStatusTypeEntity.ended;
      orderEntity!.endTime = DateFormat('h:m a').format(DateTime.now());
      CurrentDeliveryOrderProvider currentDeliveryOrderProvider =
      Provider.of(Constants.globalContext(),listen: false);
      currentDeliveryOrderProvider.deleteOrder(orderEntity!.id);
      notifyListeners();
      successDialog(msg: 'order_ended');
    });
  }
  void pagination(ScrollController controller) {
    controller.addListener(() async{
      if(controller.position.atEdge&&controller.position.pixels>50){
        if(orderProviderType == OrderProviderType.currentProvider){
          CurrentDeliveryOrderProvider currentOrderProvider = Provider.of(Constants.globalContext(),listen: false);
          if(!currentOrderProvider.paginationFinished&&!currentOrderProvider.paginationStarted){
            showLoading = true;
            notifyListeners();
            await currentOrderProvider.pagination(controller);
            showLoading = false;
            notifyListeners();
          }
        }else if(orderProviderType == OrderProviderType.newProvider){
          NewOrderProvider newOrderProvider = Provider.of(Constants.globalContext(),listen: false);
          if(!newOrderProvider.paginationFinished&&!newOrderProvider.paginationStarted){
            showLoading = true;
            notifyListeners();
            await newOrderProvider.pagination(controller);
            showLoading = false;
            notifyListeners();
          }
        }else{
          PreviousDeliveryOrderProvider previousOrderProvider = Provider.of(Constants.globalContext(),listen: false);
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
  void bottomButtonAction() {
    if(orderEntity!.orderStatus==OrderStatusTypeEntity.newOrder){
      setPreparingOrder();
    }else if(orderEntity!.orderStatus==OrderStatusTypeEntity.preparing){
      setDeliveryOrder();
    }else{
      setEndedOrder();
    }
  }

  @override
  void bottomButtonCancelAction() {
    cancelOrder();
  }

  @override
  bool showBottomButton() {
    if(orderEntity!.orderStatus==OrderStatusTypeEntity.ended||
        orderEntity!.orderStatus==OrderStatusTypeEntity.canceled){
      return false;
    }
    return deliveryEntity!.isAdmin;
  }

  @override
  bool showTopButton() {
    if(orderEntity!.orderStatus==OrderStatusTypeEntity.ended||
        orderEntity!.orderStatus==OrderStatusTypeEntity.canceled||
        orderEntity!.orderStatus==OrderStatusTypeEntity.newOrder){
      return false;
    }
    return !(deliveryEntity!.isAdmin);
  }

  @override
  void topButtonAction() {
    if(orderEntity!.orderStatus==OrderStatusTypeEntity.preparing){
      setDeliveryOrder();
    }else{
      setEndedOrder();
    }
  }

  @override
  String bottomButtonTitle() {
    if(orderEntity!.orderStatus==OrderStatusTypeEntity.newOrder){
      return 'preparing_order';
    }else if(orderEntity!.orderStatus==OrderStatusTypeEntity.preparing){
      return 'delivery_order';
    }else{
      return 'end_order';
    }
  }

  @override
  List<Map> data() {
    return [
      {"image":Images.orderSVG,"title":"order_id","widget":Text('# ${orderEntity!.id}',
        style: TextStyleClass.semiBoldStyle(),)},
      {"image":Images.activePersonSVG,"title":"name","data":orderEntity!.userClass.name,
        "widget":Text('# ${orderEntity!.userClass.id}',
          style: TextStyleClass.semiBoldStyle(),)},
      {"image":Images.activePersonSVG,"title":"client_directive",
        "data":orderEntity!.userClass.clientDirective??"",},
      // {"image":Images.timeIconSVG,"title":"work_time","data":orderEntity!.userClass.workTime,},
      {"image":Images.locationSVG,"title":orderEntity!.addressEntity?.name??"location",
        "data":orderEntity!.addressEntity?.address,"widget":isUser?null:
      InkWell(
        onTap: ()async{
          openDialogMapsSheet(Constants.globalContext(), orderEntity!.addressEntity!.lat, orderEntity!.addressEntity!.lng);
        },
        child: CircleAvatar(radius: 6.w,backgroundColor: AppColor.lightDefaultColor,
          child: const SvgWidget(svg: Images.locationSVG,color: Colors.black,),),
      )},
      {"image":Images.phoneSVG,"title":"phone","data":orderEntity!.phone,
        "widget":isUser?null:
        InkWell(
          onTap: ()async{
            final Uri _url = Uri.parse('tel:${orderEntity!.phone}');
            if (!await launchUrl(_url)) throw 'Could not launch $_url';
          },
          child: CircleAvatar(radius: 6.w,backgroundColor: AppColor.lightDefaultColor,
            child: const SvgWidget(svg: Images.phoneSVG,color: Colors.black,),),
        )},
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
  void editOrder() {
    dateInput = {"key":"date","image":Images.dateSvg,"value":TextEditingController(text: orderEntity!.date),
      "label":"date","readOnly":true,"onTap":()async{
        DateTime? time = await selectDate(currentDate: DateTime.parse(Provider.of<OrdersDeliveryProvider>
          (Constants.globalContext(),listen: false).dateInput['value'].text),);
        if(time!=null){
          Provider.of<OrdersDeliveryProvider>(Constants.globalContext(),listen: false)
              .addDate(time.toLocal().toString().split(' ').first);
        }
      }};
    navP(EditOrderPage(products: products()));
  }

  void addDate(String date){
    dateInput['value'].text = date;
    notifyListeners();
  }

  late Map dateInput;

  void editOrderButton(List<CartProductEntity> products)async{
    loading();
    Map<String,dynamic> data = {};
    num subTotal = 0;
    List<int> ids = [];
    List<Map> details = [];
    num discountValue = ((100-orderEntity!.discount)/100);
    for(var i in products){
      subTotal += i.calcTotalPrice();
      ids.add(i.idOrderDetails!);
      details.add({"id":i.idOrderDetails!,"amount":i.count,"is_ended":i.isEnded!?1:0,
      });
    }
    subTotal = num.parse((subTotal* discountValue).toStringAsFixed(2));
    num total = num.parse((subTotal).toStringAsFixed(2));
    data['subtotal'] = subTotal;
    data['total'] = total;
    data['id'] = orderEntity!.id.toString();
    data['details'] = details;
    data['details_ids[]'] = ids;
    if(dateInput['value'].text!=orderEntity!.date){
      print('date_updated');
      data['date_updated'] = 1;
      data['date'] = dateInput['value'].text;
    }
    Either<DioException,OrderEntity> value = await OrderDeliveryUseCases(sl()).updateOrder(data);

    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      orderEntity = r;
      successDialog(then: (){
        navPop();
      });
      notifyListeners();
    });

  }

  @override
  List<CartProductEntity> products() {
    List<CartProductEntity> items = [];
    for(var i in orderEntity!.orderDetails){
      items.add(i.productEntity.cartProductEntity
        (amount: i.count,isComplete: i.isCompleted,
          note: i.note,dateTime: i.dateTime,idOrderDetails: i.id,isEnded: i.isEnded));
    }
    return items;
  }

  @override
  String topButtonTitle() {
    if(orderEntity!.orderStatus==OrderStatusTypeEntity.newOrder){
      return 'preparing_order';
    }else if(orderEntity!.orderStatus==OrderStatusTypeEntity.preparing){
      return 'delivery_order';
    }else{
      return 'end_order';
    }
  }


  @override
  bool showEditButton() {
    return deliveryEntity!.isAdmin&&(orderEntity!.orderStatus!=OrderStatusTypeEntity.canceled&&
        orderEntity!.orderStatus!=OrderStatusTypeEntity.ended);
  }
  @override
  List<Map> reasons = [{"key":"reject_delivery_reason",
    "value":TextEditingController(),"label":"reject_delivery_reason"},
    // {"key":"delivered_count",
    //   "value":TextEditingController(),"label":"delivered_count"},
    // // {"key":"refunded_count",
    //   "value":TextEditingController(),"label":"refunded_count"},
    // {"key":"temperature",
    //   "value":TextEditingController(),"label":"temperature"},
  ];

  @override
  bool showReasons() {
    return orderEntity!.orderStatus == OrderStatusTypeEntity.delivery;
  }

  @override
  bool showUpdatePaidButton() {
    return orderEntity!.orderStatus == OrderStatusTypeEntity.ended;
  }

  @override
  void updatePaidButton() async{
    loading();
    Map<String,dynamic> data = {};
    data['id'] = orderEntity!.id;
    data['is_paid'] = orderEntity!.isPaid?1:0;
    Either<DioException,OrderEntity> value = await OrderDeliveryUseCases(sl()).updateOrder(data);
    navPop();
    value.fold((l) {
      showToast(l.message!);
    }, (r) {
      orderEntity = r;
      notifyListeners();
      successDialog(msg: 'success');
    });
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
    PreviousDeliveryOrderProvider previousDeliveryOrderProvider = Provider.of(Constants.globalContext(),listen: false);
    previousDeliveryOrderProvider.clear();
    previousDeliveryOrderProvider.getPreviousOrders().then((value) {
      notifyListeners();
    });
    notifyListeners();
  }

  @override
  Map? selected() {
    return pay;
  }


}