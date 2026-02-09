import 'package:flutter/material.dart';

import '../constants/constants.dart';


class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(scale: Constants.isTablet?2:1,
      child: BackButton(color: color,),);
  }
}
