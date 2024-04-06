import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manger/presentation/controller/cancelled_task_controller.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';

import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: MainBackground(
        child: GetBuilder<CancelledTaskController>(
          builder: (cancelledTaskListController) {
            return Visibility(
              visible: cancelledTaskListController.inProgress == false,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  _getCancelledTaskList();
                },
                child: ListView.builder(
                  itemCount: cancelledTaskListController.cancelledTaskListWrapper.taskList?.length ?? 0,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      statusColor: Colors.red,
                      taskItem: cancelledTaskListController.cancelledTaskListWrapper.taskList![index],
                      onRefresh: () {
                        _getCancelledTaskList();
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

  Future<void> _getCancelledTaskList() async {
    await Get.find<CancelledTaskController>().getCancelledTaskList();
  }
}

