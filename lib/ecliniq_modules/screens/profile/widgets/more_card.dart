import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class MoreSettingsMenuWidget extends StatelessWidget {
  final VoidCallback? onReferEarnPressed;
  final VoidCallback? onHelpSupportPressed;
  final VoidCallback? onTermsPressed;
  final VoidCallback? onPrivacyPressed;
  final VoidCallback? onFaqPressed;
  final VoidCallback? onAboutPressed;
  final VoidCallback? onLogoutPressed;
  final VoidCallback? onDeleteAccountPressed;
  final String appVersion;
  final String supportEmail;

  const MoreSettingsMenuWidget({
    super.key,
    this.onReferEarnPressed,
    this.onHelpSupportPressed,
    this.onTermsPressed,
    this.onPrivacyPressed,
    this.onFaqPressed,
    this.onAboutPressed,
    this.onLogoutPressed,
    this.onDeleteAccountPressed,
    this.appVersion = 'v1.0.0',
    this.supportEmail = 'Support@eclinicq.com',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              'More',
              style: EcliniqTextStyles.headlineLarge.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),

          _MoreMenuItem(
            icon: Icons.card_giftcard,
            iconColor: Colors.green,
            title: 'Refer & Earn',
            subtitle: 'Invite Friends and Family',
            onTap: onReferEarnPressed,
          ),

          _buildDivider(),

          _MoreMenuItem(
            icon: Icons.help_outline,
            iconColor: Colors.blue,
            title: 'Help & Support',
            subtitle: 'Send us Email on : $supportEmail',
            onTap: onHelpSupportPressed,
          ),

          _buildDivider(),

          _MoreMenuItem(
            icon: Icons.description_outlined,
            iconColor: Colors.blue,
            title: 'Terms & Conditions',
            onTap: onTermsPressed,
          ),

          _buildDivider(),

          _MoreMenuItem(
            icon: Icons.shield_outlined,
            iconColor: Colors.blue,
            title: 'Privacy Policy',
            onTap: onPrivacyPressed,
          ),

          _buildDivider(),

          _MoreMenuItem(
            icon: Icons.quiz_outlined,
            iconColor: Colors.blue,
            title: "FAQ's and Grievances",
            onTap: onFaqPressed,
          ),

          _buildDivider(),

          _MoreMenuItem(
            icon: Icons.info_outline,
            iconColor: Colors.blue,
            title: 'About e-Clinic Q',
            onTap: onAboutPressed,
          ),

          _buildDivider(),

          _MoreMenuItem(
            icon: Icons.logout,
            iconColor: Colors.blue,
            title: 'Logout',
            onTap: onLogoutPressed,
          ),

          const SizedBox(height: 20),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: onDeleteAccountPressed,
              child: Container(
                width: 396,
                height: 52,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Delete Account',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),

          Center(
            child: Column(
              children: [
                Text(
                  'eClinic-Q',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  appVersion,
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 16,
      endIndent: 20,
    );
  }
}

class _MoreMenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _MoreMenuItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withOpacity(0.1),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: EcliniqTextStyles.headlineXMedium.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: EcliniqTextStyles.bodySmall.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Color(0xFF424242), size: 24),
          ],
        ),
      ),
    );
  }
}
