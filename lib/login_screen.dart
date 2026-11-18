import 'package:flutter/material.dart';

import 'api/api_client.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool _carregando = false;
  bool _ocultarSenha = true;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    try {
      await ApiClient.instancia.login(_emailController.text, _senhaController.text);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/inicio');
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.mensagem),
          backgroundColor: const Color(0xFFB71C1C),
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  InputDecoration _decoracao(String rotulo, IconData icone) {
    return InputDecoration(
      labelText: rotulo,
      prefixIcon: Icon(icone, color: const Color(0xFF123B63)),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      errorStyle: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Color(0xFFB71C1C),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        title: const Text('Entrar', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.location_city, size: 55, color: Color(0xFF123B63)),
            const SizedBox(height: 12),
            const Text(
              'AlertaBairro',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B63),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Entre para acompanhar os alertas e reportar ocorrências na sua região.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: _decoracao('E-mail', Icons.email),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Preencha este campo';
                }
                if (!valor.contains('@')) {
                  return 'Digite um e-mail válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _senhaController,
              obscureText: _ocultarSenha,
              decoration: _decoracao('Senha', Icons.lock).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(_ocultarSenha ? Icons.visibility : Icons.visibility_off),
                  onPressed: () => setState(() => _ocultarSenha = !_ocultarSenha),
                ),
              ),
              validator: (valor) {
                if (valor == null || valor.isEmpty) {
                  return 'Preencha este campo';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _carregando ? null : _entrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123B63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _carregando
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white),
                    )
                  : const Text(
                      'Entrar',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}