import 'package:education_app/core/common/view/loading_view.dart';
import 'package:education_app/core/common/widgets/gradient_background.dart';
import 'package:education_app/core/res/colors.dart';
import 'package:education_app/core/res/media_res.dart';
import 'package:education_app/src/onboarding/domain/entities/page_content.dart';
import 'package:education_app/src/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:education_app/src/onboarding/presentation/widget/onboarding_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});
  static const routeName = '/';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final pageController = PageController();
  @override
  void initState() {
    super.initState();
    context.read<OnboardingCubit>().checkingIsUserFirstTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        image: MediaRes.onBoardingBackground,
        child: BlocConsumer<OnboardingCubit, OnboardingState>(
          listener: (context, state) {
            if (state is OnBoardingStatus && !state.isFirstTimer) {
              Navigator.of(context).pushReplacementNamed('/home');
            } else if (state is UserCached) {
              Navigator.of(context).pushReplacementNamed('/');
            }
          },
          builder: (BuildContext context, OnboardingState state) {
            if (state is CheckingIsUserFirstTimer ||
                state is CachingFirstTimer) {
              return const LoadingView();
            }
            return Stack(
              children: [
                PageView(
                  controller: pageController,
                  children: const [
                    OnboardingBody(pageContent: PageContent.first()),
                    OnboardingBody(pageContent: PageContent.second()),
                    OnboardingBody(pageContent: PageContent.third()),
                  ],
                ),
                Align(
                  alignment: const Alignment(0, 0.05),
                  child: SmoothPageIndicator(
                    effect: const WormEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      spacing: 40,
                      activeDotColor: Colours.primaryColour,
                      dotColor: Colors.white,
                    ),
                    controller: pageController,
                    count: 3,
                    onDotClicked: (index) => pageController.animateToPage(
                      index,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
