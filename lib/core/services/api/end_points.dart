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
  static String update = "/user/";
  // static String verifyCode = "/user/verify///!code";
  // static String verifyCode = "/user/verify///!code";
  // static String verifyCode = "/user/verify///!code";

  static String favourite = "/favorite";
  static String tokenTime = "/auth/tokenTime";
  static String lightMapTile =
      "https://tile.tracestrack.com/topo__/{z}/{x}/{y}.webp?key=0a3d18b9249fb85601f81da60aa32a24";
  static String darkMapTile =
      "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/{z}/{x}/{y}{r}.png?api_key=65e83545-df9f-4a7b-adbd-8a83575d5698";

//TODO in Case i run out of requests either make new account on each site or use these: free low quality alternative
  //! the Open Free One
  //  https://tile.openstreetmap.org/{z}/{x}/{y}.png
  //! Dark but so shitty  and free
// https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png

  static String getPropertyById(int id) => "/property/$id";

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

//! for the dark Tile
//https://client.stadiamaps.com/dashboard/#/property/57470/ 
//! for the light Tile
// https://console.tracestrack.com/explorer
