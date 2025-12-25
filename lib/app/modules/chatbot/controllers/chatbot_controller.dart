import 'package:get/get.dart';
import '../../../data/data.dart';

class ChatbotController extends GetxController {
  RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  RxBool isLoading = false.obs;
  RxBool isTyping = false.obs;

  bool get isEmptyChat => messages.isEmpty;

  Future<void> sendMessage(String question) async {
    if (question.trim().isEmpty) return;

    messages.add({
      'role': 'user',
      'message': question,
      'time': DateTime.now().toIso8601String(),
    });

    await _sendToAI(question);
  }

  Future<void> sendTemplate(String template) async {
    await sendMessage(template);
  }

  Future<void> _sendToAI(String question) async {
    isLoading.value = true;
    isTyping.value = true;

    try {
      final bool isAuthenticated = GlobalVariables.token.value.isNotEmpty;

      final String endpoint = isAuthenticated
          ? '/ai-chat/chat/authenticated'
          : '/ai-chat/chat';

      final Map<String, dynamic> payload = {
        'question': question,
      };

      final dynamic response = await APIService().post(endpoint, payload);

      if (response is! Map<String, dynamic>) {
        _addSystemMessage(
          'Respons tidak valid dari server.',
        );
        return;
      }

      final String answer = response['answer'] ?? '';
      final String status = response['status'] ?? '';
      final String? suggestion = response['suggestion'];

      if (answer.isNotEmpty) {
        messages.add({
          'role': 'ai',
          'message': answer,
          'time': DateTime.now().toIso8601String(),
        });
      }

      if (status == 'error' && suggestion != null) {
        _addSystemMessage(suggestion);
      }
    } catch (_) {
      _addSystemMessage(
        'Terjadi kesalahan sistem. Silakan coba kembali.',
      );
    } finally {
      isTyping.value = false;
      isLoading.value = false;
    }
  }

  void _addSystemMessage(String message) {
    messages.add({
      'role': 'system',
      'message': message,
      'time': DateTime.now().toIso8601String(),
    });
  }
}
