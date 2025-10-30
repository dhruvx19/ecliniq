
import 'package:ecliniq/ecliniq_ui/lib/tokens/styles.dart';
import 'package:flutter/material.dart';

class NotificationsSettingsWidget extends StatefulWidget {
  final bool initialWhatsAppEnabled;
  final bool initialSmsEnabled;
  final bool initialInAppEnabled;
  final bool initialEmailEnabled;
  final bool initialPromotionalEnabled;
  final Function(NotificationSettings)? onSettingsChanged;

  const NotificationsSettingsWidget({
    super.key,
    this.initialWhatsAppEnabled = true,
    this.initialSmsEnabled = true,
    this.initialInAppEnabled = true,
    this.initialEmailEnabled = true,
    this.initialPromotionalEnabled = false,
    this.onSettingsChanged,
  });

  @override
  State<NotificationsSettingsWidget> createState() =>
      _NotificationsSettingsWidgetState();
}

class _NotificationsSettingsWidgetState
    extends State<NotificationsSettingsWidget> {
  late bool whatsAppEnabled;
  late bool smsEnabled;
  late bool inAppEnabled;
  late bool emailEnabled;
  late bool promotionalEnabled;

  @override
  void initState() {
    super.initState();
    whatsAppEnabled = widget.initialWhatsAppEnabled;
    smsEnabled = widget.initialSmsEnabled;
    inAppEnabled = widget.initialInAppEnabled;
    emailEnabled = widget.initialEmailEnabled;
    promotionalEnabled = widget.initialPromotionalEnabled;
  }

  void _updateSettings() {
    widget.onSettingsChanged?.call(
      NotificationSettings(
        whatsApp: whatsAppEnabled,
        sms: smsEnabled,
        inApp: inAppEnabled,
        email: emailEnabled,
        promotional: promotionalEnabled,
      ),
    );
  }

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
              'Notifications',
              style: EcliniqTextStyles.headlineLarge.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),

          _NotificationToggleItem(
            icon: 'whatsapp',
            iconColor: Colors.green,
            title: "What's App Notifications",
            subtitle:
                'Keep it turn ON to get the notification about your appointment and token number status',
            value: whatsAppEnabled,
            onChanged: (value) {
              setState(() {
                whatsAppEnabled = value;
              });
              _updateSettings();
            },
          ),

          _buildDivider(),

          _NotificationToggleItem(
            icon: 'sms',
            iconColor: Colors.blue,
            title: 'SMS Notifications',
            subtitle:
                'Keep it turn ON to get the notification about your appointment and token number status',
            value: smsEnabled,
            onChanged: (value) {
              setState(() {
                smsEnabled = value;
              });
              _updateSettings();
            },
          ),

          _buildDivider(),

          _NotificationToggleItem(
            icon: 'bell',
            iconColor: Colors.blue,
            title: 'In App Updates',
            subtitle:
                'Keep it turn ON to get the notification about your appointment and token number status',
            value: inAppEnabled,
            onChanged: (value) {
              setState(() {
                inAppEnabled = value;
              });
              _updateSettings();
            },
          ),

          _buildDivider(),

          _NotificationToggleItem(
            icon: 'email',
            iconColor: Colors.blue,
            title: 'Get Email Notifications',
            subtitle:
                'Keep it turn ON to get the new feature updates and newletters',
            value: emailEnabled,
            onChanged: (value) {
              setState(() {
                emailEnabled = value;
              });
              _updateSettings();
            },
          ),

          _buildDivider(),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Get Promotional Messages and Updates',
                    style: EcliniqTextStyles.bodySmall.copyWith(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey[200],
      indent: 20,
      endIndent: 20,
    );
  }
}

class _NotificationToggleItem extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggleItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  IconData _getIconData() {
    switch (icon) {
      case 'whatsapp':
        return Icons.message;
      case 'sms':
        return Icons.sms_outlined;
      case 'bell':
        return Icons.notifications_outlined;
      case 'email':
        return Icons.email_outlined;
      default:
        return Icons.notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,

            child: Icon(_getIconData(), color: iconColor, size: 24),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: EcliniqTextStyles.headlineXMedium.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: EcliniqTextStyles.bodySmall.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Colors.blue,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationSettings {
  final bool whatsApp;
  final bool sms;
  final bool inApp;
  final bool email;
  final bool promotional;

  NotificationSettings({
    required this.whatsApp,
    required this.sms,
    required this.inApp,
    required this.email,
    required this.promotional,
  });
}
