import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/common/widgets/rounded_button.dart';
import 'package:education_app/core/res/fonts.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/core/utils/core_utils.dart';
import 'package:education_app/src/auth/data/model/user_model.dart';
import 'package:education_app/src/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/src/auth/presentation/view/sign_up_screen.dart';
import 'package:education_app/src/auth/presentation/widgets/sing_in_form.dart';
import 'package:education_app/src/dashboard/presentation/view/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            CoreUtils.showSnackBar(context, state.message);
          } else if (state is SignedIn) {
            context.read<UserProvider>().initUser(state.user as LocalUserModel);
            Navigator.of(context)
                .pushReplacementNamed(DashboardScreen.routeName);
          }
        },
        builder: (context, state) {
          return GradientBackground(
            image: MediaRes.authGradientBackground,
            child: SafeArea(
              child: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const Text(
                      'Easy to learn, discover more skills.',
                      style: TextStyle(
                        fontFamily: Fonts.aeonik,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign in to your account',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Baseline(
                          baseline: 100,
                          baselineType: TextBaseline.alphabetic,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed(
                                SignUpScreen.routeName,
                              );
                            },
                            child: const Text('Register account?'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SignInForm(
                      emailController: emailController,
                      passwordController: passwordController,
                      formKey: formKey,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text('Forgot Password ?'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/forgot-password');
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (state is AuthLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else
                      RoundedButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          FirebaseAuth.instance.currentUser?.reload();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                                  SignInEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                          }
                        },
                        label: 'Sign In',
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
