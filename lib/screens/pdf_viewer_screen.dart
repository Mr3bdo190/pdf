import 'dart:io';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../theme/app_colors.dart';

class PdfViewerScreen extends StatefulWidget {
  final File file;
  
  const PdfViewerScreen({Key? key, required this.file}) : super(key: key);

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  void _showActionMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    // استخراج اسم الملف من المسار
    String fileName = widget.file.path.split('/').last;

    return Scaffold(
      backgroundColor: AppColors.surfaceVariant,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.onSurfaceVariant),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fileName, style: const TextStyle(color: AppColors.onSurface, fontSize: 16, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
            const Text('Viewing Document', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant), onPressed: () => _showActionMessage('البحث قيد التطوير')),
          IconButton(icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          // عارض الـ PDF الفعلي
          SfPdfViewer.file(
            widget.file,
            controller: _pdfViewerController,
            canShowScrollHead: false,
            canShowScrollStatus: false,
          ),
          // زرار التعليقات
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () => _showActionMessage('إضافة تعليق جديد...'),
              child: const Icon(Icons.add_comment, color: Colors.white),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, -2))],
        ),
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            _buildBottomTool(Icons.edit, 'Edit', () => _showActionMessage('تم تفعيل وضع التعديل')),
            _buildBottomTool(Icons.format_color_text, 'Highlight', () => _showActionMessage('أداة التحديد مفعلة')),
            _buildBottomTool(Icons.draw, 'Draw', () => _showActionMessage('أداة الرسم مفعلة')),
            _buildBottomTool(Icons.chat_bubble_outline, 'Comment', () => _showActionMessage('وضع التعليقات')),
            const VerticalDivider(indent: 15, endIndent: 15, color: AppColors.surfaceVariant),
            _buildBottomTool(Icons.bookmark_border, 'Bookmark', () => _showActionMessage('تم إضافة علامة مرجعية')),
            _buildBottomTool(Icons.share, 'Share', () => _showActionMessage('جاري المشاركة...')),
            _buildBottomTool(Icons.print, 'Print', () => _showActionMessage('جاري الإرسال للطابعة...')),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTool(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.onSurfaceVariant),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
