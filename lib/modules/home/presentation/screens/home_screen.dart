import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../components/daily_task.dart';
import '../components/monthly_task.dart';
import '../components/weekly_task.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_tab_header.dart';
import '../widgets/custom_text_search.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      drawer: const CustomDrawer(),
      body: DefaultTabController(
        length: AppConstants.homeTabLength,
        child: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: CustomTextSearch(
                onTap: () => Navigator.of(context).pushNamed(
                  Routes.searchRoute,
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: TabHeader(
                minHeight: AppSize.s110.h,
                maxHeight: AppSize.s128.h,
                tabs: [
                  Tab(text: AppStrings.daily.tr()),
                  Tab(text: AppStrings.weekly.tr()),
                  Tab(text: AppStrings.monthly.tr()),
                ],
              ),
              pinned: true,
            )
          ],
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              DailyTask(),
              WeeklyTask(),
              MonthlyTask(),
            ],
          ),
        ),
      ),
    );
  }
}