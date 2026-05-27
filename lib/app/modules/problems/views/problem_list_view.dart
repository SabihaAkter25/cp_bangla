import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../topics/controllers/topic_controller.dart';
import '../controllers/problem_controller.dart';

class ProblemListView extends GetView<ProblemController> {
  const ProblemListView({super.key});

  @override
  Widget build(BuildContext context) {
    final topicController = Get.find<TopicController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Problems'),
        centerTitle: true,
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

      body: Column(
        children: [

          // =========================
          // SEARCH + FILTER SECTION
          // =========================
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [

                // SEARCH FIELD
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search problems...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: controller.searchProblems,
                ),

                const SizedBox(height: 12),

                // FILTERS
                Row(
                  children: [

                    // =========================
                    // TOPIC FILTER
                    // =========================
                    Expanded(
                      child: Obx(
                            () => DropdownButtonFormField<String>(
                          isExpanded: true,

                          decoration: InputDecoration(
                            labelText: 'Topic',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          value: controller.selectedTopicId.value,

                          items: [

                            // ALL TOPICS
                            const DropdownMenuItem<String>(
                              value: '',
                              child: Text('All Topics'),
                            ),

                            // TOPICS
                            ...topicController.topics.map(
                                  (topic) => DropdownMenuItem<String>(
                                value: topic.id,
                                child: Text(
                                  topic.name,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],

                          onChanged: (value) {
                            controller.filterByTopic(value);
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),


                    Expanded(
                      child: Obx(
                            () => DropdownButtonFormField<String>(
                          isExpanded: true,

                          decoration: InputDecoration(
                            labelText: 'Difficulty',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),

                          value: controller.selectedDifficulty.value,

                          items: const [

                            DropdownMenuItem<String>(
                              value: '',
                              child: Text('All'),
                            ),

                            DropdownMenuItem<String>(
                              value: 'Easy',
                              child: Text('Easy'),
                            ),

                            DropdownMenuItem<String>(
                              value: 'Medium',
                              child: Text('Medium'),
                            ),

                            DropdownMenuItem<String>(
                              value: 'Hard',
                              child: Text('Hard'),
                            ),
                          ],

                          onChanged: (value) {
                            controller.filterByDifficulty(value);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // =========================
          // PROBLEM LIST
          // =========================
          Expanded(
            child: Obx(() {

              // LOADING
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              // EMPTY STATE
              if (controller.filteredProblems.isEmpty) {
                return const Center(
                  child: Text(
                    'No problems found',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              // LIST
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredProblems.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final problem = controller.filteredProblems[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF1E1E2C),
                          const Color(0xFFBB86FC).withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                      onTap: () => Get.toNamed(
                        Routes.PROBLEM_DETAILS,
                        arguments: problem,
                      ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(problem.difficulty).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    problem.difficulty.substring(0, 1),
                                    style: TextStyle(
                                      color: _getDifficultyColor(problem.difficulty),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      problem.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rating: ${problem.rating}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchProblems,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }
}
