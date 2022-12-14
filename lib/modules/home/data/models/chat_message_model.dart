import 'package:cloud_firestore/cloud_firestore.dart';
import '/app/helper/extentions.dart';
import '../../../../app/helper/enums.dart';
import '../../domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  const ChatMessageModel({
    String? msgId,
    required String uid,
    required String idFrom,
    required String idTo,
    required String timestamp,
    required String content,
    required MessageType type,
    required bool isMark,
  }) : super(
          msgId: msgId,
          uid: uid,
          idFrom: idFrom,
          idTo: idTo,
          timestamp: timestamp,
          content: content,
          type: type,
          isMark: isMark,
        );
  factory ChatMessageModel.fromJson(Map<String, dynamic> map) =>
      ChatMessageModel(
        msgId: map['msgId'],
        uid: map['uid'],
        idFrom: map['idFrom'],
        idTo: map['idTo'],
        timestamp: map['timestamp'],
        content: map['content'],
        type: (map['type'] as String).toMessageType(),
        isMark: map['isMark'] == 1 ? true : false,
      );

  factory ChatMessageModel.fromSnapshot(DocumentSnapshot snapshot) =>
      ChatMessageModel(
        msgId: snapshot.id,
        uid: snapshot.get('uid'),
        idFrom: snapshot.get('idFrom'),
        idTo: snapshot.get('idTo'),
        timestamp: snapshot.get('timestamp'),
        content: snapshot.get('content'),
        type: (snapshot.get('type') as String).toMessageType(),
        isMark: snapshot.get('isMark') == 1 ? true : false,
      );

  ChatMessageModel copySubWith({
    String? uid,
    String? idFrom,
    String? idTo,
    String? timestamp,
    String? content,
    MessageType? type,
    bool? isMark,
  }) =>
      ChatMessageModel(
        msgId: msgId,
        uid: uid ?? this.uid,
        idFrom: idFrom ?? this.idFrom,
        idTo: idTo ?? this.idTo,
        timestamp: timestamp ?? this.timestamp,
        content: content ?? this.content,
        type: type ?? this.type,
        isMark: isMark ?? this.isMark,
      );

  toJson() => {
        'uid': uid,
        'idFrom': idFrom,
        'idTo': idTo,
        'timestamp': timestamp,
        'content': content,
        'type': type.toStringVal(),
        'isMark': isMark ? 1 : 0,
      };
}
