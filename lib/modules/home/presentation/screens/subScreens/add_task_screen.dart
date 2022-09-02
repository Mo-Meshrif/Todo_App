import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'New Task',
      ),
    );
  }
}
