import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'auth_controller.dart';
import '../weather/weather_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void executeLogin() {
    if (formKey.currentState?.validate() ?? false) {
      ref.read(authControllerProvider.notifier).login(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    ref.listen(authControllerProvider, (previous, next) {
      next.maybeWhen(
        authenticated: (_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const WeatherScreen()),
          );
        },
        orElse: () {},
      );
    });
    String? errorMessage;
    authState.maybeWhen(
      error: (msg) => errorMessage = msg,
      orElse: () {},
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 32.0, bottom: 32.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final double logoSize = constraints.maxWidth < 400 ? 80 : 120;
                    return SvgPicture.asset(
                      'assets/images/logo.svg',
                      width: logoSize,
                      height: logoSize,
                    );
                  },
                ),
              ),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 350),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter your email';
                              }
                              final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                              if (!emailRegex.hasMatch(value)) {
                                return 'Enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) =>
                                value == null || value.isEmpty ? 'Enter your password' : null,
                          ),
                          const SizedBox(height: 24),
                          authState.maybeWhen(
                            loading: () => const CircularProgressIndicator(),
                            orElse: () => SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: executeLogin,
                                child: const Text('Login'),
                              ),
                            ),
                          ),
                          if (errorMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text(
                                errorMessage!,
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 