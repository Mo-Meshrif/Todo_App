import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/color_manager.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/strings_manager.dart';
import '../components/daily_task.dart';
import '../components/monthly_task.dart';
import '../components/weekly_task.dart';
import '../controller/home_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_text_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context).add(GetDailyTasksEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //This line to update TabBar localization
    context.locale.languageCode;
    return Scaffold(
      backgroundColor: ColorManager.primary,
      appBar: CustomAppBar(),
      drawer: const CustomDrawer(),
      body: DefaultTabController(
        length: AppConstants.homeTabLength,
        child: Column(
          children: [
            CustomTextSearch(
              onTap: () => Navigator.of(context).pushNamed(
                Routes.searchRoute,
              ),
            ),
            TabBar(
              onTap: (val) {
                if (index != val) {
                  setState(() {
                    index = val;
                  });
                  HelperFunctions.getTasksOnTab(context, index);
                }
              },
              overlayColor: MaterialStateProperty.all<Color>(
                Colors.transparent,
              ),
              indicatorColor: Colors.white,
              splashFactory: NoSplash.splashFactory,
              tabs: [
                Tab(text: AppStrings.daily.tr()),
                Tab(text: AppStrings.weekly.tr()),
                Tab(text: AppStrings.monthly.tr()),
              ],
            ),
            Expanded(
              child: Container(
                color: ColorManager.background,
                child: const TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    DailyTask(),
                    WeeklyTask(),
                    MonthlyTask(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
