class Urls {
  static const String baseUrl = 'https://task.teamrabbil.com/api/v1';
  static String registration = '$baseUrl/registration';
  static String login = '$baseUrl/login';
  static String createTask = '$baseUrl/createTask';
  static String taskCountByStatus = '$baseUrl/taskStatusCount';
  static String newTaskList = '$baseUrl/listTaskByStatus/New';
  static String profileUpdate = '$baseUrl/profileUpdate';
  static String completedTaskList = '$baseUrl/listTaskByStatus/Completed';
  static String progressTaskList = '$baseUrl/listTaskByStatus/Progress';
  static String cancelledTaskList = '$baseUrl/listTaskByStatus/Cancelled';
  static String recoverPassword = '$baseUrl/RecoverResetPass';

  static String deleteTask(String id) => '$baseUrl/deleteTask/$id';

  static String sendOtpCode(String email) =>
      '$baseUrl/RecoverVerifyEmail/$email';

  static String verifyOtpCode(String email, String otpCode) =>
      "$baseUrl/RecoverVerifyOTP/$email/$otpCode";

  static String updateTaskStatus(String id, String status) =>
      '$baseUrl/updateTaskStatus/$id/$status';
}
