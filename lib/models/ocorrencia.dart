import 'package:flutter/material.dart';

enum TipoOcorrencia {
  alagamento('ALAGAMENTO', 'Alagamento', Icons.water),
  buraco('BURACO', 'Buraco na via', Icons.construction),
  iluminacao('ILUMINACAO', 'Iluminação', Icons.lightbulb_outline),
  lixo('LIXO', 'Lixo acumulado', Icons.delete_outline),
  outros('OUTROS', 'Outros', Icons.report_problem_outlined);

  // Valor enviado e recebido pela API
  final String api;
  final String rotulo;
  final IconData icone;

  const TipoOcorrencia(this.api, this.rotulo, this.icone);

  static TipoOcorrencia doApi(String? valor) {
    return TipoOcorrencia.values.firstWhere(
      (t) => t.api == valor,
      orElse: () => TipoOcorrencia.outros,
    );
  }
}

enum StatusOcorrencia {
  aberta('Aberta', Color(0xFFEF6C00)),
  emAnalise('Em análise', Color(0xFF1565C0)),
  resolvida('Resolvida', Color(0xFF2E7D32));

  final String rotulo;
  final Color cor;

  const StatusOcorrencia(this.rotulo, this.cor);

  static StatusOcorrencia doApi(String? valor) {
    switch (valor) {
      case 'EM_ANALISE':
        return StatusOcorrencia.emAnalise;
      case 'RESOLVIDA':
        return StatusOcorrencia.resolvida;
      default:
        return StatusOcorrencia.aberta;
    }
  }
}

class Ocorrencia {
  final int id;
  final TipoOcorrencia tipo;
  final String descricao;
  final StatusOcorrencia status;
  final DateTime? criadoEm;
  final String regiaoNome;
  final String autorNome;

  const Ocorrencia({
    required this.id,
    required this.tipo,
    required this.descricao,
    required this.status,
    required this.criadoEm,
    required this.regiaoNome,
    required this.autorNome,
  });

  factory Ocorrencia.fromJson(Map<String, dynamic> json) {
    return Ocorrencia(
      id: (json['id'] as num).toInt(),
      tipo: TipoOcorrencia.doApi(json['tipo'] as String?),
      descricao: json['descricao'] as String,
      status: StatusOcorrencia.doApi(json['status'] as String?),
      criadoEm: DateTime.tryParse(json['criadoEm'] as String? ?? ''),
      regiaoNome: json['regiaoNome'] as String,
      autorNome: json['autorNome'] as String,
    );
  }

  String get dataTexto {
    final data = criadoEm;
    if (data == null) return '';
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(data.day)}/${dois(data.month)} às ${dois(data.hour)}:${dois(data.minute)}';
  }
}