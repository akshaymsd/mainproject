import 'package:shared_preferences/shared_preferences.dart';

class DbService{

  static SharedPreferences ? prefs;


  static Future<void> init() async{

     prefs = await SharedPreferences.getInstance();
  }


  static setAuth(String role){

    prefs!.setString('role',role );
  }


   static String?  getAuth(){

    return prefs!.getString('role');
  }

  static setLoginId(String id){
    prefs!.setString('loginId',  id);

  }

  static getLoginId(){
    return prefs!.get('loginId');
  }




  

}