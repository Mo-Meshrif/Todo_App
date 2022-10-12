import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../../../app/utils/routes_manager.dart';
import '../../../../app/utils/values_manager.dart';
import '../components/daily_task.dart';
import '../components/monthly_task.dart';
import '../components/weekly_task.dart';
import '../controller/home_bloc.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import '../widgets/custom_tab_header.dart';
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
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppBar(),
        drawer: const CustomDrawer(),
        body: DefaultTabController(
          length: AppConstants.homeTabLength,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                flexibleSpace: CustomTextSearch(
                  onTap: () => Navigator.of(context).pushNamed(
                    Routes.searchRoute,
                  ),
                ),
                pinned: true,
              ),
              SliverPersistentHeader(
                delegate: TabHeader(
                  minHeight: AppSize.s80.h,
                  maxHeight: AppSize.s100.h,
                  onTap: (val) {
                    if (index != val) {
                      setState(() {
                        index = val;
                      });
                      HelperFunctions.getTasksOnTab(context, index);
                    }
                  },
                ),
                pinned: true,
              ),
              SliverFillRemaining(
                child: Container(
                  color: Colors.white,
                  child: const TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      DailyTask(),
                      WeeklyTask(),
                      MonthlyTask(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
