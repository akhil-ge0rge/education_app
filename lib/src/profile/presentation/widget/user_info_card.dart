import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({
    required this.color,
    required this.icon,
    required this.infoTitle,
    required this.infoValue,
    super.key,
  });
  final Color color;
  final Widget icon;
  final String infoTitle;
  final String infoValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 84,
      width: 156,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE4E6EA),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: icon,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  infoTitle,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  infoValue,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
