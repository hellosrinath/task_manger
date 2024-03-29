import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/screens/auth/set_password_screen.dart';
import 'package:task_manger/presentation/screens/auth/signin_screen.dart';
import 'package:task_manger/presentation/utils/app_colors.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

class PinVerificationScreen extends StatefulWidget {
  const PinVerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  bool _pinVerificationInProgress = false;
  final TextEditingController _pinTEController = TextEditingController();
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
                  "Pin Verification",
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
                PinCodeTextField(
                  controller: _pinTEController,
                  keyboardType: TextInputType.number,
                  length: 6,
                  obscureText: false,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    inactiveColor: AppColors.themeColor,
                    selectedFillColor: Colors.white,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  backgroundColor: Colors.transparent,
                  enableActiveFill: true,
                  onCompleted: (v) {
                    print("Completed");
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) {
                    return true;
                  },
                  appContext: context,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: _pinVerificationInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _verifyOtpCode();
                        }
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SetPasswordScreen(),
                          ),
                        );*/
                      },
                      child: const Text("Verify"),
                    ),
                  ),
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
    _pinTEController.dispose();
    super.dispose();
  }

  Future<void> _verifyOtpCode() async {
    _pinVerificationInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(
        Urls.verifyOtpCode(widget.email, _pinTEController.text.trim()));

    _pinVerificationInProgress = false;
    setState(() {});

    if (!mounted) return;
    if (response.isSuccess && response.responseBody['status'] == "success") {
      //{"status":"success",
      showSnackBarMessage(context, "Success verify pin");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SetPasswordScreen(
            email: widget.email,
            otp: _pinTEController.text,
          ),
        ),
      );
    } else {
      showSnackBarMessage(context, "Pin Verification Failed. Try again", true);
    }
  }
}
