import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildEmailField(),
                const SizedBox(height: 8),
                _buildPasswordField(),
                const SizedBox(height: 8),
                _buildLoginButton(),
                const SizedBox(height: 8),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.emailValidation;
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Email"),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.passwordValidation;
        }
        return null;
      },
      decoration: const InputDecoration(hintText: "Password"),
    );
  }

  Widget _buildLoginButton() {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          widget.onLogin();
        } else if (state is AuthUnauthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.invalidAuth)),
          );
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              context.read<AuthBloc>().add(
                LoginEvent(emailController.text, passwordController.text),
              );
            }
          },
          child: Text(AppLocalizations.of(context)!.loginButton),
        );
      },
    );
  }

  Widget _buildRegisterButton() {
    return OutlinedButton(
      onPressed: widget.onRegister,
      child: Text(AppLocalizations.of(context)!.registerButton),
    );
  }
}
