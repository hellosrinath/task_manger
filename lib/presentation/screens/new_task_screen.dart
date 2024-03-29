import 'package:flutter/material.dart';
import 'package:task_manger/data/models/count_by_status_wrapper.dart';
import 'package:task_manger/data/models/task_list_wrapper.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/screens/add_new_task_screen.dart';
import 'package:task_manger/presentation/utils/app_colors.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

import '../widgets/task_counter_card.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getAllTaskCountByStatusInProgress = false;
  bool _getNewTaskListInProgress = false;
  CountByStatusWrapper _countByStatusWrapper = CountByStatusWrapper();
  TaskListWrapper _newTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    super.initState();
    _getDataFromApi();
  }

  void _getDataFromApi() {
    _getAllTaskCountByStatus();
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: MainBackground(
        child: Column(
          children: [
            Visibility(
              visible: _getAllTaskCountByStatusInProgress == false,
              replacement: const Padding(
                padding: EdgeInsets.all(8.0),
                child: LinearProgressIndicator(),
              ),
              child: taskCounterSection,
            ),
            Expanded(
              child: Visibility(
                visible: _getNewTaskListInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: RefreshIndicator(
                  onRefresh: () async {
                    _getDataFromApi();
                  },
                  child: ListView.builder(
                    itemCount: _newTaskListWrapper.taskList?.length ?? 0,
                    itemBuilder: (context, index) {
                      return TaskCard(
                        taskItem: _newTaskListWrapper.taskList![index],
                        statusColor: Colors.teal,
                        onRefresh: () {
                          _getDataFromApi();
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );

          if (result != null && result == true) {
            _getDataFromApi();
          }
        },
        backgroundColor: AppColors.themeColor,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  bool _checkDataLength() {
    return false;
  }

  Widget get taskCounterSection {
    return SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return TaskCounterCard(
              taskNumber:
                  _countByStatusWrapper.listOfTaskByStatusData![index].sum ?? 0,
              taskTitle:
                  _countByStatusWrapper.listOfTaskByStatusData![index].sId ??
                      '',
            );
          },
          separatorBuilder: (_, __) {
            return const SizedBox(
              width: 8,
            );
          },
          itemCount: _countByStatusWrapper.listOfTaskByStatusData?.length ?? 0,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }

  Future<void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.newTaskList);

    if (response.isSuccess) {
      _newTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getNewTaskListInProgress = false;
      setState(() {});
    } else {
      _getNewTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMsg ?? 'Get new task list has been failed');
      }
    }
  }

  Future<void> _getAllTaskCountByStatus() async {
    _getAllTaskCountByStatusInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.taskCountByStatus);

    if (response.isSuccess) {
      _countByStatusWrapper =
          CountByStatusWrapper.fromJson(response.responseBody);
      _getAllTaskCountByStatusInProgress = false;
      setState(() {});
    } else {
      _getAllTaskCountByStatusInProgress = false;
      setState(() {});
      if (mounted) {
        showSnackBarMessage(context,
            response.errorMsg ?? "Get Task count by status has been failed");
      }
    }
  }
}
