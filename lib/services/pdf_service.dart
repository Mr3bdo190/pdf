import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/pdf.dart' as p;
import 'package:pdf/widgets.dart' as pw;

// تحديث الكلاس عشان يدعم الرسم والألوان
class CanvasElement {
  final String type; // 'text', 'image', 'path'
  final String? text;
  final File? imageFile;
  final Offset position;
  final double fontSize;
  final List<Offset>? pathPoints; // لتخزين إحداثيات الرسم
  final Color color; // لون النص أو الرسم

  CanvasElement({
    required this.type,
    this.text,
    this.imageFile,
    required this.position,
    this.fontSize = 24,
    this.pathPoints,
    this.color = Colors.black,
  });
}

class PdfService {
  static Future<List<File>> pickFiles({bool allowMultiple = false, FileType type = FileType.custom, List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: type, allowedExtensions: allowedExtensions ?? (type == FileType.custom ? ['pdf'] : null), allowMultiple: allowMultiple);
    if (result != null) return result.paths.map((path) => File(path!)).toList();
    return [];
  }

  static Future<String> _saveFile(List<int> bytes, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  // تحويل الـ Canvas التفاعلي لملف PDF حقيقي مع دعم الرسم
  static Future<String?> exportCustomPdf(List<CanvasElement> elements, Size canvasSize) async {
    final pdf = pw.Document();
    const double pdfWidth = 595.0;
    const double pdfHeight = 842.0;
    
    final double scaleX = pdfWidth / canvasSize.width;
    final double scaleY = pdfHeight / canvasSize.height;

    pdf.addPage(pw.Page(
      pageFormat: p.PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Stack(
          children: elements.map((el) {
            final p.PdfColor pdfColor = p.PdfColor(el.color.red / 255, el.color.green / 255, el.color.blue / 255, el.color.opacity);
            
            if (el.type == 'text') {
              final double pdfX = el.position.dx * scaleX;
              final double pdfY = pdfHeight - (el.position.dy * scaleY) - (el.fontSize * scaleY); 
              return pw.Positioned(
                left: pdfX, bottom: pdfY,
                child: pw.Text(el.text ?? '', style: pw.TextStyle(fontSize: el.fontSize * scaleX, color: pdfColor)),
              );
            } 
            else if (el.type == 'image' && el.imageFile != null) {
              final double pdfX = el.position.dx * scaleX;
              final double pdfY = pdfHeight - (el.position.dy * scaleY) - (100 * scaleY); 
              final imageBytes = el.imageFile!.readAsBytesSync();
              return pw.Positioned(
                left: pdfX, bottom: pdfY,
                child: pw.Container(width: 150 * scaleX, child: pw.Image(pw.MemoryImage(imageBytes))),
              );
            } 
            else if (el.type == 'path' && el.pathPoints != null && el.pathPoints!.isNotEmpty) {
              // تحويل مسارات الرسم (الفري هاند) إلى خطوط فيكتور عالية الجودة
              return pw.Positioned(
                left: 0, bottom: 0,
                child: pw.CustomPaint(
                  size: const p.PdfPoint(pdfWidth, pdfHeight),
                  painter: (p.PdfGraphics canvas, p.PdfPoint size) {
                    canvas.setColor(pdfColor);
                    canvas.setLineWidth(3);
                    for (int i = 0; i < el.pathPoints!.length - 1; i++) {
                      final p1 = el.pathPoints![i];
                      final p2 = el.pathPoints![i + 1];
                      final double x1 = p1.dx * scaleX;
                      final double y1 = pdfHeight - (p1.dy * scaleY);
                      final double x2 = p2.dx * scaleX;
                      final double y2 = pdfHeight - (p2.dy * scaleY);
                      canvas.drawLine(x1, y1, x2, y2);
                    }
                    canvas.strokePath();
                  }
                ),
              );
            }
            return pw.Positioned(child: pw.Container());
          }).toList(),
        );
      },
    ));
    return await _saveFile(await pdf.save(), 'Custom_Draft_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  // بقية الدوال زي ما هي بدون تغيير
  static Future<String?> createBlankPdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(pageFormat: p.PdfPageFormat.a4, build: (context) => pw.Center(child: pw.Text("PDF Master Pro", style: const pw.TextStyle(fontSize: 24)))));
    return await _saveFile(await pdf.save(), 'New_PDF_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
  static Future<String?> imagesToPdf() async {
    List<File> imageFiles = await pickFiles(allowMultiple: true, type: FileType.image);
    if (imageFiles.isEmpty) return null;
    final pdf = pw.Document();
    for (var file in imageFiles) {
      pdf.addPage(pw.Page(pageFormat: p.PdfPageFormat.a4, build: (context) => pw.Center(child: pw.Image(pw.MemoryImage(file.readAsBytesSync())))));
    }
    return await _saveFile(await pdf.save(), 'ImagesToPdf_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
  static Future<String?> scanFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return null;
    final pdf = pw.Document();
    pdf.addPage(pw.Page(pageFormat: p.PdfPageFormat.a4, build: (context) => pw.Center(child: pw.Image(pw.MemoryImage(File(photo.path).readAsBytesSync())))));
    return await _saveFile(await pdf.save(), 'Scanned_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
  static Future<String?> mergePdfs(List<File> files) async {
    if (files.length < 2) return null;
    final PdfDocument finalDoc = PdfDocument();
    for (File file in files) {
      final PdfDocument tempDoc = PdfDocument(inputBytes: file.readAsBytesSync());
      for (int i = 0; i < tempDoc.pages.count; i++) finalDoc.pages.add().graphics.drawPdfTemplate(tempDoc.pages[i].createTemplate(), const Offset(0, 0));
      tempDoc.dispose();
    }
    final List<int> bytes = finalDoc.saveSync();
    finalDoc.dispose();
    return await _saveFile(bytes, 'Merged_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
  static Future<String?> protectPdf(File file, String password) async {
    final PdfDocument doc = PdfDocument(inputBytes: file.readAsBytesSync());
    doc.security.userPassword = password;
    final List<int> bytes = doc.saveSync();
    doc.dispose();
    return await _saveFile(bytes, 'Protected_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
  static Future<String?> splitPdf(File file) async {
    final PdfDocument oDoc = PdfDocument(inputBytes: file.readAsBytesSync());
    final PdfDocument nDoc = PdfDocument();
    if (oDoc.pages.count > 0) nDoc.pages.add().graphics.drawPdfTemplate(oDoc.pages[0].createTemplate(), const Offset(0, 0));
    final List<int> bytes = nDoc.saveSync();
    oDoc.dispose();
    nDoc.dispose();
    return await _saveFile(bytes, 'Split_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
}
