import 'package:flutter/material.dart';

class SuccessScreen extends StatelessWidget {
  final String message;

  const SuccessScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Desafio MVL")),
      body: Center(
        child: Text(message,
            style: const TextStyle(fontSize: 24, color: Colors.green)),
      ),
    );
  }
}
