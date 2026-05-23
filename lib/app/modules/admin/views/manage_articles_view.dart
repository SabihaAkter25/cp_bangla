import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import '../../articles/controllers/article_controller.dart';
import '../../topics/controllers/topic_controller.dart';

class ManageArticlesView extends GetView<ArticleController> {
  const ManageArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch all articles including unpublished ones when entering admin view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchAdminArticles();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Articles'),
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
          itemCount: controller.articles.length,
          itemBuilder: (context, index) {
            final article = controller.articles[index];
            return ListTile(
              title: Text(article.title),
              subtitle: Text(article.slug),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      article.published ? Icons.visibility : Icons.visibility_off,
                      color: article.published ? Colors.green : Colors.grey,
                    ),
                    onPressed: () => controller.togglePublish(article.id, article.published),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showAddDialog(context, article: article),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => Get.defaultDialog(
                      title: 'Delete?',
                      middleText: 'Are you sure?',
                      onConfirm: () {
                        controller.deleteArticle(article.id);
                        Get.back();
                      },
                    ),
                  ),
                ],
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

  void _showAddDialog(BuildContext context, {Article? article}) {
    final titleController = TextEditingController(text: article?.title);
    final slugController = TextEditingController(text: article?.slug);
    final excerptController = TextEditingController(text: article?.excerpt);
    final contentController = TextEditingController(text: article?.content);
    String? selectedTopicId = article?.topicId;
    final topicController = Get.find<TopicController>();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(article == null ? 'Create Article' : 'Edit Article', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: slugController, decoration: const InputDecoration(labelText: 'Slug')),
              TextField(controller: excerptController, decoration: const InputDecoration(labelText: 'Excerpt')),
              TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Content (Markdown)'), maxLines: 5),
              const SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Topic'),
                    value: selectedTopicId,
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
                  final data = {
                    'title': titleController.text,
                    'slug': slugController.text,
                    'excerpt': excerptController.text,
                    'content': contentController.text,
                    'topic_id': selectedTopicId!,
                  };
                  if (article == null) {
                    controller.createArticle(
                      titleController.text,
                      slugController.text,
                      excerptController.text,
                      contentController.text,
                      selectedTopicId!,
                    );
                  } else {
                    controller.updateArticle(article.id, data);
                  }
                },
                child: Text(article == null ? 'Create' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
