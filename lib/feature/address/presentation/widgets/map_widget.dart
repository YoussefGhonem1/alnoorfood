import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/svg_widget.dart';
import '../provider/bottom_map_sheet.dart';
import '../provider/map_provider.dart';

class MapWidget extends StatelessWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CameraPosition? currentPos;
    var provider = Provider.of<MapProvider>(context,listen: true);
    return Stack(
      children: [
        GoogleMap(
            onTap: (pos) {
              Provider.of<BottomMapSheetProvider>(context,listen: false).disAbleExtend();
              provider.setData(pos.latitude, pos.longitude);
            },
            onCameraMove: (CameraPosition pos) {
              currentPos = pos;
            },
            onCameraIdle: () {
              if (currentPos != null) {
                provider.setData(currentPos!.target.latitude, currentPos!.target.longitude);
              }
            },
            onMapCreated: (GoogleMapController controller) {
              provider.setDataController(controller);
            },
            zoomControlsEnabled: true,
            initialCameraPosition: CameraPosition(target: LatLng(provider.lat, provider.lng), zoom: 18)),
        Center(child: SvgWidget(svg: Images.locationSVG, width: 10.w, height: 10.w))
      ],
    );
    // return GoogleMap(
    //   markers: provider.markers,
    //   onTap: (pos) {
    //     Provider.of<BottomMapSheetProvider>(context,listen: false).disAbleExtend();
    //     provider.setData(pos.latitude, pos.longitude);
    //   },
    //   onCameraMove: (CameraPosition pos) {
    //     currentPos = pos;
    //   },
    //   onCameraIdle: (){
    //     if(currentPos!=null){
    //       provider.setData(currentPos!.target.latitude, currentPos!.target.longitude);
    //     }
    //   },
    //   onMapCreated: (GoogleMapController controller) {
    //     provider.setDataController(controller);
    //   },
    //   zoomControlsEnabled: true,
    //   initialCameraPosition: CameraPosition(target: LatLng(provider.lat,provider.lng),zoom: 18),
    // );
  }
}
