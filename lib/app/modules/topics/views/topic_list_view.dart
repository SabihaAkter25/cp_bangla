import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/topic_controller.dart';

class TopicListView extends GetView<TopicController> {
  const TopicListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.topics.isEmpty) {
          return const Center(child: Text('No topics found'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: controller.topics.length,
          itemBuilder: (context, index) {
            final topic = controller.topics[index];
            return Card(
              child: InkWell(
                onTap: () {
                  // Navigate to topic articles/problems
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      topic.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchTopics,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
