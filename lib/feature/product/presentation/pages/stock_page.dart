import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../provider/stock_product_provider.dart';
import '../widgets/shimmer/shimmer_product_widget.dart';
import '../widgets/stock_product_widget.dart';

class StockPage extends StatelessWidget {
  StockPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    StockProductProvider stockProductProvider = Provider.of(context,listen: true);
    stockProductProvider.pagination(scrollController);
    return PopScope(
      canPop: true,
      onPopInvoked: (val)async{
        stockProductProvider.clear();
      },
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(LanguageProvider.translate('main', "stock")),
          ),
          body: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.w),
              child: RefreshIndicator(
                onRefresh: ()async{
                  stockProductProvider.refresh();
                },
                child: Column(
                  children: [
                    TextFieldWidget(controller: stockProductProvider.input['value'],
                      prefix: SvgWidget(svg: stockProductProvider.input['image']),hintText: stockProductProvider.input['label'],
                      onChange: stockProductProvider.input['onChange'],
                      onEditingComplete: (){
                        FocusScope.of(context).unfocus();
                        stockProductProvider.input['onComplete'];
                      },),
                    SizedBox(height: 2.h,),
                    Expanded(
                      child: Stack(
                        children: [
                          ListView.builder(
                            itemCount: (stockProductProvider.searchProducts?.length??8),
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (ctx,i){
                              if(stockProductProvider.startSearch){
                                return const ShimmerProductWidget();
                              }

                              ProductEntity productEntity = stockProductProvider.searchProducts![i];
                              return StockProductWidget(productEntity: productEntity,);
                            },
                          ),
                          if(!stockProductProvider.startSearch&&stockProductProvider.searchProducts!=null
                              &&stockProductProvider.searchProducts!.isEmpty)
                            const EmptyWidget(title: 'search'),

                          if(stockProductProvider.paginationStarted)const LoadingWidget(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
