import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/pdf_service.dart';
import 'pdf_viewer_screen.dart';

class FilesScreen extends StatelessWidget {
  const FilesScreen({Key? key}) : super(key: key);

  // دالة لفتح واختيار ملف لعرضه
  Future<void> _openFilePickerAndShow(BuildContext context) async {
    List<File> files = await PdfService.pickFiles(allowMultiple: false);
    if (files.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PdfViewerScreen(file: files.first)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 16,
              backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'),
            ),
            const SizedBox(width: 12),
            const Text('PDF Master Pro', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppColors.primary), onPressed: () {}),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: AppColors.onSurfaceVariant),
                  hintText: 'Search documents...',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTab('Recent', isActive: true),
                  _buildTab('Favorites'),
                  _buildTab('Downloads'),
                  _buildTab('Cloud'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildFileItem(context, 'Q3_Financial_Report_Final.pdf', '42 Pgs • 4.2 MB • Oct 24, 2023'),
                  _buildFileItem(context, 'Client_Contract_AcmeCorp.pdf', '15 Pgs • 1.8 MB • Oct 22, 2023'),
                  _buildFileItem(context, 'Product_Roadmap_2024.pdf', '8 Pgs • 3.1 MB • Oct 20, 2023'),
                  _buildFileItem(context, 'Employee_Handbook_V2.pdf', '120 Pgs • 12.5 MB • Oct 15, 2023'),
                ],
              ),
            ),
          ],
        ),
      ),
      // زر الإضافة العائم لفتح الملفات
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => _openFilePickerAndShow(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildTab(String title, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? null : Border.all(color: AppColors.outline.withOpacity(0.3)),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: isActive ? Colors.white : AppColors.onSurfaceVariant, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildFileItem(BuildContext context, String title, String subtitle) {
    return InkWell(
      onTap: () => _openFilePickerAndShow(context), // اضغط على أي ملف ليفتح عارض الملفات كتيست
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.picture_as_pdf, color: AppColors.error),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14)),
                ],
              ),
            ),
            const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
