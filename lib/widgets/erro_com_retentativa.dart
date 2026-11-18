import 'package:flutter/material.dart';

import '../api/api_client.dart';
import '../login_screen.dart';

class ErroComRetentativa extends StatelessWidget {
  final Object erro;
  final VoidCallback aoTentarNovamente;

  const ErroComRetentativa({
    super.key,
    required this.erro,
    required this.aoTentarNovamente,
  });

  @override
  Widget build(BuildContext context) {
    final e = erro;
    final sessaoExpirada = e is SessaoExpiradaException;
    final mensagem =
        e is ApiException ? e.mensagem : 'Algo deu errado. Tente novamente.';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.cloud_off, size: 56, color: Color(0xFF123B63)),
          const SizedBox(height: 16),
          Text(
            mensagem,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: sessaoExpirada
                ? () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (rota) => false,
                    )
                : aoTentarNovamente,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF123B63),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              sessaoExpirada ? 'Fazer login novamente' : 'Tentar novamente',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}