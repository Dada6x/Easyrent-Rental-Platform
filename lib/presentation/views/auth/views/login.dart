import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/constants/utils/button.dart';
import 'package:easyrent/core/constants/utils/textFields.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/auth/views/forget_password.dart';
import 'package:easyrent/presentation/views/auth/views/signup.dart';
import 'package:easyrent/presentation/views/auth/widgets/empty_search_bar.dart';
import 'package:easyrent/presentation/views/auth/widgets/greeting.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  LoginPage({super.key});
//$----------------------text controllers------------------------->
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
//$--------------------------------------------------------------->
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: emptySearchBar(),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                greetings("Welcome Back!", "Please login to your account"),
                //! EMAIL
                CustomTextfield(
                  hint: "Phone Number ",
                  icon: const Icon(Icons.phone),
                  controller: _numberController,
                  isPhoneNumber: true,
                ),
                //! PASSWORD
                CustomTextfield(
                  hint: "Password ",
                  icon: const Icon(Icons.password_outlined),
                  controller: _passwordController,
                  isPassword: true,
                ),
                //! FORGET PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () {
                        //@forget password
                        Get.to(() => ForgetPasswordPage());
                      },
                      child: Text('Forgot Password?',
                          style: AppTextStyles.h14regular.copyWith(
                              color: Theme.of(context).colorScheme.primary))),
                ),
                //@ LOGIN BUTTON :O
                CustomButton(
                  //todo fix this long if else shit
                  hint: "login",
                  function: () async {
                    userLogin();
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: AppTextStyles.h12regular),
                    TextButton(
                      onPressed: () {
                        Get.off(() => const SignupPage(),
                            transition: Transition.rightToLeft,
                            curve: Curves.easeInOutCubicEmphasized);
                      },
                      child: Text('Sign Up', style: AppTextStyles.h16semi),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//!
  void userLogin() async {
    final phone = _numberController.text.trim();
    final password = _passwordController.text;
    if (phone.isEmpty ||
        password.isEmpty ||
        _numberController.text.length != 10 ||
        password.length < 6 ||
        !RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      Get.snackbar(
        "Missing Information",
        "All fields are required",
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: red,
        colorText: white,
        margin: EdgeInsets.all(12.w),
        borderRadius: 8.r,
      );
      return;
    }
    userDio.loginUser(
      number: _numberController.text,
      password: _passwordController.text,
    );
  }
}
