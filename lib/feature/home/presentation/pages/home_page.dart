import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/drop_down_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../../category/presentation/provider/category_provider.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../../../option/presentation/provider/options_provider.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../../product/presentation/provider/search_product_provider.dart';
import '../../../product/presentation/widgets/product_widget.dart';
import '../../../product/presentation/widgets/shimmer/shimmer_product_widget.dart';
import '../../../slider/presentation/widgets/slider_widget.dart';
import '../provider/home_provider.dart';
import '../widgets/warning_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    SearchProductProvider searchProductProvider = Provider.of(context,listen: true);
    searchProductProvider.pagination(scrollController);
    return Scaffold(
      bottomSheet: isGuest
          ?Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h,horizontal: 5.w),
            child: ButtonWidget(onTap: (){navPARU(LoginPage());}, text: 'login'),
          ):null,
      body: Consumer<HomeProvider>(
        builder: (context,home,_) {
          return SizedBox(
            width: 100.w,
            height: 100.h,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: RefreshIndicator(
                onRefresh: ()async{
                  if(isGuest){
                    home.getHomeDataGuest(back: false,showLoading: false);
                  }else{
                    home.getHomeData(back: false,showLoading: false);
                  }
                  // Provider.of<OptionsProvider>(context,listen: false).setOption(null);
                  Provider.of<CategoryProvider>(context,listen: false).setCategory(null);
                  searchProductProvider.refresh();
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(height: 2.h,),
                        SliderWidget(sliders: home.sliders,scrollController: ScrollController()),
                        SizedBox(height: 2.h,),
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

                        ...List.generate(searchProductProvider.startSearch?3:
                        searchProductProvider.searchProducts?.length??0, (index) {
                          if(searchProductProvider.startSearch){
                            return const ShimmerProductWidget();
                          }
                          ProductEntity productEntity = searchProductProvider.searchProducts![index];
                          return ProductWidget(productEntity: productEntity,);
                        }),
                        if(searchProductProvider.paginationStarted)SizedBox(
                          width: 100.w,
                          height: 5.h,
                          child: const Stack(
                            children: [
                              LoadingWidget(),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h,),
                        // const WarningWidget(),
                        InkWell(
                          onTap: ()async{
                            final Uri _url = Uri.parse('https://aliweb.ch/');
                            if (!await launchUrl(_url)) throw 'Could not launch $_url';
                          },
                          child: FittedBox(child: Text('Copyright © ${DateTime.now().year} Ali Web. Alle Rechte vorbehalten')),
                        ),
                        // Expanded(
                        //   child: Stack(
                        //     children: [
                        //       ListView.builder(
                        //         controller: scrollController,
                        //         itemCount: searchProductProvider.startSearch?3:searchProductProvider.searchProducts?.length??0,
                        //         physics: const AlwaysScrollableScrollPhysics(),
                        //         itemBuilder: (ctx,i){
                        //           if(searchProductProvider.startSearch){
                        //             return const ShimmerProductWidget();
                        //           }
                        //           ProductEntity productEntity = searchProductProvider.searchProducts![i];
                        //           return ProductWidget(productEntity: productEntity,);
                        //         },
                        //       ),
                        //       if(!searchProductProvider.startSearch&&searchProductProvider.searchProducts!=null
                        //           &&searchProductProvider.searchProducts!.isEmpty)
                        //         const EmptyWidget(title: 'search'),
                        //       if(searchProductProvider.paginationStarted)LoadingWidget(),
                        //     ],
                        //   ),
                        // ),
                        // CategoryPage(categories: home.categories),
                        SizedBox(height: isGuest? 10.h:3.h,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
