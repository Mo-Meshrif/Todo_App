import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_text_search.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Search',
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            pinned: true,
            flexibleSpace: CustomTextSearch(
              onChanged: (val) => debugPrint(val),
            ),
          ),
        ],
        body: Container(),
      ),
    );
  }
}
