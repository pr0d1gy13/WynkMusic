import 'package:flutter/material.dart';
import '../utils/dummy_data.dart';
import '../models/song_model.dart';
import 'player_screen.dart';
import '../utils/song_search_delegate.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  bool _offlineMode = true;

  @override
  Widget build(BuildContext context) {
    // In Figma, all songs seem to be downloaded. I'll just get all songs.
    final downloadedSongs = DummyData.getSongs();
    
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Downloads', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SongSearchDelegate());
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage('https://placehold.co/100x100/3498db/ffffff/png?text=A'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Offline Mode Toggle
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withAlpha(20),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cloud_off, color: Color(0xFFE53935), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text('Offline Mode ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withAlpha(30),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('ACTIVE', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text('Only play saved audio without data', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                      ],
                    ),
                  ),
                  Switch(
                    value: _offlineMode,
                    onChanged: (val) => setState(() => _offlineMode = val),
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFFE53935),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Device Storage
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.pie_chart_outline, color: Colors.orange, size: 18),
                    SizedBox(width: 8),
                    Text('Device Storage', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.cleaning_services_outlined, color: Color(0xFFE53935), size: 16),
                  label: const Text('Clear Cache', style: TextStyle(color: Color(0xFFE53935), fontSize: 12, fontWeight: FontWeight.bold)),
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 3.4 / 64.0,
                backgroundColor: Colors.white12,
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE53935)),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(radius: 3, backgroundColor: Color(0xFFE53935)),
                    const SizedBox(width: 6),
                    Text('3.4 GB • ${downloadedSongs.length} Tracks', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
                  ],
                ),
                Text('36.0 GB Free of 64 GB', style: TextStyle(color: Colors.grey[400], fontSize: 11)),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterPill('All (${downloadedSongs.length})', true),
                  const SizedBox(width: 8),
                  _buildFilterPill('Playlists (1)', false),
                  const SizedBox(width: 8),
                  _buildFilterPill('Albums (1)', false),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Sort
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('Recently Downloaded', style: TextStyle(color: Colors.grey[300], fontSize: 12)),
                const SizedBox(width: 4),
                Icon(Icons.keyboard_arrow_down, color: Colors.grey[300], size: 16),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Songs List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: downloadedSongs.length,
              itemBuilder: (context, index) {
                final song = downloadedSongs[index];
                return InkWell(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PlayerScreen(song: song))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.asset(
                            song.coverUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
                              const SizedBox(height: 4),
                              Text('${song.artist} • ${song.duration.inMinutes}:${(song.duration.inSeconds % 60).toString().padLeft(2, '0')}', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('HD 320k', style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 12),
                        const Icon(Icons.check_circle, color: Colors.green, size: 16),
                        const SizedBox(width: 16),
                        const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 100), // padding for mini player
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPill(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withAlpha(20) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isSelected ? Colors.white : Colors.white24),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
