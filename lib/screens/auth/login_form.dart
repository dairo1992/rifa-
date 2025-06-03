import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rifa_plus/providers/auth/auth_provider.dart';
import 'package:rifa_plus/providers/helper/conectity_status.dart';
import 'package:rifa_plus/widgets/widgets.dart';

class LoginForm extends ConsumerWidget {
  LoginForm({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(connectivityProvider);
    final authState = ref.watch(authProvider);

    return SizedBox(
      width:
          MediaQuery.of(context).size.width > 320
              ? 320
              : MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text("Estado de conexion: ${authState.isAuthenticated}"),
            CustomTextField(
              label: 'Correo electrónico',
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese su correo';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
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
            const SizedBox(height: 16),
            CustomButton(
              text: 'Iniciar sesion',
              onPressed: () async {
                // if (tipe != 'google') {
                if (_formKey.currentState!.validate()) {
                  ref
                      .read(authProvider.notifier)
                      .login(
                        _emailController.text,
                        _passwordController.text,
                        status.isOnline,
                      );
                  // ref
                  //     .read(authProvider.notifier)
                  //     .login(
                  //       'emailAndPassword',
                  //       _emailController.text,
                  //       _passwordController.text,
                  //     );
                  // }
                  // } else {
                  //   // ref.read(authProvider.notifier).login('google', null, null);
                }
              },
              isLoading: false,
            ),
            SizedBox(height: 10),
            // SizedBox(
            //   width: double.infinity,
            //   child: SignInButton(
            //     Buttons.google,
            //     text: "INGRESA CON GOOGLE",
            //     onPressed: () => _submitForm('google'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
