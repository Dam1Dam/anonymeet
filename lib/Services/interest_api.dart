import 'package:http/http.dart' as http;
import 'package:mmm_anonymeet/Models/interest_model.dart';

Future<List<Interest>> fetchInterests() async {

  var response = await fetchInterest();

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    List<Interest> interestsObj = interestFromJson(response.body);
    return interestsObj;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load Interests');
  }
}

Future<http.Response> fetchInterest(){
  return http.get(new Uri.http('10.0.2.2:8080', '/interest/getAll'));
}