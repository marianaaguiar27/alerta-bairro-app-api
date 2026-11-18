// Alertas que o morador marcou como lidos (só em memória)
class AlertasLidos {
  AlertasLidos._();

  static final Set<int> _ids = {};

  static bool contem(int id) => _ids.contains(id);

  // Alterna o estado e devolve o novo: true = lido
  static bool alternar(int id) {
    if (_ids.remove(id)) return false;
    _ids.add(id);
    return true;
  }
}