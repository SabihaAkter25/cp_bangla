import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../topics/controllers/topic_controller.dart';

class ManageTopicsView extends GetView<TopicController> {
  const ManageTopicsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Topics'),
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
          itemCount: controller.topics.length,
          itemBuilder: (context, index) {
            final topic = controller.topics[index];
            return ListTile(
              title: Text(topic.name),
              subtitle: Text(topic.slug),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => Get.defaultDialog(
                  title: 'Delete?',
                  middleText: 'Are you sure?',
                  onConfirm: () {
                    controller.deleteTopic(topic.id);
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
    final nameController = TextEditingController();
    final slugController = TextEditingController();
    final descriptionController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: slugController, decoration: const InputDecoration(labelText: 'Slug')),
              TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => controller.createTopic(
                  nameController.text,
                  slugController.text,
                  descriptionController.text,
                ),
                child: const Text('Create'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
