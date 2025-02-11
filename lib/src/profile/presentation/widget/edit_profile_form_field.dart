import 'package:education_app/core/common/widgets/i_field.dart';
import 'package:flutter/material.dart';

class EditProfileFormField extends StatelessWidget {
  const EditProfileFormField({
    required this.controller,
    required this.title,
    required this.hintText,
    this.readOnly = false,
    super.key,
  });
  final String title;
  final TextEditingController controller;
  final String hintText;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 10),
        IField(
          controller: controller,
          hintText: hintText,
          readOnly: readOnly,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
