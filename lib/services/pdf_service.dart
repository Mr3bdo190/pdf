import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:pdf/pdf.dart' as p;
import 'package:pdf/widgets.dart' as pw;

class PdfService {
  
  static Future<List<File>> pickFiles({bool allowMultiple = false, FileType type = FileType.custom, List<String>? allowedExtensions}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type,
      allowedExtensions: allowedExtensions,
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

  // 1. إنشاء ملف PDF فارغ
  static Future<String?> createBlankPdf() async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      pageFormat: p.PdfPageFormat.a4,
      build: (pw.Context context) {
      return pw.Center(child: pw.Text("Blank Document Created with PDF Master Pro", style: const pw.TextStyle(fontSize: 24)));
    }));
    return await _saveFile(await pdf.save(), 'New_PDF_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  // 2. تحويل الصور إلى PDF
  static Future<String?> imagesToPdf() async {
    List<File> imageFiles = await pickFiles(allowMultiple: true, type: FileType.image);
    if (imageFiles.isEmpty) return null;

    final pdf = pw.Document();
    for (var file in imageFiles) {
      final imageBytes = file.readAsBytesSync();
      final pdfImage = pw.MemoryImage(imageBytes);
      pdf.addPage(pw.Page(
        pageFormat: p.PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(child: pw.Image(pdfImage));
        },
      ));
    }
    return await _saveFile(await pdf.save(), 'ImagesToPdf_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  // 3. التصوير بالكاميرا والتحويل لـ PDF
  static Future<String?> scanFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo == null) return null;

    final pdf = pw.Document();
    final imageBytes = await photo.readAsBytes();
    final pdfImage = pw.MemoryImage(imageBytes);
    
    pdf.addPage(pw.Page(
      pageFormat: p.PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Center(child: pw.Image(pdfImage));
      },
    ));
    return await _saveFile(await pdf.save(), 'Scanned_${DateTime.now().millisecondsSinceEpoch}.pdf');
  }

  // 4. دمج الملفات
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
}
