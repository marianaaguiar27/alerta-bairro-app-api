
import 'package:flutter/material.dart';

class DetalheRegiaoScreen extends StatelessWidget {
  final String nome;
  final String risco;
  final String nivelAgua;
  final String orientacao;

  const DetalheRegiaoScreen({
    super.key,
    required this.nome,
    required this.risco,
    required this.nivelAgua,
    required this.orientacao,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        title: const Text(
          'Detalhes da região',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nome,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B63),
              ),
            ),

            const SizedBox(height: 24),

            Card(
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 38,
                ),
                title: const Text(
                  'Nível de risco',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                subtitle: Text(
                  risco,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(
                  Icons.water,
                  color: Colors.blue,
                  size: 38,
                ),
                title: const Text(
                  'Nível da água',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
                subtitle: Text(
                  nivelAgua,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111111),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Orientações de segurança',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: Color(0xFF111111),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                orientacao,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                  color: Color(0xFF111111),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Informações demonstrativas. Dados simulados.',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
