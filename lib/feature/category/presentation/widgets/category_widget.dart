import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../product/presentation/widgets/product_widget.dart';
import '../../domain/entities/category_entity.dart';

class CategoryWidget extends StatelessWidget {
  final int index;
  final CategoryEntity category;
  const CategoryWidget({required this.index,required this.category,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      color: index.isEven?AppColor.lightDefaultColor:AppColor.lightGreyColor,
      child: Padding(
        padding: EdgeInsets.all(3.w),
        child: Column(
          children: [
            Row(
              key: category.key,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColor.defaultColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 1.h),
                    child: Center(
                      child: Text(category.name,style: TextStyleClass.semiStyle(color: Colors.white),),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.5.w,),
            ...List.generate(category.productEntity.length, (index) =>
                ProductWidget(productEntity: category.productEntity[index],)),
          ],
        ),
      ),
    );
  }
}
