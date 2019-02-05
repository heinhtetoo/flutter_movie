import 'dart:convert';

import 'package:demo_api_calls/api.dart';
import 'package:demo_api_calls/color.dart';
import 'package:demo_api_calls/const.dart';
import 'package:demo_api_calls/movie.dart';
import 'package:demo_api_calls/movie_detail_screen.dart';
import 'package:demo_api_calls/movie_list.dart';
import 'package:demo_api_calls/movie_list_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp(
      nowPlayingMovieList: fetchNowPlayingMovieList(),
      popularMovieList: fetchPopularMovieList(),
      upComingMovieList: fetchUpComingMovieList(),
      topRatedMovieList: fetchTopRatedMovieList(),
    ));

class MyApp extends StatelessWidget {
  final Future<List<Movie>> nowPlayingMovieList;
  final Future<List<Movie>> popularMovieList;
  final Future<List<Movie>> upComingMovieList;
  final Future<List<Movie>> topRatedMovieList;

  MyApp(
      {Key key,
      this.nowPlayingMovieList,
      this.popularMovieList,
      this.upComingMovieList,
      this.topRatedMovieList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: primaryColor,
    ));
    return MaterialApp(
      title: 'The Movie DB',
      theme: ThemeData(
        primaryColor: primaryColor,
        accentColor: accentColor,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('The Movie DB'),
        ),
        body: Container(
          child: _buildMovieList(),
          color: backgroundColor,
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Widget _buildMovieList() {
    return ListView.builder(
        itemCount: 4,
        itemBuilder: (BuildContext context, int parentIndex) {
          var headerList = [
            "Now Showing",
            "Popular Movies",
            "Up Coming Movies",
            "All Time Best"
          ];
          var movieList = [
            nowPlayingMovieList,
            popularMovieList,
            upComingMovieList,
            topRatedMovieList
          ];
          var heightList = [420.0, 200.0, 200.0, 280.0];
          return _buildContent(
              context, parentIndex, headerList, movieList, heightList);
        });
  }

  Widget _buildContent(BuildContext context, int parentIndex, var headerList,
      var dataList, var heightList) {
    return _buildHorizontalList(
        context: context,
        parentIndex: parentIndex,
        header: headerList[parentIndex],
        height: heightList[parentIndex],
        data: dataList[parentIndex]);
  }

  Widget _buildHorizontalList(
      {BuildContext context,
      int parentIndex,
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
                parentIndex != 0
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MovieListScreen(
                                        header: header,
                                      )));
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
                    : Text('')
              ],
            )),
        SizedBox(
          height: height,
          child: FutureBuilder(
              future: data,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      itemBuilder: (BuildContext context, int index) {
                        return _buildItem(
                          context: context,
                          index: index,
                          parentIndex: parentIndex,
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(accentColor),
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
      return GestureDetector(
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
          margin:
              EdgeInsets.fromLTRB(edgeSize, edgeSize, edgeSize, edgeSize / 2),
          child: parentIndex == 0
              ? ClipRRect(
                  borderRadius: new BorderRadius.circular(8.0),
                  child: Image.network(
                    imagePathw342 + snapshot.data[index].poster_path,
                    height: height,
                    width: width,
                    fit: BoxFit.cover,
                  ),
                )
              : Column(
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
                              color: greyColor),
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
}

Future<List<Movie>> fetchNowPlayingMovieList() async {
  final response = await http.get(baseUrl + nowPlayingMovieList + apiKey);

  if (response.statusCode == 200) {
    return MovieList.fromJson(json.decode(response.body)["results"]).movieList;
  } else {
    throw Exception('Failed to load movie');
  }
}

Future<List<Movie>> fetchPopularMovieList() async {
  final response = await http.get(baseUrl + popularMovieList + apiKey);

  if (response.statusCode == 200) {
    return MovieList.fromJson(json.decode(response.body)["results"]).movieList;
  } else {
    throw Exception('Failed to load movie');
  }
}

Future<List<Movie>> fetchUpComingMovieList() async {
  final response = await http.get(baseUrl + upComingMovieList + apiKey);

  if (response.statusCode == 200) {
    return MovieList.fromJson(json.decode(response.body)["results"]).movieList;
  } else {
    throw Exception('Failed to load movie');
  }
}

Future<List<Movie>> fetchTopRatedMovieList() async {
  final response = await http.get(baseUrl + topRatedMovieList + apiKey);

  if (response.statusCode == 200) {
    return MovieList.fromJson(json.decode(response.body)["results"]).movieList;
  } else {
    throw Exception('Failed to load movie');
  }
}
