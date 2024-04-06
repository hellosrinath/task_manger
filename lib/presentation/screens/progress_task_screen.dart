import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manger/presentation/controller/progress_task_controller.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';

import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {


  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: MainBackground(
        child: GetBuilder<ProgressTaskController>(
          builder: (progressTaskListController) {
            return Visibility(
              visible: progressTaskListController.inProgress == false,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  _getProgressTaskList();
                },
                child: ListView.builder(
                  itemCount: progressTaskListController.progressTaskListWrapper.taskList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      statusColor: Colors.yellow,
                      taskItem: progressTaskListController.progressTaskListWrapper.taskList![index],
                      onRefresh: () {
                        _getProgressTaskList();
                      },
                    );
                  },
                ),
              ),
            );
          }
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    await Get.find<ProgressTaskController>().getProgressTaskList();
  }
}
