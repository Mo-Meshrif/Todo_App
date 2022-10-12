import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../../app/utils/assets_manager.dart';
import '../../../../../app/utils/strings_manager.dart';
import '../../../domain/entities/task_to_do.dart';
import '../../controller/home_bloc.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_task_list.dart';
import '../../widgets/custom_text_search.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TaskTodo> searchedList = [];
    bool showEmpty = false;
    return WillPopScope(
      onWillPop: () {
        //use this event here to clear savedList when user exit and enter immediately
        BlocProvider.of<HomeBloc>(context).add(ClearSearchListEvent());
        return Future.value(true);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: AppStrings.search,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              flexibleSpace: CustomTextSearch(
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    BlocProvider.of<HomeBloc>(context).add(
                      GetSearchedTasksEvent(searchedVal: val),
                    );
                  } else {
                    BlocProvider.of<HomeBloc>(context)
                        .add(ClearSearchListEvent());
                  }
                },
              ),
            ),
          ],
          body: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state is EditTaskLoaded) {
                int index = searchedList
                    .indexWhere((task) => task.id == state.task?.id);
                if (index > -1) {
                  searchedList[index] = state.task!;
                }
              } else if (state is DeleteTaskLLoaded) {
                int index =
                    searchedList.indexWhere((task) => task.id == state.taskId);
                if (index > -1) {
                  searchedList.removeAt(index);
                  showEmpty = searchedList.isEmpty;
                }
              } else if (state is SearchedTaskLoaded) {
                searchedList = state.searchedList;
                showEmpty = searchedList.isEmpty;
              } else if (state is HomeTranstion) {
                searchedList = [];
                showEmpty = false;
              }
            },
            builder: (context, state) => state is SearchedTaskLoading
                ? Lottie.asset(JsonAssets.search)
                : searchedList.isNotEmpty
                    ? CustomTaskList(
                        taskList: searchedList,
                      )
                    : Visibility(
                        visible: showEmpty,
                        child: Lottie.asset(JsonAssets.empty),
                      ),
          ),
        ),
      ),
    );
  }
}
