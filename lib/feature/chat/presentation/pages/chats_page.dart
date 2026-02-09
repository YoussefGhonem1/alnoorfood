import 'package:flutter/material.dart';
import 'package:homsfood/core/widget/empty_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../config/app_color.dart';
import '../../../../config/text_style.dart';
import '../../../../core/widget/animation/fade_transition_widget.dart';
import '../../../../core/widget/loading_widget.dart';
import '../../../language/presentation/provider/language_provider.dart';
import '../provider/chat_provider.dart';
import '../widgets/chat_widget.dart';
import '../widgets/shimmer_chat_widget.dart';

class ChatsPage extends StatelessWidget {
  ChatsPage({super.key});
  final ScrollController controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    ChatProvider chatProvider = Provider.of(context);
    chatProvider.pagination(controller);
    return Scaffold(
      appBar: AppBar(title: Text(LanguageProvider.translate('settings', 'support_live'), style: TextStyleClass.headBoldStyle()), centerTitle: true, elevation: 0),
      body: SizedBox(
        width: 100.w,
        height: 100.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: FadeTransitionWidget(
            durationMilliSec: 1000,
            child: Container(
              key: ValueKey<bool>(chatProvider.chats != null),
              child: Column(
                children: [
                  if (chatProvider.chats != null && chatProvider.chats!.isEmpty)
                    Column(
                      children: [
                        EmptyWidget(title: "chat"),
                      ],
                    ),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        chatProvider.refresh();
                      },
                      color: AppColor.defaultColor,
                      child: SizedBox(
                        width: 100.w,
                        height: 100.h,
                        child: ListView.builder(
                          controller: controller,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: chatProvider.chats?.length ?? 3,
                          itemBuilder: (ctx, i) {
                            if (chatProvider.chats == null) {
                              return const ShimmerChatWidget();
                            }
                            return ChatWidget(
                              chatEntity: chatProvider.chats![i],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (chatProvider.paginationStarted) const LoadingWidget(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
