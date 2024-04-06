import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manger/presentation/controller/completed_task_controller.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/no_data_screen.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';

import '../widgets/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  @override
  void initState() {
    super.initState();
    getCompletedTaskList();
  }

  Future<void> getCompletedTaskList() async {
    await Get.find<CompletedTaskController>().getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: MainBackground(
        child: GetBuilder<CompletedTaskController>(
            builder: (completedTaskController) {
          return Visibility(
            visible: completedTaskController.inProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                getCompletedTaskList();
              },
              child: Visibility(
                visible: completedTaskController
                        .completedTaskListWrapper.taskList?.isEmpty ==
                    false,
                replacement: const NoDataScreen(),
                child: ListView.builder(
                  itemCount: completedTaskController
                          .completedTaskListWrapper.taskList?.length ??
                      0,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      statusColor: Colors.green,
                      taskItem: completedTaskController
                          .completedTaskListWrapper.taskList![index],
                      onRefresh: () {
                        getCompletedTaskList();
                      },
                    );
                  },
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
