import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/nested_back_button.dart';
import 'package:education_app/core/enums/update_user.dart';
import 'package:education_app/core/extension/context_extension.dart';
import 'package:education_app/core/res/colors.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/profile/presentation/widget/edit_profile_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final bioController = TextEditingController();
  final oldPasswordController = TextEditingController();

  File? pickedImage;

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        pickedImage = File(image.path);
      });
    }
  }

  bool get nameChanged =>
      context.currentUser?.fullName.trim() != fullNameController.text.trim();
  bool get emailChanged => emailController.text.trim().isNotEmpty;
  bool get passwordChanged => passwordController.text.trim().isNotEmpty;
  bool get bioChanged =>
      context.currentUser?.bio?.trim() != bioController.text.trim();
  bool get imageChanged => pickedImage != null;

  bool get notingChanged =>
      !nameChanged &&
      !emailChanged &&
      !passwordChanged &&
      !bioChanged &&
      !imageChanged;
  @override
  void initState() {
    fullNameController.text = context.currentUser!.fullName.trim();
    bioController.text = context.currentUser!.bio?.trim() ?? '';
    super.initState();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    oldPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UserUpdated) {
          CoreUtils.showSnackBar(context, 'Profile Updated Sucessfully');
          context.pop();
        } else if (state is AuthError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) => Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: const NestedBackButton(),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 24,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (notingChanged) {
                  context.pop();
                }
                final bloc = context.read<AuthBloc>();
                if (passwordChanged) {
                  if (oldPasswordController.text.isEmpty) {
                    CoreUtils.showSnackBar(
                      context,
                      'Please enter your old password',
                    );
                    return;
                  }

                  bloc.add(
                    UpdateUserEvent(
                      action: UpdateUserAction.password,
                      userData: jsonEncode(
                        {
                          'oldPassword': oldPasswordController.text.trim(),
                          'newPassword': passwordController.text.trim(),
                        },
                      ),
                    ),
                  );
                }
                if (nameChanged) {
                  bloc.add(
                    UpdateUserEvent(
                      action: UpdateUserAction.displayName,
                      userData: fullNameController.text.trim(),
                    ),
                  );
                }
                if (emailChanged) {
                  bloc.add(
                    UpdateUserEvent(
                      action: UpdateUserAction.email,
                      userData: emailController.text.trim(),
                    ),
                  );
                }
                if (imageChanged) {
                  bloc.add(
                    UpdateUserEvent(
                      action: UpdateUserAction.profilePic,
                      userData: pickedImage,
                    ),
                  );
                }
                if (bioChanged) {
                  bloc.add(
                    UpdateUserEvent(
                      action: UpdateUserAction.bio,
                      userData: bioController.text.trim(),
                    ),
                  );
                }
              },
              child: state is AuthLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : StatefulBuilder(
                      builder: (context, refresh) {
                        fullNameController.addListener(() => refresh(() {}));
                        emailController.addListener(() => refresh(() {}));
                        passwordController.addListener(() => refresh(() {}));
                        bioController.addListener(() => refresh(() {}));

                        return Text(
                          'Done',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color:
                                notingChanged ? Colors.grey : Colors.blueAccent,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
        body: GradientBackground(
          image: MediaRes.profileGradientBackground,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Builder(
                builder: (context) {
                  final user = context.currentUser!;
                  final userImage =
                      user.profilePic == null || user.profilePic!.isEmpty
                          ? null
                          : user.profilePic;
                  return CircleAvatar(
                    radius: 50,
                    backgroundImage: pickedImage != null
                        ? FileImage(pickedImage!)
                        : userImage != null
                            ? NetworkImage(userImage)
                            : const AssetImage(MediaRes.user),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                        ),
                        IconButton(
                          onPressed: pickImage,
                          icon: Icon(
                            (pickedImage != null || user.profilePic != null)
                                ? Icons.edit
                                : Icons.add_a_photo,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'We Recommend an image of atleast 400x400',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF777E90), fontSize: 14),
                ),
              ),
              const SizedBox(height: 30),
              EditProfileForm(
                nameController: fullNameController,
                emailController: emailController,
                passwordController: passwordController,
                oldPasswordController: oldPasswordController,
                bioController: bioController,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
