import 'package:get/get.dart';
import 'package:task_manger/presentation/controller/add_new_task_controller.dart';
import 'package:task_manger/presentation/controller/cancelled_task_controller.dart';
import 'package:task_manger/presentation/controller/completed_task_controller.dart';
import 'package:task_manger/presentation/controller/new_task_controller.dart';
import 'package:task_manger/presentation/controller/progress_task_controller.dart';
import 'package:task_manger/presentation/controller/sign_in_controller.dart';
import 'package:task_manger/presentation/controller/task_count_by_status_controller.dart';

class GetXControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SignInController());
    Get.lazyPut(() => TaskCountByStatusController());
    Get.lazyPut(() => NewTaskController());
    Get.lazyPut(() => CompletedTaskController());
    Get.lazyPut(() => ProgressTaskController());
    Get.lazyPut(() => CancelledTaskController());
    Get.lazyPut(() => CancelledTaskController());
    Get.lazyPut(() => AddNewTaskController());
  }
}
