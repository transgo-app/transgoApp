import '../../../data/data.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import '../../../widget/widgets.dart';

class ChatbotController extends GetxController {
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isTyping = false.obs;

  bool get isEmptyChat => messages.isEmpty;

  Future<void> sendMessage(String question) async {
    if (question.trim().isEmpty) return;

    _addMessage('user', question);
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
      final String endpoint =
          isAuthenticated ? '/ai-chat/chat/authenticated' : '/ai-chat/chat';

      final Map<String, dynamic> payload = {'question': question};
      final dynamic response = await APIService().post(endpoint, payload);

      if (response is! Map<String, dynamic>) {
        _addSystemMessage('Respons tidak valid dari server.');
        return;
      }

      final String answer = response['answer'] ?? '';
      final String status = response['status'] ?? '';
      final String? suggestion = response['suggestion'];

      if (answer.isNotEmpty) _addMessage('ai', answer);
      if (status == 'error' && suggestion != null) {
        _addSystemMessage(suggestion);
      }
    } catch (_) {
      _addSystemMessage('Terjadi kesalahan sistem. Silakan coba kembali.');
    } finally {
      isTyping.value = false;
      isLoading.value = false;
    }
  }

  void _addMessage(String role, String message) {
    messages.add({
      'role': role,
      'message': message,
      'time': DateTime.now().toIso8601String(),
    });
  }

  void _addSystemMessage(String message) {
    _addMessage('system', message);
  }
}

class CmsController extends GetxController {
  final RxList<Map<String, dynamic>> cmsList = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCms();
  }

  Future<void> fetchCms() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('https://api.transgo.id/api/v1/cms/active'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          cmsList.assignAll(List<Map<String, dynamic>>.from(data));
        } else if (data is Map<String, dynamic>) {
          cmsList.assignAll([data]);
        }
      } else {
        CustomSnackbar.show(
          title: "Terjadi Kesalahan",
          message: "Gagal mengambil data CMS",
        );
      }
    } catch (_) {
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Terjadi kesalahan sistem. Silakan coba kembali.",
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> openCms(String slug) async {
    final Uri url = Uri.parse('https://transgo.com/$slug');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      CustomSnackbar.show(
        title: "Terjadi Kesalahan",
        message: "Tidak bisa membuka link",
      );
    }
  }
}
