import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> cards;

  CardSwiper({@required this.cards});

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
        padding: EdgeInsets.only(top: 10),
        child: new Swiper(
          itemBuilder: (BuildContext context, int index) {
            cards[index].uniqueId = '${cards[index].id}-swiper';
            return Hero(
              tag: cards[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: GestureDetector(
                  onTap: () => Navigator.pushNamed(context, 'detalle',
                      arguments: cards[index]),
                  child: FadeInImage(
                    placeholder: AssetImage('assets/images/no-image.jpg'),
                    image: NetworkImage(cards[index].getPosterImg()),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
          itemCount: cards.length,
          layout: SwiperLayout.STACK,
          itemWidth: _screenSize.width * 0.7,
          itemHeight: _screenSize.height * 0.5,
        ));
  }
}
