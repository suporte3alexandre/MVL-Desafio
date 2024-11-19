import 'dart:async';
import 'dart:convert';

import 'package:desafio_modelviewlabs/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'https://desafioflutter-api.modelviewlabs.com';

  static Future<Map<String, dynamic>?> validatePassword(
      String password, BuildContext context) async {
    final url = Uri.parse('$_baseUrl/validate');

    try {
      final response = await http
          .post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'password': password}),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw TimeoutException('Tempo de requisição excedido');
        },
      );

      print("Resposta da API: ${response.body}");

      if (response.statusCode == 202) {
        return _handleSuccess(response, context);
      } else if (response.statusCode == 503) {
        return _handleError(response, context,
            errorMessage:
                'Serviço temporariamente indisponível. Tente novamente mais tarde.');
      } else {
        return _handleError(response, context);
      }
    } catch (e) {
      return _handleError(null, context, errorMessage: e.toString());
    }
  }

  static Future<Map<String, dynamic>?> _handleSuccess(
      http.Response response, BuildContext context) async {
    final data = json.decode(response.body);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );

    return data;
  }

  static Map<String, dynamic> _handleError(
      http.Response? response, BuildContext context,
      {String? errorMessage}) {
    String message = errorMessage ??
        (response != null
            ? json.decode(response.body)['message']
            : 'Erro desconhecido');
    _showErrorDialog(context, message);
    return {'message': message};
  }

  static void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
