import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:easyrent/core/constants/assets.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/navigation/introduction_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Future.delayed(const Duration(seconds: 2), () {
      _controller.forward().whenComplete(() {
        // ! just the introduction Screens sharedPref
        if (userPref?.getBool("isFirst") == true) {
          Get.offNamed("/login");
        } else {
          Get.off(() => const IntroductionScreen());
        }
      });
    });

    //! fetch the User Profile During the SplashScreen only if hes Logged in
    if (userPref?.getBool("isLoggedIn") == true) {
      debug.f("User is Logged in so im fetching his Data ");
      userDio.getProfile();
    } else {
      debug.w("User is Not Logged in so im Not fetching his Data ");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Stack(
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (_, child) {
                final radius = screenSize.longestSide * 1.5 * _animation.value;
                return ClipPath(
                    clipper: CircleRevealClipper(radius),
                    child: Container(color: blue));
              },
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(easyRent),
                  const SizedBox(height: 20),
                  AnimatedTextKit(
                    totalRepeatCount: 1,
                    isRepeatingAnimation: false,
                    animatedTexts: [
                      TyperAnimatedText(
                        "Your Getaway To Perfect Homes",
                        textStyle: AppTextStyles.h24medium.copyWith(
                          color: white,
                        ),
                        speed: const Duration(milliseconds: 50),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircleRevealClipper extends CustomClipper<Path> {
  final double radius;

  CircleRevealClipper(this.radius);

  @override
  Path getClip(Size size) {
    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    path.addOval(Rect.fromCircle(center: center, radius: radius));
    return path;
  }

  @override
  bool shouldReclip(CircleRevealClipper oldClipper) =>
      radius != oldClipper.radius;
}
