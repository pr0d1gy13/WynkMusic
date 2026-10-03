import 'package:flutter/material.dart';

import '../utils/dummy_data.dart';
import '../models/playlist_model.dart';
import 'playlist_screen.dart';

class MyMusicScreen extends StatefulWidget {
  const MyMusicScreen({super.key});

  @override
  State<MyMusicScreen> createState() => _MyMusicScreenState();
}

class _MyMusicScreenState extends State<MyMusicScreen> {
  late List<Playlist> playlists;

  @override
  void initState() {
    super.initState();
    playlists = DummyData.getPlaylists();
  }

  void _createNewPlaylist() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('New Playlist', style: TextStyle(color: Colors.white)),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Playlist name',
              hintStyle: TextStyle(color: Colors.white.withAlpha(100)),
              enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white30)),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    playlists.insert(
                      0,
                      Playlist(
                        id: 'new_${DateTime.now().millisecondsSinceEpoch}',
                        title: controller.text,
                        creator: 'You',
                        followerCount: '0',
                        coverUrl: 'https://placehold.co/400x400/2c3e50/ffffff/png?text=${controller.text.replaceAll(' ', '+')}',
                        songs: [],
                      ),
                    );
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Playlist "${controller.text}" created!')));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
              child: const Text('Create', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _openLikedSongs() {
    final likedPlaylist = Playlist(
      id: 'liked',
      title: 'Liked Songs',
      creator: 'You',
      followerCount: 'Private',
      coverUrl: 'https://placehold.co/400x400/e50914/ffffff/png?text=Liked+Songs',
      songs: DummyData.getSongs(), // Just passing all as a mock
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: likedPlaylist)));
  }

  void _openRecentlyPlayed() {
    final recentPlaylist = Playlist(
      id: 'recent',
      title: 'Recently Played',
      creator: 'You',
      followerCount: 'Private',
      coverUrl: 'https://placehold.co/400x400/34495e/ffffff/png?text=Recently+Played',
      songs: DummyData.getSongs().reversed.toList(),
    );
    Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: recentPlaylist)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Music', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 800 ? 4 : constraints.maxWidth > 600 ? 3 : 2;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildActionRow(context, Icons.favorite, 'Liked Songs', '${DummyData.getSongs().length} songs', _openLikedSongs),
                const SizedBox(height: 16),
                _buildActionRow(context, Icons.history, 'Recently Played', 'View history', _openRecentlyPlayed),
                const SizedBox(height: 40),
                const Text(
                  'Your Playlists',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: playlists.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildCreatePlaylistCard(context);
                    }
                    final playlist = playlists[index - 1];
                    return _buildPlaylistCard(context, playlist);
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionRow(BuildContext context, IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: Colors.black45,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withAlpha(20), width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Theme.of(context).primaryColor.withAlpha(50), Theme.of(context).primaryColor.withAlpha(10)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: Theme.of(context).primaryColor.withAlpha(100), width: 1),
                ),
                child: Icon(icon, color: Theme.of(context).primaryColor, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                    const SizedBox(height: 4),
                    Text(subtitle, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[600], size: 28),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCreatePlaylistCard(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _createNewPlaylist,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withAlpha(150),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withAlpha(30), width: 1.5, strokeAlign: BorderSide.strokeAlignOutside),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(20),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, size: 36, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text('Create Playlist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaylistCard(BuildContext context, Playlist playlist) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      shadowColor: Colors.black.withAlpha(100),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: playlist)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: Image.asset(
                  playlist.coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.music_note, size: 50, color: Colors.white54),
                  ),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.white.withAlpha(20))),
              ),
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(playlist.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text('${playlist.songs.length} songs', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
