import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class PdfViewerScreen extends StatelessWidget {
  final String fileName;
  const PdfViewerScreen({Key? key, this.fileName = 'Q4_Financial_Report_Final_v2.pdf'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Text(fileName, style: const TextStyle(color: AppColors.onSurface, fontSize: 16, fontWeight: FontWeight.bold)),
            const Text('Page 1 of 42', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 12)),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert, color: AppColors.onSurfaceVariant), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          // Simulated PDF Page
          Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
              ),
              child: const Center(child: Text('PDF Content Preview', style: TextStyle(color: Colors.grey))),
            ),
          ),
          // FAB for comments
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: () {},
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
            _buildBottomTool(Icons.edit, 'Edit'),
            _buildBottomTool(Icons.format_color_text, 'Highlight'),
            _buildBottomTool(Icons.draw, 'Draw'),
            _buildBottomTool(Icons.chat_bubble_outline, 'Comment'),
            const VerticalDivider(indent: 15, endIndent: 15, color: AppColors.surfaceVariant),
            _buildBottomTool(Icons.bookmark_border, 'Bookmark'),
            _buildBottomTool(Icons.share, 'Share'),
            _buildBottomTool(Icons.print, 'Print'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomTool(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.onSurfaceVariant),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
