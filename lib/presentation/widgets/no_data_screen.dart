import 'package:flutter/material.dart';

class NoDataScreen extends StatelessWidget {
  const NoDataScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("No Item Found"),
    );
  }
}
