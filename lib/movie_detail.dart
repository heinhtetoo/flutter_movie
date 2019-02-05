import 'package:demo_api_calls/genre.dart';

class MovieDetail {
  final int id, runtime;
  final double popularity;
  final String backdrop_path,
      status,
      title,
      overview,
      poster_path,
      release_date,
      tagline;
  final List<Genre> genres;

  MovieDetail(
      {this.backdrop_path,
      this.genres,
      this.id,
      this.overview,
      this.popularity,
      this.poster_path,
      this.release_date,
      this.runtime,
      this.status,
      this.tagline,
      this.title});

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    var list = json['genres'] as List;
    List<Genre> genres;
    if (list != null) {
      print(list.runtimeType);
      genres = list.map((i) => Genre.fromJson(i)).toList();
    }

    return MovieDetail(
      backdrop_path: json['backdrop_path'],
      genres: genres,
      id: json['id'],
      overview: json['overview'],
      popularity: json['popularity'],
      poster_path: json['poster_path'],
      release_date: json['release_date'],
      runtime: json['runtime'],
      status: json['status'],
      tagline: json['tagline'],
      title: json['title'],
    );
  }
}
