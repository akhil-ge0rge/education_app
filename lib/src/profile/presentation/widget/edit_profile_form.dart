import 'package:education_app/core/extension/context_extension.dart';
import 'package:education_app/core/extension/string_extention.dart';
import 'package:education_app/src/profile/presentation/widget/edit_profile_form_field.dart';
import 'package:flutter/material.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.oldPasswordController,
    required this.bioController,
    super.key,
  });
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController oldPasswordController;
  final TextEditingController bioController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EditProfileFormField(
          controller: nameController,
          hintText: context.currentUser!.fullName,
          title: 'Full Name',
        ),
        EditProfileFormField(
          controller: emailController,
          hintText: context.currentUser!.email.obscureEmail,
          title: 'Email',
        ),
        EditProfileFormField(
          controller: oldPasswordController,
          hintText: '********',
          title: 'Current Password',
        ),
        StatefulBuilder(
          builder: (context, refresh) {
            oldPasswordController.addListener(() => refresh(() {}));
            return EditProfileFormField(
              controller: passwordController,
              hintText: '********',
              title: 'New Password',
              readOnly: oldPasswordController.text.trim().isEmpty,
            );
          },
        ),
        EditProfileFormField(
          controller: bioController,
          hintText: context.currentUser!.bio ?? 'Add Bio',
          title: 'Bio',
        ),
      ],
    );
  }
}
