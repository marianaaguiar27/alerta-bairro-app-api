import 'package:flutter/material.dart';

import 'api/api_client.dart';
import 'api/ocorrencia_service.dart';
import 'api/regiao_service.dart';
import 'login_screen.dart';
import 'models/ocorrencia.dart';
import 'models/regiao.dart';
import 'models/regiao_selecionada.dart';
import 'widgets/erro_com_retentativa.dart';

class ReportarOcorrenciaScreen extends StatefulWidget {
  const ReportarOcorrenciaScreen({super.key});

  @override
  State<ReportarOcorrenciaScreen> createState() =>
      _ReportarOcorrenciaScreenState();
}

class _ReportarOcorrenciaScreenState extends State<ReportarOcorrenciaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descricaoController = TextEditingController();

  late Future<List<Regiao>> _regioes;
  TipoOcorrencia? _tipo;
  int? _regiaoId = RegiaoSelecionada.id;
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _regioes = RegiaoService.listar();
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    super.dispose();
  }

  void _recarregarRegioes() {
    setState(() {
      _regioes = RegiaoService.listar();
    });
  }

  void _mostrarMensagem(String texto, {required bool erro}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(texto),
        backgroundColor: erro ? const Color(0xFFB71C1C) : const Color(0xFF2E7D32),
      ),
    );
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _enviando = true;
    });

    try {
      await OcorrenciaService.criar(
        tipo: _tipo!,
        descricao: _descricaoController.text,
        regiaoId: _regiaoId!,
      );
      if (!mounted) return;
      _mostrarMensagem(
        'Ocorrência enviada! Acompanhe o andamento na lista.',
        erro: false,
      );
      Navigator.pop(context, true);
    } on SessaoExpiradaException catch (e) {
      if (!mounted) return;
      _mostrarMensagem(e.mensagem, erro: true);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (rota) => false,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarMensagem(e.mensagem, erro: true);
    } finally {
      if (mounted) {
        setState(() {
          _enviando = false;
        });
      }
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
        title: const Text(
          'Reportar ocorrência',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Regiao>>(
        future: _regioes,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ListView(
              children: [
                ErroComRetentativa(
                  erro: snapshot.error!,
                  aoTentarNovamente: _recarregarRegioes,
                ),
              ],
            );
          }

          final regioes = snapshot.data ?? [];
          if (regioes.isEmpty) {
            return const Center(child: Text('Nenhuma região cadastrada na API.'));
          }

          // Se a região escolhida no início não estiver na lista, usa a primeira
          if (!regioes.any((r) => r.id == _regiaoId)) {
            _regiaoId = regioes.first.id;
          }

          return _formulario(regioes);
        },
      ),
    );
  }

  Widget _formulario(List<Regiao> regioes) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Icon(Icons.campaign, size: 55, color: Color(0xFF123B63)),
          const SizedBox(height: 12),
          const Text(
            'Viu um problema no seu bairro?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF123B63),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Conte o que está acontecendo. A Defesa Civil recebe o aviso e você acompanha o andamento.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              height: 1.5,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 24),
          DropdownButtonFormField<TipoOcorrencia>(
            initialValue: _tipo,
            isExpanded: true,
            decoration: _decoracao('Tipo de ocorrência', Icons.category),
            items: TipoOcorrencia.values
                .map(
                  (t) => DropdownMenuItem<TipoOcorrencia>(
                    value: t,
                    child: Text(t.rotulo),
                  ),
                )
                .toList(),
            onChanged: (valor) {
              setState(() {
                _tipo = valor;
              });
            },
            validator: (valor) =>
                valor == null ? 'Escolha o tipo da ocorrência' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            initialValue: _regiaoId,
            isExpanded: true,
            decoration: _decoracao('Região', Icons.location_on),
            items: regioes
                .map(
                  (r) => DropdownMenuItem<int>(
                    value: r.id,
                    child: Text('${r.nome} - ${r.cidade}'),
                  ),
                )
                .toList(),
            onChanged: (valor) {
              setState(() {
                _regiaoId = valor;
              });
            },
            validator: (valor) => valor == null ? 'Escolha a região' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _descricaoController,
            maxLines: 5,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: _decoracao('Descrição', Icons.edit_note).copyWith(
              alignLabelWithHint: true,
              hintText: 'Ex.: Rua das Flores alagada em frente ao número 120',
            ),
            validator: (valor) {
              final texto = valor?.trim() ?? '';
              if (texto.isEmpty) return 'Preencha este campo';
              if (texto.length < 10) {
                return 'Descreva com pelo menos 10 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _enviando ? null : _enviar,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF123B63),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _enviando
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Enviar ocorrência',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
          ),
        ],
      ),
    );
  }
}