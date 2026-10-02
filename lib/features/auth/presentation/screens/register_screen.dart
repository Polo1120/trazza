import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/auth/application/providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLogin;

  const RegisterScreen({super.key, this.onLogin});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool isPasswordVisible = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> handleRegister() async {
    FocusScope.of(context).unfocus();

    if (!(registerFormKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => isLoading = true);

    try {
      await ref.read(authProvider).signUp(
            name: nameController.text.trim(),
            email: emailController.text.trim(),
            password: passwordController.text,
          );

      if (!mounted) return;
      context.go('/');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible crear tu cuenta. Inténtalo de nuevo.'),
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void navigateBack() {
    if (widget.onLogin != null) {
      widget.onLogin!.call();
      return;
    }
    Navigator.of(context).maybePop();
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Escribe tu nombre.';
    }
    if (value.trim().length < 2) {
      return 'Tu nombre debe tener al menos 2 letras.';
    }
    return null;
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
    if (value == null || value.isEmpty) return 'Crea una contraseña.';
    if (value.length < 8) return 'Usa al menos 8 caracteres.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Transform.translate(
                offset: const Offset(0, -8),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IconButton(
                    onPressed: navigateBack,
                    tooltip: 'Volver',
                    icon: const Icon(Icons.arrow_back_rounded),
                  ),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight > 40
                          ? constraints.maxHeight - 40
                          : 0,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: Form(
                          key: registerFormKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                        const _BrandMark(),
                        const SizedBox(height: 24),
                        Text(
                          'Crea tu cuenta',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurfaceColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Empieza a organizar tus gastos de forma sencilla.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            height: 1.5,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildNameField(),
                        const SizedBox(height: 16),
                        _buildEmailField(),
                        const SizedBox(height: 16),
                        _buildPasswordField(),
                        const SizedBox(height: 12),
                        Text(
                          'Tu contraseña debe tener al menos 8 caracteres.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 54,
                          child: FilledButton(
                            onPressed: isLoading ? null : handleRegister,
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
                                : const Text('Crear cuenta'),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '¿Ya tienes una cuenta?',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                            TextButton(
                              onPressed: navigateBack,
                              child: Text(
                                'Inicia sesión',
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
          ],
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: nameController,
      validator: validateName,
      keyboardType: TextInputType.name,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.name],
      decoration: _inputDecoration(
        label: 'Nombre completo',
        hint: '¿Cómo te llamas?',
        icon: Icons.person_outline_rounded,
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
      autofillHints: const [AutofillHints.newPassword],
      onFieldSubmitted: (_) => handleRegister(),
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
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Icon(
            Icons.account_balance_wallet_rounded,
            size: 32,
            color: AppTheme.onPrimaryColor,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'trazza',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppTheme.primaryColor,
          ),
        ),
      ],
    );
  }
}
