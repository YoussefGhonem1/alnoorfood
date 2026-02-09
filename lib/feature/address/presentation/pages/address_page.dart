import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/address_provider.dart';
import '../widgets/address_widget.dart';
import '../widgets/shimmer_address_widget.dart';

class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageProvider.translate("address", "title")),
      ),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w,vertical: 2.h),
          child: RefreshIndicator(
            onRefresh: ()async{
              Provider.of<AddressProvider>(context,listen: false).refresh();
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Consumer<AddressProvider>(
                builder: (context,addressProvider,_) {
                  if(addressProvider.address==null){
                    return Column(
                      children: [
                        ...List.generate(3, (index) => const ShimmerAddressWidget()),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      ...List.generate(addressProvider.address!.length, (index) =>
                          AddressWidget(addressEntity: addressProvider.address![index],)),
                      SizedBox(height: 2.h,),
                      ButtonWidget(onTap: (){
                        Provider.of<AddressProvider>(context,listen: false).goMapPage();
                      }, text: "add_address",widgetAfterText: false,
                        widget: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 3.w),
                          child: const SvgWidget(svg: Images.addSVG,),
                        ),color: AppColor.lightDefaultColor,
                        textStyle: TextStyleClass.semiStyle(),
                      borderColor: AppColor.lightGreyColor,),
                    ],
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
