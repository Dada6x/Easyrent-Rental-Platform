import 'package:dio/dio.dart';
import 'package:easyrent/core/constants/colors.dart';
import 'package:easyrent/core/services/api/dio_consumer.dart';
import 'package:easyrent/core/constants/utils/textStyles.dart';
import 'package:easyrent/data/repos/userRepo.dart';
import 'package:easyrent/main.dart';
import 'package:easyrent/presentation/views/auth/views/login.dart';
import 'package:easyrent/core/constants/utils/button.dart';
import 'package:easyrent/presentation/views/auth/widgets/empty_search_bar.dart';
import 'package:easyrent/presentation/views/auth/widgets/greeting.dart';
import 'package:easyrent/core/constants/utils/textFields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  Governorate? selectedGovernorate;

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
                Padding(
                  padding: EdgeInsets.all(5.0.r),
                  child: greetings("Create Account", "Sign Up to get Started!"),
                ),
                //! Full Name
                CustomTextfield(
                  hint: "Full Name ",
                  icon: const Icon(Icons.person),
                  controller: _nameController,
                ),
                //! Phone Number
                CustomTextfield(
                  hint: "Phone Number ",
                  icon: const Icon(Icons.phone),
                  controller: _phoneNumberController,
                  isPhoneNumber: true,
                ),
                //! Password
                CustomTextfield(
                  hint: "Password",
                  icon: const Icon(Icons.lock),
                  controller: _passwordController,
                  isPassword: true,
                ),
                //! Confirm Password
                CustomTextfield(
                  hint: "Confirm Password",
                  icon: const Icon(Icons.lock),
                  controller: _confirmController,
                  isPassword: true,
                ),
                //! Governorate Dropdown
                Padding(
                  padding: EdgeInsets.only(left: 1.w, top: 8.h),
                  child: Material(
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                    ),
                    child: StateDropdown(
                      onStateSelected: (Governorate? state) {
                        selectedGovernorate = state;
                      },
                    ),
                  ),
                ),
                //! Register Button
                CustomButton(
                  hint: "Register",
                  function: () async {
                    final name = _nameController.text.trim();
                    final phone = _phoneNumberController.text.trim();
                    final password = _passwordController.text;
                    final confirmPassword = _confirmController.text;
                    if (name.isEmpty ||
                        phone.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty ||
                        phone.length != 10 ||
                        password.length < 6 ||
                        name.length < 5 ||
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

                    if (password != confirmPassword) {
                      Get.snackbar(
                        "Error",
                        "Passwords do not match",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: red,
                        colorText: white,
                        margin: EdgeInsets.all(12.w),
                        borderRadius: 8.r,
                      );
                      return;
                    }
                    if (selectedGovernorate == null) {
                      Get.snackbar(
                        "Missing Information",
                        "Please select a governorate",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: red,
                        colorText: white,
                        margin: EdgeInsets.all(12.w),
                        borderRadius: 8.r,
                      );
                      return;
                    }
                    userREPO.signUpUser(
                      userName: name,
                      number: phone,
                      password: password,
                      latLang: {
                        "lat": selectedGovernorate!.latitude,
                        "lon": selectedGovernorate!.longitude,
                      },
                    );
                  },
                ),
                Row(
                  //! Navigate to Login
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account!",
                        style: AppTextStyles.h12regular),
                    TextButton(
                      onPressed: () {
                        Get.off(() => LoginPage(),
                            transition: Transition.leftToRight,
                            curve: Curves.easeInOutCubicEmphasized);
                      },
                      child: Text('Login', style: AppTextStyles.h16semi),
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
}

class StateDropdown extends StatefulWidget {
  final void Function(Governorate?) onStateSelected;

  const StateDropdown({super.key, required this.onStateSelected});

  @override
  _StateDropdownState createState() => _StateDropdownState();
}

class _StateDropdownState extends State<StateDropdown> {
  Governorate? selectedState;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Governorate>(
      focusColor: Theme.of(context).colorScheme.secondary,
      isExpanded: true,
      underline: const SizedBox(),
      hint: Text(
        "  Select an Governorate",
        style: AppTextStyles.h20regular.copyWith(color: grey),
      ),
      value: selectedState,
      onChanged: (Governorate? newState) {
        setState(() {
          selectedState = newState;
        });
        widget.onStateSelected(newState);
      },
      items: syriaGovernorate.map((Governorate state) {
        return DropdownMenuItem<Governorate>(
          value: state,
          child: Text(
            "  ${state.name}",
            style: AppTextStyles.h20medium,
          ),
        );
      }).toList(),
    );
  }
}

class Governorate {
  final String name;
  final double latitude;
  final double longitude;

  Governorate({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

final List<Governorate> syriaGovernorate = [
  Governorate(name: 'Damascus', latitude: 33.5138, longitude: 36.2765),
  Governorate(name: 'Homs', latitude: 34.7304, longitude: 36.7096),
  Governorate(name: 'Aleppo', latitude: 36.2021, longitude: 37.1343),
  Governorate(name: 'Latakia', latitude: 35.5167, longitude: 35.7917),
  Governorate(name: 'Daraa', latitude: 32.6189, longitude: 36.1021),
];
