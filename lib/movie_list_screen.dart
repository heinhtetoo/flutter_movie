import 'dart:convert';

import 'package:demo_api_calls/api.dart';
import 'package:demo_api_calls/color.dart';
import 'package:demo_api_calls/const.dart';
import 'package:demo_api_calls/movie.dart';
import 'package:demo_api_calls/movie_detail_screen.dart';
import 'package:demo_api_calls/movie_list.dart';
import 'package:flutter/material.dart';

import 'package:flutter_rating/flutter_rating.dart';

import 'package:http/http.dart' as http;

class MovieListScreen extends StatelessWidget {
  final String header;

  MovieListScreen({Key key, @required this.header}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(header),
      ),
      body: Container(
        color: backgroundColor,
        child: Center(child: _buildVerticalList(context: context)),
      ),
    );
  }

  Widget _buildVerticalList({BuildContext context}) {
    return SizedBox(
      child: FutureBuilder(
          future: fetchMovieList(),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildItem(
                      context: context,
                      index: index,
                      height: 160.0,
                      snapshot: snapshot,
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else {
              return Container(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    ),
                  ),
                  color: Colors.transparent);
            }
          }),
    );
  }

  Widget _buildItem({
    BuildContext context,
    int index,
    double height,
    AsyncSnapshot<List<Movie>> snapshot,
  }) {
    double width = height / 1.5;
    if (snapshot.hasData) {
      return new GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MovieDetailScreen(
                        id: snapshot.data[index].id,
                        title: snapshot.data[index].title,
                      )));
        },
        child: Container(
          height: height,
          margin: EdgeInsets.all(edgeSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ClipRRect(
                borderRadius: new BorderRadius.circular(8.0),
                child: snapshot.data[index].poster_path != null
                    ? Image.network(
                        imagePathw342 + snapshot.data[index].poster_path,
                        fit: BoxFit.fitWidth,
                        height: height,
                        width: width,
                      )
                    : Image.asset(
                        'images/img_not_available.png',
                        fit: BoxFit.fill,
                        height: height,
                        width: width,
                      ),
              ),
              Container(
                  width: width * 1.7,
                  margin: EdgeInsets.fromLTRB(
                      edgeSize, edgeSize / 2, edgeSize, edgeSize / 2),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        snapshot.data[index].title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                            color: greyColor2),
                        textAlign: TextAlign.left,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.fade,
                      ),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.date_range,
                            color: accentColor,
                            size: width / 6,
                          ),
                          Container(
                            padding: EdgeInsets.only(left: edgeSize),
                            child: Text(
                              snapshot.data[index].release_date.substring(0, 4),
                              style: TextStyle(
                                  fontStyle: FontStyle.normal,
                                  fontSize: 11.0,
                                  color: greyColor),
                              textAlign: TextAlign.left,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(edgeSize / 4),
                            margin: EdgeInsets.only(right: edgeSize),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border:
                                    Border.all(color: accentColor, width: 1.0)),
                            child: Text(
                              getGenreNameById(
                                  snapshot.data[index].genre_ids[0]),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11.0,
                                  color: greyColor2),
                              textAlign: TextAlign.left,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.fade,
                            ),
                          ),
                          snapshot.data[index].genre_ids.length > 1
                              ? Container(
                                  padding: EdgeInsets.all(edgeSize / 4),
                                  margin: EdgeInsets.only(right: edgeSize),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      border: Border.all(
                                          color: accentColor, width: 1.0)),
                                  child: Text(
                                    getGenreNameById(
                                        snapshot.data[index].genre_ids[1]),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11.0,
                                        color: greyColor2),
                                    textAlign: TextAlign.left,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.fade,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      Container(
                        width: width,
                        alignment: Alignment.centerLeft,
                        child: StarRating(
                          size: 20.0,
                          color: Colors.yellow,
                          starCount: 5,
                          borderColor: Colors.grey,
                          rating: (snapshot.data[index].vote_average) / 2.0,
                        ),
                      )
                    ],
                  )),
              Container(
                width: width / 4,
                alignment: Alignment.topCenter,
                child: IconButton(
                  icon: Icon(
                    Icons.bookmark_border,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return new Container();
    }
  }
}

Future<List<Movie>> fetchMovieList() async {
  final response = await http.get(baseUrl + upComingMovieList + apiKey);

  if (response.statusCode == 200) {
    return MovieList.fromJson(json.decode(response.body)["results"]).movieList;
  } else {
    throw Exception('Failed to load movie');
  }
}

String getGenreNameById(int id) {
  List idList = [
    28,
    12,
    16,
    35,
    80,
    99,
    18,
    10751,
    14,
    36,
    27,
    10402,
    9648,
    10749,
    878,
    10770,
    53,
    10752,
    37
  ];
  List nameList = [
    "Action",
    "Adventure",
    "Animation",
    "Comedy",
    "Crime",
    "Documentary",
    "Drama",
    "Family",
    "Fantasy",
    "History",
    "Horror",
    "Music",
    "Mystery",
    "Romance",
    "Science Fiction",
    "TV Movie",
    "Thriller",
    "War",
    "Western"
  ];
  if (id != null) {
    for (int i = 0; i < idList.length; i++) {
      if (idList[i] == id) {
        return nameList[i];
      }
    }
  }
}
