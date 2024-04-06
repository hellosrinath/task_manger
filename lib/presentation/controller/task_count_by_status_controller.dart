import 'package:get/get.dart';
import 'package:task_manger/data/models/count_by_status_wrapper.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';

class TaskCountByStatusController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String? _errorMessage;

  String get errorMessage =>
      _errorMessage ?? "Get Task count by status has been failed";

  CountByStatusWrapper _countByStatusWrapper = CountByStatusWrapper();

  CountByStatusWrapper get countByStatusWrapper => _countByStatusWrapper;

  Future<bool> getAllTaskCountByStatus() async {
    bool isSuccess = false;

    _inProgress = true;
    update();

    final response = await NetworkCaller.getRequest(Urls.taskCountByStatus);

    if (response.isSuccess) {
      _countByStatusWrapper =
          CountByStatusWrapper.fromJson(response.responseBody);

      isSuccess = true;
    } else {
      _errorMessage = response.errorMsg;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
