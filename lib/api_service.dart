import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class ApiService {
  static const String baseUrl = 'https://crudcrud.com/api/46f06da0cf4d410386fc94f51ac12f6e';
  final Logger _logger = Logger('ApiService');

  // Helper untuk menangani error dan mencetak log
  void _logError(dynamic error, String methodName) {
    _logger.severe('Error in $methodName: $error');
  }

  Future<bool> registerUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/users');
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await http.post(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 201) {
        return true;
      } else {
        _logError(response.body, 'registerUser');
        return false;
      }
    } catch (error) {
      _logError(error, 'registerUser');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/users');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);
        for (var user in users) {
          if (user['username'] == username && user['password'] == password) {
            return user;
          }
        }
        return null;
      } else {
        _logError(response.body, 'loginUser');
        return null;
      }
    } catch (error) {
      _logError(error, 'loginUser');
      return null;
    }
  }

  Future<bool> updateUser(String id, String username, String password) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await http.put(url, body: body, headers: {'Content-Type': 'application/json'});
      if (response.statusCode == 200) {
        return true;
      } else {
        _logError(response.body, 'updateUser');
        return false;
      }
    } catch (error) {
      _logError(error, 'updateUser');
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    final url = Uri.parse('$baseUrl/users/$id');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        _logError(response.body, 'deleteUser');
        return false;
      }
    } catch (error) {
      _logError(error, 'deleteUser');
      return false;
    }
  }
}