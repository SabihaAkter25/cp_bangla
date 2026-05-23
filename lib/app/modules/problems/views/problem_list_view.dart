import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

                          value: controller.selectedTopicId.value.isEmpty
                              ? null
                              : controller.selectedTopicId.value,

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

                          value: controller.selectedDifficulty.value.isEmpty
                              ? null
                              : controller.selectedDifficulty.value,

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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),

                itemCount: controller.filteredProblems.length,

                separatorBuilder: (_, __) =>
                const SizedBox(height: 10),

                itemBuilder: (context, index) {

                  final problem =
                  controller.filteredProblems[index];

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(14),
                    ),

                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.all(14),

                      title: Text(
                        problem.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Padding(
                        padding:
                        const EdgeInsets.only(top: 6),
                        child: Text(
                          'Rating: ${problem.rating} • Difficulty: ${problem.difficulty}',
                        ),
                      ),

                      trailing: const Icon(
                        Icons.chevron_right,
                      ),

                      onTap: () {

                        // TODO:
                        // Navigate to problem details page

                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),

      // =========================
      // REFRESH BUTTON
      // =========================
      floatingActionButton: FloatingActionButton(
        onPressed: controller.fetchProblems,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}