import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class LaterTaskScreen extends StatelessWidget {
  const LaterTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Later Tasks',
      ),
    );
  }
}