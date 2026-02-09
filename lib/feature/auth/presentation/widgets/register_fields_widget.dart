import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../../core/constants/var.dart';
import '../../../../core/widget/list_text_field.dart';
import '../provider/auth_provider.dart';
import 'accept_widget.dart';

class RegisterFieldsWidget extends StatelessWidget {
  const RegisterFieldsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider auth = Provider.of(context);
    return Column(
      children: [
        SizedBox(height: 2.h),
        ListTextFieldWidget(inputs: auth.registerInputs,color: Colors.grey.shade300,
        borderColor:Colors.grey.shade300 ,),
        // SizedBox(height: 2.h),
        // if(!auth.fromAuthRegister)
        //   Row(
        //     mainAxisAlignment: MainAxisAlignment.end,
        //     children: [
        //       InkWell(
        //           onTap: () {
        //             Provider.of<ResetPassProvider>(context, listen: false).goToResetPassPage();
        //           },
        //           child: ShaderMask(
        //             shaderCallback: (bounds) => AppColor.gradient.createShader(bounds),
        //             blendMode: BlendMode.srcIn,
        //             child: Text(
        //                 LanguageProvider.translate(
        //                     'login', 'change_password'),
        //                 style: TextStyleClass.normalStyle()),
        //           ))
        //     ],
        //   ),
        if(auth.fromAuthRegister&&!isUser)
          const AcceptWidget(),

      ],
    );
  }
}
