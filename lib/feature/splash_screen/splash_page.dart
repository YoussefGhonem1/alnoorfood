import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../core/constants/images.dart';
import 'splash_provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SplashProvider>(context,listen: false).startApp(context);
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Stack(
          children: [
         /*   Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset(Images.splash),
            ),*/
            Center(
              child: Image.asset(Images.logo),
            ),
          ],
        ),
      ),
    );
  }
}
