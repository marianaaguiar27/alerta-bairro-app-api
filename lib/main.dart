
import 'package:flutter/material.dart';
import 'regioes_screen.dart';
import 'alertas_screen.dart';
import 'cadastro_screen.dart';

void main() {
  runApp(const AlertaBairroApp());
}

class AlertaBairroApp extends StatelessWidget {
  const AlertaBairroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AlertaBairro',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3F6FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF123B63),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Color(0xFF111827),
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Color(0xFF1F2937),
          ),
        ),
      ),
      home: const CadastroScreen(),

      routes: {
        '/inicio': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool alertaLido = false;
  int paginaSelecionada = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        title: const Text(
          'AlertaBairro',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_active_outlined),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá, morador! 👋',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B63),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Acompanhe a situação da sua região.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Situação da sua região',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE0B2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFE65100),
                        size: 32,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'ATENÇÃO',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFE65100),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  Text(
                    'Jardim São Paulo',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'O nível da água está aumentando. '
                    'Fique atento aos próximos avisos.',
                    style: TextStyle(
                      fontSize: 18,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Monitoramento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.water,
                    size: 42,
                    color: Colors.blue,
                  ),

                  SizedBox(width: 16),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nível da água',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF111827),
                        ),
                      ),

                      SizedBox(height: 3),

                      Text(
                        '1,2 metros',
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              'Regiões monitoradas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 12),

            regiao(
              'Jardim São Paulo',
              'Atenção',
              Colors.orange.shade800,
            ),

            regiao(
              'Av.Paulista',
              'Alerta',
              Colors.red.shade800,
            ),

            regiao(
              'Parque das Flores',
              'Normal',
              Colors.green.shade800,
            ),

            regiao(
              'Centro',
              'Emergência',
              Colors.red.shade900,
            ),

            const SizedBox(height: 24),

            const Text(
              'Último aviso recebido',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 12),

            Card(
              color: Colors.white,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                leading: const Icon(
                  Icons.notifications_active,
                  color: Colors.deepOrange,
                  size: 30,
                ),

                title: const Text(
                  'Atenção para chuvas fortes',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                subtitle: const Text(
                  'Jardim São Paulo - Dados simulados',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                trailing: IconButton(
                  icon: Icon(
                    alertaLido
                        ? Icons.check_circle
                        : Icons.mark_email_unread,
                    color: alertaLido
                        ? Colors.green
                        : Colors.orange,
                  ),

                  onPressed: () {
                    setState(() {
                      alertaLido = !alertaLido;
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          alertaLido
                              ? 'Alerta marcado como lido!'
                              : 'Alerta marcado como não lido!',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                'ALERTABAIRRO • PREVENÇÃO SALVA VIDAS',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaSelecionada,

        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RegioesScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AlertasScreen(),
              ),
            );
          }
        },

        selectedItemColor: const Color(0xFF123B63),
        unselectedItemColor: const Color(0xFF374151),
        selectedFontSize: 14,
        unselectedFontSize: 14,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Regiões',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
        ],
      ),
    );
  }

  Widget regiao(String nome, String risco, Color cor) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),

        leading: const Icon(
          Icons.location_on,
          color: Color(0xFF123B63),
          size: 36,
        ),

        title: Text(
          nome,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF111827),
          ),
        ),

        trailing: Text(
          risco,
          style: TextStyle(
            fontSize: 15,
            color: cor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
