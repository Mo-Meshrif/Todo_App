import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(
        title: 'Categories',
      ),
    );
  }
}
