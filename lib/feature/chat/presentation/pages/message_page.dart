import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/helper_function/helper_function.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/message_provider.dart';
import '../widgets/messages_widget.dart';
import '../widgets/send_message_widget.dart';
import '../widgets/shimmer_message_widget.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});
  @override
  Widget build(BuildContext context) {
    MessageProvider messageProvider = Provider.of(context);
    if (messageProvider.chatEntity != null) {
      delay(300).then((value) {
        messageProvider.scrollToBottom();
      });
    }
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(LanguageProvider.translate("settings", 'support')),
        ),
        body: Builder(builder: (context) {
          if (messageProvider.chatEntity == null) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.h),
              child: SingleChildScrollView(
                  child: Column(
                children: List.generate(8, (index) => const ShimmerMessageWidget()),
              )),
            );
          }
          return Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Row(
                    //   children: [
                    //     if (messageProvider.chatEntity!.date!.isAfter(DateTime.now())) const MessageTitleWidget(),
                    //   ],
                    // ),
                    SizedBox(height: 1.h),
                    const MessagesWidget()
                  ],
                ),
              ),
              const SendMessageWidget(),
            ],
          );
        }),
      ),
    );
  }
}
