import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

Future<List<dynamic>> getPresignedUrls({
  required List<String> fileNames,
  required String baseUrl,
  required String username,
  required String password,
  String folder = 'user',
}) async {
  var response = await http.post(
    Uri.parse('$baseUrl/storages/presign/list'),
    headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$username:$password'))}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      'file_names': fileNames,
      'folder': folder,
    }),
  );

  if (response.statusCode == 200 || response.statusCode == 201) {
    return jsonDecode(response.body);
  } else {
    throw Exception("Failed to get presigned URLs. Status: ${response.statusCode}, Body: ${response.body}");
  }
}

Future<List<String>> uploadImages({
  required List<dynamic> presignData,
  required List<File> pickedImages,
  required void Function(int progress) onProgress,
}) async {
  List<String> uploadedUrls = [];

  for (int i = 0; i < pickedImages.length; i++) {
    var image = pickedImages[i];
    var uploadUrl = presignData[i]['upload_url'];
    var downloadUrl = presignData[i]['download_url'];

     var uploadResponse = await http.put(
        Uri.parse(uploadUrl),
        headers: {'Content-Type': 'image/jpeg'},
        body: await image.readAsBytes(),
      );

      if (uploadResponse.statusCode == 200 || uploadResponse.statusCode == 201) {
        int progress = ((i + 1) / pickedImages.length * 100).floor();
        onProgress(progress);
      } else {
        throw Exception("Failed to upload image: ${image.path}. Status: ${uploadResponse.statusCode}");
      }

    uploadedUrls.add(downloadUrl);
  }

  return uploadedUrls;
}
