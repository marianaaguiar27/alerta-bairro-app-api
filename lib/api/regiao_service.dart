import '../models/regiao.dart';
import 'api_client.dart';

class RegiaoService {
  RegiaoService._();

  // A lista vem no formato HAL: {"_embedded": {"regioes": [...]}, "_links": ...}
  // Sem nenhuma região, o bloco _embedded pode nem existir
  static Future<List<Regiao>> listar() async {
    final json = await ApiClient.instancia.get('/api/regioes?size=50&sort=nome')
        as Map<String, dynamic>;
    final embutido = json['_embedded'] as Map<String, dynamic>?;
    final lista = embutido?['regioes'] as List<dynamic>? ?? [];
    return lista
        .map((item) => Regiao.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<RiscoRegiao> risco(int regiaoId) async {
    final json = await ApiClient.instancia.get('/api/regioes/$regiaoId/risco')
        as Map<String, dynamic>;
    return RiscoRegiao.fromJson(json);
  }
}