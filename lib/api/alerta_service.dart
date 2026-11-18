import '../models/alerta.dart';
import 'api_client.dart';

class AlertaService {
  AlertaService._();

  // Formato HAL: {"_embedded": {"alertas": [...]}}. Sem alertas, _embedded pode faltar.
  // A API já devolve os mais recentes primeiro.
  static Future<List<Alerta>> ativos() async {
    final json = await ApiClient.instancia.get('/api/alertas/ativos')
        as Map<String, dynamic>;
    final embutido = json['_embedded'] as Map<String, dynamic>?;
    final lista = embutido?['alertas'] as List<dynamic>? ?? [];
    return lista
        .map((item) => Alerta.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}