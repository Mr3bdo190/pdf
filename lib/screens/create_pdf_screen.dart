import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/pdf_service.dart';
import 'pdf_editor_screen.dart'; // <--- استدعاء المحرر الجديد

class CreatePdfScreen extends StatefulWidget {
  const CreatePdfScreen({Key? key}) : super(key: key);

  @override
  State<CreatePdfScreen> createState() => _CreatePdfScreenState();
}

class _CreatePdfScreenState extends State<CreatePdfScreen> {
  String _selectedAction = 'blank';
  bool _isLoading = false;

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: AppColors.primary));
  }

  Future<void> _handleCreateAction() async {
    if (_selectedAction == 'blank') {
      // فتح المحرر التفاعلي مباشرة
      Navigator.push(context, MaterialPageRoute(builder: (_) => const InteractivePdfEditor()));
      return;
    }

    setState(() => _isLoading = true);
    String? path;
    try {
      if (_selectedAction == 'camera') {
        path = await PdfService.scanFromCamera();
      } else {
        _showMessage('هذه الميزة قيد التطوير');
      }
      if (path != null) _showMessage('تم الحفظ بنجاح في:\n$path');
    } catch (e) {
      _showMessage('حدث خطأ: $e');
    } finally {
      setState(() => _isLoading = false);
    }
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
              ],
            ),
          ),
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(top: BorderSide(color: AppColors.outlineVariant)),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: _isLoading ? null : _handleCreateAction,
                child: const Text('START CREATING PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
}
