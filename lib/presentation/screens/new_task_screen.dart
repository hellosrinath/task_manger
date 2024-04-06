import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manger/data/models/task_by_status_data.dart';
import 'package:task_manger/presentation/controller/new_task_controller.dart';
import 'package:task_manger/presentation/controller/task_count_by_status_controller.dart';
import 'package:task_manger/presentation/screens/add_new_task_screen.dart';
import 'package:task_manger/presentation/utils/app_colors.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';

import '../widgets/task_counter_card.dart';
import '../widgets/task_card.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TaskCountByStatusController _taskCountByStatusController =
      Get.find<TaskCountByStatusController>();
  final NewTaskController _newTaskController = Get.find<NewTaskController>();

  @override
  void initState() {
    super.initState();
    _getDataFromApi();
  }

  void _getDataFromApi() {
    _taskCountByStatusController.getAllTaskCountByStatus();
    _newTaskController.getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: MainBackground(
        child: Column(
          children: [
            GetBuilder<TaskCountByStatusController>(
                builder: (taskCountController) {
              return Visibility(
                visible: taskCountController.inProgress == false,
                replacement: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                ),
                child: taskCounterSection(
                  taskCountController
                          .countByStatusWrapper.listOfTaskByStatusData ??
                      [],
                ),
              );
            }),
            Expanded(
              child:
                  GetBuilder<NewTaskController>(builder: (newTaskController) {
                return Visibility(
                  visible: newTaskController.inProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _getDataFromApi();
                    },
                    child: ListView.builder(
                      itemCount: newTaskController
                              .newTaskListWrapper.taskList?.length ??
                          0,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          taskItem: newTaskController
                              .newTaskListWrapper.taskList![index],
                          statusColor: Colors.teal,
                          onRefresh: () {
                            _getDataFromApi();
                          },
                        );
                      },
                    ),
                  ),
                );
              }),
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

  Widget taskCounterSection(List<TaskByStatusData>? listOfTaskByStatusData) {
    return SizedBox(
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.separated(
          itemBuilder: (context, index) {
            return TaskCounterCard(
              taskNumber: listOfTaskByStatusData![index].sum ?? 0,
              taskTitle: listOfTaskByStatusData[index].sId ?? '',
            );
          },
          separatorBuilder: (_, __) {
            return const SizedBox(
              width: 8,
            );
          },
          itemCount: listOfTaskByStatusData?.length ?? 0,
          scrollDirection: Axis.horizontal,
        ),
      ),
    );
  }
}
