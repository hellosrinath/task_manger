import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manger/data/models/user_data.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/controller/auth_controller.dart';
import 'package:task_manger/presentation/screens/main_bottom_nav_screen.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _fNameTEController = TextEditingController();
  final TextEditingController _lNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  bool _updateProfileInProgress = false;
  XFile? pickedImage;

  @override
  void initState() {
    super.initState();
    _emailTEController.text = AuthController.userData?.email ?? "";
    _fNameTEController.text = AuthController.userData?.firstName ?? "";
    _lNameTEController.text = AuthController.userData?.lastName ?? "";
    _mobileTEController.text = AuthController.userData?.mobile ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: MainBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _globalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  Text(
                    "Update Profile",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _imagePickerButton(),
                  const SizedBox(height: 16),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter Email";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _fNameTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'First Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter First Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lNameTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Last Name',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter Last Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _mobileTEController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Mobile',
                    ),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return "Enter Mobile Number";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password(Optional)',
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _updateProfileInProgress == false,
                      replacement:
                          const Center(child: CircularProgressIndicator()),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_globalKey.currentState!.validate()) {
                            _profileUpdate();
                          }
                          //Navigator.pop(context);
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _imagePickerButton() {
    return GestureDetector(
      onTap: () {
        _pickedImageFromGallery();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8),
                  )),
              child: const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
                child: Text(
              pickedImage?.name ?? "Select Photo",
              maxLines: 1,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _pickedImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Future<void> _profileUpdate() async {
    String? photo;
    _updateProfileInProgress = true;
    setState(() {});

    Map<String, dynamic> inputParam = {
      "email": _emailTEController.text.trim(),
      "firstName": _fNameTEController.text.trim(),
      "lastName": _lNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
    };

    if (_passwordTEController.text.isNotEmpty) {
      inputParam['password'] = _passwordTEController.text;
    }

    if (pickedImage != null) {
      final bytes = File(pickedImage!.path).readAsBytesSync();
      photo = base64Encode(bytes);
      inputParam['photo'] = photo;
    }

    final response =
        await NetworkCaller.postRequest(Urls.profileUpdate, inputParam);
    _updateProfileInProgress = false;
    if (response.isSuccess) {
      if (response.responseBody['status'] == "success") {
        final userData = UserData(
          email: _emailTEController.text,
          firstName: _fNameTEController.text.trim(),
          lastName: _lNameTEController.text.trim(),
          mobile: _mobileTEController.text.trim(),
          photo: photo,
        );
        await AuthController.saveUserData(userData);
      }
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainBottomNavScreen()),
          (route) => false);
    } else {
      if (!mounted) {
        return;
      }
      setState(() {});
      showSnackBarMessage(context, 'Update Profile Failed! Try Again');
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _fNameTEController.dispose();
    _lNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}

/*
{

"email":"rabbil@rabbil.com",
"firstName":"Rabbil",
"lastName":"Hasan",
"mobile":"01785388919",
"password":"1234",
"photo":""

}*/
