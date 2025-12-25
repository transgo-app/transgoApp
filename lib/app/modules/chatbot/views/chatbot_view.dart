import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../controllers/chatbot_controller.dart';
import '../widgets/chatbot.dart';
import '../widgets/empty_chat.dart';
import 'package:transgomobileapp/app/data/theme.dart';
import 'package:transgomobileapp/app/widget/General/text.dart';

class ChatbotPage extends GetView<ChatbotController> {
  const ChatbotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,

        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(
            IconsaxPlusBold.arrow_left_1,
            size: 28,
          ),
        ),
        title: gabaritoText(
          text: 'Gogo Ai',
          fontSize: 16,
          textColor: textHeadline,
        ),
        centerTitle: false,
        // centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return controller.messages.isEmpty
                  ? const ChatbotEmptyView()
                  : const ChatbotChatView();
            }),
          ),
          _InputBar(
            controller: controller,
            textController: textController,
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final ChatbotController controller;
  final TextEditingController textController;

  const _InputBar({
    required this.controller,
    required this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(
              color: Colors.grey.withOpacity(0.15),
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: textController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan di sini...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: primaryColor,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: primaryColor,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() {
              return IconButton(
                onPressed: controller.isLoading.value ? null : _send,
                icon: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(IconsaxPlusBold.send_2),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _send() {
    final text = textController.text.trim();
    if (text.isEmpty) return;

    controller.sendMessage(text);
    textController.clear();
  }
}
