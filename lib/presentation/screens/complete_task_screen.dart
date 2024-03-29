import 'package:flutter/material.dart';
import 'package:task_manger/data/models/task_list_wrapper.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/no_data_screen.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

import '../widgets/task_card.dart';

class CompleteTaskScreen extends StatefulWidget {
  const CompleteTaskScreen({super.key});

  @override
  State<CompleteTaskScreen> createState() => _CompleteTaskScreenState();
}

class _CompleteTaskScreenState extends State<CompleteTaskScreen> {
  bool _getCompletedTaskListInProgress = false;
  TaskListWrapper _taskListWrapper = TaskListWrapper();

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  Future<void> _getCompletedTaskList() async {
    _getCompletedTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.completedTaskList);

    _getCompletedTaskListInProgress = false;

    if (response.isSuccess) {
      _taskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      setState(() {});
    } else {
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMsg ?? "Completed Task List has been failed");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: MainBackground(
        child: Visibility(
          visible: _getCompletedTaskListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              _getCompletedTaskList();
            },
            child: Visibility(
              visible: _taskListWrapper.taskList?.isEmpty == false,
              replacement: const NoDataScreen(),
              child: ListView.builder(
                itemCount: _taskListWrapper.taskList?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskCard(
                    statusColor: Colors.green,
                    taskItem: _taskListWrapper.taskList![index],
                    onRefresh: (){
                      _getCompletedTaskList();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

}
