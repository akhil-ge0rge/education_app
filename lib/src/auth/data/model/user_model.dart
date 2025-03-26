import 'package:education_app/core/utils/typedef.dart';
import 'package:education_app/src/auth/domain/entities/user.dart';

class LocalUserModel extends LocalUser {
  const LocalUserModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.points,
    super.groupId = const [],
    super.enrolledCourseId = const [],
    super.following = const [],
    super.followers = const [],
    super.profilePic,
    super.bio,
  });

  const LocalUserModel.empty()
      : this(
          email: '',
          fullName: '',
          points: 0,
          uid: '',
        );

  LocalUserModel.fromMap(DataMap map)
      : super(
          uid: map['uid'] as String,
          email: map['email'] as String,
          fullName: map['fullName'] as String,
          points: (map['points'] as num).toInt(),
          groupId: List<String>.from(map['groupId'] as List<dynamic>),
          enrolledCourseId:
              List<String>.from(map['enrolledCourseId'] as List<dynamic>),
          following: List<String>.from(map['following'] as List<dynamic>),
          followers: List<String>.from(map['followers'] as List<dynamic>),
          profilePic: map['profilePic'] as String?,
          bio: map['bio'] as String?,
        );

  DataMap toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'points': points,
      'groupId': groupId,
      'enrolledCourseId': enrolledCourseId,
      'following': following,
      'followers': followers,
      'profilePic': profilePic,
      'bio': bio,
    };
  }

  LocalUserModel copyWith({
    String? uid,
    String? fullName,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    List<String>? groupId,
    List<String>? enrolledCourseId,
    List<String>? following,
    List<String>? followers,
  }) {
    return LocalUserModel(
      uid: uid ?? this.uid,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      groupId: groupId ?? this.groupId,
      enrolledCourseId: enrolledCourseId ?? this.enrolledCourseId,
      following: following ?? this.following,
      followers: followers ?? this.followers,
    );
  }
}
