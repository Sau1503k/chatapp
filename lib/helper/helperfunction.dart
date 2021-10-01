import 'package:shared_preferences/shared_preferences.dart';

class HelperFunction{
  static String sharedpreferenceUserLoggedInKey="ISLOGGEDIN";
  static String sharedpreferenceUserNameKey="USERNAMEKEY";
  static String sharedpreferenceUserEmailKey="USEREMAILKEY";
  static Future<bool> saveUserLoggedInsharedpreference(bool isUserloggedIn)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(sharedpreferenceUserLoggedInKey, isUserloggedIn);
  }
  static Future<bool> saveUserNamesharedpreference(String UserName)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedpreferenceUserNameKey, UserName);
  }
  static Future<bool> saveUserEmailsharedpreference(String EmailId)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedpreferenceUserEmailKey, EmailId);
  }

  //get data form sharedpreference
  static Future<bool> getUserLoggedInsharedpreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getBool(sharedpreferenceUserLoggedInKey);
  }
  static Future<String> getUserNamesharedpreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedpreferenceUserNameKey);
  }
  static Future<String> getUserEmailsharedpreference()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return  prefs.getString(sharedpreferenceUserEmailKey);
  }

}