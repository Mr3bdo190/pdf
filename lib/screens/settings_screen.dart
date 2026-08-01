import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _cloudSync = true;
  bool _bioUnlock = false;
  bool _pushNotif = true;
  bool _emailUpdates = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.9),
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _buildSectionHeader('General'),
          _buildSettingsBox([
            _buildNavRow(Icons.language, 'Language', trailingText: 'English (US)'),
            _buildSwitchRow(Icons.dark_mode, 'Dark Mode', 'Adjust app appearance', _darkMode, (v) => setState(() => _darkMode = v)),
          ]),
          
          _buildSectionHeader('Storage & Sync'),
          _buildSettingsBox([
            _buildSwitchRow(Icons.cloud_sync, 'Cloud Sync', 'Sync files across devices', _cloudSync, (v) => setState(() => _cloudSync = v)),
            _buildNavRow(Icons.folder_outlined, 'Default Save Location', trailingText: 'Local/Documents'),
          ]),

          _buildSectionHeader('Security'),
          _buildSettingsBox([
            _buildSwitchRow(Icons.fingerprint, 'Biometric Unlock', 'Require FaceID/TouchID', _bioUnlock, (v) => setState(() => _bioUnlock = v)),
            _buildNavRow(Icons.lock_outline, 'Change Password'),
          ]),

          _buildSectionHeader('Notifications'),
          _buildSettingsBox([
            _buildSwitchRow(Icons.notifications_active_outlined, 'Push Notifications', null, _pushNotif, (v) => setState(() => _pushNotif = v)),
            _buildSwitchRow(Icons.mail_outline, 'Email Updates', 'News and promotional offers', _emailUpdates, (v) => setState(() => _emailUpdates = v)),
          ]),

          _buildSectionHeader('About'),
          _buildSettingsBox([
            _buildNavRow(Icons.info_outline, 'App Version', trailingText: 'v2.14.3 (Pro)', showArrow: false),
            _buildNavRow(Icons.star_outline, 'Rate App', showArrow: true, trailingIcon: Icons.open_in_new),
            _buildNavRow(Icons.gavel, 'Legal & Terms'),
          ]),

          const SizedBox(height: 24),
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: const Text('Sign Out', style: TextStyle(color: AppColors.error, fontSize: 16, fontWeight: FontWeight.bold)),
              style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), backgroundColor: AppColors.error.withOpacity(0.1)),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8, top: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsBox(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainer),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
      ),
      child: Column(
        children: children.asMap().entries.map((entry) {
          int idx = entry.key;
          Widget child = entry.value;
          return Column(
            children: [
              child,
              if (idx < children.length - 1) const Divider(height: 1, indent: 48),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNavRow(IconData icon, String title, {String? trailingText, bool showArrow = true, IconData trailingIcon = Icons.chevron_right}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(title, style: const TextStyle(fontSize: 16, color: AppColors.onSurface)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null) Text(trailingText, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
          if (showArrow) ...[
            if (trailingText != null) const SizedBox(width: 4),
            Icon(trailingIcon, color: AppColors.onSurfaceVariant, size: 20),
          ]
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildSwitchRow(IconData icon, String title, String? subtitle, bool value, ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon, color: AppColors.onSurfaceVariant),
      title: Text(title, style: const TextStyle(fontSize: 16, color: AppColors.onSurface)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primaryContainer,
      ),
    );
  }
}
