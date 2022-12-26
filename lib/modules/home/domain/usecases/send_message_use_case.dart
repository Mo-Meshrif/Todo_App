import 'package:dartz/dartz.dart';
import '../../../../app/common/usecase/base_use_case.dart';
import '../../../../app/errors/failure.dart';
import '../entities/chat_message.dart';
import '../repositories/base_home_repository.dart';

class SendMessageUseCase
    implements BaseUseCase<Either<ServerFailure, bool>, ChatMessage> {
  final BaseHomeRespository baseHomeRespository;

  SendMessageUseCase(this.baseHomeRespository);

  @override
  Future<Either<ServerFailure, bool>> call(ChatMessage parameters) =>
      baseHomeRespository.sendMessage(parameters);
}
