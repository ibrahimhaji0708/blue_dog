import 'package:shared_preferences/shared_preferences.dart';

const String _userLoginStatus = 'user_login_status';

class UserLoginStatus {
  static Future<bool> isLoggedIn() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(_userLoginStatus) ?? false;
  }

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool(_userLoginStatus, isLoggedIn);
  }
}