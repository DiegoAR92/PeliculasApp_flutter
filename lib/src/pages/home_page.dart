import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/pelicutas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';

import 'package:peliculas/src/widgets/card_swiper_witget.dart';
import 'package:peliculas/src/widgets/movie_horizontal_wirdget.dart';

class HomePage extends StatelessWidget {
  final pelicula = new PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    pelicula.getPopulares();
    return Scaffold(
        appBar: AppBar(
          title: Text('Peliculas de cine'),
          actions: [
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                })
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [_swiperTarjetas(), _footer(context)],
        ));
  }

  Widget _swiperTarjetas() {
    return FutureBuilder(
      future: pelicula.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(cards: snapshot.data);
        } else {
          return Container(
              height: 400, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Populares',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          StreamBuilder(
            stream: pelicula.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(
                  peliculas: snapshot.data,
                  nextPage: pelicula.getPopulares,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}
