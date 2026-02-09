import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/models/counter_class.dart';

class CounterWidget extends StatefulWidget {
  final CounterClass counter;
  const CounterWidget({required this.counter,Key? key}) : super(key: key);
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // IconButton(onPressed: (){
        //   if(widget.counter.count>1){
        //     widget.counter.remove();
        //     setState(() {
        //
        //     });
        //   }
        // }, icon: Icon(Icons.remove,size: 25,),padding: EdgeInsets.zero),
        InkWell(onTap: (){
          if(widget.counter.count>1){
            widget.counter.remove();
            setState(() {
            });
          }
        },child: Icon(Icons.remove,size: Constants.isTablet?40:25,)),
        SizedBox(width: 2.w,),
        Text(widget.counter.count.toString(),style: TextStyleClass.semiHeadBoldStyle(),),
        SizedBox(width: 2.w,),
        InkWell(onTap: (){
          widget.counter.add();
          setState(() {
          });
        },child: Icon(Icons.add,size: Constants.isTablet?40:25,)),
        // IconButton(onPressed: (){
        //   widget.counter.add();
        //   setState(() {
        //   });
        // }, icon: Icon(Icons.add,size: 25,),padding: EdgeInsets.zero,
        // ),
      ],
    );
  }
}
