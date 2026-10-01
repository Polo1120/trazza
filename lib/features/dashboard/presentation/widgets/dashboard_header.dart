import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trazza/core/theme/app_theme.dart';

class DashboardHeader extends StatelessWidget {
  final String userName;
  final String screenTitle;
  final String? avatarUrl;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;

  const DashboardHeader({
    super.key,
    this.userName = 'Camila',
    this.screenTitle = 'Dashboard',
    this.avatarUrl,
    this.onNotificationPressed,
    this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.surfaceColor.withValues(alpha: 0.8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_rounded,
                    color: AppTheme.onPrimaryColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Hola, $userName',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      screenTitle,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.onSurfaceColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  onPressed: onNotificationPressed,
                  icon: const Icon(
                    Icons.notifications_none_rounded,
                    color: AppTheme.onSurfaceVariant,
                    size: 24,
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: AppTheme.surfaceContainer.withValues(alpha: 0.6),
                    minimumSize: const Size(44, 44),
                    shape: const CircleBorder(),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onProfilePressed,
                  borderRadius: BorderRadius.circular(22),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.surfaceContainerHigh,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primaryFixedDim,
                        width: 1.5,
                      ),
                    ),
                    child: ClipOval(
                      child: avatarUrl != null
                          ? Image.network(
                              avatarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.person_rounded,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
