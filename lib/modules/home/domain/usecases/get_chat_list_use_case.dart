import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/chat_message.dart';
import '../repositories/base_home_repository.dart';

class GetChatListUseCae
    implements
        BaseUseCase<Either<ServerFailure, Stream<List<ChatMessage>>>, String> {
  final BaseHomeRespository baseHomeRespository;

  GetChatListUseCae(this.baseHomeRespository);

  @override
  Future<Either<ServerFailure, Stream<List<ChatMessage>>>> call(
          String parameters) =>
      baseHomeRespository.getChatList(parameters);
}
