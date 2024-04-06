import 'package:get/get.dart';
import 'package:task_manger/data/models/response_object.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';

class SignUpController extends GetxController {
  bool _inProgress = false;

  bool get inProgress => _inProgress;
  String? _errorMessage;

  String get errorMessage =>
      _errorMessage ?? "Something went wrong. Please try again.";

  Future<bool> signUp(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String password,
  ) async {
    bool isSuccess = false;
    _inProgress = true;
    update();

    Map<String, dynamic> postParam = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };

    final ResponseObject response =
        await NetworkCaller.postRequest(Urls.registration, postParam);

    if (response.isSuccess) {
      isSuccess = true;
    } else {
      _errorMessage = response.errorMsg;
    }

    _inProgress = false;
    update();
    return isSuccess;
  }
}
