import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';
import 'package:trazza/features/auth/application/providers/auth_provider.dart';
import 'package:trazza/features/profile/presentation/widgets/profile_menu_tile.dart';
import 'package:trazza/features/profile/presentation/widgets/profile_section_card.dart';

final biometricEnabledProvider = StateProvider<bool>((ref) => false);
final notificationsEnabledProvider = StateProvider<bool>((ref) => true);

class ProfileScreen extends ConsumerWidget {
  final VoidCallback? onBudgetTap;
  final VoidCallback? onCategoriesTap;
  final VoidCallback? onPaymentMethodsTap;
  final VoidCallback? onAlertsTap;
  final VoidCallback? onEditProfileTap;
  final VoidCallback? onPrivacyTap;
  final VoidCallback? onHelpTap;
  final VoidCallback? onSignOut;

  const ProfileScreen({
    super.key,
    this.onBudgetTap,
    this.onCategoriesTap,
    this.onPaymentMethodsTap,
    this.onAlertsTap,
    this.onEditProfileTap,
    this.onPrivacyTap,
    this.onHelpTap,
    this.onSignOut,
  });

  void _showUnavailableMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Esta opción estará disponible pronto.')),
    );
  }

  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('¿Cerrar sesión?'),
        content: const Text('Tendrás que volver a ingresar para continuar.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppTheme.errorColor),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (shouldSignOut == true) {
      try {
        if (onSignOut != null) {
          onSignOut!.call();
        } else {
          await ref.read(authProvider).signOut();
        }
      } catch (_) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No fue posible cerrar sesión. Inténtalo de nuevo.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBiometricEnabled = ref.watch(biometricEnabledProvider);
    final areNotificationsEnabled = ref.watch(notificationsEnabledProvider);

    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          'Perfil y configuración',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppTheme.onSurfaceColor,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          _ProfileHeader(onEditProfileTap: onEditProfileTap),
          const SizedBox(height: 24),
          ProfileSectionCard(
            title: 'Gestión financiera',
            icon: Icons.account_balance_wallet_outlined,
            children: [
              ProfileMenuTile(
                icon: Icons.savings_outlined,
                title: 'Presupuesto',
                subtitle: 'Ajusta tus límites mensuales',
                onTap: onBudgetTap ?? () => _showUnavailableMessage(context),
              ),
              ProfileMenuTile(
                icon: Icons.category_outlined,
                title: 'Categorías',
                subtitle: 'Organiza tus gastos',
                onTap:
                    onCategoriesTap ?? () => _showUnavailableMessage(context),
              ),
              ProfileMenuTile(
                icon: Icons.credit_card_outlined,
                title: 'Métodos de pago',
                subtitle: 'Administra tus cuentas y tarjetas',
                onTap: onPaymentMethodsTap ??
                    () => _showUnavailableMessage(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProfileSectionCard(
            title: 'Preferencias',
            icon: Icons.tune_rounded,
            children: [
              ProfileMenuTile(
                icon: Icons.notifications_outlined,
                title: 'Alertas y recordatorios',
                subtitle: 'Recibe avisos sobre tus gastos',
                onTap: onAlertsTap ?? () => _showUnavailableMessage(context),
                trailing: Switch.adaptive(
                  value: areNotificationsEnabled,
                  onChanged: (value) => ref
                      .read(notificationsEnabledProvider.notifier)
                      .state = value,
                ),
              ),
              ProfileMenuTile(
                icon: Icons.fingerprint_rounded,
                title: 'Acceso con biometría',
                subtitle: 'Usa tu huella o reconocimiento facial',
                onTap: () => ref
                    .read(biometricEnabledProvider.notifier)
                    .state = !isBiometricEnabled,
                trailing: Switch.adaptive(
                  value: isBiometricEnabled,
                  onChanged: (value) => ref
                      .read(biometricEnabledProvider.notifier)
                      .state = value,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ProfileSectionCard(
            title: 'Cuenta y seguridad',
            icon: Icons.person_outline_rounded,
            children: [
              ProfileMenuTile(
                icon: Icons.lock_outline_rounded,
                title: 'Privacidad',
                subtitle: 'Revisa tus preferencias de privacidad',
                onTap: onPrivacyTap ?? () => _showUnavailableMessage(context),
              ),
              ProfileMenuTile(
                icon: Icons.help_outline_rounded,
                title: 'Ayuda y soporte',
                subtitle: 'Estamos aquí para ayudarte',
                onTap: onHelpTap ?? () => _showUnavailableMessage(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => _confirmSignOut(context, ref),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Cerrar sesión'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
              side: BorderSide(color: AppTheme.errorColor.withValues(alpha: 0.4)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final VoidCallback? onEditProfileTap;

  const _ProfileHeader({this.onEditProfileTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      color: AppTheme.surfaceContainerLowest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.surfaceContainerHigh),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 34,
              backgroundColor: AppTheme.primaryColor,
              child: Text(
                'MR',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onPrimaryColor,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'María Fernanda Rojas',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurfaceColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'maría.rojas@email.com',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Editar perfil',
              onPressed: onEditProfileTap,
              icon: const Icon(Icons.edit_outlined, size: 20),
              color: AppTheme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
