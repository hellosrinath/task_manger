import 'package:flutter/material.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/presentation/widgets/main_background.dart';
import 'package:task_manger/presentation/widgets/profile_app_bar.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

import '../../data/utils/urls.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _addNewTaskProgress = false;
  bool _shouldRefreshNewTaskList = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (dipPop) {
        if (dipPop) return;
        Navigator.pop(context, _shouldRefreshNewTaskList);
      },
      child: Scaffold(
        appBar: profileAppBar,
        body: MainBackground(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Add New Tasks',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontSize: 26),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _titleTEController,
                      decoration: const InputDecoration(
                        hintText: 'Title',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter Title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _descTEController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter Description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: Visibility(
                        visible: _addNewTaskProgress == false,
                        replacement: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _addNewTask();
                            }
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
      ),
    );
  }

  Future<void> _addNewTask() async {
    _addNewTaskProgress = true;
    setState(() {});

    Map<String, dynamic> inputParam = {
      "title": _titleTEController.text.trim(),
      "description": _descTEController.text.trim(),
      "status": "New",
    };

    final response =
        await NetworkCaller.postRequest(Urls.createTask, inputParam);
    _addNewTaskProgress = false;
    setState(() {});

    if (response.isSuccess) {
      _shouldRefreshNewTaskList = true;

      _titleTEController.clear();
      _descTEController.clear();
      if (mounted) {
        showSnackBarMessage(context, "Add New Task has bees Added");
      }
    } else {
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMsg ?? "Add New Task Failed.", false);
      }
    }
  }

  @override
  void dispose() {
    _titleTEController.dispose();
    _descTEController.dispose();
    super.dispose();
  }
}
