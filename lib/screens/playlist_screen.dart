import 'package:flutter/material.dart';
import '../models/playlist_model.dart';
import '../models/song_model.dart';
import 'player_screen.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';
import 'dart:math' as math;

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({super.key, required this.playlist});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  bool _isLiked = false;
  bool _isShuffled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 340.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.playlist.title, style: const TextStyle(fontWeight: FontWeight.bold)),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    widget.playlist.coverUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[900]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Theme.of(context).scaffoldBackgroundColor,
                        ],
                        stops: const [0.5, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border),
                color: _isLiked ? Theme.of(context).primaryColor : Colors.white,
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(_isLiked ? 'Added to your library' : 'Removed from library')),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Share option clicked')),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage('https://placehold.co/100x100/e50914/ffffff/png?text=W'),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Created by ${widget.playlist.creator}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${widget.playlist.followerCount} Followers • ${widget.playlist.songs.length} songs',
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (widget.playlist.songs.isNotEmpty) {
                              final provider = context.read<AudioProvider>();
                              if (provider.isShuffle) provider.toggleShuffle();
                              provider.setPlaylist(widget.playlist.songs, 0);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => PlayerScreen(song: widget.playlist.songs.first)),
                              );
                            }
                          },
                          icon: const Icon(Icons.play_arrow, size: 28),
                          label: const Text('Play', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                        Consumer<AudioProvider>(
                          builder: (context, audioProvider, child) {
                            final isShuffled = audioProvider.isShuffle;
                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isShuffled ? Theme.of(context).primaryColor : Colors.white30, 
                                  width: 2
                                ),
                                color: isShuffled ? Theme.of(context).primaryColor.withAlpha(50) : Colors.transparent,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  if (widget.playlist.songs.isNotEmpty) {
                                    if (!audioProvider.isShuffle) audioProvider.toggleShuffle();
                                    final randomStartIndex = math.Random().nextInt(widget.playlist.songs.length);
                                    audioProvider.setPlaylist(widget.playlist.songs, randomStartIndex);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Shuffle playback started')),
                                    );
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (_) => PlayerScreen(song: widget.playlist.songs[randomStartIndex])),
                                    );
                                  }
                                },
                                icon: Icon(Icons.shuffle, color: isShuffled ? Theme.of(context).primaryColor : Colors.white),
                                padding: const EdgeInsets.all(14),
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final song = widget.playlist.songs[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () {
                        context.read<AudioProvider>().setPlaylist(widget.playlist.songs, index);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => PlayerScreen(song: song)),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(color: Colors.grey[500], fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
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
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(song.artist, style: TextStyle(color: Colors.grey[400], fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.grey),
                              onPressed: () {
                                _showOptionsBottomSheet(context, song);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: widget.playlist.songs.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 48)),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context, Song song) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(song.coverUrl, width: 40, height: 40, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text(song.artist, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.playlist_add, color: Colors.white),
                title: const Text('Add to Playlist', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to playlist')));
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: const Text('Share', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.info_outline, color: Colors.white),
                title: const Text('Song Info', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    );
  }
}
