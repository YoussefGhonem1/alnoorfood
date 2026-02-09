import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DashedDivider extends StatelessWidget {
  final int count;
  const DashedDivider({Key? key, required this.count}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 100.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(count, (i) {
          return SizedBox(
            width: (100.w)/(count*2),
            child: Divider(endIndent: 1,indent: 1,thickness: 0.15.h,
              color: Colors.grey.shade300,),
          );
        }),
      ),
    );
  }
}
