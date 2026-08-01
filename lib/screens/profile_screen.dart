import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'settings_screen.dart';
import 'subscription_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        automaticallyImplyLeading: false, // ده بيمنع ظهور زرار الرجوع التلقائي
        title: const Text('Profile', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.onSurfaceVariant),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.surface, width: 4),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                        ),
                        child: const CircleAvatar(
                          radius: 48,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
                        ),
                      ),
                      Positioned(
                        bottom: -8,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4)],
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.stars, color: Colors.white, size: 14),
                                SizedBox(width: 4),
                                Text('PRO', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Abdullah Sayed', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('abdullah@example.com', style: TextStyle(color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Storage Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceVariant, width: 4),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.cloud, color: AppColors.primary),
                          SizedBox(width: 8),
                          Text('Cloud Storage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      Text('45%', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('45.2 GB of 100 GB used', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 0.45,
                    backgroundColor: AppColors.surfaceContainerHighest,
                    color: AppColors.primary,
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('LOCAL FILES', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 10, fontWeight: FontWeight.bold)),
                          Text('1,204', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceVariant,
                          foregroundColor: AppColors.onSurface,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {},
                        child: const Text('Manage Space'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Settings & Actions
            _buildActionItem(
              icon: Icons.workspace_premium,
              title: 'Manage Subscription',
              subtitle: 'Billing, plan details, features',
              iconColor: Colors.white,
              iconBgColor: AppColors.primary,
              bgColor: AppColors.primaryFixed.withOpacity(0.3),
              titleColor: AppColors.primary,
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()));
              },
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: Column(
                children: [
                  _buildListItem(Icons.sync, 'Backup & Cloud Sync'),
                  const Divider(height: 1, indent: 56),
                  _buildListItem(Icons.tune, 'App Settings', onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                  }),
                  const Divider(height: 1, indent: 56),
                  _buildListItem(Icons.help_outline, 'Help & Support'),
                  const Divider(height: 1, indent: 56),
                  _buildListItem(Icons.shield_outlined, 'Privacy Policy'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _buildActionItem(
              icon: Icons.logout,
              title: 'Logout',
              iconColor: AppColors.error,
              iconBgColor: AppColors.errorContainer,
              bgColor: Colors.white,
              titleColor: AppColors.error,
              borderColor: AppColors.errorContainer,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String title,
    String? subtitle,
    required Color iconColor,
    required Color iconBgColor,
    required Color bgColor,
    required Color titleColor,
    Color? borderColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: borderColor != null ? Border.all(color: borderColor) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor)),
                  if (subtitle != null) Text(subtitle, style: TextStyle(color: titleColor.withOpacity(0.8), fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: titleColor),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(color: AppColors.secondaryContainer, shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.onSecondaryContainer, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
    );
  }
}
