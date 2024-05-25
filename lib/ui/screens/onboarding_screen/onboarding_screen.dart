// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:hufniture/configs/color_config.dart';
import 'package:hufniture/configs/constraint_config.dart';
import 'package:hufniture/configs/helpers.dart';
import 'package:hufniture/data/helpers/onboarding_model.dart';
import 'package:hufniture/ui/screens/auth_selection_screen/auth_selection_screen.dart';
import 'package:page_transition/page_transition.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    //A list of onboarding content
    List<OnboardingModel> _onboardingList = _generateOnboarding();
    // render background images using loop
    List<Widget> backgrounds = _buildBackground(_onboardingList, context);
    // render body content using loop
    List<Widget> bodies = _buildBody(_onboardingList, context);

    return Scaffold(
      body: OnBoardingSlider(
        addController: true,
        controllerColor: ColorConfig.primaryColor,
        headerBackgroundColor: Colors.white,
        pageBackgroundColor: Colors.white,
        finishButtonText: 'Tiếp tục',
        onFinish: () {
          //Direct to login/sign up
          Navigator.push(
            context,
            PageTransition(
              type: PageTransitionType.fade,
              child: const AuthSelectionScreen(),
            ),
          );
        },
        finishButtonStyle: const FinishButtonStyle(
          backgroundColor: ColorConfig.primaryColor,
        ),
        skipTextButton: const Text(
          'Bỏ qua',
          style: TextStyle(color: ColorConfig.primaryColor),
        ),
        background: backgrounds,
        totalPage: _onboardingList.length,
        speed: 1.25,
        pageBodies: bodies,
      ),
    );
  }

  List<OnboardingModel> _generateOnboarding() {
    List<OnboardingModel> _onboardingList = [
      OnboardingModel(
          imgUrl: '${Helpers.imgUrl}/img_onboarding_1.jpg',
          title: 'Nội Thất Tinh Tế',
          desc:
              'Mang lại những nguồn cảm hứng và nét sinh động cho không gian'),
      OnboardingModel(
          imgUrl: '${Helpers.imgUrl}/img_onboarding_2.jpg',
          title: 'Không gian hiện đại',
          desc:
              'Hướng đến sự tiện ích, hiện đại tối giản và thân thiện môi trường'),
      OnboardingModel(
          imgUrl: '${Helpers.imgUrl}/img_onboarding_3.jpg',
          title: 'Thân Thiện Môi Trường',
          desc:
              'Mỗi sản phẩm đều được thiết kế với sự bền vững và thân thiện với môi trường')
    ];
    return _onboardingList;
  }

  List<Widget> _buildBody(
      List<OnboardingModel> _onboardingList, BuildContext context) {
    List<Widget> bodies = _onboardingList.map((model) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: ConstraintConfig.getHeight(context) / 2 + 20,
            ),
            FittedBox(
              child: Text(
                model.title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontSize: 28),
              ),
            ),
            SizedBox(
              height: ConstraintConfig.kSpaceBetweenItemsMedium,
            ),
            Text(model.desc,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }).toList();
    return bodies;
  }

  List<Widget> _buildBackground(
      List<OnboardingModel> _onboardingList, BuildContext context) {
    List<Widget> backgrounds = _onboardingList.map((model) {
      return ClipRRect(
        borderRadius:
            const BorderRadius.only(bottomLeft: Radius.circular(34.0)),
        child: Image.asset(
          model.imgUrl,
          fit: BoxFit.cover,
          height: ConstraintConfig.getHeight(context) / 2,
          width: ConstraintConfig.getWidth(context),
        ),
      );
    }).toList();
    return backgrounds;
  }
}
