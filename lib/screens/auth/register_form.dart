import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rifa_plus/providers/auth/auth_provider.dart';
import 'package:rifa_plus/providers/helper/conectity_status.dart';
import 'package:rifa_plus/widgets/custom_button.dart';
import 'package:rifa_plus/widgets/custom_textField.dart';

class RegisterForm extends ConsumerWidget {
  RegisterForm({super.key});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conexionState = ref.watch(connectivityProvider);
    final authState = ref.watch(authProvider);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text("Estado de authenticacion ${authState.isAuthenticated}"),
          CustomTextField(
            label: 'Nombre',
            prefixIcon: Icons.person,
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su nombre';
              }
              final RegExp soloLetras = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
              if (!soloLetras.hasMatch(value)) {
                return 'Solo se caracteres alfabeticos';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Apellidos',
            prefixIcon: Icons.person,
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su contraseña';
              }
              final RegExp soloLetras = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
              if (!soloLetras.hasMatch(value)) {
                return 'Solo se caracteres alfabeticos';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Correo electrónico',
            prefixIcon: Icons.email_outlined,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su correo';
              }
              final RegExp validEmail = RegExp(
                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
              );
              if (!validEmail.hasMatch(value)) {
                return 'Por favor ingrese un correo válido';
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Contraseña',
            prefixIcon: Icons.lock_outline,
            obscureText: true,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese su contraseña';
              }
              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 24),
          CustomButton(
            text: 'Registrarse',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref
                    .read(authProvider.notifier)
                    .register(_emailController.text, _passwordController.text, conexionState.isOnline);
              }
            },
            isLoading: authState.isLoading,
          ),
        ],
      ),
    );
  }
}
