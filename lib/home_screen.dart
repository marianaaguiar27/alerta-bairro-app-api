import 'package:flutter/material.dart';

import 'alertas_screen.dart';
import 'api/alerta_service.dart';
import 'api/api_client.dart';
import 'api/regiao_service.dart';
import 'login_screen.dart';
import 'models/alerta.dart';
import 'models/alertas_lidos.dart';
import 'models/regiao.dart';
import 'models/regiao_selecionada.dart';
import 'regioes_screen.dart';
import 'widgets/erro_com_retentativa.dart';
import 'ocorrencias_screen.dart';

class _DadosInicio {
  final List<Regiao> regioes;
  final Regiao regiao;
  final RiscoRegiao risco;
  final List<Alerta> alertas;

  const _DadosInicio({
    required this.regioes,
    required this.regiao,
    required this.risco,
    required this.alertas,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<_DadosInicio> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _carregar();
  }

  Future<_DadosInicio> _carregar() async {
    final regioes = await RegiaoService.listar();
    if (regioes.isEmpty) {
      throw ApiException('Nenhuma região cadastrada na API.');
    }

    // Usa a região escolhida; se ainda não houve escolha, a primeira da lista
    final regiao = regioes.firstWhere(
      (r) => r.id == RegiaoSelecionada.id,
      orElse: () => regioes.first,
    );
    RegiaoSelecionada.id = regiao.id;

    final risco = await RegiaoService.risco(regiao.id);
    final alertas = await AlertaService.ativos();

    return _DadosInicio(
      regioes: regioes,
      regiao: regiao,
      risco: risco,
      alertas: alertas,
    );
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

  void _sair() {
    ApiClient.instancia.sair();
    RegiaoSelecionada.id = null;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (rota) => false,
    );
  }

  void _abrir(Widget tela) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => tela),
    ).then((_) {
      // ao voltar, o "lido" pode ter mudado na tela de alertas
      if (mounted) setState(() {});
    });
  }

  void _escolherRegiao(List<Regiao> regioes) {
    showModalBottomSheet<void>(
      context: context,
      builder: (contexto) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Escolha a sua região',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF123B63),
                ),
              ),
            ),
            ...regioes.map(
              (r) => ListTile(
                leading: Icon(Icons.location_on, color: r.nivelRisco.cor),
                title: Text(r.nome),
                subtitle: Text('${r.cidade} - ${r.uf}'),
                trailing: r.id == RegiaoSelecionada.id
                    ? const Icon(Icons.check, color: Color(0xFF123B63))
                    : null,
                onTap: () {
                  Navigator.pop(contexto);
                  RegiaoSelecionada.id = r.id;
                  setState(() {
                    _futuro = _carregar();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        title: const Text(
          'AlertaBairro',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        actions: [
          const Icon(Icons.notifications_active_outlined),
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: _sair,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: FutureBuilder<_DadosInicio>(
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
        bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            _abrir(const RegioesScreen());
          } else if (index == 2) {
            _abrir(const AlertasScreen());
          } else if (index == 3) {
            _abrir(const OcorrenciasScreen());
          }
        },
        selectedItemColor: const Color(0xFF123B63),
        unselectedItemColor: const Color(0xFF374151),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'Regiões'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Alertas'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Ocorrências'),
        ],
      ),
    );
  }

  Widget _conteudo(_DadosInicio dados) {
    final nome = ApiClient.instancia.sessao?.nome ?? 'morador';

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Olá, $nome! 👋',
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF123B63),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Acompanhe a situação da sua região.',
          style: TextStyle(fontSize: 16, color: Color(0xFF111827)),
        ),
        const SizedBox(height: 24),
        _titulo('Situação da sua região'),
        const SizedBox(height: 12),
        _cartaoSituacao(dados),
        const SizedBox(height: 24),
        _titulo('Monitoramento'),
        const SizedBox(height: 12),
        _cartaoMonitoramento(dados.risco),
        const SizedBox(height: 24),
        _titulo('Regiões monitoradas'),
        const SizedBox(height: 12),
        ...dados.regioes.map(_linhaRegiao),
        const SizedBox(height: 24),
        _titulo('Último aviso recebido'),
        const SizedBox(height: 12),
        _ultimoAviso(dados.alertas),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            'ALERTABAIRRO • PREVENÇÃO SALVA VIDAS',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF374151),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _titulo(String texto) {
    return Text(
      texto,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF111827),
      ),
    );
  }

  Widget _cartaoSituacao(_DadosInicio dados) {
    final nivel = dados.risco.nivelRisco;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: nivel.cor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(nivel.icone, color: nivel.cor, size: 32),
              const SizedBox(width: 10),
              Text(
                nivel.rotulo.toUpperCase(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: nivel.cor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            dados.regiao.nome,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            nivel.orientacao,
            style: const TextStyle(
              fontSize: 18,
              height: 1.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _escolherRegiao(dados.regioes),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Trocar região'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartaoMonitoramento(RiscoRegiao risco) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.water, size: 42, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nível da água',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  risco.nivelAguaTexto,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Pico das últimas ${risco.janelaHoras} horas • ${risco.alertasTexto}',
                  style: const TextStyle(fontSize: 14, color: Color(0xFF374151)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _linhaRegiao(Regiao regiao) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
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
        trailing: Text(
          regiao.nivelRisco.rotulo,
          style: TextStyle(
            fontSize: 15,
            color: regiao.nivelRisco.cor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _ultimoAviso(List<Alerta> alertas) {
    if (alertas.isEmpty) {
      return const Card(
        color: Colors.white,
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(Icons.check_circle, color: Colors.green, size: 30),
          title: Text(
            'Nenhum alerta ativo',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          subtitle: Text(
            'Tudo tranquilo por enquanto.',
            style: TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
          ),
        ),
      );
    }

    final alerta = alertas.first;
    final lido = AlertasLidos.contem(alerta.id);

    return Card(
      color: Colors.white,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(alerta.nivel.icone, color: alerta.nivel.cor, size: 30),
        title: Text(
          alerta.titulo,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        subtitle: Text(
          '${alerta.regiaoNome} - ${alerta.dataTexto}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            lido ? Icons.check_circle : Icons.mark_email_unread,
            color: lido ? Colors.green : Colors.orange,
          ),
          onPressed: () {
            bool agoraLido = false;
            setState(() {
              agoraLido = AlertasLidos.alternar(alerta.id);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  agoraLido
                      ? 'Alerta marcado como lido!'
                      : 'Alerta marcado como não lido!',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}