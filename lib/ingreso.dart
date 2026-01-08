import 'package:flutter/material.dart';

bool validarCedulaEcuatoriana(String cedula) {
  if (cedula.length != 10) return false;
  if (!RegExp(r'^\d+$').hasMatch(cedula)) return false;

  int provincia = int.parse(cedula.substring(0, 2));
  if (provincia < 1 || provincia > 24) return false;

  int tercerDigito = int.parse(cedula[2]);
  if (tercerDigito >= 6) return false;

  List<int> coef = [2, 1, 2, 1, 2, 1, 2, 1, 2];
  int suma = 0;

  for (int i = 0; i < 9; i++) {
    int valor = int.parse(cedula[i]) * coef[i];
    if (valor >= 10) valor -= 9;
    suma += valor;
  }

  int digito = (10 - (suma % 10)) % 10;
  return digito == int.parse(cedula[9]);
}

class Ingreso extends StatefulWidget {
  const Ingreso({super.key});

  @override
  State<Ingreso> createState() => _IngresoState();
}

class _IngresoState extends State<Ingreso> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cedCtrl = TextEditingController();
  final TextEditingController mailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  @override
  void dispose() {
    cedCtrl.dispose();
    mailCtrl.dispose();
    passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              //CEDULA
              TextFormField(
                controller: cedCtrl,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: const InputDecoration(
                  labelText: 'Cédula',
                  border: OutlineInputBorder(),
                  counterText: '',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la cédula';
                  }
                  if (!validarCedulaEcuatoriana(value)) {
                    return 'Cédula ecuatoriana inválida';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              // EMAIL
              TextFormField(
                controller: mailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                  ).hasMatch(value ?? "");

                  if (value == null || value.isEmpty) {
                    return 'Por favor, introduce un correo';
                  } else if (!emailValid) {
                    return 'Introduce un correo válido';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 12),

              /// CONTRASEÑA
              TextFormField(
                controller: passCtrl,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingrese la contraseña';
                  }

                  if (value.contains(' ')) {
                    return 'La contraseña no debe contener espacios';
                  }

                  if (!RegExp(r'^(?=.*[A-Z])').hasMatch(value)) {
                    return 'Debe contener al menos una mayúscula';
                  }

                  if (!RegExp(r'.*\d.*').hasMatch(value)) {
                    return 'Debe contener al menos un número';
                  }

                  if (!RegExp(r'^(?=.*[@$!%*?&._-])').hasMatch(value)) {
                    return 'Debe contener al menos un carácter especial';
                  }

                  if (value.length < 8) {
                    return 'Mínimo 8 caracteres';
                  }

                  return null;
                },
              ),

              SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Formulario válido')),
                      );
                    }
                  },
                  child: Text('Crear cuenta'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
