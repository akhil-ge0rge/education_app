import 'package:equatable/equatable.dart';

class LocalUser extends Equatable {
  const LocalUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.points,
    this.groupId = const [],
    this.enrolledCourseId = const [],
    this.following = const [],
    this.followers = const [],
    this.profilePic,
    this.bio,
  });
  const LocalUser.empty()
      : this(
          uid: '',
          email: '',
          enrolledCourseId: const [],
          followers: const [],
          following: const [],
          fullName: '',
          groupId: const [],
          points: 0,
          profilePic: '',
          bio: '',
        );
  @override
  String toString() {
    return 'LocalUser{uid : $uid, email : $email,bio : $bio, '
        'points : $points,fullName : $fullName}';
  }

  final String uid;
  final String fullName;
  final String email;
  final String? profilePic;
  final String? bio;
  final int points;
  final List<String> groupId;
  final List<String> enrolledCourseId;
  final List<String> following;
  final List<String> followers;

  @override
  List<Object?> get props => [
        uid,
        fullName,
        email,
        profilePic,
        bio,
        points,
        groupId.length,
        enrolledCourseId.length,
        following.length,
        followers.length,
      ];
}
