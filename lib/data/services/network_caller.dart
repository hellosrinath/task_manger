import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manger/app.dart';
import 'package:task_manger/data/models/response_object.dart';
import 'package:task_manger/presentation/controller/auth_controller.dart';
import 'package:task_manger/presentation/screens/auth/signin_screen.dart';

class NetworkCaller {
  static Future<ResponseObject> getRequest(String url) async {
    try {
      log(url);
      log('token ${AuthController.accessToken}');

      final Response response = await get(Uri.parse(url), headers: {
        'token': AuthController.accessToken ?? '',
      });

      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        final decodeResponse = jsonDecode(response.body);
        return ResponseObject(
          isSuccess: true,
          statusCode: 200,
          responseBody: decodeResponse,
        );
      } else if (response.statusCode == 401) {
        _moveToSignIn();
        return ResponseObject(
          isSuccess: false,
          statusCode: response.statusCode,
          responseBody: '',
          errorMsg: '',
        );
      } else {
        return ResponseObject(
          isSuccess: false,
          statusCode: response.statusCode,
          responseBody: '',
        );
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
          isSuccess: false,
          responseBody: '',
          statusCode: -1,
          errorMsg: e.toString());
    }
  }

  static Future<ResponseObject> postRequest(
      String url, Map<String, dynamic> body,
      {bool fromSignIn = false}) async {
    try {
      log(url);
      log(body.toString());

      final Response response = await post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {
          'Content-Type': 'application/json',
          'token': AuthController.accessToken ?? '',
        },
      );
      log(response.statusCode.toString());
      log(response.body.toString());

      if (response.statusCode == 200) {
        final decodeResponse = jsonDecode(response.body);
        return ResponseObject(
          isSuccess: true,
          statusCode: 200,
          responseBody: decodeResponse,
        );
      } else if (response.statusCode == 401) {
        if(fromSignIn){
          return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
            errorMsg: 'Email/Password is incorrect. Try Again.',
          );
        }else{
          _moveToSignIn();
          return ResponseObject(
            isSuccess: false,
            statusCode: response.statusCode,
            responseBody: '',
          );
        }


      } else {
        return ResponseObject(
          isSuccess: false,
          statusCode: response.statusCode,
          responseBody: '',
        );
      }
    } catch (e) {
      log(e.toString());
      return ResponseObject(
        isSuccess: false,
        statusCode: -1,
        responseBody: '',
      );
    }
  }

  static void _moveToSignIn() async {
    await AuthController.clearUserData();
    Navigator.pushAndRemoveUntil(
        TaskManager.navigatorKey.currentState!.context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
        (route) => false);
  }
}
