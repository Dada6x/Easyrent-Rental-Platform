class EndPoints {
  static String baseUrl = "http://192.168.1.4:3000/";
  static String login = "/auth/login";
  // static String Logout = "auth/logout";
  static String me = "/auth/me";
  static String registerUser = "/user/register";
  static String reset_forgetPassword = "/auth/reset";
  static String resetPasswordAfterReset = "/auth/reset///!Code";

  static String verifyCode(int id) => "/user/verify/$id";
  static String resendCode(int id) => "/user/resend/$id";

  static String resetPassword = "//user/";
  static String updateUserName = "//user/";
  static String deleteMe = "//user/";
  // static String verifyCode = "/user/verify///!code";
  // static String verifyCode = "/user/verify///!code";
  // static String verifyCode = "/user/verify///!code";

  static String favourite = "/favorite";
  static String tokenTime = "/auth/tokenTime";

  static String openStreetMap =
      "https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  static String fetchAllProperties = "/getAllPropereties";

  // static String getUserData(id) {
  //   return "ddwdwdwdwdwdwd/user/$id";
  // }

  const EndPoints();
}

class ApiKey {
  // static String status = "statusCode"; // must be the same with the response
  // static String email = "email";
  static String password = "password";
  static String confirmPassword = "ConfirmPassword";
  static String userName = "username";
  static String phone = "phone";
  static String code = "code";

  static String pointsDto = "pointsDto";

  static String lat = "lat";
  static String lon = "lon";

  // static String token = "token";

  static String token = "token";
  // static String errorMessage = "message";

  const ApiKey();
}
