import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../models/song_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/audio_provider.dart';

class PlayerScreen extends StatefulWidget {
  final Song song;

  const PlayerScreen({super.key, required this.song});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  String _audioQuality = 'HD 320k';
  bool _isLiked = true;
  bool _isKaraoke = false;
  bool _autoScroll = true;
  bool _isLyricsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
              alignment: Alignment.center,
              child: const Text('W', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
            const Text('Now Playing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.more_vert, color: Colors.white), onPressed: () {}),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 12,
              backgroundImage: NetworkImage('https://placehold.co/100x100/3498db/ffffff/png?text=A'),
            ),
          ),
        ],
      ),
      body: Consumer<AudioProvider>(
        builder: (context, audioProvider, child) {
          final song = audioProvider.currentSong ?? widget.song;
          final duration = audioProvider.totalDuration;
          final position = audioProvider.currentPosition;
          final isPlaying = audioProvider.isPlaying;
          final isShuffle = audioProvider.isShuffle;
          final repeatMode = audioProvider.repeatMode;
          
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.graphic_eq, color: Color(0xFFE53935), size: 16),
                              const SizedBox(width: 8),
                              Text('PLAYING FROM: ${song.album.toUpperCase()}', style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Hero(
                          tag: 'album_art_${song.id}',
                          child: Builder(
                            builder: (context) {
                              final size = MediaQuery.of(context).size;
                              double imageSize = math.min(size.width * 0.75, size.height * 0.4);
                              imageSize = math.min(imageSize, 400.0);
                              return Container(
                                width: imageSize,
                                height: imageSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withAlpha(150),
                                      blurRadius: 24,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 12),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.asset(
                                        song.coverUrl,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (song.lyrics != null) GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLyricsExpanded = !_isLyricsExpanded;
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.lyrics, color: Color(0xFFE53935), size: 14),
                                      const SizedBox(width: 6),
                                      const Text('LYRICS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                    ],
                                  ),
                                  Icon(
                                    _isLyricsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    color: Colors.white54,
                                    size: 20,
                                  ),
                                ],
                              ),
                              if (_isLyricsExpanded) ...[
                                const SizedBox(height: 12),
                                LyricsWidget(lyrics: song.lyrics!, position: position),
                              ],
                            ],
                          ),
                        ),
                      ),
                      if (song.lyrics != null) const SizedBox(height: 24),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(song.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                                const SizedBox(height: 4),
                                Text(song.artist, style: TextStyle(fontSize: 13, color: Colors.grey[400])),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(_isLiked ? Icons.favorite : Icons.favorite_border, color: _isLiked ? const Color(0xFFE53935) : Colors.white, size: 28),
                            onPressed: () => setState(() => _isLiked = !_isLiked),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 3.0,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                          activeTrackColor: const Color(0xFFE53935),
                          inactiveTrackColor: Colors.grey[800],
                          thumbColor: Colors.white,
                        ),
                        child: Slider(
                          value: position.inSeconds.toDouble().clamp(0.0, duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0),
                          min: 0,
                          max: duration.inSeconds > 0 ? duration.inSeconds.toDouble() : 1.0,
                          onChanged: (value) {
                            audioProvider.seek(Duration(seconds: value.toInt()));
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_formatDuration(position), style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                          Text(_formatDuration(duration), style: TextStyle(fontSize: 12, color: Colors.grey[400])),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.shuffle, color: isShuffle ? const Color(0xFFE53935) : Colors.white, size: 24),
                            onPressed: () => audioProvider.toggleShuffle(),
                          ),
                          IconButton(icon: const Icon(Icons.skip_previous, color: Colors.white, size: 36), onPressed: () => audioProvider.previous()),
                          InkWell(
                            onTap: () => audioProvider.togglePlayPause(),
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: const BoxDecoration(color: Color(0xFFE53935), shape: BoxShape.circle),
                              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                            ),
                          ),
                          IconButton(icon: const Icon(Icons.skip_next, color: Colors.white, size: 36), onPressed: () => audioProvider.next()),
                          IconButton(
                            icon: Icon(repeatMode == 2 ? Icons.repeat_one : Icons.repeat, color: repeatMode > 0 ? const Color(0xFFE53935) : Colors.white, size: 24),
                            onPressed: () => audioProvider.toggleRepeat(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDuration(Duration d) {
    String minutes = d.inMinutes.toString();
    String seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '0$minutes:$seconds';
  }
}

class LyricLine {
  final Duration time;
  final String text;
  LyricLine(this.time, this.text);
}

List<LyricLine> _parseLyrics(String lyrics) {
  final lines = lyrics.split('\n');
  final RegExp regex = RegExp(r'\[(\d+):(\d+\.\d+)\](.*)');
  List<LyricLine> result = [];
  for (var line in lines) {
    final match = regex.firstMatch(line);
    if (match != null) {
      final min = int.parse(match.group(1) ?? '0');
      final sec = double.parse(match.group(2) ?? '0');
      final text = (match.group(3) ?? '').trim();
      final duration = Duration(milliseconds: (min * 60 * 1000 + sec * 1000).toInt());
      result.add(LyricLine(duration, text));
    }
  }
  return result;
}

class LyricsWidget extends StatefulWidget {
  final String lyrics;
  final Duration position;

  const LyricsWidget({super.key, required this.lyrics, required this.position});

  @override
  State<LyricsWidget> createState() => _LyricsWidgetState();
}

class _LyricsWidgetState extends State<LyricsWidget> {
  List<LyricLine> _parsedLyrics = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadLyrics();
  }

  @override
  void didUpdateWidget(LyricsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lyrics != widget.lyrics) {
      _loadLyrics();
    }
    
    if (_parsedLyrics.isNotEmpty) {
      int activeIndex = -1;
      for (int i = 0; i < _parsedLyrics.length; i++) {
        if (widget.position >= _parsedLyrics[i].time) {
          activeIndex = i;
        } else {
          break;
        }
      }
      
      if (activeIndex >= 0) {
        double targetOffset = activeIndex * 34.0 - 60; 
        if (targetOffset < 0) targetOffset = 0;
        
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      }
    }
  }

  Future<void> _loadLyrics() async {
    if (widget.lyrics.endsWith('.lrc')) {
      setState(() => _isLoading = true);
      try {
        final content = await rootBundle.loadString(widget.lyrics);
        if (mounted) {
          setState(() {
            _parsedLyrics = _parseLyrics(content);
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) setState(() => _isLoading = false);
      }
    } else {
      if (mounted) {
        setState(() {
          _parsedLyrics = _parseLyrics(widget.lyrics);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox(
        height: 180, 
        child: Center(child: CircularProgressIndicator(color: Color(0xFFE53935))),
      );
    }

    if (_parsedLyrics.isEmpty) {
      return Text(widget.lyrics.endsWith('.lrc') ? 'Lyrics unavailable' : widget.lyrics, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold, height: 1.4));
    }

    int activeIndex = -1;
    for (int i = 0; i < _parsedLyrics.length; i++) {
      if (widget.position >= _parsedLyrics[i].time) {
        activeIndex = i;
      } else {
        break;
      }
    }

    return SizedBox(
      height: 180,
      child: ListView.builder(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        itemCount: _parsedLyrics.length,
        itemBuilder: (context, index) {
          final isActive = index == activeIndex;
          return AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.white38,
              fontSize: isActive ? 20 : 16,
              fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
              height: 1.5,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(_parsedLyrics[index].text),
            ),
          );
        },
      ),
    );
  }
}
