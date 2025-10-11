class LoginData {
  static const String staticEmail = "admin@jawara.com";
  static const String staticPassword = "123456";
  
  static bool validateCredentials(String email, String password) {
    return email == staticEmail && password == staticPassword;
  }
}