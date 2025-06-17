class EndPoints {
  static String baseUrl = "https://run.mocky.io/v3/";
  static String login = "/auth/login";
  static String Logout = "auth/logout";
  static String registerUser = "/user/register";
  static String verifyCode = "/user/verify///!code";
  static String favourite = "/favorite";
  static String me = "/auth/me";
  static String tokenTime = "/auth/tokenTime";

  static String openstreetmap="https://tile.openstreetmap.org/{z}/{x}/{y}.png";
  static String fetchAllProperties = "/getAllPropereties";

  // static String getUserData(id) {
  //   return "ddwdwdwdwdwdwd/user/$id";
  // }

  const EndPoints();
}

class ApiKey {
  static String status = "status"; // must be the same with the response
  static String email = "email";
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
  static String errorMessage = "errorMessage";

  const ApiKey();
}
