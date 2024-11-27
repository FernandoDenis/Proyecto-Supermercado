import 'package:flutter/material.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController neighborhoodController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  void _validateAndProceed() {
    if (_formKey.currentState!.validate()) {
      final total = ModalRoute.of(context)!.settings.arguments
          as double; // Recibe el total
      Navigator.pushNamed(
        context,
        '/payment-method',
        arguments: total, // Pasa el total a la pantalla de pago
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dirección de Envío',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        elevation: 5,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Ingrese los detalles para el envío:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ..._buildTextFormFields(),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _validateAndProceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildTextFormFields() {
    final List<Map<String, dynamic>> fields = [
      {'controller': nameController, 'label': 'Nombre completo'},
      {
        'controller': phoneController,
        'label': 'Teléfono',
        'type': TextInputType.phone
      },
      {'controller': streetController, 'label': 'Calle'},
      {'controller': houseNumberController, 'label': 'Número de casa'},
      {'controller': neighborhoodController, 'label': 'Colonia'},
      {'controller': cityController, 'label': 'Ciudad'},
      {'controller': stateController, 'label': 'Estado'},
      {
        'controller': postalCodeController,
        'label': 'Código Postal',
        'type': TextInputType.number
      },
    ];

    return fields.map((field) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: field['controller'] as TextEditingController,
          keyboardType: field['type'] as TextInputType? ?? TextInputType.text,
          decoration: InputDecoration(
            labelText: field['label'] as String,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor ingrese ${field['label']}';
            }
            if (field['label'] == 'Teléfono' &&
                !RegExp(r'^\d{10}$').hasMatch(value)) {
              return 'Ingrese un número de teléfono válido de 10 dígitos';
            }
            if (field['label'] == 'Código Postal' &&
                !RegExp(r'^\d{5}$').hasMatch(value)) {
              return 'Ingrese un código postal válido de 5 dígitos';
            }
            return null;
          },
        ),
      );
    }).toList();
  }
}
