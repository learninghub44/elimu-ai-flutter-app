import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  final _topicController = TextEditingController();
  bool _generating = false;
  List<dynamic>? _questions;
  final Map<int, String> _answers = {};
  int? _score;

  Future<void> _generate() async {
    if (_topicController.text.trim().isEmpty) return;
    setState(() {
      _generating = true;
      _questions = null;
      _score = null;
      _answers.clear();
    });
    try {
      final res = await ApiClient.instance.dio.post('/ai/quiz/generate', data: {
        'text': _topicController.text, // for v1: paste topic notes directly; swap for documentId once picker is wired
        'subject': 'General',
        'topic': _topicController.text,
        'count': 5,
      });
      setState(() => _questions = res.data['quiz']['questions']);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to generate quiz: $e')));
    } finally {
      setState(() => _generating = false);
    }
  }

  void _submit() {
    if (_questions == null) return;
    int correct = 0;
    for (int i = 0; i < _questions!.length; i++) {
      if (_answers[i] == _questions![i]['correctAnswer']) correct++;
    }
    setState(() => _score = correct);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _topicController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Paste notes, or type a topic (e.g. "Photosynthesis - Grade 7 CBC Science")',
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _generating ? null : _generate,
              child: Text(_generating ? 'Generating...' : 'Generate 5-question quiz'),
            ),
            const SizedBox(height: 16),
            if (_questions != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _questions!.length,
                  itemBuilder: (ctx, i) {
                    final q = _questions![i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${i + 1}. ${q['question']}', style: const TextStyle(fontWeight: FontWeight.w600)),
                            ...List<String>.from(q['options']).map((opt) => RadioListTile<String>(
                                  title: Text(opt),
                                  value: opt,
                                  groupValue: _answers[i],
                                  onChanged: (v) => setState(() => _answers[i] = v!),
                                )),
                            if (_score != null)
                              Text(
                                'Correct answer: ${q['correctAnswer']}${q['explanation'] != null ? ' — ${q['explanation']}' : ''}',
                                style: const TextStyle(color: Colors.green),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (_questions != null && _score == null)
              FilledButton(onPressed: _submit, child: const Text('Submit answers')),
            if (_score != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text('Score: $_score / ${_questions!.length}', style: Theme.of(context).textTheme.titleMedium),
              ),
          ],
        ),
      ),
    );
  }
}
