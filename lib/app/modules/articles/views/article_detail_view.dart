import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:get/get.dart';
import '../../../data/models/article_model.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/github.dart';

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
        title: Text(article.title),
        actions: [
          Obx(() => IconButton(
                icon: Icon(
                  controller.isBookmarked(article.id)
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: controller.isBookmarked(article.id) ? Colors.blue : null,
                ),
                onPressed: () => controller.toggleBookmark(article.id),
              )),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Published on: ${article.createdAt.toLocal().toString().split(' ')[0]}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 32),
            MarkdownBody(
              data: article.content,
              selectable: true,
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
  Widget? visitElementAfter( md.Element element, TextStyle? preferredStyle) {
    var language = '';
    if (element.attributes['class'] != null) {
      String lg = element.attributes['class'] as String;
      if (lg.startsWith('language-')) {
        language = lg.substring(9);
      }
    }
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: HighlightView(
        element.textContent,
        language: language,
        theme: githubTheme,
        padding: const EdgeInsets.all(12),
        textStyle: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 14,
        ),
      ),
    );
  }
}
