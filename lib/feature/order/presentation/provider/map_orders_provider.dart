import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_custom_marker/google_maps_custom_marker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homsfood/core/constants/constants.dart';
import 'package:homsfood/core/dialog/success_dialog.dart';
import 'package:homsfood/core/helper_function/loading.dart';
import 'package:homsfood/feature/cities/domain/entities/city_entity.dart';
import 'package:homsfood/feature/cities/presentation/provider/city_provider.dart';
import 'package:homsfood/feature/order/domain/entities/order_status_type_entity.dart';
import 'package:provider/provider.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/dialog/snack_bar.dart';
import '../../../../core/helper_function/location.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/use_cases/order_delivery_usecases.dart';
import '../pages/map_orders_page.dart';
import 'order_delivery_provider.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapOrdersProvider extends ChangeNotifier {


  List<Marker> markers = [];
  LatLng? latLng;
  CityEntity? cityEntity;
  PolylinePoints polylinePoints = PolylinePoints();
  Set<Polyline> poly = {};
  Map<PolylineId, Polyline> polylines = {};
  LatLng? _point2;
  String? from;
  String? to;
  OrderEntity? orderEntity;
  List<int> ids = [];
  List<CityEntity> cities(){
    return Provider.of<CityProvider>(Constants.globalContext(),listen: false).cityList;
  }

  void setDate(String? from,String? to){
    this.from = from;
    this.to = to;
    getCurrentOrders();
    notifyListeners();
  }

  void setCity(CityEntity city){
    if(city.id==cityEntity?.id){
      cityEntity = null;
    }else{
      cityEntity = city;
    }
    getCurrentOrders();
    notifyListeners();
  }

  bool selectedCity(CityEntity city){
    return city.id==cityEntity?.id;
  }
  Future drawLine(PointLatLng start,PointLatLng end)async{
    try{
      List<LatLng> polylineCoordinates = [];
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyBVl1JPbjzJzE5CmLRY4EYD5H8ag5yXkkM", //GoogleMap ApiKey
        start, //first added marker
        end, //last added marker
        travelMode: TravelMode.driving,

      );
      print("errorr1 ${result}");
      if (result.points.isNotEmpty) {
        print("errorr2");
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print("errorr3");
      }
      addPolyLine(polylineCoordinates);
    }catch(e){
      print("errorr $e");
    }

  }
  addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly ${polylineCoordinates.first.latitude}");
    Polyline polyline = Polyline(
      polylineId: id,
      color: AppColor.defaultColor,
      points: polylineCoordinates,
      width: 4,
    );
    poly.add(polyline);
    polylines[id] = polyline;

    notifyListeners();
  }

  void initCamera(GoogleMapController controller){
   if(_point2!=null){
     LatLng _point1 = LatLng(latLng!.latitude, latLng!.longitude);
     LatLngBounds bounds = LatLngBounds(
       southwest: LatLng(
         _point1.latitude < _point2!.latitude ? _point1.latitude : _point2!.latitude,
         _point1.longitude < _point2!.longitude ? _point1.longitude : _point2!.longitude,
       ),
       northeast: LatLng(
         _point1.latitude > _point2!.latitude ? _point1.latitude : _point2!.latitude,
         _point1.longitude > _point2!.longitude ? _point1.longitude : _point2!.longitude,
       ),
     );

     CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(bounds, 100);
     controller.animateCamera(cameraUpdate);
   }
  }

  Future getCurrentOrders()async{
    orderEntity = null;
    ids.clear();
    markers.clear();
    _point2 = null;
    poly = {};
    polylines = {};
    loading();
    Either<DioException,List<OrderEntity>> data = await OrderDeliveryUseCases(sl())
        .currentOrders(0,from,to,withPagination: false,cityId: cityEntity?.id);
    navPop();
    await data.fold((l) {
      showToast(l.message!);
    }, (r) async{
      List<OrderEntity> nearOrders = [];
      for(var i in r){
        if(i.orderStatus==OrderStatusTypeEntity.preparing){
          ids.add(i.id);
        }
        OrderEntity orderEntity = i;
        orderEntity.distance = await calculateDistance(LatLng(globalPosition?.latitude??0, globalPosition?.longitude??0),
            LatLng(orderEntity.addressEntity?.lat??0, orderEntity.addressEntity?.lng??0),);
        nearOrders.add(orderEntity);
      }
      print(nearOrders.length);
      nearOrders.sort((a, b) => a.distance.compareTo(b.distance));
      for (var index = 0; index < nearOrders.length; index++) {
        var i = nearOrders[index];
        latLng ??= LatLng(i.addressEntity?.lat??0, i.addressEntity?.lng??0);
        Marker bubbleMarkerCustomized = await GoogleMapsCustomMarker.createCustomMarker(
          marker: Marker(
            markerId:MarkerId(i.id.toString()),
            position: LatLng(i.addressEntity?.lat??0, i.addressEntity?.lng??0),
            onTap: (){
              Provider.of<OrdersDeliveryProvider>(Constants.globalContext(),listen: false).goDetailsPage(i);
            },

            // infoWindow: InfoWindow(title: i.title),
          ),
          shape: MarkerShape.bubble,
          title: "#${index+1}",
          backgroundColor: i.orderStatus==OrderStatusTypeEntity.preparing?Colors.orange: AppColor.defaultColor,
          foregroundColor: Colors.white,
          textSize: 25,
          enableShadow: false,
          padding: 25,
          textStyle: TextStyleClass.normalBoldStyle(),
          imagePixelRatio: 1.5,
          bubbleOptions: BubbleMarkerOptions(
            anchorTriangleWidth: 20,
            anchorTriangleHeight: 20,
            cornerRadius: 8,
          ),
        );
        markers.add(bubbleMarkerCustomized);
        if(index!=nearOrders.length-1){
          var next = nearOrders[index+1];
          PointLatLng start = PointLatLng(i.addressEntity?.lat??0, i.addressEntity?.lng??0);
          PointLatLng end = PointLatLng(next.addressEntity?.lat??0, next.addressEntity?.lng??0);
          await drawLine(start, end);
        }
        if(index==nearOrders.length-1){
          _point2 = LatLng(i.addressEntity?.lat??0, i.addressEntity?.lng??0);
        }


      }

    });
    notifyListeners();
  }
  Future updateAllOrders()async{
    loading();
    Map<String,dynamic> data = {};
    data['ids'] = ids;
    Either<DioException,bool> result = await OrderDeliveryUseCases(sl())
        .updateAllOrders(data);
    navPop();
    await result.fold((l) {
      showToast(l.message??"");
    }, (r) async{
      successDialog(then: (){
        getCurrentOrders();
      });

    });
    notifyListeners();
  }

  void goToMapOrdersPage()async{
    cityEntity = null;
    orderEntity = null;
    from = null;
    to = null;
    await determinePosition();
    latLng = LatLng(globalPosition?.latitude??0, globalPosition?.longitude??0);
    await getCurrentOrders();
    navP(MapOrdersPage());
  }


}