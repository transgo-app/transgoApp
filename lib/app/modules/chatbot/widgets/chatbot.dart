import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transgomobileapp/app/data/data.dart';
import '../controllers/chatbot_controller.dart';

class ChatbotChatView extends GetView<ChatbotController> {
  const ChatbotChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ChatList();
  }
}

class _ChatList extends StatefulWidget {
  const _ChatList();

  @override
  State<_ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<_ChatList> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatbotController>();

    return Obx(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
          );
        }
      });

      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount:
            controller.messages.length + (controller.isTyping.value ? 1 : 0),
        itemBuilder: (context, index) {
          if (controller.isTyping.value &&
              index == controller.messages.length) {
            return const _TypingBubble();
          }

          final message = controller.messages[index];
          final String role = message['role'];
          final String text = message['message'];
          final DateTime time = DateTime.parse(message['time']);
          final bool isUser = role == 'user';

          return Column(
            crossAxisAlignment:
                isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Align(
                alignment:
                    isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  decoration: BoxDecoration(
                    color: _bubbleColor(context, role),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isUser ? 14 : 2),
                      bottomRight: Radius.circular(isUser ? 2 : 14),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser
                          ? Colors.white
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  DateFormat('HH:mm').format(time),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Color _bubbleColor(BuildContext context, String role) {
    if (role == 'user') {
      return primaryColor;
    }
    if (role == 'ai') {
      return Theme.of(context).colorScheme.surfaceVariant;
    }
    return Colors.red.withOpacity(0.1);
  }
}

class _TypingBubble extends StatelessWidget {
  const _TypingBubble();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const SizedBox(
          width: 36,
          child: _DotTyping(),
        ),
      ),
    );
  }
}

class _DotTyping extends StatefulWidget {
  const _DotTyping();

  @override
  State<_DotTyping> createState() => _DotTypingState();
}

class _DotTypingState extends State<_DotTyping>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final count = (_controller.value * 6).floor() + 1;
        return Text(
          '.' * count,
          style: TextStyle(
            fontSize: 18,
            color: primaryColor,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
