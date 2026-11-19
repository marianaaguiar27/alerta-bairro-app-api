import 'package:flutter/material.dart';

import 'api/api_client.dart';
import 'api/ocorrencia_service.dart';
import 'api/regiao_service.dart';
import 'models/ocorrencia.dart';
import 'models/regiao.dart';
import 'models/regiao_selecionada.dart';
import 'reportar_ocorrencia_screen.dart';
import 'widgets/erro_com_retentativa.dart';

class _DadosOcorrencias {
  final Regiao regiao;
  final List<Ocorrencia> ocorrencias;

  const _DadosOcorrencias({required this.regiao, required this.ocorrencias});
}

class OcorrenciasScreen extends StatefulWidget {
  const OcorrenciasScreen({super.key});

  @override
  State<OcorrenciasScreen> createState() => _OcorrenciasScreenState();
}

class _OcorrenciasScreenState extends State<OcorrenciasScreen> {
  late Future<_DadosOcorrencias> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _carregar();
  }

  Future<_DadosOcorrencias> _carregar() async {
    final regioes = await RegiaoService.listar();
    if (regioes.isEmpty) {
      throw ApiException('Nenhuma região cadastrada na API.');
    }

    final regiao = regioes.firstWhere(
      (r) => r.id == RegiaoSelecionada.id,
      orElse: () => regioes.first,
    );
    RegiaoSelecionada.id = regiao.id;

    final lista = await OcorrenciaService.listar(regiao.id);
    return _DadosOcorrencias(regiao: regiao, ocorrencias: lista);
  }

  void _tentarNovamente() {
    setState(() {
      _futuro = _carregar();
    });
  }

  Future<void> _atualizar() async {
    final novo = _carregar();
    setState(() {
      _futuro = novo;
    });
    try {
      await novo;
    } catch (_) {
      // o erro aparece no FutureBuilder
    }
  }

  Future<void> _reportar() async {
    final enviou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const ReportarOcorrenciaScreen()),
    );
    if (enviou == true && mounted) {
      _tentarNovamente();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        title: const Text(
          'Ocorrências',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _reportar,
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_comment),
        label: const Text(
          'Reportar',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: FutureBuilder<_DadosOcorrencias>(
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

            return _conteudo(snapshot.data!);
          },
        ),
      ),
    );
  }

  Widget _conteudo(_DadosOcorrencias dados) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        Text(
          dados.regiao.nome,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123B63),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Problemas reportados pelos moradores. Puxe a tela para atualizar.',
          style: TextStyle(fontSize: 15, color: Color(0xFF374151)),
        ),
        const SizedBox(height: 16),
        if (dados.ocorrencias.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Text(
              'Nenhuma ocorrência registrada nesta região. Toque em "Reportar" para ser o primeiro.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5, color: Color(0xFF1F2937)),
            ),
          ),
        ...dados.ocorrencias.map(_cartao),
      ],
    );
  }

  Widget _cartao(Ocorrencia ocorrencia) {
    final status = ocorrencia.status;

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(ocorrencia.tipo.icone, color: const Color(0xFF123B63), size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ocorrencia.tipo.rotulo,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: status.cor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          status.rotulo,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: status.cor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ocorrencia.descricao,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Reportado por ${ocorrencia.autorNome} - ${ocorrencia.dataTexto}',
                    style: const TextStyle(fontSize: 13, color: Color(0xFF374151)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}