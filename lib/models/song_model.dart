class Song {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String releaseYear;
  final String coverUrl;
  final Duration duration;
  final bool isHighDefinition;
  final bool isDownloaded;
  final String? assetPath;
  final String? lyrics;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.releaseYear,
    required this.coverUrl,
    required this.duration,
    this.isHighDefinition = false,
    this.isDownloaded = false,
    this.assetPath,
    this.lyrics,
  });
}
