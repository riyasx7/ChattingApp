 import 'package:shared_preferences/shared_preferences.dart';

class helperFunction{
  static String userLoggedInKey ="LOGGEDINKEY";
  static String userNameKey="USERNAMEKEY";
  static String userEmailKey="USEREMAILKEY"   ;


  static Future<bool?> saveUserLoggedInStatus(bool isUserLoggedIn)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setBool(userLoggedInKey,isUserLoggedIn);
  }
  static Future<bool> saveUserNameSF(String userName)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userNameKey,userName);
  }
  static Future<bool?> saveUserEmail(String userEmail)async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.setString(userEmailKey,userEmail);
  }
  static Future<bool?> getUserLoggedInStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(userLoggedInKey);
  }
  static Future<String?> getUserEmailStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userEmailKey);
  }
  static Future<String?> getUserNameStatus()async{
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(userNameKey);
  }


}