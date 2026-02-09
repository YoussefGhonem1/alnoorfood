import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:homsfood/config/app_color.dart';
import 'package:homsfood/core/helper_function/navigation.dart';
import 'package:homsfood/core/widget/button_widget.dart';
import 'package:homsfood/feature/cities/domain/entities/city_entity.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/text_style.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/map_orders_provider.dart';
import '../widgets/date_filter_widget.dart';

class MapOrdersPage extends StatelessWidget {
  const MapOrdersPage({super.key});
  @override
  Widget build(BuildContext context) {
    MapOrdersProvider mapOrdersProvider = Provider.of(context);
    LatLng location = mapOrdersProvider.latLng!;
    return Scaffold(
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Stack(
          children: [
            GoogleMap(
              markers: mapOrdersProvider.markers.toSet(),
              initialCameraPosition:
                  CameraPosition(target: location, zoom: 15),
              onCameraMove: (CameraPosition pos) {
                location = pos.target;
              },
              onMapCreated: (GoogleMapController controller) {
                mapOrdersProvider.initCamera(controller);
              },
              zoomControlsEnabled: false,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              polylines: mapOrdersProvider.poly,
            ),
            Positioned(
              top: 3.h,
              right: 3.w,
              left: 3.w,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DateFilterWidget(from: mapOrdersProvider.from, to: mapOrdersProvider.to,
                            onFilter: (String from,String to){
                              mapOrdersProvider.setDate(from, to);
                            },reset: (){
                            mapOrdersProvider.setDate(null, null);
                            },color: Colors.white,textColor: Colors.black,),
                      ),
                      SizedBox(width: 3.w,),
                      InkWell(
                        onTap: (){
                          mapOrdersProvider.getCurrentOrders();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white
                          ),
                          padding: EdgeInsets.all(3.w),
                          child: Icon(Icons.refresh,size: 5.w,),
                        ),
                      ),
                      SizedBox(width: 3.w,),
                      InkWell(
                        onTap: (){
                          navPop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Colors.white
                          ),
                          padding: EdgeInsets.all(3.w),
                          child: Icon(Icons.login,size: 5.w,),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h,),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 3.w,
                      children: List.generate(mapOrdersProvider.cities().length, (index){
                        CityEntity city = mapOrdersProvider.cities()[index];
                        bool check = mapOrdersProvider.selectedCity(city);
                        return InkWell(
                          onTap: (){
                            mapOrdersProvider.setCity(city);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: check?AppColor.defaultColor:Colors.white,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 1.h),
                            child: Text(city.name,style: TextStyleClass.normalStyle(color: check?Colors.white:Colors.black).copyWith(height: 1),),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
            if(mapOrdersProvider.cityEntity!=null&&mapOrdersProvider.ids.isNotEmpty)Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 2.h),
                child: Column(
                  children: [
                    Text(LanguageProvider.translate('orders', 'update_all_orders'),style: TextStyleClass.semiBoldStyle(),),
                    SizedBox(height: 1.h,),
                    ButtonWidget(onTap: (){
                      if(mapOrdersProvider.ids.isNotEmpty){
                        mapOrdersProvider.updateAllOrders();
                      }
                    }, text: 'save'),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
