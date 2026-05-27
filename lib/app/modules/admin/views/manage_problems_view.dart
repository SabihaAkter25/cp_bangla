import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../problems/controllers/problem_controller.dart';
import '../../topics/controllers/topic_controller.dart';

class ManageProblemsView extends GetView<ProblemController> {
  const ManageProblemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Problems'),
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
      body: Obx(() {
        if (controller.isLoading.value) return const Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: controller.problems.length,
          itemBuilder: (context, index) {
            final problem = controller.problems[index];
            return ListTile(
              title: Text(problem.title),
              subtitle: Text('${problem.difficulty} - ${problem.rating}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => Get.defaultDialog(
                  title: 'Delete?',
                  middleText: 'Are you sure?',
                  onConfirm: () {
                    controller.deleteProblem(problem.id);
                    Get.back();
                  },
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _showAddDialog(context),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final titleController = TextEditingController();
    final slugController = TextEditingController();
    final statementController = TextEditingController();
    final difficultyController = TextEditingController();
    final ratingController = TextEditingController();
    final answerController = TextEditingController();
    String? selectedTopicId;
    final topicController = Get.find<TopicController>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Color(0xFF1E1E2C),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: slugController, decoration: const InputDecoration(labelText: 'Slug')),
              TextField(controller: statementController, decoration: const InputDecoration(labelText: 'Statement'), maxLines: 3),
              TextField(controller: difficultyController, decoration: const InputDecoration(labelText: 'Difficulty (Easy/Medium/Hard)')),
              TextField(controller: ratingController, decoration: const InputDecoration(labelText: 'Rating (e.g. 800)'), keyboardType: TextInputType.number),
              TextField(controller: answerController, decoration: const InputDecoration(labelText: 'Correct Answer')),
              const SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Topic'),
                    items: topicController.topics.map((topic) {
                      return DropdownMenuItem(
                        value: topic.id,
                        child: Text(topic.name),
                      );
                    }).toList(),
                    onChanged: (value) => selectedTopicId = value,
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedTopicId == null) {
                    Get.snackbar('Error', 'Please select a topic');
                    return;
                  }
                  controller.createProblem(
                    titleController.text,
                    slugController.text,
                    statementController.text,
                    difficultyController.text,
                    int.tryParse(ratingController.text) ?? 800,
                    selectedTopicId!,
                    answerController.text,
                  );
                },
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
