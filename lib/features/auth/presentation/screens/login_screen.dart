import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/auth/application/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSignUp;
  final VoidCallback? onForgotPassword;

  const LoginScreen({
    super.key,
    this.onSignUp,
    this.onForgotPassword,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    FocusScope.of(context).unfocus();

    if (!(loginFormKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => isLoading = true);

    try {
      await ref.read(authProvider).signIn(
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      if (!mounted) return;
      context.go('/');
    } catch (error) {
      if (!mounted) return;
      final errorMessage =
          error is AuthException ? error.message.toLowerCase() : '';
      final message = errorMessage.contains('invalid login credentials')
          ? 'El correo o la contraseña no coinciden.'
          : errorMessage.contains('email not confirmed')
              ? 'Confirma tu correo electrónico antes de iniciar sesión.'
              : 'No fue posible iniciar sesión. Inténtalo de nuevo.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void navigateToSignUp() {
    if (widget.onSignUp != null) {
      widget.onSignUp!.call();
      return;
    }
    context.push('/register');
  }

  void navigateToPasswordRecovery() {
    widget.onForgotPassword?.call();
    if (widget.onForgotPassword == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'La recuperación de contraseña estará disponible pronto.',
          ),
        ),
      );
    }
  }

  String? validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingresa tu correo electrónico.';
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(email)) {
      return 'Ingresa un correo electrónico válido.';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu contraseña.';
    if (value.length < 8) return 'Usa al menos 8 caracteres.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight > 60
                    ? constraints.maxHeight - 60
                    : 0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Form(
                    key: loginFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const _BrandMark(),
                        const SizedBox(height: 32),
                        Text(
                          '¡Qué bueno verte!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurfaceColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Inicia sesión para seguir al tanto de tus finanzas.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.5,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildEmailField(),
                        const SizedBox(height: 18),
                        _buildPasswordField(),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: navigateToPasswordRecovery,
                            child: Text(
                              '¿Olvidaste tu contraseña?',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed: isLoading ? null : handleLogin,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: AppTheme.onPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: AppTheme.onPrimaryColor,
                                    ),
                                  )
                                : const Text('Iniciar sesión'),
                          ),
                        ),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Aún no tienes una cuenta?',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: navigateToSignUp,
                              child: Text(
                                'Regístrate',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: emailController,
      validator: validateEmail,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      decoration: _inputDecoration(
        label: 'Correo electrónico',
        hint: 'Ingresa tu correo electrónico',
        icon: Icons.mail_outline_rounded,
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      validator: validatePassword,
      obscureText: !isPasswordVisible,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      onFieldSubmitted: (_) => handleLogin(),
      decoration: _inputDecoration(
        label: 'Contraseña',
        hint: 'Mínimo 8 caracteres',
        icon: Icons.lock_outline_rounded,
      ).copyWith(
        suffixIcon: IconButton(
          tooltip:
              isPasswordVisible ? 'Ocultar contraseña' : 'Mostrar contraseña',
          onPressed: () =>
              setState(() => isPasswordVisible = !isPasswordVisible),
          icon: Icon(
            isPasswordVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: AppTheme.onSurfaceVariant),
      filled: true,
      fillColor: AppTheme.surfaceContainerLowest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 1.5),
      ),
      errorMaxLines: 2,
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            size: 36,
            color: AppTheme.onPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'trazza',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
