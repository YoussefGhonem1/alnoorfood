import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/widget/empty_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/material_provider.dart';
import '../widgets/material_widget.dart';
import '../widgets/shimmer_material_widget.dart';

class MaterialsPage extends StatelessWidget {
  MaterialsPage({Key? key}) : super(key: key);
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    MaterialProvider materialProvider = Provider.of(context,listen: true);
    materialProvider.pagination(scrollController);
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate("settings", "material")),
      ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
          child: RefreshIndicator(
            onRefresh: ()async{
              materialProvider.refresh();
            },
            child: Stack(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 4.w,
                  controller: scrollController,
                  mainAxisSpacing: 4.w,
                  children: List.generate(materialProvider.materials?.length??8, (index) {
                    if(materialProvider.materials==null){
                      return const ShimmerMaterialWidget();
                    }
                    else{
                      return MaterialWidget(materialEntity: materialProvider.materials![index],);
                    }
                  }),
                ),
                if(materialProvider.materials!=null
                    &&materialProvider.materials!.isEmpty)const EmptyWidget(title: 'material'),
                if(materialProvider.paginationStarted) const LoadingWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
