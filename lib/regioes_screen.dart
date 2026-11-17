
import 'package:flutter/material.dart';
import 'detalhe_regiao_screen.dart';

class RegioesScreen extends StatelessWidget {
  const RegioesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        title: const Text(
          'Regiões monitoradas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Acompanhe os níveis de risco das regiões.',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 20),

          regiao(
            context,
            'Jardim São Paulo',
            'Atenção',
            Colors.orange.shade800,
            '1,2 metros',
            'Evite áreas próximas a rios e fique atento aos próximos avisos.',
          ),

          regiao(
            context,
            'Av.Paulista',
            'Alerta',
            Colors.red,
            '1,8 metros',
            'Evite sair de casa se não for necessário. Procure locais seguros.',
          ),

          regiao(
            context,
            'Parque das Flores',
            'Normal',
            Colors.green.shade800,
            '0,3 metros',
            'A situação está normal. Continue acompanhando os avisos.',
          ),

          regiao(
            context,
            'Centro',
            'Emergência',
            Colors.red.shade900,
            '2,5 metros',
            'Afaste-se das áreas alagadas e procure um local seguro.',
          ),
        ],
      ),
    );
  }

  Widget regiao(
    BuildContext context,
    String nome,
    String risco,
    Color cor,
    String nivelAgua,
    String orientacao,
  ) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: const Icon(
          Icons.location_on,
          color: Color(0xFF123B63),
          size: 36,
        ),
        title: Text(
          nome,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        subtitle: const Text(
          'Dados simulados',
          style: TextStyle(
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
        trailing: Text(
          risco,
          style: TextStyle(
            fontSize: 15,
            color: cor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalheRegiaoScreen(
                nome: nome,
                risco: risco,
                nivelAgua: nivelAgua,
                orientacao: orientacao,
              ),
            ),
          );
        },
      ),
    );
  }
}
