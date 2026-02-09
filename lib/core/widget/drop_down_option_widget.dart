import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../config/text_style.dart';
import '../models/drop_down_class.dart';
class DropDownOptionWidget extends StatefulWidget {
  final DropDownClass dropDownClass;
  final dynamic data;
  final void Function() rebuild;
  const DropDownOptionWidget({required this.dropDownClass,
    Key? key, required this.data, required this.rebuild}) : super(key: key);
  @override
  State<DropDownOptionWidget> createState() => _DropDownOptionWidgetState(dropDownClass,data);
}

class _DropDownOptionWidgetState extends State<DropDownOptionWidget> {
  _DropDownOptionWidgetState(this.dropDownClass,this.data);
  DropDownClass dropDownClass;
  dynamic data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Card(
        color: Colors.white,
        shadowColor: Colors.grey,
        child: InkWell(
          onTap: ()async {
            await dropDownClass.onTap(data);
            widget.rebuild();
            setState(() {

            });
          },
          child: Container(
            width: 90.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 0.5.h),
              child: ListTile(
                leading: Transform.scale(
                  scale: 1,
                  child: Radio(value: data, groupValue: dropDownClass.selected(), onChanged: (val){
                    dropDownClass.onTap(data);
                    widget.rebuild();
                    setState(() {

                    });
                  },
                    visualDensity: VisualDensity.compact,materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
                ),
                title: Text(dropDownClass.displayedOptionName(data),style: TextStyleClass.normalStyle(),),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
