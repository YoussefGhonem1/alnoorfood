import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/drop_down_widget.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../cart/presentation/provider/cart_provider.dart';
import '../../../category/presentation/provider/category_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../option/presentation/provider/options_provider.dart';
import '../../domain/entities/product_entity.dart';
import '../provider/search_product_provider.dart';
import '../widgets/product_widget.dart';
import '../widgets/shimmer/shimmer_product_widget.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    SearchProductProvider searchProductProvider = Provider.of(context,listen: true);
    searchProductProvider.pagination(scrollController);
    return PopScope(
      canPop: true,
      onPopInvoked: (val)async{
        searchProductProvider.clear();
      },
      child: GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(LanguageProvider.translate("main", "search")),
            actions: [
              searchProductProvider.fromDelivery?InkWell(
                onTap: (){
                  Provider.of<CartProvider>(Constants.globalContext(),listen: false).refresh();
                  navP(const CartPage());
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Badge(
                      alignment: Alignment.topRight,
                      textStyle: TextStyleClass.smallStyle(),
                      label: Text((Provider.of<CartProvider>(context,listen: true).cartProducts?.length??0).toString(),
                      style: TextStyleClass.smallStyle(color: Colors.white),),
                      backgroundColor: AppColor.defaultColor,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(Icons.shopping_cart,color: AppColor.defaultColor,
                        size: Constants.isTablet?40:20,),
                      ),
                    ),
                  ],
                ),
              ):InkWell(
                onTap: (){
                  // Provider.of<OptionsProvider>(context,listen: false).setOption(null);
                  Provider.of<CategoryProvider>(context,listen: false).setCategory(null);
                  searchProductProvider.refresh();
                },
                child: Row(
                  children: [
                    Text(LanguageProvider.translate('global', 'reset'),
                      style: TextStyleClass.normalStyle(color: AppColor.defaultColor),),
                    SizedBox(width: 2.w,),
                    Icon(Icons.restart_alt,color: AppColor.defaultColor,size: Constants.isTablet?40:20,),
                  ],
                ),
              ),
              SizedBox(width: 5.w,),
            ],
          ),
          body: SizedBox(
            width: 100.w,
            height: 100.h,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 2.w),
              child: Column(
                children: [
                  TextFieldWidget(controller: searchProductProvider.input['value'],
                    prefix: SvgWidget(svg: searchProductProvider.input['image']),hintText: searchProductProvider.input['label'],
                    onChange: searchProductProvider.input['onChange'],
                    onEditingComplete: (){
                      FocusScope.of(context).unfocus();
                      searchProductProvider.input['onComplete'];
                    },),
                  Row(
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(LanguageProvider.translate('global', 'category'),style: TextStyleClass.normalStyle(),),
                              SizedBox(height: 1.h,),
                              DropDownWidget(dropDownClass: Provider.of<CategoryProvider>(context,listen: false),
                                  afterClick: (){
                                    String text = searchProductProvider.input['value'].text;
                                    searchProductProvider.clear();
                                    searchProductProvider.input['value'].text = text;
                                    searchProductProvider.search();
                                  }),
                            ],
                          ),
                          SizedBox(width: 7.w,),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(LanguageProvider.translate('global', 'sub_category'),style: TextStyleClass.normalStyle(),),
                          //     SizedBox(height: 1.h,),
                          //     DropDownWidget(dropDownClass: Provider.of<OptionsProvider>(context,listen: false),
                          //       afterClick: (){
                          //         String text = searchProductProvider.input['value'].text;
                          //         searchProductProvider.clear();
                          //         searchProductProvider.input['value'].text = text;
                          //         searchProductProvider.search();
                          //       },),
                          //   ],
                          // ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h,),
                  Expanded(
                    child: Stack(
                      children: [
                        ListView.builder(
                          controller: scrollController,
                          itemCount: searchProductProvider.startSearch?3:searchProductProvider.searchProducts?.length??0,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (ctx,i){
                            if(searchProductProvider.startSearch){
                              return const ShimmerProductWidget();
                            }
                            ProductEntity productEntity = searchProductProvider.searchProducts![i];
                            return ProductWidget(productEntity: productEntity,);
                          },
                        ),
                        if(!searchProductProvider.startSearch&&searchProductProvider.searchProducts!=null
                            &&searchProductProvider.searchProducts!.isEmpty)
                          const EmptyWidget(title: 'search'),
                        if(searchProductProvider.paginationStarted)const LoadingWidget(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
