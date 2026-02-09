import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 1.h,
      right: 0,
      left: 0,
      child: Center(
        child: Transform.scale(scale: 2,
            child: const CupertinoActivityIndicator(color: Colors.black,)),
      ),
    );
  }
}
