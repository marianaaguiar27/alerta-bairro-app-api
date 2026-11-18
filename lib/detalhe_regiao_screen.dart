import 'package:flutter/material.dart';

import 'api/regiao_service.dart';
import 'models/regiao.dart';
import 'widgets/erro_com_retentativa.dart';

class DetalheRegiaoScreen extends StatefulWidget {
  // A região chega por parâmetro; o risco atual vem da API
  final Regiao regiao;

  const DetalheRegiaoScreen({super.key, required this.regiao});

  @override
  State<DetalheRegiaoScreen> createState() => _DetalheRegiaoScreenState();
}

class _DetalheRegiaoScreenState extends State<DetalheRegiaoScreen> {
  late Future<RiscoRegiao> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = RegiaoService.risco(widget.regiao.id);
  }

  void _tentarNovamente() {
    setState(() {
      _futuro = RegiaoService.risco(widget.regiao.id);
    });
  }

  Future<void> _atualizar() async {
    final novo = RegiaoService.risco(widget.regiao.id);
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
          'Detalhes da região',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              widget.regiao.nome,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B63),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${widget.regiao.cidade} - ${widget.regiao.uf}',
              style: const TextStyle(fontSize: 16, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 24),
            FutureBuilder<RiscoRegiao>(
              future: _futuro,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 60),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return ErroComRetentativa(
                    erro: snapshot.error!,
                    aoTentarNovamente: _tentarNovamente,
                  );
                }
                return _conteudo(snapshot.data!);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _conteudo(RiscoRegiao risco) {
    final nivel = risco.nivelRisco;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _cartao(
          icone: nivel.icone,
          corIcone: nivel.cor,
          titulo: 'Nível de risco',
          valor: nivel.rotulo,
        ),
        const SizedBox(height: 12),
        _cartao(
          icone: Icons.water,
          corIcone: Colors.blue,
          titulo: 'Nível da água',
          valor: risco.nivelAguaTexto,
          subtitulo: 'Pico das últimas ${risco.janelaHoras} horas',
        ),
        const SizedBox(height: 12),
        _cartao(
          icone: Icons.notifications_active,
          corIcone: Colors.deepOrange,
          titulo: 'Alertas',
          valor: risco.alertasTexto,
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
            nivel.orientacao,
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
          'Dados em tempo real da API AlertaBairro. Puxe a tela para atualizar.',
          style: TextStyle(fontSize: 15, color: Color(0xFF374151)),
        ),
      ],
    );
  }

  Widget _cartao({
    required IconData icone,
    required Color corIcone,
    required String titulo,
    required String valor,
    String? subtitulo,
  }) {
    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icone, color: corIcone, size: 38),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111111),
          ),
        ),
        subtitle: Text(
          subtitulo == null ? valor : '$valor\n$subtitulo',
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111111),
          ),
        ),
        isThreeLine: subtitulo != null,
      ),
    );
  }
}