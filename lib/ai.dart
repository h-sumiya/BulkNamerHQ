import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

const apiBaseUrl = 'https://bnh.hiro.red';

Future<List<String>> getaiFileChanges(
    List<File> files, Map<File, String> patch) async {
  final payload = [];
  for (final file in files) {
    final fileName = p.basename(file.path);
    final extension = p.extension(file.path).substring(1);
    if (patch.containsKey(file)) {
      payload.add([fileName, '${patch[file]}.$extension']);
    } else {
      payload.add([fileName]);
    }
  }
  final response = await http.post(
    Uri.parse('$apiBaseUrl/rename'),
    body: jsonEncode(payload),
    headers: {'Content-Type': 'application/json'},
    encoding: Encoding.getByName('utf-8'),
  );
  final body = jsonDecode(response.body);
  if (response.statusCode != 200) {
    throw Exception(body);
  }
  if (body is! List) {
    throw Exception('API response is not a list');
  }
  if (body.length != files.length) {
    throw Exception('API response length does not match');
  }
  final changes = <String>[];
  for (var i = 0; i < files.length; i++) {
    final name = (body[i] as List).last as String;
    final withOutExtension = p.basenameWithoutExtension(name);
    changes.add(withOutExtension);
  }
  return changes;
}
