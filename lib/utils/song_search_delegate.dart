import 'package:flutter/material.dart';
import '../models/song_model.dart';
import '../utils/dummy_data.dart';
import '../screens/player_screen.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';

class SongSearchDelegate extends SearchDelegate<Song?> {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        hintStyle: TextStyle(color: Colors.white54),
        border: InputBorder.none,
      ),
      textTheme: theme.textTheme.copyWith(
        titleLarge: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    final allSongs = DummyData.getSongs();
    final searchTerm = query.trim().toLowerCase();

    if (searchTerm.isEmpty) {
      return Container(
        color: const Color(0xFF0C0C0C),
        child: const Center(
          child: Text(
            'Search for songs or artists...',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
      );
    }

    final results = allSongs.where((song) {
      final titleMatch = song.title.toLowerCase().contains(searchTerm);
      final artistMatch = song.artist.toLowerCase().contains(searchTerm);
      return titleMatch || artistMatch;
    }).toList();

    if (results.isEmpty) {
      return Container(
        color: const Color(0xFF0C0C0C),
        child: const Center(
          child: Text(
            'No songs found.',
            style: TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ),
      );
    }

    return Material(
      color: const Color(0xFF0C0C0C),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final song = results[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                song.coverUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[800],
                  child: const Icon(Icons.music_note, color: Colors.white54),
                ),
              ),
            ),
            title: Text(song.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(song.artist, style: TextStyle(color: Colors.grey[400])),
            onTap: () {
              // Find the index of this song in the original list for queueing
              final originalIndex = allSongs.indexWhere((s) => s.id == song.id);
              if (originalIndex != -1) {
                context.read<AudioProvider>().setPlaylist(allSongs, originalIndex);
              }
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PlayerScreen(song: song)),
              );
            },
          );
        },
      ),
    );
  }
}
