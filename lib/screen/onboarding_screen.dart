
import 'package:a5dmny/screen/auth/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) async{
    SharedPreferences preferences=await SharedPreferences.getInstance();
    preferences.setBool('isShow',true);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('assets/images/$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration =  PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      isBottomSafeArea: true,
      isTopSafeArea: true,
      pages: [
        PageViewModel(
          title: " أهلا بك في تطبيق أخدمني!",
          body:
          "تطبيقنا يقدم لك خدمات الطرق المختلفة لجعل حياتك أسهل وأثبت",
          image: _buildImage('onboardingone.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "خدماتنا أمنة",
          body:
          "خدماتنا تضمن لك الأمان والأداء الجيد وسوف تجد أن أسعارنا مناسبة ومنافسة لأي خدمة مماثلة",
          image: _buildImage('onboardingtwo.png'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "أخدمني",
          body:
          "يوفر لك خدمات عالية الجودة وأمانة علي مدار الساعة",
          image: _buildImage('onboardingthree.png'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: TextButton(
        child: const Text(
          'Skip',
          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.orange),
        ),
        onPressed: () => _onIntroEnd(context),
      ),
      skipOrBackFlex: 0,
      nextFlex: 0,
      onSkip: () => _onIntroEnd(context),
      showBackButton: false,
      back: const Icon(Icons.arrow_back,color: Colors.orange,),
      next: const Icon(Icons.arrow_forward,color:  Colors.orange,),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600,color: Colors.orange,
          fontSize: 20)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeColor: Colors.orange,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}

