import 'dart:convert';
import 'package:http/http.dart' as http;

class GithubService {
  static Future<Map<String, dynamic>> fetchGithubUser(String apiURL, String username) async {
    try {
      final response = await http.get(
        Uri.parse('$apiURL$username'),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        return {'error': 'Error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'error': 'Error fetching user'};
    }
  }

  static Future<List<dynamic>> fetchGithubRepositories(String apiURL) async {
    try {
      final response = await http.get(
        Uri.parse('$apiURL'),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body) as List<dynamic>;
      } else {
        throw Exception('Error al obtener los repositorios: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al obtener los repositorios');
    }
  }
}
