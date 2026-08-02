import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../services/pdf_service.dart';

class InteractivePdfEditor extends StatefulWidget {
  const InteractivePdfEditor({Key? key}) : super(key: key);

  @override
  State<InteractivePdfEditor> createState() => _InteractivePdfEditorState();
}

class _InteractivePdfEditorState extends State<InteractivePdfEditor> {
  List<CanvasElement> _elements = [];
  bool _isSaving = false;
  bool _isDrawMode = false; // تفعيل وإلغاء وضع الرسم
  Color _selectedColor = Colors.black; // اللون الافتراضي
  
  List<Offset> _currentPoints = []; // النقط الحالية للرسمة

  final double _canvasWidth = 350;
  final double _canvasHeight = 495;

  void _addText() {
    setState(() => _isDrawMode = false);
    showDialog(
      context: context,
      builder: (context) {
        String newText = '';
        return AlertDialog(
          title: const Text('Add Text'),
          content: TextField(
            onChanged: (val) => newText = val,
            decoration: const InputDecoration(hintText: 'Enter your text here...'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (newText.isNotEmpty) {
                  setState(() {
                    _elements.add(CanvasElement(
                      type: 'text', text: newText,
                      position: const Offset(50, 50),
                      fontSize: 20, color: _selectedColor,
                    ));
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addImage() async {
    setState(() => _isDrawMode = false);
    List<File> files = await PdfService.pickFiles(type: FileType.image, allowMultiple: false);
    if (files.isNotEmpty) {
      setState(() {
        _elements.add(CanvasElement(
          type: 'image', imageFile: files.first,
          position: const Offset(50, 100),
        ));
      });
    }
  }

  Future<void> _exportPdf() async {
    setState(() => _isSaving = true);
    try {
      String? path = await PdfService.exportCustomPdf(_elements, Size(_canvasWidth, _canvasHeight));
      if (path != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم تصدير الـ PDF بنجاح في:\n$path')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('حدث خطأ أثناء الحفظ')));
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: const Text('Pro Editor', style: TextStyle(color: AppColors.onSurface, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.onSurface), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.picture_as_pdf, color: AppColors.primary),
            onPressed: _isSaving ? null : _exportPdf,
            tooltip: 'Export to PDF',
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: _canvasWidth,
          height: _canvasHeight,
          decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
          child: GestureDetector(
            // أحداث الرسم باللمس
            onPanStart: (details) {
              if (!_isDrawMode) return;
              setState(() {
                _currentPoints = [details.localPosition];
                _elements.add(CanvasElement(type: 'path', position: Offset.zero, pathPoints: List.from(_currentPoints), color: _selectedColor));
              });
            },
            onPanUpdate: (details) {
              if (!_isDrawMode) return;
              setState(() {
                _currentPoints.add(details.localPosition);
                _elements.last = CanvasElement(type: 'path', position: Offset.zero, pathPoints: List.from(_currentPoints), color: _selectedColor);
              });
            },
            onPanEnd: (details) {
              if (!_isDrawMode) return;
              _currentPoints = [];
            },
            child: Stack(
              children: [
                Container(color: Colors.transparent), // قاعدة حساسة للمس
                
                // عرض العناصر المرسومة والنصوص
                ..._elements.asMap().entries.map((entry) {
                  int index = entry.key;
                  CanvasElement el = entry.value;

                  if (el.type == 'path' && el.pathPoints != null) {
                    return CustomPaint(
                      painter: _FreehandPainter(el.pathPoints!, el.color),
                      size: Size(_canvasWidth, _canvasHeight),
                    );
                  }

                  return Positioned(
                    left: el.position.dx,
                    top: el.position.dy,
                    child: GestureDetector(
                      onPanUpdate: _isDrawMode ? null : (details) {
                        setState(() {
                          _elements[index] = CanvasElement(
                            type: el.type, text: el.text, imageFile: el.imageFile, fontSize: el.fontSize, color: el.color,
                            position: Offset(
                              (el.position.dx + details.delta.dx).clamp(0.0, _canvasWidth - 50),
                              (el.position.dy + details.delta.dy).clamp(0.0, _canvasHeight - 50),
                            ),
                          );
                        });
                      },
                      child: el.type == 'text'
                          ? Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(border: Border.all(color: _isDrawMode ? Colors.transparent : Colors.blueAccent.withOpacity(0.3), style: BorderStyle.dash)),
                              child: Text(el.text ?? '', style: TextStyle(fontSize: el.fontSize, color: el.color)),
                            )
                          : Container(
                              width: 100, padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(border: Border.all(color: _isDrawMode ? Colors.transparent : Colors.blueAccent.withOpacity(0.3), style: BorderStyle.dash)),
                              child: Image.file(el.imageFile!, fit: BoxFit.cover),
                            ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: AppColors.surface, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)]),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // لوحة اختيار الألوان
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _colorPicker(Colors.black),
                  _colorPicker(Colors.red),
                  _colorPicker(Colors.blue),
                  _colorPicker(Colors.green),
                ],
              ),
            ),
            const Divider(height: 1),
            // شريط الأدوات
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildToolBtn(Icons.text_fields, 'Text', _addText, false),
                _buildToolBtn(Icons.image, 'Image', _addImage, false),
                _buildToolBtn(Icons.draw, 'Draw', () => setState(() => _isDrawMode = !_isDrawMode), _isDrawMode),
                _buildToolBtn(Icons.undo, 'Undo', () {
                  if (_elements.isNotEmpty) setState(() => _elements.removeLast());
                }, false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _colorPicker(Color color) {
    bool isSelected = _selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => _selectedColor = color),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: color, shape: BoxShape.circle,
          border: isSelected ? Border.all(color: AppColors.primaryContainer, width: 3) : Border.all(color: Colors.grey.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildToolBtn(IconData icon, String label, VoidCallback onTap, bool isActive) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryContainer.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: isActive ? AppColors.primary : AppColors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

// كلاس مساعد لرسم الخطوط على الشاشة الحية
class _FreehandPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;

  _FreehandPainter(this.points, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
