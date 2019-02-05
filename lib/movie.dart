class Movie {
  final bool adult, video;
  final int id, vote_count;
  final double popularity;
  final String backdrop_path,
      original_title,
      original_language,
      title,
      overview,
      poster_path,
      release_date;
  final List<int> genre_ids;
  final num vote_average;

  Movie({
    this.adult,
    this.video,
    this.id,
    this.vote_count,
    this.popularity,
    this.backdrop_path,
    this.original_title,
    this.original_language,
    this.title,
    this.overview,
    this.poster_path,
    this.release_date,
    this.genre_ids,
    this.vote_average,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    var list = json['genre_ids'] as List;
    List<int> genres;
    if (list != null) {
      genres = list.map((i) => (int.parse(i.toString()))).toList();
    }

    return Movie(
      adult: json['adult'],
      video: json['video'],
      id: json['id'],
      vote_count: json['vote_count'],
      popularity: json['popularity'],
      backdrop_path: json['backdrop_path'],
      original_title: json['original_title'],
      original_language: json['original_language'],
      title: json['title'],
      overview: json['overview'],
      poster_path: json['poster_path'],
      release_date: json['release_date'],
      genre_ids: genres,
      vote_average: json['vote_average'],
    );
  }
}
