
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final ruaController = TextEditingController();
  final numeroController = TextEditingController();
  final bairroController = TextEditingController();
  final cepController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    ruaController.dispose();
    numeroController.dispose();
    bairroController.dispose();
    cepController.dispose();
    super.dispose();
  }

  void cadastrar() {
  if (_formKey.currentState!.validate()) {
    Navigator.pushReplacementNamed(context, '/inicio');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF123B63),
        foregroundColor: Colors.white,
        title: const Text(
          'Cadastro do Morador',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(
              Icons.location_city,
              size: 55,
              color: Color(0xFF123B63),
            ),

            const SizedBox(height: 12),

            const Text(
              'Bem-vindo ao AlertaBairro!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Color(0xFF123B63),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Informe seus dados para acompanhar os alertas da sua região.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: Color(0xFF111827),
              ),
            ),

            const SizedBox(height: 24),

            campo(
              'Nome completo',
              'Digite seu nome',
              nomeController,
              Icons.person,
            ),

            campo(
              'E-mail',
              'Digite seu e-mail',
              emailController,
              Icons.email,
              email: true,
            ),

            campo(
              'Rua',
              'Digite o nome da sua rua',
              ruaController,
              Icons.home,
            ),

            campo(
              'Número',
              'Digite o número da residência',
              numeroController,
              Icons.numbers,
            ),

            campo(
              'Bairro',
              'Digite seu bairro',
              bairroController,
              Icons.location_on,
            ),

            campo(
              'CEP',
              'Digite seu CEP',
              cepController,
              Icons.markunread_mailbox,
              cep: true,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: cadastrar,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF123B63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Cadastrar e continuar',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget campo(
    String titulo,
    String dica,
    TextEditingController controller,
    IconData icone, {
    bool email = false,
    bool cep = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 8),

          TextFormField(
            controller: controller,
            inputFormatters: cep ? [CepInputFormatter()] : [],
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111827),
            ),
            keyboardType: email
                ? TextInputType.emailAddress
                : TextInputType.text,
            decoration: InputDecoration(
              hintText: dica,
              hintStyle: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
              errorStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFFB71C1C),
              ),
              prefixIcon: Icon(icone, color: const Color(0xFF123B63)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (valor) {
              if (valor == null || valor.trim().isEmpty) {
                return 'Preencha este campo';
              }

              if (email && !valor.contains('@')) {
                return 'Digite um e-mail válido';
              }
              
              if (cep && valor.replaceAll('-', '').length != 8) {
                return 'Digite um CEP válido (00000-000)';
              }

              return null;
            },
          ),
        ],
      ),
    );
  }
}

class CepInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String numeros = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (numeros.length > 8) {
      numeros = numeros.substring(0, 8);
    }

    String cep = numeros;

    if (numeros.length > 5) {
      cep = '${numeros.substring(0, 5)}-${numeros.substring(5)}';
    }

    return TextEditingValue(
      text: cep,
      selection: TextSelection.collapsed(offset: cep.length),
    );
  }
}