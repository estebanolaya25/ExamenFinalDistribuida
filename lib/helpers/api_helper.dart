import 'dart:convert';

import 'package:olayafinal_app/helpers/constans.dart';
import 'package:olayafinal_app/models/poll.dart';
import 'package:olayafinal_app/models/response.dart';
import 'package:olayafinal_app/models/token.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
static Future<Response> getPoll(Token token) async {
    if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }

    var url = Uri.parse('${Constans.apiUrl}/api/Finals');
    var response = await http.get(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${token.token}',
      },
    );

    var body = response.body;
    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: body);
    }

    var decodedJson = jsonDecode(body);
    return Response(isSuccess: true, result: Poll.fromJson(decodedJson));
  }


  static bool _validToken(Token token) {
    if (DateTime.parse(token.expiration).isAfter(DateTime.now())) {
      return true;
    }

    return false;
  }


   static Future<Response> post(String controller, Map<String, dynamic> request, Token token) async {
    if (!_validToken(token)) {
      return Response(isSuccess: false, message: 'Sus credenciales se han vencido, por favor cierre sesión y vuelva a ingresar al sistema.');
    }

    print(jsonEncode(request));
    
    var url = Uri.parse('${Constans.apiUrl}$controller');
    var response = await http.post(
      url,
      headers: {
        'content-type' : 'application/json',
        'accept' : 'application/json',
        'authorization': 'bearer ${token.token}',
      },
      body: jsonEncode(request),
    );


    print(response.body);

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.reasonPhrase.toString());

    }

    return Response(isSuccess: true);
  }

}