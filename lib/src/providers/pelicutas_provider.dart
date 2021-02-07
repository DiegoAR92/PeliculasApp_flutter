import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = '';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  Future<List<Pelicula>> _mapResponse(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final peliculas = Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEnCines() async {
    final url = Uri.http(_url, '/3/movie/now_playing',
        {'api_key': _apikey, 'language': _language});
    return await _mapResponse(url);
  }

  Future<List<Pelicula>> getPopulares() async {
    final url = Uri.http(_url, '/3/movie/popular',
        {'api_key': _apikey, 'language': _language, 'page': '1'});
    return await _mapResponse(url);
  }
}
