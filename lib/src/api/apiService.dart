import 'package:http/http.dart' show Client;
import 'package:practicawidgets/src/models/materia.dart';

class ApiService {
  final String baseUrl = "https://mtwdm-multi-android.azurewebsites.net/api/Materias";
  Client httpClient = Client();

  Future<List<Materia>> getMaterias() async {
    final response = await httpClient.get("$baseUrl");
    if (response.statusCode == 200) {
      return Materia.materiaFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createMateria(Materia data) async {
    final response = await httpClient.post(
        '$baseUrl',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: Materia.materiaToJson(data));
    if (response.statusCode == 201)
      return true;
    else
      return false;
  }

  Future<bool> updateMateria(Materia data) async {
    final response = await httpClient.put(
        //'$BASE_URL/api/profile/${data.id}',
        '$baseUrl/${data.id}',
        headers: {'content-type': 'application/json'},
        body: Materia.materiaToJson(data));
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteMateria(int id) async {
    final response = await httpClient.delete(
        //'$BASE_URL/api/profile/$id',
        '$baseUrl/$id',
        headers: {'content-type': 'application/json'});
    if (response.statusCode == 200)
      return true;
    else
      return false;
  }
}

//import 'package:practicawidgets/src/model/profile.dart';
//import 'package:http/http.dart' show Client;
//
//class ApiService{
//  final String baseUrl = "http://api.bengkelrobot.net:8001";
//  Client client = Client();
//
//  Future<List<Profile>> getProfiles() async {
//    final response = await client.get('$baseUrl/api/profile');
//    if(response.statusCode == 200)
//    {
//      return profileFromJson(response.body);
//    }
//    else
//    {
//      return null;
//    }
//  }
//
//    Future<bool> createProfile(Profile data) async {
//    final response = await client.post(
//      "$baseUrl/api/profile",
//      headers: {"content-type": "application/json"},
//      body: profileToJson(data),
//    );
//    if (response.statusCode == 201) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//
//  Future<bool> updateProfile(Profile data) async {
//    final response = await client.put(
//      "$baseUrl/api/profile/${data.id}",
//      headers: {"content-type": "application/json"},
//      body: profileToJson(data),
//    );
//    if (response.statusCode == 200 || response.statusCode == 204) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//
//  Future<bool> deleteProfile(int id) async {
//    final response = await client.delete(
//      "$baseUrl/api/profile/$id",
//      headers: {"content-type": "application/json"},
//    );
//    if (response.statusCode == 200) {
//      return true;
//    } else {
//      return false;
//    }
//  }
//}
