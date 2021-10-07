import 'package:audio_service_example/utilities/constants.dart';
import 'package:dio/dio.dart';

class StationsWebServices {
  Dio dio = Dio();

  stationsWebServices() {
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
    );
    dio = Dio(options);
  }

  Future<List<dynamic>> getAllStations() async {
    try {
      Response response = await dio.get(baseUrl);
      print(response.data.toString());
      return response.data;
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
  // late Dio dio;

  // stationsWebServices() {
  //   BaseOptions options = BaseOptions(
  //     receiveDataWhenStatusError: true,
  //     connectTimeout: 20 * 1000,
  //     receiveTimeout: 20 * 1000,
  //     contentType: 'application/json', // Added contentType here
  //   );
  //   dio = Dio(options);
  // }

  // Future<List<dynamic>> getAllStations() async {
  //   try {
  //     print("data");
  //     Response response =
  //         await dio.get('https://api.npoint.io/6e03e2feb680607a8a72');

  //     print(response.data.toString());

  //     return response.data;
  //   } catch (e) {
  //     print(e.toString());
  //     return [];
  //   }
  // }

  // var dio = new Dio();

  // Future<List<Stations>> fetchData() async {
  //   String url = "https://rickandmortyapi.com/api/character";

  //   final response = await dio.get(url);

  //   if (response.statusCode == 200) {
  //     final dataresult = response.data;
  //     Iterable list = dataresult['results'];
  //     print({'5555 ${list.length}'});
  //     return list.map((data) => Stations.fromJson(data)).toList();
  //   } else {
  //     throw Exception('Failled to Get Data');
  //   }
  // }

  // void main(List<String> arguments) async {
  //   // This example uses the Google Books API to search for books about http.
  //   // https://developers.google.com/books/docs/overview
  //   var url =
  //       Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});

  //   // Await the http get response, then decode the json-formatted response.
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //         convert.jsonDecode(response.body) as Map<String, dynamic>;
  //     var itemCount = jsonResponse['totalItems'];
  //     print('Number of books about http: $itemCount.');
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

