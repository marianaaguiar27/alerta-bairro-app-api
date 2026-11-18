import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String mensagem;
  final int? status;

  ApiException(this.mensagem, {this.status});

  @override
  String toString() => mensagem;
}

// O token venceu (validade de 1 hora) ou foi recusado: a tela deve voltar ao login
class SessaoExpiradaException extends ApiException {
  SessaoExpiradaException()
      : super('Sua sessão expirou. Faça login novamente.', status: 401);
}

class Sessao {
  final String token;
  final int usuarioId;
  final String nome;
  final String papel;

  Sessao({
    required this.token,
    required this.usuarioId,
    required this.nome,
    required this.papel,
  });
}

class ApiClient {
  ApiClient._();

  static final ApiClient instancia = ApiClient._();

  // 10.0.2.2 é o endereço pelo qual o emulador Android enxerga o localhost do PC.
  // Em celular físico: flutter run --dart-define=API_URL=http://IP_DO_PC:8080
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://10.0.2.2:8080',
  );

  static const Duration _limiteDeEspera = Duration(seconds: 10);

  // Token só em memória: some quando o app fecha
  Sessao? sessao;

  bool get logado => sessao != null;

  Future<Sessao> login(String email, String senha) async {
    final dados = await _enviar(
      'POST',
      '/api/auth/login',
      corpo: {'email': email.trim(), 'senha': senha},
      exigeToken: false,
    ) as Map<String, dynamic>;

    sessao = Sessao(
      token: dados['token'] as String,
      usuarioId: (dados['usuarioId'] as num).toInt(),
      nome: dados['nome'] as String,
      papel: dados['papel'] as String,
    );
    return sessao!;
  }

  void sair() {
    sessao = null;
  }

  Future<dynamic> get(String caminho) => _enviar('GET', caminho);

  Future<dynamic> post(String caminho, Map<String, dynamic> corpo) =>
      _enviar('POST', caminho, corpo: corpo);

  Future<dynamic> _enviar(
    String metodo,
    String caminho, {
    Map<String, dynamic>? corpo,
    bool exigeToken = true,
  }) async {
    final uri = Uri.parse('$baseUrl$caminho');
    final cabecalhos = <String, String>{
      'Accept': 'application/json',
      if (corpo != null) 'Content-Type': 'application/json',
      if (exigeToken && sessao != null) 'Authorization': 'Bearer ${sessao!.token}',
    };

    try {
      final http.Response resposta;
      if (metodo == 'POST') {
        resposta = await http
            .post(uri, headers: cabecalhos, body: jsonEncode(corpo))
            .timeout(_limiteDeEspera);
      } else {
        resposta = await http.get(uri, headers: cabecalhos).timeout(_limiteDeEspera);
      }
      return _tratar(resposta, exigeToken: exigeToken);
    } on SocketException {
      throw ApiException(_semConexao);
    } on http.ClientException {
      throw ApiException(_semConexao);
    } on TimeoutException {
      throw ApiException(_semConexao);
    }
  }

  static const String _semConexao =
      'Não foi possível conectar à API. Verifique se ela está rodando e o endereço configurado.';

  dynamic _tratar(http.Response resposta, {required bool exigeToken}) {
    // utf8.decode evita acentos quebrados: o Spring não envia charset no Content-Type
    final texto = utf8.decode(resposta.bodyBytes);
    dynamic json;
    if (texto.isNotEmpty) {
      try {
        json = jsonDecode(texto);
      } on FormatException {
        json = null;
      }
    }

    if (resposta.statusCode >= 200 && resposta.statusCode < 300) {
      return json;
    }

    // No login, 401 significa senha errada, e não sessão expirada
    if (resposta.statusCode == 401 && exigeToken) {
      sessao = null;
      throw SessaoExpiradaException();
    }

    throw ApiException(_mensagemDeErro(json, resposta.statusCode), status: resposta.statusCode);
  }

  // Usa o corpo de erro padronizado da API (message e lista de campos)
  String _mensagemDeErro(dynamic json, int status) {
    if (json is Map<String, dynamic>) {
      final mensagem = json['message'] as String? ?? 'Erro $status';
      final campos = json['campos'];
      if (campos is List && campos.isNotEmpty) {
        final detalhes = campos.map((c) => '${c['campo']}: ${c['mensagem']}').join('; ');
        return '$mensagem ($detalhes)';
      }
      return mensagem;
    }
    return 'Erro $status ao falar com a API';
  }
}