import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/controller/recover_password_controller.dart';
import 'package:task_manger/presentation/screens/auth/signin_screen.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

class SetPasswordScreen extends StatefulWidget {
  const SetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MainBackground(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Text(
                  "Set Password",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text(
                  "Maximum Length Password 8 Character with letter and number combination",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return "Enter Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Confirm Password',
                  ),
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return "Enter Confirm Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: GetBuilder<RecoverPasswordController>(
                      builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_passwordTEController.text ==
                                _confirmPasswordTEController.text) {
                              _recoverPassword();
                            } else {
                              showSnackBarMessage(
                                  context, 'Password not match', true);
                            }
                          }
                          /*Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PinVerificationScreen(),
                              ),
                            );*/
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "have Account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                            (route) => false);
                      },
                      child: const Text(
                        'Sign in',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }

  Future<void> _recoverPassword() async {
    final result = await Get.find<RecoverPasswordController>().recoverPassword(
      widget.email,
      widget.otp,
      _passwordTEController.text,
    );

    if (!mounted) return;
    if (result) {
      showSnackBarMessage(context,
          "Password update successfully. Try Sign In with new password");
    } else {
      showSnackBarMessage(
          context, "Password recovery failed. Please try again");
    }
  }
}
