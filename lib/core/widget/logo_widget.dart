import 'package:flutter/material.dart';

import '../constants/images.dart';

class LogoWidget extends StatelessWidget {
  final double? width,height;
  const LogoWidget({this.height,this.width,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Image.asset(Images.logo,width: width,height: height,fit: width==null?null:BoxFit.fitWidth,);
  }
}
