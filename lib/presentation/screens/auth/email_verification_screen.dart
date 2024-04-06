import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manger/presentation/controller/send_otp_controller.dart';
import 'package:task_manger/presentation/screens/auth/pin_verification_screen.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _emailTEController = TextEditingController();
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
                  "Your Email Address",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text(
                  "A 6 digit verification pin will sent to your email address",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailTEController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                  ),
                  validator: (String? value) {
                    if (value?.trim().isEmpty ?? true) {
                      return "Enter Your Email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: GetBuilder<SendOtpCodeController>(
                      builder: (sendOptCodeController) {
                    return Visibility(
                      visible: sendOptCodeController.inProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _sendOtpCode();
                          }
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
                        Navigator.pop(context);
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

  Future<void> _sendOtpCode() async {
    final result = await Get.find<SendOtpCodeController>().sendOtpCode(
      _emailTEController.text.trim(),
    );

    if (!mounted) return;
    if (result) {
      showSnackBarMessage(context,
          "Sending success OTP Verification pin. Please, check email and check spam.");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PinVerificationScreen(
            email: _emailTEController.text.trim(),
          ),
        ),
      );
    } else {
      showSnackBarMessage(context, "Otp Code sending failed. Try again", true);
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    super.dispose();
  }
}
