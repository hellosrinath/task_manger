import 'package:get/get.dart';
import 'package:task_manger/data/models/login_response.dart';
import 'package:task_manger/data/models/response_object.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/controller/auth_controller.dart';

class SignInController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String? _errorMessage;

  String get errorMessage =>
      _errorMessage ?? "Something went wrong. Please try again.";

  Future<bool> signIn(
    String email,
    String password,
  ) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> postParam = {
      "email": email,
      "password": password,
    };

    final ResponseObject response = await NetworkCaller.postRequest(
      Urls.login,
      postParam,
      fromSignIn: true,
    );

    if (response.isSuccess) {
      LoginResponse loginResponse =
          LoginResponse.fromJson(response.responseBody);
      // save data to local db
      await AuthController.saveUserData(loginResponse.data!);
      await AuthController.saveUserToken(loginResponse.token!);

      isSuccess = true;
    } else {
      _errorMessage = response.errorMsg;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
