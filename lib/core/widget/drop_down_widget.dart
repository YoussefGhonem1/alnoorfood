import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../config/app_color.dart';
import '../../config/text_style.dart';
import '../dialog/drop_down_dialog.dart';
import '../models/drop_down_class.dart';


class DropDownWidget extends StatefulWidget {
  final DropDownClass dropDownClass;
  final void Function() afterClick;
  final double? width,height;
  final Color? color;
  const DropDownWidget({required this.dropDownClass,Key? key, required this.afterClick, this.width, this.height, this.color}) : super(key: key);
  @override
  State<DropDownWidget> createState() => _DropDownWidgetState(dropDownClass);
}

class _DropDownWidgetState extends State<DropDownWidget> {
  DropDownClass dropDownClass;
  _DropDownWidgetState(this.dropDownClass);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: (){
                showDropDownDialog(dropDownClass).then((value) {
                  setState((){});
                  widget.afterClick();
                });
              },
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color:widget.color?? AppColor.defaultColor),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w,vertical: 0.5.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(dropDownClass.displayedName(),maxLines: 1,
                        style: TextStyleClass.normalStyle(color: widget.color !=null? Colors.black: AppColor.defaultColor),),
                      SizedBox(width: 1.w,),
                      const Icon(Icons.arrow_downward,color:Colors.black,size: 20,),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
