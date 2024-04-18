

import 'package:http/http.dart' as http;

class ApiHelper{


  var client = http.Client();

  Future<http.Response>  postData({
    required String url,
    Object? body
    
  }) async{


    final uri = Uri.parse(url);

   

      var response = await client.post(uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: body);

      return response;





  }
}