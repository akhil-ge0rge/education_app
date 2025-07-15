import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/chat/domain/entities/group.dart';

class GroupModel extends Group {
  const GroupModel({
    required super.id,
    required super.name,
    required super.courseId,
    required super.members,
    super.lastMessage,
    super.groupImageUrl,
    super.lastMessageSenderName,
    super.lastMessageTimeStamp,
  });
  GroupModel.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          courseId: map['courseId'] as String,
          members: List<String>.from(map['members'] as List<dynamic>),
          lastMessage: map['lastMessage'] as String?,
          groupImageUrl: map['groupImageUrl'] as String?,
          lastMessageTimeStamp:
              (map['lastMessageTimeStamp'] as Timestamp?)?.toDate(),
          lastMessageSenderName: map['lastMessageSenderName'] as String?,
        );

  GroupModel.empty()
      : this(
          id: '',
          name: '',
          courseId: '',
          members: const [],
          lastMessage: null,
          groupImageUrl: null,
          lastMessageSenderName: null,
          lastMessageTimeStamp: DateTime.now(),
        );

  DataMap toMap() {
    return {
      'id': id,
      'name': name,
      'courseId': courseId,
      'members': members,
      'lastMessage': lastMessage,
      'groupImageUrl': groupImageUrl,
      'lastMessageTimeStamp':
          lastMessage == null ? null : FieldValue.serverTimestamp(),
      'lastMessageSenderName': lastMessageSenderName,
    };
  }

  GroupModel copyWith({
    String? id,
    String? name,
    String? courseId,
    List<String>? members,
    String? lastMessage,
    String? groupImageUrl,
    DateTime? lastMessageTimeStamp,
    String? lastMessageSenderName,
  }) {
    return GroupModel(
      id: id ?? this.id,
      name: name ?? this.name,
      courseId: courseId ?? this.courseId,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      groupImageUrl: groupImageUrl ?? this.groupImageUrl,
      lastMessageTimeStamp: lastMessageTimeStamp ?? this.lastMessageTimeStamp,
      lastMessageSenderName:
          lastMessageSenderName ?? this.lastMessageSenderName,
    );
  }
}
