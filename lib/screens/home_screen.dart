import 'package:flutter/material.dart';
import '../utils/dummy_data.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import 'player_screen.dart';
import 'playlist_screen.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import '../utils/song_search_delegate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playlists = DummyData.getPlaylists();
    final songs = DummyData.getSongs();

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage('https://placehold.co/100x100/3498db/ffffff/png?text=A'),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Flexible(
                        child: Text(
                          'Hello, Abdullah',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.verified, color: Colors.orange, size: 14),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.white24),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shield, color: Colors.green[400], size: 10),
                        const SizedBox(width: 4),
                        const Text('PREMIUM', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('English / हिंदी', style: TextStyle(fontSize: 10)),
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 24),
            onPressed: () {
              showSearch(context: context, delegate: SongSearchDelegate());
            },
          ),
          IconButton(icon: const Icon(Icons.notifications_none, size: 24), onPressed: () {}),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            
            // Airtel VIP Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.flash_on, color: Colors.red, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Airtel 5G VIP Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          Text('Lossless 320kbps Audio & Zero Ads', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check, color: Colors.orange, size: 12),
                          SizedBox(width: 4),
                          Text('Claimed', style: TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Recently Played
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recently Played',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      final recentPlaylist = Playlist(
                        id: 'recent',
                        title: 'Recently Played',
                        creator: 'You',
                        followerCount: 'Private',
                        coverUrl: 'https://placehold.co/400x400/34495e/ffffff/png?text=Recently+Played',
                        songs: songs.reversed.toList(),
                      );
                      Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: recentPlaylist)));
                    },
                    child: const Text('See all', style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            _buildRecentlyPlayedCarousel(context, songs),
            
            const SizedBox(height: 32),
            
            // Curated Regional Playlists
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Curated Regional Playlists', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Top picks based on your region', style: TextStyle(color: Colors.grey[400], fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildCuratedPlaylistsGrid(context, playlists),
            
            const SizedBox(height: 100), // Space for mini player
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayedCarousel(BuildContext context, List<Song> songs) {
    return SizedBox(
      height: 216,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            child: InkWell(
              onTap: () {
                context.read<AudioProvider>().setPlaylist(songs, index);
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          song.coverUrl,
                          width: 140,
                          height: 140,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 140,
                            height: 140,
                            color: Colors.grey[800],
                            child: const Icon(Icons.music_note, color: Colors.white54),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53935),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (song.isDownloaded)
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[400], size: 12),
                        const SizedBox(width: 4),
                        Text('Downloaded', style: TextStyle(color: Colors.green[400], fontSize: 10)),
                      ],
                    ),
                  const SizedBox(height: 4),
                  Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                  Text(song.artist, style: TextStyle(color: Colors.grey[400], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCuratedPlaylistsGrid(BuildContext context, List<Playlist> playlists) {
    int crossAxisCount = MediaQuery.of(context).size.width > 800 ? 4 : MediaQuery.of(context).size.width > 600 ? 3 : 2;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: 0.8,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: playlists.length > 4 ? 4 : playlists.length,
        itemBuilder: (context, index) {
          final playlist = playlists[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => PlaylistScreen(playlist: playlist)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          playlist.coverUrl,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.music_note, color: Colors.white54),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(150),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person, color: Colors.orange, size: 10),
                              const SizedBox(width: 4),
                              Text('${playlist.followerCount} Followers', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(150),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.play_arrow, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(playlist.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text('${playlist.songs.length} Tracks • Sacred', style: TextStyle(color: Colors.grey[400], fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        },
      ),
    );
  }
}
