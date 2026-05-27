import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import '../../../data/models/problem_model.dart';
import '../controllers/problem_controller.dart';

class ProblemDetailView extends StatefulWidget {
  const ProblemDetailView({super.key});

  @override
  State<ProblemDetailView> createState() => _ProblemDetailViewState();
}

class _ProblemDetailViewState extends State<ProblemDetailView> {
  final answerController = TextEditingController();
  final controller = Get.find<ProblemController>();
  final Problem problem = Get.arguments;

  @override
  void initState() {
    super.initState();
    controller.checkProblemStatus(problem.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem Details'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1E1E2C),
                const Color(0xFFBB86FC).withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Metadata
            Text(
              problem.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFBB86FC),
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildTag('Rating: ${problem.rating}', Colors.blue),
                const SizedBox(width: 8),
                _buildTag(problem.difficulty, _getDifficultyColor(problem.difficulty)),
                const Spacer(),
                Obx(() => controller.isCurrentProblemSolved.value
                    ? const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.green, size: 20),
                          SizedBox(width: 4),
                          Text('Solved', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                        ],
                      )
                    : const SizedBox.shrink()),
              ],
            ),
            const Divider(height: 40, color: Colors.white10),

            // Statement
            const Text(
              'Problem Statement',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            MarkdownBody(
              data: problem.statement ?? 'No statement provided.',
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16, height: 1.6, color: Colors.white70),
              ),
            ),

            const SizedBox(height: 40),

            // Answer Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Answer',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: answerController,
                    decoration: InputDecoration(
                      hintText: 'Enter solution...',
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (answerController.text.isEmpty) return;
                        
                        final isCorrect = await controller.submitAnswer(problem, answerController.text);
                        
                        if (isCorrect) {
                          Get.snackbar(
                            'Correct!',
                            'Well done! You solved this problem.',
                            backgroundColor: Colors.green.withOpacity(0.1),
                            colorText: Colors.green,
                          );
                          answerController.clear();
                        } else {
                          Get.snackbar(
                            'Incorrect',
                            'Keep trying! Check your logic and try again.',
                            backgroundColor: Colors.red.withOpacity(0.1),
                            colorText: Colors.red,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBB86FC),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('SUBMIT ANSWER', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy': return Colors.green;
      case 'medium': return Colors.orange;
      case 'hard': return Colors.red;
      default: return Colors.blue;
    }
  }
}
