import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  String _selectedPlan = 'yearly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('PDF Master Pro', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.secondaryContainer,
              child: Icon(Icons.workspace_premium, color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: 16),
            const Text('Go Premium', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'Unlock the full potential of your documents with unlimited access to powerful AI and pro tools.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16),
            ),
            const SizedBox(height: 32),
            
            // Features Box
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.outline.withOpacity(0.2)),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.star, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text('Pro Features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureItem('Unlimited OCR', 'Convert unlimited scanned documents.'),
                  _buildFeatureItem('AI PDF Tools', 'Instantly summarize and translate.'),
                  _buildFeatureItem('Cloud Sync', 'Access securely across all devices.'),
                  _buildFeatureItem('No Ads & Unlimited Conversions', null),
                  _buildFeatureItem('Priority Processing', null),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pricing Plans
            _buildPlanCard('yearly', 'Yearly Plan', '\$4.99 / month, billed annually', '\$59.99/yr', badge: 'Save 50%'),
            _buildPlanCard('monthly', 'Monthly Plan', 'Flexible billing, cancel anytime', '\$9.99/mo'),
            _buildPlanCard('lifetime', 'Lifetime Plan', 'Pay once, own forever', '\$149.99\nOne-time'),

            const SizedBox(height: 32),
            // Call to Action
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () {},
                child: const Text('Start Free Trial', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '7 days free, then \$59.99/year. Cancel anytime before trial ends.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () {}, child: const Text('Restore Purchase', style: TextStyle(color: AppColors.onSurfaceVariant))),
                const Text('•', style: TextStyle(color: AppColors.onSurfaceVariant)),
                TextButton(onPressed: () {}, child: const Text('Terms of Service', style: TextStyle(color: AppColors.onSurfaceVariant))),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String title, String? subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard(String id, String title, String subtitle, String price, {String? badge}) {
    final isSelected = _selectedPlan == id;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEEF0FF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.outline.withOpacity(0.3), width: 2),
          boxShadow: [if (isSelected) BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 8)],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.outline, width: isSelected ? 6 : 2),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
                    ],
                  ),
                ),
                Text(
                  price,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: -32,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
