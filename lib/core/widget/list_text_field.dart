import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../config/text_style.dart';
import '../../feature/language/presentation/provider/language_provider.dart';
import '../constants/constants.dart';
import '../models/text_field_model.dart';
import 'svg_widget.dart';
import 'text_field.dart';

class ListTextFieldWidget extends StatelessWidget {
  const ListTextFieldWidget({super.key, required this.inputs, this.style, this.color, this.borderColor, this.isGradient});
  final List<TextFieldModel> inputs;
  final TextStyle? style;
  final bool? isGradient;
  final Color? color;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    List telInputs = ['phone','whats'];
    return Column(
      children: List.generate(
        inputs.length,
        (index) {
          TextFieldWidget textFieldWidget = TextFieldWidget(
            titleWidget: inputs[index].label != null
                ? Row(
                    children: [
                      if (inputs[index].image != null)
                        SvgWidget(
                          svg: inputs[index].image!,
                          width: Constants.isTablet ? 5.w : null,
                        ),
                      if (inputs[index].image != null)
                        SizedBox(
                          width: 2.w,
                        ),
                      Text(LanguageProvider.translate('inputs', inputs[index].label!),
                          style:style?? TextStyleClass.semiStyle(color: Colors.black))
                    ],
                  )
                : null,
            color: color,
            borderColor: borderColor,
            // isLabel: inputs[index].isLabel ?? false,
            // maxLength: telInputs.contains(inputs[index].key)?9:null,
            controller: inputs[index].controller,
            keyboardType: inputs[index].textInputType,
            next: inputs.length - 1 != index,
            hintText: inputs[index].hint,
            onTextTap: inputs[index].onTap,
            minLines: inputs[index].min,
            maxLines: inputs[index].max,
            validator: inputs[index].validator,
            obscureText: inputs[index].obscureText,
            // suffix: telInputs.contains(inputs[index].key) ? isGradient !=null?ShaderMask(
            //   shaderCallback : (bounds) => AppColor.gradient.createShader(bounds),
            //   blendMode: BlendMode.srcIn,
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 4.w),
            //         child: Text("966+" ,style: TextStyleClass.semiStyle(),),
            //       ),
            //     ],
            //   ),
            // ):Padding(
            //         padding: EdgeInsets.symmetric(horizontal: 4.w),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Builder(builder: (context) {
            //               return Text(
            //                 '966+',
            //                 style: TextStyleClass.semiStyle(color: AppColor.defaultColor.withOpacity(0.5)),
            //               );
            //             }),
            //           ],
            //         ),
            //       )
            //     : inputs[index].suffix,
            prefix: inputs[index].prefix,
            readOnly: inputs[index].readOnly,
            width: inputs[index].width,
            // contentPadding: inputs[index].contentPadding,
          );
          return textFieldWidget;
        },
      ),
    );
  }
}
