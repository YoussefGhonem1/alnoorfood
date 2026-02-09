
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../feature/chat/presentation/provider/message_provider.dart';
import '../helper_function/navigation.dart';
import 'button_widget.dart';

class ImagePreviewWidget extends StatelessWidget {
  final XFile? img;
  final String? imgPath;
  final bool showSendButton;
  final String? heroTag;
  const ImagePreviewWidget({this.img,this.imgPath,Key? key,
    this.showSendButton = true,this.heroTag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: img==null||!showSendButton?null:Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonWidget(onTap: (){
            navPop();
            Provider.of<MessageProvider>(context,listen: false).addMessage(file: img!, type: 'image');
          }, text: 'send'),
          SizedBox(height: 3.h,),
        ],
      ),
      extendBody: true,
      appBar: AppBar(
        // backgroundColor: Colors.black,
        // leading: BackButtonWidget(),
        title: SizedBox(),
      ),
      body: PinchZoom(
        maxScale: 2.5,
        child: Hero(
          tag: heroTag??"",
          child: Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              image: img==null?DecorationImage(
                image: CachedNetworkImageProvider(imgPath!),
                fit: BoxFit.contain,
              ):DecorationImage(
                image: FileImage(File(img!.path)),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
