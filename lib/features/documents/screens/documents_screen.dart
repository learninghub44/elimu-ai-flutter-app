import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';

final documentsListProvider = FutureProvider.autoDispose((ref) async {
  // Documents are fetched implicitly via /ai/history in this scaffold;
  // add a dedicated GET /ai/documents backend route if you want a standalone list.
  return <Map<String, dynamic>>[];
});

class DocumentsScreen extends ConsumerStatefulWidget {
  const DocumentsScreen({super.key});

  @override
  ConsumerState<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends ConsumerState<DocumentsScreen> {
  bool _uploading = false;
  String? _lastResult;

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg']);
    if (result == null || result.files.single.path == null) return;

    setState(() => _uploading = true);
    try {
      final file = File(result.files.single.path!);
      final formData = FormData.fromMap({
        'title': result.files.single.name,
        'file': await MultipartFile.fromFile(file.path, filename: result.files.single.name),
      });

      final res = await ApiClient.instance.dio.post('/ai/document', data: formData);
      setState(() => _lastResult = 'Uploaded: ${res.data['document']['title']}');
    } catch (e) {
      setState(() => _lastResult = 'Upload failed: $e');
    } finally {
      setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Documents')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Upload notes, textbook PDFs, or scanned pages. Elimu AI will read them so you can '
                'ask questions and generate quizzes from the content.',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _uploading ? null : _pickAndUpload,
              icon: _uploading
                  ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.upload_file),
              label: Text(_uploading ? 'Uploading...' : 'Upload a document'),
            ),
            if (_lastResult != null) ...[
              const SizedBox(height: 16),
              Text(_lastResult!),
            ],
          ],
        ),
      ),
    );
  }
}
