import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart' as p;
import 'package:pdf/widgets.dart' as pw;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

class PdfHelper {
  // 1. إنشاء ملف PDF من الصفر
  static Future<String?> createNewPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text('تم إنشاء هذا الملف برمجياً!',
                style: const pw.TextStyle(fontSize: 24)),
          );
        },
      ),
    );

    return await _saveFile(await pdf.save(), 'new_document.pdf');
  }

  // 2. التعديل على ملف PDF موجود
  static Future<String?> editExistingPdf() async {
    // اختيار الملف من الجهاز
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      File file = File(result.files.single.path!);
      final List<int> bytes = await file.readAsBytes();

      // فتح الملف للتعديل
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      final PdfPage page = document.pages[0]; // التعديل على الصفحة الأولى

      // إضافة نص كعلامة مائية أو تعديل
      page.graphics.drawString(
        'تم التعديل - Modified',
        PdfStandardFont(PdfFontFamily.helvetica, 30),
        bounds: const Rect.fromLTWH(0, 0, 500, 50),
        brush: PdfBrushes.red,
      );

      final List<int> modifiedBytes = await document.save();
      document.dispose();

      return await _saveFile(modifiedBytes, 'modified_document.pdf');
    }
    return null;
  }

  // دالة مساعدة لحفظ الملفات في الجهاز
  static Future<String> _saveFile(List<int> bytes, String fileName) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }
}
