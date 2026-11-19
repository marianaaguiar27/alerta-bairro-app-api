import '../models/ocorrencia.dart';
import 'api_client.dart';

class OcorrenciaService {
  OcorrenciaService._();

  // A API já devolve as mais recentes primeiro (ordenação padrão por criadoEm)
  // Formato HAL: {"_embedded": {"ocorrencias": [...]}}; sem itens, _embedded pode faltar
  static Future<List<Ocorrencia>> listar(int regiaoId) async {
    final json = await ApiClient.instancia
        .get('/api/ocorrencias?regiaoId=$regiaoId&size=50') as Map<String, dynamic>;
    final embutido = json['_embedded'] as Map<String, dynamic>?;
    final lista = embutido?['ocorrencias'] as List<dynamic>? ?? [];
    return lista
        .map((item) => Ocorrencia.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // O autor não é enviado: a API usa o usuário do token
  static Future<void> criar({
    required TipoOcorrencia tipo,
    required String descricao,
    required int regiaoId,
  }) async {
    await ApiClient.instancia.post('/api/ocorrencias', {
      'tipo': tipo.api,
      'descricao': descricao.trim(),
      'regiaoId': regiaoId,
    });
  }
}