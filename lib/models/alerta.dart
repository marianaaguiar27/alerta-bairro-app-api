import 'nivel_risco.dart';

class Alerta {
  final int id;
  final NivelRisco nivel;
  final String mensagem;
  final int regiaoId;
  final String regiaoNome;
  final DateTime? criadoEm;

  const Alerta({
    required this.id,
    required this.nivel,
    required this.mensagem,
    required this.regiaoId,
    required this.regiaoNome,
    required this.criadoEm,
  });

  factory Alerta.fromJson(Map<String, dynamic> json) {
    return Alerta(
      id: (json['id'] as num).toInt(),
      nivel: NivelRisco.doApi(json['nivel'] as String?),
      mensagem: json['mensagem'] as String,
      regiaoId: (json['regiaoId'] as num).toInt(),
      regiaoNome: json['regiaoNome'] as String,
      criadoEm: DateTime.tryParse(json['criadoEm'] as String? ?? ''),
    );
  }

  String get titulo {
    switch (nivel) {
      case NivelRisco.baixo:
        return 'Monitoramento normal';
      case NivelRisco.medio:
        return 'Atenção ao nível da água';
      case NivelRisco.alto:
        return 'Risco de alagamento';
      case NivelRisco.critico:
        return 'Emergência: risco crítico';
    }
  }

  String get dataTexto {
    final data = criadoEm;
    if (data == null) return '';
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(data.day)}/${dois(data.month)} às ${dois(data.hour)}:${dois(data.minute)}';
  }
}