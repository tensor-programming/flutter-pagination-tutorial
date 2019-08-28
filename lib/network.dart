import "package:http/http.dart" as http;
import 'dart:convert';
import "package:pagination/model.dart";

class API {
  String url = "https://jsonplaceholder.typicode.com/photos";

  Future<List<Photo>> getPhotos(int albumId) async {
    final response = await http.get(Uri.parse("$url?albumId=$albumId"));

    List jsonData = json.decode(response.body);

    return jsonData.map((c) => Photo.fromJson(c)).toList();
  }
}
