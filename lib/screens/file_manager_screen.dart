import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FileManagerScreen extends StatelessWidget {
  const FileManagerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('File Manager', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        actions: [IconButton(icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant), onPressed: () {})],
      ),
      body: Column(
        children: [
          // Storage Widget
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.outline.withOpacity(0.2))),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [Icon(Icons.cloud_done, color: AppColors.primary), SizedBox(width: 8), Text('Pro Cloud Sync', style: TextStyle(fontWeight: FontWeight.bold))]),
                      Text('45.2 GB / 100 GB', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(value: 0.45, backgroundColor: AppColors.surfaceVariant, color: AppColors.primary, minHeight: 8, borderRadius: BorderRadius.circular(4)),
                ],
              ),
            ),
          ),
          // Tabs
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildTab('Recent', isActive: true),
                _buildTab('Favorites'),
                _buildTab('Downloads'),
                _buildTab('Internal Storage'),
                _buildTab('Cloud'),
              ],
            ),
          ),
          // File Grid
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildFileCard('Employee_Handbook_2024.pdf', '118 Pgs • 12.5 MB', true),
                _buildFileCard('Acme_Corp_Merger_Agreement.pdf', '14 Pgs • 1.8 MB', true),
                _buildFileCard('Meeting_Notes_Design.docx', '3 Pgs • 845 KB', false),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTab(String title, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.secondaryContainer : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? null : Border.all(color: AppColors.outline.withOpacity(0.3)),
      ),
      child: Center(child: Text(title, style: TextStyle(color: isActive ? Colors.black : AppColors.onSurfaceVariant, fontWeight: FontWeight.bold))),
    );
  }

  Widget _buildFileCard(String title, String details, bool isPdf) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: AppColors.outline.withOpacity(0.2))),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: isPdf ? AppColors.errorContainer : AppColors.primaryContainer.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: Icon(isPdf ? Icons.picture_as_pdf : Icons.description, color: isPdf ? AppColors.error : AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), overflow: TextOverflow.ellipsis),
        subtitle: Text(details, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}
