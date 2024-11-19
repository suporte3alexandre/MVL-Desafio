import 'package:desafio_modelviewlabs/auth_service.dart';
import 'package:desafio_modelviewlabs/success_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _validatePassword() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    String password = _passwordController.text;

    try {
      var response = await AuthService.validatePassword(password, context);

      if (response != null && response['message'] == 'Senha válida!') {
        setState(() {
          _isLoading = false;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const SuccessScreen(message: 'Login realizado com sucesso')),
        );
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Senha inválida. Tente novamente.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Erro ao tentar validar a senha: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tela de Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Digite a Senha',
                errorText: _errorMessage,
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _validatePassword,
                    child: const Text('Validar Senha'),
                  ),
          ],
        ),
      ),
    );
  }
}
