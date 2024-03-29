import 'package:flutter/material.dart';
import 'package:task_manger/data/models/task_list_wrapper.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/no_data_screen.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

import '../widgets/task_card.dart';

class CancelledTaskScreen extends StatefulWidget {
  const CancelledTaskScreen({super.key});

  @override
  State<CancelledTaskScreen> createState() => _CancelledTaskScreenState();
}

class _CancelledTaskScreenState extends State<CancelledTaskScreen> {
  bool _getCancelledTaskListInProgress = false;
  TaskListWrapper _taskListWrapper = TaskListWrapper();

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
        child: Visibility(
          visible: _getCancelledTaskListInProgress == false,
          replacement: const Center(
            child: CircularProgressIndicator(),
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              _getCancelledTaskList();
            },
            child: ListView.builder(
              itemCount: _taskListWrapper.taskList?.length ?? 0,
              itemBuilder: (context, index) {
                return TaskCard(
                  statusColor: Colors.red,
                  taskItem: _taskListWrapper.taskList![index],
                  onRefresh: () {
                    _getCancelledTaskList();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _getCancelledTaskList() async {
    _getCancelledTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.cancelledTaskList);

    _getCancelledTaskListInProgress = false;

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

