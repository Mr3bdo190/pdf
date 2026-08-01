import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AllToolsScreen extends StatelessWidget {
  const AllToolsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('All Tools', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildToolItem(Icons.edit_document, 'Edit PDF', 'Modify text & images'),
          _buildToolItem(Icons.add_circle, 'Create PDF', 'From blank or template'),
          _buildToolItem(Icons.call_merge, 'Merge PDF', 'Combine multiple files'),
          _buildToolItem(Icons.call_split, 'Split PDF', 'Extract or split pages'),
          _buildToolItem(Icons.compress, 'Compress', 'Reduce file size'),
          _buildToolItem(Icons.lock, 'Protect PDF', 'Add password'),
          _buildToolItem(Icons.branding_watermark, 'Watermark', 'Add text/image'),
          _buildToolItem(Icons.draw, 'Sign PDF', 'Add signatures'),
        ],
      ),
    );
  }

  Widget _buildToolItem(IconData icon, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.primaryContainer.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: AppColors.primaryContainer, size: 30),
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
