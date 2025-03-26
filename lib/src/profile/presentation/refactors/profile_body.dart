import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/res/colors.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/profile/presentation/widget/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (_, value, __) {
        final user = value.user;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: UserInfoCard(
                    color: Colours.physicsTileColour,
                    icon: const Icon(
                      IconlyLight.document,
                      size: 24,
                      color: Color(0xFF767DFF),
                    ),
                    infoTitle: 'Courses',
                    infoValue: user!.enrolledCourseId.length.toString(),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: UserInfoCard(
                    color: Colours.languageTileColour,
                    icon: Image.asset(
                      MediaRes.scoreboard,
                      height: 24,
                      width: 24,
                    ),
                    infoTitle: 'Score',
                    infoValue: user.points.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: UserInfoCard(
                    color: Colours.biologyTileColour,
                    icon: const Icon(
                      IconlyLight.user,
                      size: 24,
                      color: Color(0xFF56AEFF),
                    ),
                    infoTitle: 'Followers',
                    infoValue: user.followers.length.toString(),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: UserInfoCard(
                    color: Colours.chemistryTileColour,
                    icon: const Icon(
                      IconlyLight.user,
                      color: Color(0xFFFF848A),
                      size: 24,
                    ),
                    infoTitle: 'Following',
                    infoValue: user.following.length.toString(),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
