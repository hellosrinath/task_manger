import 'package:get/get.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';

class AddNewTaskController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String? _errorMessage;

  String get errorMessage =>
      _errorMessage ?? "Something went wrong. Please try again.";

  Future<bool> addNewTask(
      String title,
      String description
      ) async {

    bool isSuccess = false;

    _inProgress = true;
    update();

    Map<String, dynamic> inputParam = {
      "title": title,
      "description": description,
      "status": "New",
    };

    final response =
    await NetworkCaller.postRequest(Urls.createTask, inputParam);

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage =response.errorMsg;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
