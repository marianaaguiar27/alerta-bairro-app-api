import 'package:flutter/material.dart';

enum NivelRisco {
  baixo(
    'Normal',
    Color(0xFF2E7D32),
    Icons.check_circle,
    'A situação está normal. Continue acompanhando os avisos.',
  ),
  medio(
    'Atenção',
    Color(0xFFEF6C00),
    Icons.warning_amber_rounded,
    'Evite áreas próximas a rios e fique atento aos próximos avisos.',
  ),
  alto(
    'Alerta',
    Color(0xFFF44336),
    Icons.error_outline,
    'Evite sair de casa se não for necessário. Procure locais seguros.',
  ),
  critico(
    'Emergência',
    Color(0xFFB71C1C),
    Icons.error,
    'Afaste-se das áreas alagadas e procure um local seguro.',
  );

  final String rotulo;
  final Color cor;
  final IconData icone;
  final String orientacao;

  const NivelRisco(this.rotulo, this.cor, this.icone, this.orientacao);

  // Valor que a API envia: BAIXO, MEDIO, ALTO ou CRITICO
  static NivelRisco doApi(String? valor) {
    switch (valor) {
      case 'MEDIO':
        return NivelRisco.medio;
      case 'ALTO':
        return NivelRisco.alto;
      case 'CRITICO':
        return NivelRisco.critico;
      default:
        return NivelRisco.baixo;
    }
  }
}