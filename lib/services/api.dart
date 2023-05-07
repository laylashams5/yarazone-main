import 'package:http/http.dart' as http;
import 'package:yarazon/helpers/helper.dart';

class ApiServices {

  static Future<dynamic> postApi(String feedURL,
      {var parameters, Map<String, String>? headers}) async {
    var parse = Uri.parse(baseUrl + feedURL);

    http.Response response =
        await http.post(parse, body: parameters, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      logger.i(response.body);
    }

    return response.body;
  }
  static Future<dynamic> deleteApi(String feedURL,
      {var parameters, Map<String, String>? headers}) async {
    var parse = Uri.parse(baseUrl + feedURL);

    http.Response response =
        await http.delete(parse, body: parameters, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      logger.i(response.body);
    }

    return response.body;
  }

  static Future getApi(String feedURL,
      {Map<String, String>? headers}) async {
    var parse = Uri.parse(baseUrl + feedURL);

    http.Response response = await http.get(parse, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      logger.i(response.body);
    }
    return response.body;
  }
}
