import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../domain/entities/product_entity.dart';
import '../provider/new_product_provider.dart';
import '../widgets/product_widget.dart';
import '../widgets/shimmer/shimmer_product_widget.dart';

class NewPage extends StatelessWidget {
  NewPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    NewProductProvider newProductProvider = Provider.of(context,listen: true);
    newProductProvider.pagination(scrollController);
    return SizedBox(
      width: 100.w,
      height: 100.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.w),
        child: RefreshIndicator(
          onRefresh: ()async{
            newProductProvider.refresh();
          },
          child: Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                itemCount: newProductProvider.newProducts?.length??8,
                physics: newProductProvider.newProducts==null?const NeverScrollableScrollPhysics()
                    :const AlwaysScrollableScrollPhysics(),
                itemBuilder: (ctx,i){
                  if(newProductProvider.newProducts==null){
                    return const ShimmerProductWidget();
                  }
                  ProductEntity productEntity = newProductProvider.newProducts![i];
                  return ProductWidget(productEntity: productEntity,);
                },
              ),
              if(newProductProvider.newProducts!=null
                  &&newProductProvider.newProducts!.isEmpty)const EmptyWidget(title: 'new'),
              if(newProductProvider.paginationStarted)const LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
