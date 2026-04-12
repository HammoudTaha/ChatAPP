import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:chatapp/core/errors/exceptions.dart';
import 'package:chatapp/core/utils/enums.dart';
import 'package:http/http.dart' as http;
import '../constants/strings.dart';

class ApiService {
  const ApiService();
  Future<dynamic> request({
    HttpMethods method = HttpMethods.post,
    required String endpoint,
    Map<String, dynamic>? data,
    String? token,
  }) async {
    try {
      final uri = Uri.parse('${AppStrings.baseUrl}$endpoint');
      final headers = {
        'Content-Type': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
      http.Response response;
      switch (method) {
        case HttpMethods.get:
          response = await http
              .get(uri.replace(queryParameters: data), headers: headers)
              .timeout(const Duration(seconds: 20));
          break;

        case HttpMethods.post:
          response = await http
              .post(uri, headers: headers, body: jsonEncode(data))
              .timeout(const Duration(seconds: 20));
          break;
      }
      print(response.body);
      print(response.statusCode);
      return errorHandling(response);
    } on SocketException catch (_) {
      throw const NoInternatException();
    } on TimeoutException catch (_) {
      throw const ConnectTimeoutException();
    }
  }
}
