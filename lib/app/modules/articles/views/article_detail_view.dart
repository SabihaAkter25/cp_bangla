import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

import '../controllers/article_controller.dart';

class ArticleDetailView extends StatelessWidget {
  const ArticleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final Article article = Get.arguments;
    final controller = Get.find<ArticleController>();

    // Record history
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.addToHistory(article.id);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Article Details'),
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
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isBookmarked(article.id)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: controller.isBookmarked(article.id) ? const Color(0xFFBB86FC) : null,
                ),
                onPressed: () => controller.toggleBookmark(article.id),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFBB86FC),
                  ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  article.createdAt.toLocal().toString().split(' ')[0],
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 24),
            MarkdownBody(
              data: article.content,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(fontSize: 16, height: 1.5, color: Colors.white70),
                h1: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                h2: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                code: const TextStyle(backgroundColor: Color(0xFF1E1E2C), color: Color(0xFFBB86FC)),
              ),
              builders: {
                'code': CodeBlockBuilder(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CodeBlockBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    var language = '';
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      if (lg.startsWith('language-')) {
        language = lg.substring(9);
      }
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: HighlightView(
          element.textContent,
          language: language,
          theme: atomOneDarkTheme,
          padding: const EdgeInsets.all(16),
          textStyle: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
