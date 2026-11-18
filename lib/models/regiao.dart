import 'nivel_risco.dart';

class Regiao {
  final int id;
  final String nome;
  final String cidade;
  final String uf;
  final NivelRisco nivelRisco;

  const Regiao({
    required this.id,
    required this.nome,
    required this.cidade,
    required this.uf,
    required this.nivelRisco,
  });

  factory Regiao.fromJson(Map<String, dynamic> json) {
    return Regiao(
      id: (json['id'] as num).toInt(),
      nome: json['nome'] as String,
      cidade: json['cidade'] as String,
      uf: json['uf'] as String,
      nivelRisco: NivelRisco.doApi(json['nivelRisco'] as String?),
    );
  }
}

// Resposta de GET /api/regioes/{id}/risco
class RiscoRegiao {
  final int regiaoId;
  final String regiaoNome;
  final NivelRisco nivelRisco;
  final double? picoNivelAguaCm;
  final int janelaHoras;
  final int alertasAtivos;

  const RiscoRegiao({
    required this.regiaoId,
    required this.regiaoNome,
    required this.nivelRisco,
    required this.picoNivelAguaCm,
    required this.janelaHoras,
    required this.alertasAtivos,
  });

  factory RiscoRegiao.fromJson(Map<String, dynamic> json) {
    return RiscoRegiao(
      regiaoId: (json['regiaoId'] as num).toInt(),
      regiaoNome: json['regiaoNome'] as String,
      nivelRisco: NivelRisco.doApi(json['nivelRisco'] as String?),
      picoNivelAguaCm: (json['picoNivelAguaCm'] as num?)?.toDouble(),
      janelaHoras: (json['janelaHoras'] as num).toInt(),
      alertasAtivos: (json['alertasAtivos'] as num).toInt(),
    );
  }

  // A API devolve centímetros, e o app mostra metros
  String get nivelAguaTexto {
    final pico = picoNivelAguaCm;
    if (pico == null) return 'Sem leituras recentes';
    final metros = (pico / 100).toStringAsFixed(2).replaceAll('.', ',');
    return '$metros metros';
  }

  String get alertasTexto {
    if (alertasAtivos == 0) return 'Nenhum alerta ativo';
    if (alertasAtivos == 1) return '1 alerta ativo';
    return '$alertasAtivos alertas ativos';
  }
}