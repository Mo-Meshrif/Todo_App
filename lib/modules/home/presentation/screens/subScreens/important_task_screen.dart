import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class ImportantTaskScreen extends StatelessWidget {
  const ImportantTaskScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Important Tasks',
      ),
    );
  }
}
