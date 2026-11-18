import 'package:flutter/material.dart';

import 'api/regiao_service.dart';
import 'detalhe_regiao_screen.dart';
import 'models/regiao.dart';
import 'widgets/erro_com_retentativa.dart';

class RegioesScreen extends StatefulWidget {
  const RegioesScreen({super.key});

  @override
  State<RegioesScreen> createState() => _RegioesScreenState();
}

class _RegioesScreenState extends State<RegioesScreen> {
  late Future<List<Regiao>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = RegiaoService.listar();
  }

  void _tentarNovamente() {
    setState(() {
      _futuro = RegiaoService.listar();
    });
  }

  Future<void> _atualizar() async {
    final novo = RegiaoService.listar();
    setState(() {
      _futuro = novo;
    });
    try {
      await novo;
    } catch (_) {
      // o erro aparece no FutureBuilder
    }
  }
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
      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: FutureBuilder<List<Regiao>>(
          future: _futuro,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: CircularProgressIndicator()),
                ],
              );
            }

            if (snapshot.hasError) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ErroComRetentativa(
                    erro: snapshot.error!,
                    aoTentarNovamente: _tentarNovamente,
                  ),
                ],
              );
            }

            final regioes = snapshot.data ?? [];

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
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
                if (regioes.isEmpty)
                  const Text(
                    'Nenhuma região cadastrada.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF1F2937)),
                  ),
                ...regioes.map((regiao) => _cartao(context, regiao)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cartao(BuildContext context, Regiao regiao) {
    final risco = regiao.nivelRisco;

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
          regiao.nome,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        subtitle: Text(
          '${regiao.cidade} - ${regiao.uf}',
          style: const TextStyle(
            fontSize: 16,
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1F2937),
          ),
        ),
        trailing: Text(
          risco.rotulo,
          style: TextStyle(
            fontSize: 15,
            color: risco.cor,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalheRegiaoScreen(regiao: regiao),
            ),
          );
        },
      ),
    );
  }
}