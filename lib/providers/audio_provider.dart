import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/song_model.dart';
import '../utils/dummy_data.dart';

class AudioProvider with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _currentPlaylist = [];
  int _currentIndex = -1;

  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  bool _isShuffle = false;
  int _repeatMode = 0; // 0 = off, 1 = all, 2 = one

  List<int> _shuffledIndices = [];
  int _shuffleIndex = -1;

  AudioProvider() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentPosition = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (_repeatMode != 2) {
        next();
      }
    });
  }

  bool get isPlaying => _isPlaying;
  Duration get currentPosition => _currentPosition;
  Duration get totalDuration => _totalDuration;
  Song? get currentSong => _currentIndex >= 0 && _currentIndex < _currentPlaylist.length ? _currentPlaylist[_currentIndex] : null;
  bool get isShuffle => _isShuffle;
  int get repeatMode => _repeatMode;
  List<Song> get currentPlaylist => _currentPlaylist;

  void setPlaylist(List<Song> playlist, int startIndex) {
    _currentPlaylist = playlist;
    _currentIndex = startIndex;
    _generateShuffleIndices();
    if (_isShuffle) {
      _shuffleIndex = _shuffledIndices.indexOf(startIndex);
    }
    _playCurrentSong();
  }

  void _generateShuffleIndices() {
    _shuffledIndices = List.generate(_currentPlaylist.length, (index) => index);
    if (_currentPlaylist.length > 1) {
      _shuffledIndices.shuffle(Random());
    }
  }

  void toggleShuffle() {
    _isShuffle = !_isShuffle;
    if (_isShuffle) {
      _generateShuffleIndices();
      // Ensure current song is the first in shuffle queue or find its new index
      _shuffleIndex = _shuffledIndices.indexOf(_currentIndex);
    }
    notifyListeners();
  }

  void toggleRepeat() {
    _repeatMode = _repeatMode == 0 ? 2 : 0;
    if (_repeatMode == 2) {
      _audioPlayer.setReleaseMode(ReleaseMode.loop);
    } else {
      _audioPlayer.setReleaseMode(ReleaseMode.stop);
    }
    notifyListeners();
  }

  Future<void> _playCurrentSong() async {
    if (currentSong?.assetPath != null) {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(currentSong!.assetPath!.replaceFirst('assets/', '')));
    }
  }

  Future<void> play() async {
    await _audioPlayer.resume();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await play();
    }
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> next() async {
    if (_currentPlaylist.isEmpty) return;

    if (_isShuffle) {
      _shuffleIndex++;
      if (_shuffleIndex >= _shuffledIndices.length) {
        if (_repeatMode == 0) {
          _shuffleIndex = 0; // stop or loop back? lets loop for now
          return; // or stop
        }
        _shuffleIndex = 0;
      }
      _currentIndex = _shuffledIndices[_shuffleIndex];
    } else {
      _currentIndex++;
      if (_currentIndex >= _currentPlaylist.length) {
        if (_repeatMode == 0) {
          _currentIndex = 0;
          await _audioPlayer.stop();
          return;
        }
        _currentIndex = 0;
      }
    }
    _playCurrentSong();
  }

  Future<void> previous() async {
    if (_currentPlaylist.isEmpty) return;

    if (_currentPosition.inSeconds > 3) {
      await seek(Duration.zero);
      return;
    }

    if (_isShuffle) {
      _shuffleIndex--;
      if (_shuffleIndex < 0) {
        _shuffleIndex = _shuffledIndices.length - 1;
      }
      _currentIndex = _shuffledIndices[_shuffleIndex];
    } else {
      _currentIndex--;
      if (_currentIndex < 0) {
        _currentIndex = _currentPlaylist.length - 1;
      }
    }
    _playCurrentSong();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
