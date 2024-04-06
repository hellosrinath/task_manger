import 'package:get/get.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';

class RecoverPasswordController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String? _errorMessage;

  String get errorMessage =>
      _errorMessage ?? "Something went wrong. Please try again";

  Future<bool> recoverPassword(
    String email,
    String otp,
    String password,
  ) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> postParam = {
      "email": email,
      "OTP": otp,
      "password": password,
    };

    final response =
        await NetworkCaller.postRequest(Urls.recoverPassword, postParam);

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
