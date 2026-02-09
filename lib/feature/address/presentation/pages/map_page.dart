import 'package:flutter/material.dart';

import '../../../language/presentation/provider/language_provider.dart';
import '../widgets/bottom_map_sheet.dart';
import '../widgets/map_widget.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate("address", "select_location")),
      ),
      body: const MapWidget(),
      bottomSheet: const BottomMapSheetWidget(),
    );
  }
}
