import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../config/text_style.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widget/button_widget.dart';
import '../../../../core/widget/logo_widget.dart';
import '../../../../core/widget/svg_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/otp_provider.dart';

class ForgetPage extends StatelessWidget {
  ForgetPage({Key? key}) : super(key: key);
  final TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(LanguageProvider.translate("forget_pass", "title")),
          ),
          body: Center(
            child: SizedBox(
              width: 94.w,
              height: 100.h,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LogoWidget(width: 80.w,),
                      ],
                    ),
                    SizedBox(height: 7.h,),
                    Text(LanguageProvider.translate("forget_pass", "title"),style:
                      TextStyleClass.semiHeadStyle(),),
                    SizedBox(height: 4.h,),
                    Text(LanguageProvider.translate("forget_pass", "enter_email"),style:
                    TextStyleClass.smallStyle(color: Colors.grey),),
                    TextFieldWidget(controller: email,
                      hintText: 'email',prefix: SvgWidget(svg: Images.emailSVG,),),
                    SizedBox(height: 6.h,),
                    ButtonWidget(onTap: (){
                      Provider.of<OTPProvider>(context,listen: false).checkEmail(email.text);
                    }, text: "send"),
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
