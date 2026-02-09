
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:homsfood/core/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:social_media_recorder/audio_encoder_type.dart';
import 'package:social_media_recorder/screen/social_media_recorder.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/helper_function/convert.dart';
import '../../../../core/helper_function/helper_function.dart';
import '../../../../core/helper_function/image.dart';
import '../../../../core/helper_function/navigation.dart';
import '../../../../core/widget/img_preview_widget.dart';
import '../../../../core/widget/text_field.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/message_provider.dart';

class SendMessageWidget extends StatelessWidget {
  const SendMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MessageProvider messageProvider = Provider.of(context);
    GlobalKey btnKey = GlobalKey();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 100.w,
        decoration: BoxDecoration(
            color: AppColor.defaultColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 0.8.h,),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                messageProvider.controller.text.isEmpty? SocialMediaRecorder(
                  sendRequestFunction: (soundFile,time) async{
                    await delay(100);
                    messageProvider.addMessage(file: soundFile,type: 'audio',sec: convertToSeconds(time));

                  },
                  recordIconWhenLockBackGroundColor: Colors.transparent,

                  recordIconWhenLockedRecord: Icon(
                    Icons.send,
                    textDirection: TextDirection.ltr,
                    size: Constants.isTablet?40: 18,
                    color: Colors.white,
                  ),

                  slideToCancelTextStyle: TextStyleClass.normalStyle(color: Colors.white),
                  cancelTextStyle: TextStyleClass.normalStyle(color: Colors.white),
                  counterTextStyle: TextStyleClass.normalStyle(color: Colors.white),
                  recordIconBackGroundColor: Colors.transparent,
                  fullRecordPackageHeight: 6.h,
                  counterBackGroundColor: Colors.transparent,
                  cancelText: LanguageProvider.translate('buttons', 'cancel'),
                  slideToCancelText: LanguageProvider.translate('global', 'slide_to_cancel'),
                  cancelTextBackGroundColor: Colors.transparent,
                  recordIcon: Icon(Icons.mic,color: Colors.white,size: Constants.isTablet?40:30,),
                  backGroundColor: Colors.transparent,

                ):
                InkWell(
                  onTap: (){
                    FocusScope.of(context).unfocus();
                    messageProvider.addMessage(type: 'text');
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 1.5.h),
                    child: Icon(Icons.send,color: Colors.white,size: Constants.isTablet?40:30,
                      textDirection: TextDirection.ltr,
                    ),
                  ),
                ),
                if(messageProvider.controller.text.isNotEmpty)SizedBox(width: 2.5.w,),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        key:btnKey,
                        onTap: ()async{
                          XFile? image = await chooseImage();
                          if(image!=null){
                            navP(ImagePreviewWidget(img: image,));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1.5.h),
                          child: Icon(Icons.image,color: Colors.white,size:Constants.isTablet?40: 30,),
                        ),
                      ),
                      SizedBox(width: 2.5.w,),
                      Expanded(
                        child: TextFieldWidget(controller: messageProvider.controller,
                          maxLines: 3,
                          minLines: 1,
                          cursorColor: Colors.black,
                          // height: 5.h,
                          counter: "",
                          onChange: (val){
                            messageProvider.rebuild();

                          },
                          style: TextStyleClass.normalStyle(color: Colors.black),
                          contentPadding: 0.7.h,
                          color: Colors.white,borderRadius: 15,borderColor: Colors.transparent,),
                      ),
                      SizedBox(width: 2.w,),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
