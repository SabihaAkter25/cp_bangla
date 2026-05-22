import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import '../../../routes/app_pages.dart';
import '../../topics/controllers/topic_controller.dart';
import '../controllers/article_controller.dart';

class ArticleListView extends GetView<ArticleController> {
  const ArticleListView({super.key});

  @override
  Widget build(BuildContext context) {
    final topicController = Get.find<TopicController>();

    // Ensure we only show published articles in the public view
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchArticles(onlyPublished: true);
    });

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Bookmarks'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildArticleList(context, controller.filteredArticles, topicController),
            _buildArticleList(context, controller.bookmarkedArticles, null, isBookmark: true),
            _buildArticleList(context, controller.readingHistory, null),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context, RxList<Article> articles, TopicController? topicController, {bool isBookmark = false}) {
    return Column(
      children: [
        if (topicController != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search articles...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: controller.searchArticles,
                  ),
                ),
                const SizedBox(width: 8),
                Obx(() => DropdownButton<String>(
                      hint: const Text('Topic'),
                      value: controller.selectedTopicId.value.isEmpty ? null : controller.selectedTopicId.value,
                      items: [
                        const DropdownMenuItem(value: null, child: Text('All')),
                        ...topicController.topics.map((topic) => DropdownMenuItem(
                              value: topic.id,
                              child: Text(topic.name),
                            )),
                      ],
                      onChanged: controller.filterByTopic,
                    )),
              ],
            ),
          ),
        Expanded(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            if (articles.isEmpty) {
              return Center(child: Text(isBookmark ? 'No bookmarks yet' : 'No articles found'));
            }
            return ListView.builder(
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return ListTile(
                  title: Text(article.title),
                  subtitle: Text(article.excerpt ?? ''),
                  onTap: () => Get.toNamed(
                    Routes.ARTICLE_DETAILS,
                    arguments: article,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
