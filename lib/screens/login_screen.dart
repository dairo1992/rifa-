import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rifa_plus/widgets/widgets.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: AppBar(title: Text("status: ${conexionState.isOnline}"),),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo_sin_fondo.png',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey.shade300,
                        child: const Center(
                          child: Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Bienvenido de nuevo',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Inicia sesin para continuar',
                  style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
                ),
                const SizedBox(height: 48),
                const _LoginForm(),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes una cuenta?',
                      style: TextStyle(color: Colors.grey.shade800),
                    ),
                    TextButton(
                      onPressed: () {
                        context.push('/register');
                      },
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginForm extends ConsumerStatefulWidget {
  const _LoginForm();

  @override
  ConsumerState<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends ConsumerState<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su correo';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Por favor ingrese un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese su contraseña';
    }
    if (value.length < 6) {
      return 'La contraseña debe tener al menos 6 caracteres';
    }
    return null;
  }

  void _submitForm(String tipe) {
    if (tipe != 'google') {
      if (_formKey.currentState!.validate()) {
        // ref
        //     .read(authProvider.notifier)
        //     .login(
        //       'emailAndPassword',
        //       _emailController.text,
        //       _passwordController.text,
        //     );
      }
    } else {
      // ref.read(authProvider.notifier).login('google', null, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:
          MediaQuery.of(context).size.width > 320
              ? 320
              : MediaQuery.of(context).size.width,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              label: 'Correo electrónico',
              prefixIcon: Icons.email_outlined,
              controller: _emailController,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Contraseña',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              controller: _passwordController,
              validator: _validatePassword,
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Iniciar sesion',
              onPressed: () => _submitForm(''),
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
