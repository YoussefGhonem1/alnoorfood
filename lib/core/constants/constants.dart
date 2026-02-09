import 'package:flutter/material.dart';

class Constants{
  static const String domain = 'https://alnoorfood.online/api/';
  static final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  static bool isTablet = false;
  static BuildContext globalContext(){
    return navState.currentContext!;
  }
}