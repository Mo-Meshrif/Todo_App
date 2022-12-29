import 'package:dartz/dartz.dart';
import '/app/helper/extentions.dart';
import '../../../../app/errors/exception.dart';
import '../../../../app/errors/failure.dart';
import '../../../../app/helper/helper_functions.dart';
import '../../../../app/services/network_services.dart';
import '../../../../app/utils/constants_manager.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/task_to_do.dart';
import '../../domain/repositories/base_home_repository.dart';
import '../../domain/usecases/get_tasks_use_case.dart';
import '../../domain/usecases/send_problem_use_case.dart';
import '../datasources/local_data_source.dart';
import '../datasources/remote_data_source.dart';
import '../models/chat_message_model.dart';
import '../models/task_model.dart';

class HomeRepositoryImpl implements BaseHomeRespository {
  final BaseHomeRemoteDataSource baseHomeRemoteDataSource;
  final BaseHomeLocalDataSource baseHomeLocalDataSource;
  final NetworkServices networkServices;

  HomeRepositoryImpl(this.baseHomeLocalDataSource,
      this.baseHomeRemoteDataSource, this.networkServices);
  @override
  Future<Either<LocalFailure, bool>> addTask(TaskTodo taskTodo) async {
    try {
      final DateTime date = DateTime.parse(taskTodo.date);
      final isAdded = await baseHomeLocalDataSource.addTask(
        TaskModel(
          uid: HelperFunctions.getSavedUser().id,
          name: taskTodo.name,
          description: taskTodo.description,
          category: taskTodo.category,
          date: taskTodo.date,
          day: date.day,
          week: date.weekOfMonth(),
          month: date.month,
          year: date.year,
          priority: taskTodo.priority,
          important: taskTodo.important,
          done: taskTodo.done,
          later: taskTodo.later,
        ),
      );
      return Right(isAdded);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, List<TaskTodo>>> getTasks(
      TaskInputs parameter) async {
    try {
      final tasks = await baseHomeLocalDataSource.getTasks(parameter);
      return Right(tasks);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, TaskTodo?>> editTask(TaskTodo taskTodo) async {
    try {
      final DateTime date = DateTime.parse(taskTodo.date);
      final task = await baseHomeLocalDataSource.editTask(
        TaskModel(
          id: taskTodo.id,
          uid: HelperFunctions.getSavedUser().id,
          name: taskTodo.name,
          description: taskTodo.description,
          category: taskTodo.category,
          date: taskTodo.date,
          day: date.day,
          week: date.weekOfMonth(),
          month: date.month,
          year: date.year,
          priority: taskTodo.priority,
          important: taskTodo.important,
          done: taskTodo.done,
          later: taskTodo.later,
        ),
      );
      return Right(task);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<LocalFailure, int>> deleteTask(int taskId) async {
    try {
      final id = await baseHomeLocalDataSource.deleteTask(taskId);
      return Right(id);
    } on LocalExecption catch (failure) {
      return Left(LocalFailure(msg: failure.msg));
    }
  }

  @override
  Future<Either<ServerFailure, bool>> sendMessage(ChatMessage message) async {
    if (await networkServices.isConnected()) {
      try {
        final val = await baseHomeRemoteDataSource.sendMessage(ChatMessageModel(
            uid: message.uid,
            idFrom: message.idFrom,
            idTo: message.idTo,
            timestamp: message.timestamp,
            content: message.content,
            type: message.type,
            isMark: message.isMark));
        return Right(val);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppConstants.noConnection));
    }
  }

  @override
  Future<Either<ServerFailure, Stream<List<ChatMessage>>>> getChatList(
      String uid) async {
    if (await networkServices.isConnected()) {
      try {
        Stream<List<ChatMessageModel>> val =
            await baseHomeRemoteDataSource.getChatList(uid);
        return Right(val);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppConstants.noConnection));
    }
  }

  @override
  Future<Either<ServerFailure, void>> updateMessage(ChatMessage message) async {
    if (await networkServices.isConnected()) {
      try {
        var val = await baseHomeRemoteDataSource.updateMessage(
          ChatMessageModel(
            msgId: message.msgId,
            uid: message.uid,
            idFrom: message.idFrom,
            idTo: message.idTo,
            timestamp: message.timestamp,
            content: message.content,
            type: message.type,
            isMark: message.isMark,
          ),
        );
        return Right(val);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppConstants.noConnection));
    }
  }

  @override
  Future<Either<ServerFailure, bool>> sendProblem(
      ProblemInput problemInput) async {
    if (await networkServices.isConnected()) {
      try {
        final val = await baseHomeRemoteDataSource.sendProblem(problemInput);
        return Right(val);
      } on ServerExecption catch (failure) {
        return Left(ServerFailure(msg: failure.msg));
      }
    } else {
      return const Left(ServerFailure(msg: AppConstants.noConnection));
    }
  }
}
