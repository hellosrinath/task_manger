import 'package:get/get.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';

class PinVerificationController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String? _errorMessage;

  String get errorMessage =>
      _errorMessage ?? "Something went wrong. Please try again";

  Future<bool> verifyOtpCode(String email, String pin) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    final response = await NetworkCaller.getRequest(
        Urls.verifyOtpCode(email, pin));

    if (response.isSuccess && response.responseBody['status'] == "success") {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMsg;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
