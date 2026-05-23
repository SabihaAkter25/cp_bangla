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
          title: const Text('Articles'),
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
          bottom: const TabBar(
            indicatorColor: Color(0xFFBB86FC),
            labelColor: Color(0xFFBB86FC),
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Saved'),
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
              padding: const EdgeInsets.all(16),
              itemCount: articles.length,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => Get.toNamed(
                      Routes.ARTICLE_DETAILS,
                      arguments: article,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (article.excerpt != null)
                            Text(
                              article.excerpt!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white.withOpacity(0.7)),
                            ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 14, color: Theme.of(context).primaryColor),
                              const SizedBox(width: 4),
                              Text(
                                article.createdAt.toLocal().toString().split(' ')[0],
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
