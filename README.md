# Wynk Music Clone (Flutter Web)

![Flutter Version](https://img.shields.io/badge/Flutter-Web-blue.svg)
![Dart Version](https://img.shields.io/badge/Dart-3.0%2B-blue.svg)
![License](https://img.shields.io/badge/License-MIT-green.svg)

A premium, highly-interactive Flutter web application meticulously modeled after top-tier music streaming platforms. This project leverages custom design systems, seamless widget animations, and robust state management to deliver a production-ready music playback experience directly in the browser.

---

## 🌟 Key Features

### 🎧 Core Audio Engine
- **Robust Playback:** Full audio lifecycle management (Play, Pause, Resume, Stop, Seek) powered by the `audioplayers` package.
- **Queue Management:** Intelligent queue traversal supporting multiple playback modes:
  - Shuffle (Randomized queue traversal)
  - Repeat Off
  - Repeat All (Loops the playlist)
  - Repeat One (Loops the current track)
- **Persistent Global State:** The audio player persists across all screens, allowing users to browse while listening.

### 🎤 Dynamic Lyrics Synchronization
- **LRC Parsing Engine:** A custom-built `.lrc` file parser that reads timestamped lyric files and synchronizes them with the audio playback stream in real-time.
- **Auto-Scrolling UI:** The lyrics view automatically scrolls to keep the currently active line perfectly centered and highlighted.
- **Fault-Tolerant:** Safely handles malformed LRC tags, missing text, and empty carriage returns without crashing.

### 🎨 Responsive & Premium UI
- **Cross-Platform Readiness:** While optimized for Web (via constrained boxes and dynamic flex layouts), the UI scales perfectly down to mobile dimensions, preventing `RenderFlex` overflow errors.
- **Hero Animations:** Smooth, 60fps shared-element transitions (Hero) for album art when routing between the mini-player, playlists, and the main Player Screen.
- **Custom Design System:** Utilizes a dark-mode first aesthetic with subtle glassmorphic elements, modern typography, and vivid accent colors.

### ⌨️ Global Keyboard Shortcuts
- **Spacebar Play/Pause:** Built on top of Flutter's Focus Management system, users can tap the `Spacebar` to toggle audio playback at any time, anywhere in the app, without focus traversal crashes.

### 🔍 Search & Filtering
- **Local Search Delegate:** Instant, debounced searching through local track libraries by both Title and Artist, immediately pushing the user to the playback context.

---

## 🛠️ Technology Stack

| Technology / Package | Purpose |
|----------------------|---------|
| **Flutter (Web)** | Core UI Framework |
| **Dart** | Application Language |
| **`provider`** | Reactive State Management (AudioProvider) |
| **`audioplayers`** | Hardware-accelerated Audio playback engine |

---

## 📁 Project Structure

```text
lib/
│
├── main.dart                  # App entry point, Theme config, & Focus Root
├── models/
│   └── song_model.dart        # Data classes (Song, Playlist, LyricLine)
├── providers/
│   └── audio_provider.dart    # Centralized Audio State & Queue Management
├── screens/
│   ├── home_screen.dart       # Dashboard (Recent, Curated, Playlists)
│   ├── player_screen.dart     # Main Audio Interface & Lyrics Sync View
│   ├── playlist_screen.dart   # Detailed playlist view & track listing
│   └── my_music_screen.dart   # Library & User-saved tracks
└── utils/
    ├── dummy_data.dart        # Mock database of songs & playlists
    └── song_search_delegate.dart # Global search UI logic
```

---

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK:** Version `3.10.0` or higher.
- **Browser:** Google Chrome is heavily recommended for optimal Web Audio API performance.

### Installation & Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/flutter-music-clone.git
   cd flutter-music-clone
   ```

2. **Fetch Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Local Assets**
   Because this is a locally-hosted clone, you must ensure your audio files and lyrics exist:
   - Place all `.mp3` audio files in the `assets/` directory.
   - Place all `.lrc` lyric files in the `assets/lyrics/` directory.
   - *Ensure all paths strictly match the definitions in `lib/utils/dummy_data.dart`.*

4. **Run the Application**
   ```bash
   flutter run -d chrome
   ```

---

## 📝 LRC Formatting Guide

For the lyrics engine to function, your `.lrc` files must follow the standard LRC format. The custom parser explicitly looks for minutes, seconds, and milliseconds:

```lrc
[00:12.72]We were drinkin'
[00:13.92]
[00:14.62]We were drinkin' out the bottle
```
*Note: Empty lines (like `[00:13.92]`) are safely parsed as instrumental breaks.*

---

## 🐛 Known Issues (Flutter Web Specific)
- **Autoplay Policies:** Browsers may block audio autoplay until the user interacts with the DOM (clicking anywhere on the screen).
- **Focus Traversal:** Using `WidgetSpan` with `TextOverflow.ellipsis` alongside global `FocusNode` listeners can trigger Web rendering bugs. This project employs a specialized `Flexible` Row layout and targeted `Focus` wrappers to bypass this.

---

## 🤝 Contributing
Contributions, issues, and feature requests are welcome! Feel free to fork the repository and submit pull requests.
