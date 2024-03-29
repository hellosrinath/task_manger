import 'package:flutter/material.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

import '../../data/models/task_list_wrapper.dart';
import '../widgets/task_card.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getProgressTaskListInProgress = false;
  TaskListWrapper _taskListWrapper = TaskListWrapper();

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
        child: Visibility(
          visible: _getProgressTaskListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              _getProgressTaskList();
            },
            child: ListView.builder(
              itemCount: _taskListWrapper.taskList?.length ?? 0,
              itemBuilder: (context, index) {
                return TaskCard(
                  statusColor: Colors.yellow,
                  taskItem: _taskListWrapper.taskList![index],
                  onRefresh: (){
                    _getProgressTaskList();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    _getProgressTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.progressTaskList);

    _getProgressTaskListInProgress = false;

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

}
