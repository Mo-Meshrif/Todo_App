import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class DoneTaskScreen extends StatelessWidget {
  const DoneTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Done Tasks',
      ),
    );
  }
}
