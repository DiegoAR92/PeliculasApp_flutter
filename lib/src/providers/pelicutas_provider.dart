import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_models.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  String _apikey = '';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularesPage = 0;
  bool _loading = false;
  List<Pelicula> _populares = new List();
  final _popularesStreamController =
      StreamController<List<Pelicula>>.broadcast();
  Function(List<Pelicula>) get popularesSink =>
      _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream =>
      _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

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
    _popularesPage++;

    if (_loading) return [];
    _loading = true;
    final url = Uri.http(_url, '/3/movie/popular', {
      'api_key': _apikey,
      'language': _language,
      'page': _popularesPage.toString()
    });

    final resp = await _mapResponse(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _loading = false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async {
    final url = Uri.https(_url, '/3/movie/$peliId/credits',
        {'api_key': _apikey, 'language': _language});
    print(url);

    final resp = await http.get(url);

    final decodeData = json.decode(resp.body);
    final cast = new Cast.fromJsonList(decodeData['cast']);

    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async {
    final url = Uri.http(_url, '/3/search/movie',
        {'api_key': _apikey, 'language': _language, 'query': query});
    return await _mapResponse(url);
  }
}
