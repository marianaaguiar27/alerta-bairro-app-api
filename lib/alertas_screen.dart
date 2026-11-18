import 'package:flutter/material.dart';

import 'api/alerta_service.dart';
import 'models/alerta.dart';
import 'models/alertas_lidos.dart';
import 'widgets/erro_com_retentativa.dart';

class AlertasScreen extends StatefulWidget {
  const AlertasScreen({super.key});

  @override
  State<AlertasScreen> createState() => _AlertasScreenState();
}

class _AlertasScreenState extends State<AlertasScreen> {
  late Future<List<Alerta>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = AlertaService.ativos();
  }

  void _tentarNovamente() {
    setState(() {
      _futuro = AlertaService.ativos();
    });
  }

  Future<void> _atualizar() async {
    final novo = AlertaService.ativos();
    setState(() {
      _futuro = novo;
    });
    try {
      await novo;
    } catch (_) {
      // o erro aparece no FutureBuilder
    }
  }

  void _alternarLido(Alerta alerta) {
    bool lido = false;
    setState(() {
      lido = AlertasLidos.alternar(alerta.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lido ? 'Alerta marcado como lido!' : 'Alerta marcado como não lido!',
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
          'Alertas recebidos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _atualizar,
        child: FutureBuilder<List<Alerta>>(
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

            final alertas = snapshot.data ?? [];
            final naoLidos =
                alertas.where((a) => !AlertasLidos.contem(a.id)).length;

            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Confira os avisos sobre sua região.',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  alertas.isEmpty
                      ? 'Nenhum alerta ativo no momento.'
                      : 'Alertas não lidos: $naoLidos de ${alertas.length}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF123B63),
                  ),
                ),
                const SizedBox(height: 20),
                ...alertas.map(_cartao),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _cartao(Alerta alerta) {
    final lido = AlertasLidos.contem(alerta.id);

    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(alerta.nivel.icone, color: alerta.nivel.cor, size: 36),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alerta.titulo,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alerta.regiaoNome,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alerta.mensagem,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  if (alerta.dataTexto.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      alerta.dataTexto,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              tooltip: lido ? 'Marcar como não lido' : 'Marcar como lido',
              icon: Icon(
                lido ? Icons.check_circle : Icons.mark_email_unread,
                color: lido ? Colors.green : Colors.orange,
              ),
              onPressed: () => _alternarLido(alerta),
            ),
          ],
        ),
      ),
    );
  }
}