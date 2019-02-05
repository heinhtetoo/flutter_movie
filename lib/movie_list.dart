import 'package:demo_api_calls/movie.dart';

class MovieList {
  final List<Movie> movieList;

  MovieList({this.movieList});

  factory MovieList.fromJson(List<dynamic> parsedJson) {
    List<Movie> movieList = new List<Movie>();
    movieList = parsedJson.map((i) => Movie.fromJson(i)).toList();
    return new MovieList(
      movieList: movieList,
    );
  }
}
