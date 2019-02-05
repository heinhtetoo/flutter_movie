import 'dart:convert';

import 'package:demo_api_calls/api.dart';
import 'package:demo_api_calls/color.dart';
import 'package:demo_api_calls/const.dart';
import 'package:demo_api_calls/genre.dart';
import 'package:demo_api_calls/movie.dart';
import 'package:demo_api_calls/movie_detail.dart';
import 'package:demo_api_calls/movie_list.dart';
import 'package:demo_api_calls/movie_list_screen.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

class MovieDetailScreen extends StatelessWidget {
  final int id;
  final String title;

  MovieDetailScreen({Key key, @required this.id, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Container(
        color: backgroundColor,
        child: Center(
            child: FutureBuilder(
                future: fetchMovieById(id),
                builder: (BuildContext context,
                    AsyncSnapshot<MovieDetail> snapshot) {
                  MovieDetail movie = snapshot.data;
                  if (snapshot.hasData) {
                    Future<List<Movie>> similarMovieList =
                        fetchSimilarMovieList(snapshot.data.id);
                    return ListView(
                      children: <Widget>[
                        _buildHeader(
                            snapshot.data.backdrop_path, snapshot.data.title),
                        _buildDescription(movie.status, movie.runtime,
                            movie.genres, movie.release_date, movie.overview),
                        _buildSimilarList(
                            context: context,
                            header: "Similar Movie",
                            height: 240.0,
                            data: similarMovieList),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(accentColor),
                          ),
                        ),
                        color: Colors.transparent);
                  }
                })),
      ),
    );
  }

  Widget _buildHeader(String backdropPath, String title) {
    return Container(
        child: Image.network(
      imagePathw500 + backdropPath,
      fit: BoxFit.scaleDown,
    ));
  }

  Widget _buildDescription(String status, int runtime, List<Genre> genreList,
      String releaseDate, String overview) {
    int hour, min = 0;
    if (runtime != null) {
      hour = (runtime / 60).round();
      min = runtime % 60;
    }
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(edgeSize, edgeSize, edgeSize, edgeSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: edgeSize),
                child: Text(
                  'Status',
                  style: TextStyle(
                    color: accentColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: edgeSize),
                child: Text(
                  status != null ? status : 'Unknown',
                  style: TextStyle(
                    color: greyColor2,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: edgeSize),
                child: Text(
                  'Time',
                  style: TextStyle(
                    color: accentColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: edgeSize),
                child: Text(
                  runtime != null ? '$hour h $min m' : 'Unknown',
                  style: TextStyle(
                    color: greyColor2,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.right,
                  softWrap: true,
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(edgeSize, edgeSize, edgeSize, edgeSize),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: edgeSize),
                child: Text(
                  'Genre',
                  style: TextStyle(
                    color: accentColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(right: edgeSize),
                child: Text(
                  genreList != null
                      ? genreList.length > 1
                          ? genreList[0].name + '/' + genreList[1].name
                          : genreList[0].name
                      : 'Unknown',
                  style: TextStyle(
                    color: greyColor2,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: edgeSize),
                child: Text(
                  'Year',
                  style: TextStyle(
                    color: accentColor,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.left,
                  softWrap: true,
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.only(left: edgeSize),
                child: Text(
                  releaseDate.substring(0, 4),
                  style: TextStyle(
                    color: greyColor2,
                    fontStyle: FontStyle.normal,
                    fontSize: 12.0,
                  ),
                  textAlign: TextAlign.right,
                  softWrap: true,
                  maxLines: 30,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(edgeSize, edgeSize, edgeSize, edgeSize),
          alignment: Alignment.centerLeft,
          child: Text(
            overview,
            style: TextStyle(
              color: greyColor2,
              fontStyle: FontStyle.normal,
              fontSize: 12.0,
            ),
            textAlign: TextAlign.justify,
            softWrap: true,
            maxLines: 30,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}

Widget _buildSimilarList(
    {BuildContext context,
    String header,
    double height,
    Future<List<Movie>> data}) {
  return Column(
    children: <Widget>[
      Container(
          padding:
              EdgeInsets.fromLTRB(edgeSize, edgeSize, edgeSize, edgeSize / 2),
          color: Colors.transparent,
          alignment: Alignment.centerLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                header,
                style: TextStyle(
                  color: greyColor2,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.left,
                softWrap: true,
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MovieListScreen(header: header)));
                  },
                  child: Text(
                    'View all',
                    style: TextStyle(
                      color: accentColor,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0,
                    ),
                    textAlign: TextAlign.right,
                    softWrap: true,
                    maxLines: 1,
                    overflow: TextOverflow.fade,
                  ))
            ],
          )),
      SizedBox(
        height: height,
        child: FutureBuilder(
            future: data,
            builder: (BuildContext context,
                AsyncSnapshot<List<Movie>> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildItem(
                        context: context,
                        index: index,
                        snapshot: snapshot,
                        parentSize: height,
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
      )
    ],
  );
}

Widget _buildItem(
    {BuildContext context,
    int index,
    int parentIndex,
    AsyncSnapshot<List<Movie>> snapshot,
    double parentSize}) {
  double height = (parentSize - edgeSize - edgeSize);
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
        margin: EdgeInsets.fromLTRB(edgeSize, edgeSize, edgeSize, edgeSize / 2),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: new BorderRadius.circular(8.0),
              child: Image.network(
                imagePathw342 + snapshot.data[index].poster_path,
                height: height * 0.9,
                width: width,
                fit: BoxFit.cover,
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: edgeSize / 4),
                alignment: Alignment.center,
                height: height * 0.1,
                width: width,
                child: Text(
                  snapshot.data[index].title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.0,
                      color: greyColor2),
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.fade,
                )),
          ],
        ),
      ),
    );
  } else {
    return new Container();
  }
}

Future<MovieDetail> fetchMovieById(int id) async {
  final response = await http.get(baseUrl + findMovie + id.toString() + apiKey);

  if (response.statusCode == 200) {
    return MovieDetail.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load movie');
  }
}

Future<List<Movie>> fetchSimilarMovieList(int id) async {
  final response = await http
      .get(baseUrl + findMovie + id.toString() + similarMovies + apiKey);

  if (response.statusCode == 200) {
    return MovieList.fromJson(json.decode(response.body)["results"]).movieList;
  } else {
    throw Exception('Failed to load movie');
  }
}
