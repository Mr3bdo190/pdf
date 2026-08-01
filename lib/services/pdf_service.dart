import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/pdf.dart' as p;
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  
  static Future<List<File>> pickFiles({bool allowMultiple = false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: allowMultiple,
    );
    if (result != null) return result.paths.map((path) => File(path!)).toList();
    return [];
  }

  static Future<String> _saveFile(List<int> bytes, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static Future<String?> createPdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (pw.Context context) {
      return pw.Center(child: pw.Text("Created with PDF Master Pro", style: const pw.TextStyle(fontSize: 24)));
    }));
    return await _saveFile(await pdf.save(), 'Created_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  static Future<String?> mergePdfs(List<File> files) async {
    if (files.length < 2) return null;
    final PdfDocument finalDoc = PdfDocument();
    for (File file in files) {
      final PdfDocument tempDoc = PdfDocument(inputBytes: file.readAsBytesSync());
      for (int i = 0; i < tempDoc.pages.count; i++) {
        finalDoc.pages.add().graphics.drawPdfTemplate(tempDoc.pages[i].createTemplate(), const Offset(0, 0));
      }
      tempDoc.dispose();
    }
    final List<int> bytes = finalDoc.saveSync();
    finalDoc.dispose();
    return await _saveFile(bytes, 'Merged_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  static Future<String?> protectPdf(File file, String password) async {
    final PdfDocument document = PdfDocument(inputBytes: file.readAsBytesSync());
    document.security.userPassword = password;
    final List<int> bytes = document.saveSync();
    document.dispose();
    return await _saveFile(bytes, 'Protected_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  // الميزة الجديدة 1: فصل أول صفحة من الملف
  static Future<String?> splitPdf(File file) async {
    final PdfDocument originalDoc = PdfDocument(inputBytes: file.readAsBytesSync());
    final PdfDocument newDoc = PdfDocument();
    
    if (originalDoc.pages.count > 0) {
      newDoc.pages.add().graphics.drawPdfTemplate(originalDoc.pages[0].createTemplate(), const Offset(0, 0));
    }
    
    final List<int> bytes = newDoc.saveSync();
    originalDoc.dispose();
    newDoc.dispose();
    return await _saveFile(bytes, 'Split_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  // الميزة الجديدة 2: إضافة علامة مائية
  static Future<String?> watermarkPdf(File file, String watermarkText) async {
    final PdfDocument document = PdfDocument(inputBytes: file.readAsBytesSync());
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 40);
    
    for (int i = 0; i < document.pages.count; i++) {
      final PdfPage page = document.pages[i];
      final Size pageSize = page.getClientSize();
      
      page.graphics.save();
      page.graphics.setTransparency(0.3); // شفافية بنسبة 30%
      page.graphics.translateTransform(pageSize.width / 2, pageSize.height / 2);
      page.graphics.rotateTransform(-45); // ميلان النص
      
      final Size textSize = font.measureString(watermarkText);
      page.graphics.drawString(
        watermarkText,
        font,
        brush: PdfBrushes.red,
        bounds: Rect.fromLTWH(-textSize.width / 2, -textSize.height / 2, textSize.width, textSize.height)
      );
      page.graphics.restore();
    }
    
    final List<int> bytes = document.saveSync();
    document.dispose();
    return await _saveFile(bytes, 'Watermarked_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }
}
