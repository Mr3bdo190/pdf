import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/pdf_service.dart';

class CreatePdfScreen extends StatefulWidget {
  const CreatePdfScreen({Key? key}) : super(key: key);

  @override
  State<CreatePdfScreen> createState() => _CreatePdfScreenState();
}

class _CreatePdfScreenState extends State<CreatePdfScreen> {
  String _selectedAction = 'blank';
  bool _isLoading = false;

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _handleCreateAction() async {
    setState(() => _isLoading = true);
    String? path;
    
    try {
      if (_selectedAction == 'blank') {
        path = await PdfService.createBlankPdf();
      } else if (_selectedAction == 'images') {
        path = await PdfService.imagesToPdf();
      } else if (_selectedAction == 'camera') {
        path = await PdfService.scanFromCamera();
      } else {
        _showMessage('هذه الميزة قيد التطوير حالياً');
      }

      if (path != null) {
        _showMessage('تم الحفظ بنجاح في:\n$path');
      }
    } catch (e) {
      _showMessage('حدث خطأ: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.outlineVariant, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 24),
            const Text('Document Setup', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            const Align(alignment: Alignment.centerLeft, child: Text('Filename Template', style: TextStyle(color: AppColors.onSurfaceVariant, fontWeight: FontWeight.bold))),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surfaceContainer,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              controller: TextEditingController(text: 'New_PDF_{{date}}'),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.surfaceVariant, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () => Navigator.pop(context),
                child: const Text('SAVE SETTINGS', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0.5,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.onSurface), onPressed: () => Navigator.pop(context)),
        title: const Text('Create PDF', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.settings, color: AppColors.onSurface), onPressed: _showSettingsSheet),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Create', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildQuickCard('blank', Icons.description, 'Blank Document')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildQuickCard('camera', Icons.photo_camera, 'Scan from Camera')),
                    const SizedBox(width: 12),
                    Expanded(child: _buildQuickCard('images', Icons.image, 'From Images')),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                const Text('Convert to PDF', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: [
                    _buildConvertCard('Word to PDF', '.docx, .doc', Icons.description, Colors.blue),
                    _buildConvertCard('Excel to PDF', '.xlsx, .xls', Icons.table_chart, Colors.green),
                    _buildConvertCard('PPT to PDF', '.pptx, .ppt', Icons.slideshow, Colors.orange),
                    _buildConvertCard('Text to PDF', '.txt, .rtf', Icons.text_fields, Colors.grey),
                  ],
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Document Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant)),
                    TextButton(onPressed: _showSettingsSheet, child: const Text('Edit All', style: TextStyle(color: AppColors.primary))),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.outlineVariant)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.straighten, color: AppColors.onSurfaceVariant),
                          SizedBox(width: 12),
                          Text('Paper Size', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Text('A4 Standard', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                border: const Border(top: BorderSide(color: AppColors.outlineVariant)),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                onPressed: _isLoading ? null : _handleCreateAction,
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('START CREATING PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCard(String id, IconData icon, String title) {
    bool isSelected = _selectedAction == id;
    return GestureDetector(
      onTap: () => setState(() => _selectedAction = id),
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: isSelected ? Colors.white : AppColors.primary),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppColors.onSurface)),
          ],
        ),
      ),
    );
  }

  Widget _buildConvertCard(String title, String ext, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _showMessage('قريباً: تحويل الملفات يتطلب اتصال بخادم (Server)'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12), overflow: TextOverflow.ellipsis),
                  Text(ext, style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
