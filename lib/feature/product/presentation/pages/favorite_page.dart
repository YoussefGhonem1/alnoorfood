import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../domain/entities/product_entity.dart';
import '../provider/favorite_product_provider.dart';
import '../widgets/product_widget.dart';
import '../widgets/shimmer/shimmer_product_widget.dart';

class FavoritePage extends StatelessWidget {
  FavoritePage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    FavoriteProductProvider favoriteProductProvider = Provider.of(context,listen: true);
    favoriteProductProvider.pagination(scrollController);
    return SizedBox(
      width: 100.w,
      height: 100.h,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.w),
        child: RefreshIndicator(
          onRefresh: ()async{
            favoriteProductProvider.refresh();
          },
          child: Stack(
            children: [
              ListView.builder(
                controller: scrollController,
                itemCount: favoriteProductProvider.favoriteProducts?.length??8,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (ctx,i){
                  if(favoriteProductProvider.favoriteProducts==null){
                    return const ShimmerProductWidget();
                  }
                  ProductEntity productEntity = favoriteProductProvider.favoriteProducts![i];
                  return ProductWidget(productEntity: productEntity,);
                },
              ),
              if(favoriteProductProvider.favoriteProducts!=null
                  &&favoriteProductProvider.favoriteProducts!.isEmpty)const EmptyWidget(title: 'favorite'),

              if(favoriteProductProvider.paginationStarted)const LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
