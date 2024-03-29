import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_manger/data/models/task_item.dart';
import 'package:task_manger/data/services/network_caller.dart';
import 'package:task_manger/data/utils/urls.dart';
import 'package:task_manger/presentation/widgets/snackbar_message.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key,
    required this.statusColor,
    required this.taskItem,
    required this.onRefresh,
  });

  final TaskItem taskItem;
  final Color statusColor;
  final VoidCallback onRefresh;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _getDeleteTaskInProgress = false;
  bool _getUpdateTaskStatusInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskItem.title ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(widget.taskItem.description ?? ""),
            Text('Date: ${widget.taskItem.createdDate}'),
            Row(
              children: [
                Chip(
                  label: Text(widget.taskItem.status ?? ""),
                  backgroundColor: widget.statusColor,
                ),
                const Spacer(),
                Visibility(
                  visible: _getUpdateTaskStatusInProgress == false,
                  replacement: const CircularProgressIndicator(),
                  child: IconButton(
                      onPressed: () {
                        _showUpdateStatusDialog(widget.taskItem.sId!);
                      },
                      icon: const Icon(Icons.edit)),
                ),
                Visibility(
                  visible: _getDeleteTaskInProgress == false,
                  replacement: const CircularProgressIndicator(),
                  child: IconButton(
                      onPressed: () {
                        _deleteTaskById(widget.taskItem.sId!);
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTaskById(String id) async {
    _getDeleteTaskInProgress = true;
    setState(() {});

    final response = await NetworkCaller.getRequest(Urls.deleteTask(id));

    _getDeleteTaskInProgress = false;
    if (response.isSuccess) {
      widget.onRefresh();
    } else {
      setState(() {});
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMsg ?? "Delete task has been failed");
      }
    }
  }

  Future<void> _updateTaskStatusById(String id, String status) async {
    _getUpdateTaskStatusInProgress = true;
    setState(() {});

    final response =
        await NetworkCaller.getRequest(Urls.updateTaskStatus(id, status));
    _getUpdateTaskStatusInProgress = false;
    if (response.isSuccess) {
      widget.onRefresh();
    } else {
      setState(() {});
      if (mounted) {
        showSnackBarMessage(
            context, response.errorMsg ?? "Update task status has been failed");
      }
    }
  }

  bool _checkCurrentStatus(String status) {
    return widget.taskItem.status! == status;
  }

  void _showUpdateStatusDialog(String id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Select Status"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text("New"),
                  trailing:
                      _checkStatus("New") ? const Icon(Icons.check) : null,
                  onTap: () {
                    if (_checkCurrentStatus("New")) return;
                    _updateTaskStatusById(id, "New");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Completed"),
                  trailing: _checkStatus("Completed")
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    if (_checkCurrentStatus("Completed")) return;
                    _updateTaskStatusById(id, "Completed");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Progress"),
                  trailing:
                      _checkStatus("Progress") ? const Icon(Icons.check) : null,
                  onTap: () {
                    if (_checkCurrentStatus("Progress")) return;
                    _updateTaskStatusById(id, "Progress");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: const Text("Cancelled"),
                  trailing: _checkStatus("Cancelled")
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    if (_checkCurrentStatus("Cancelled")) return;
                    _updateTaskStatusById(id, "Cancelled");
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  bool _checkStatus(String status) => (widget.taskItem.status! == status);
}
