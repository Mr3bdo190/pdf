import 'package:flutter/material.dart';
import 'pdf_helper.dart';

void main() => runApp(const PdfApp());

class PdfApp extends StatelessWidget {
  const PdfApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String message = 'اختر عملية للبدء';

  void _showMessage(String text) {
    setState(() {
      message = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('محرر PDF الشامل')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.add_box),
              label: const Text('إنشاء ملف جديد'),
              onPressed: () async {
                final path = await PdfHelper.createNewPdf();
                if (path != null) _showMessage('تم الحفظ في:\n$path');
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.edit),
              label: const Text('تعديل ملف موجود'),
              onPressed: () async {
                final path = await PdfHelper.editExistingPdf();
                if (path != null) {
                  _showMessage('تم تعديل الملف وحفظه في:\n$path');
                } else {
                  _showMessage('تم إلغاء اختيار الملف');
                }
              },
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.greenAccent, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
