import 'package:http/http.dart' as http;

Future<String> loadConfig(String url) async {
  final http.Response response = await http.post(
    Uri.parse(url + '/config'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  // TODO: Add better exception handling for response.
  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load config.');
  }
}

// Future<Config> sendData() async {
//   final http.Response response = await http.post(
//     Uri.parse('http://192.168.1.243:50000/data'),
//     headers: <String, String>{
//       'Content-Type': 'data/json; charset=UTF-8',
//     },
//     body: 'for you, a data json file',
//   );
//
// //ignore: avoid_print
//   print('Response: ' + response.body);
//
//   if (response.statusCode == 200) {
//
//
//     return Config.fromJson(jsonDecode(response.body));
//   } else {
//     throw Exception('Failed to send data.');
//   }
// }
