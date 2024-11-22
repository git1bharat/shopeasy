import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:luxe_loft/screens/login_screen.dart';
import 'package:luxe_loft/utill/luxe_color.dart';
import 'package:luxe_loft/utill/luxe_typography.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final introKey = GlobalKey<IntroductionScreenState>();
  void _onIntroEnd(context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  String descriptionText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pharetra quam elementum massa, viverra. Ut turpis consectetur.';
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      key: introKey,
      showSkipButton: true,
      showNextButton: true,
      showDoneButton: true,
      isProgressTap: false,
      isProgress: false,
      controlsPosition: const Position(left: 35, right: 0, bottom: 0),
      controlsMargin: const EdgeInsets.all(10.0),
      skip: Text(
        'Skip>>',
        style: LuxeTypo.headline1.copyWith(color: LuxeColors.brandSecondry),
      ),
      onSkip: () => _onIntroEnd(context),
      next: Image.asset('assets/images/next_arrow.png'),
      done: Text(
        'Done',
        style: LuxeTypo.headline1.copyWith(color: LuxeColors.brandSecondry),
      ),
      onDone: () => _onIntroEnd(context),
      pages: [
        PageViewModel(
          title: '',
          bodyWidget: _buildPageView(context, 'ONLINE PAYMENT', descriptionText,
              'assets/images/new.png'),
          decoration: const PageDecoration(
            pageColor: LuxeColors.brandPrimary,
            footerPadding: EdgeInsets.zero,
            pageMargin: EdgeInsets.zero,
            contentMargin: EdgeInsets.zero,
            safeArea: 0,
          ),
        ),
        PageViewModel(
          title: '',
          bodyWidget: _buildPageView(context, 'ONLINE SHOPPING',
              descriptionText, 'assets/images/online_shopping.png'),
          decoration: const PageDecoration(
            pageColor: LuxeColors.brandPrimary,
            footerPadding: EdgeInsets.zero,
            pageMargin: EdgeInsets.zero,
            contentMargin: EdgeInsets.zero,
            safeArea: 0,
          ),
        ),
        PageViewModel(
          title: '',
          bodyWidget: _buildPageView(context, 'HOME DELIVERY SERVICE',
              descriptionText, 'assets/images/pana.png'),
          decoration: const PageDecoration(
            pageColor: LuxeColors.brandPrimary,
            footerPadding: EdgeInsets.zero,
            pageMargin: EdgeInsets.zero,
            contentMargin: EdgeInsets.zero,
            safeArea: 0,
          ),
        )
      ],
    );
  }
}

Widget _buildPageView(
  BuildContext context,
  String title,
  String description,
  String image,
) {
  return Column(
    children: [
      Image.asset(
        image,
        width: 350.w,
        height: 350.h,
      ),
      SizedBox(
        height: 50.w,
      ),
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        height: 500.h,
        decoration: BoxDecoration(
          color: LuxeColors.brandWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.r),
            topRight: Radius.circular(40.r),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 57.7.h,
            ),
            Text(
              title,
              style: LuxeTypo.title.copyWith(color: LuxeColors.brandSecondry),
            ),
            SizedBox(
              height: 35.h,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: LuxeTypo.caption
                  .copyWith(color: LuxeColors.brandAccentLightDark),
            ),
            SizedBox(
              height: 81.13.h,
            ),
          ],
        ),
      ),
    ],
  );
}
