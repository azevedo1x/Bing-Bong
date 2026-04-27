<p align="center">
  <img src="assets/readme/200px-Bing_Bong.png" alt="Bing Bong" width="180"/>
</p>

<h1 align="center">Bing Bong</h1>

<p align="center">
  <em>Squeeze the plushie. Get the wisdom. Carry it to the top.</em>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.41.6-02569B?logo=flutter" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.11.4-0175C2?logo=dart" alt="Dart"/>
  <img src="https://img.shields.io/badge/Platform-Android-3DDC84?logo=android" alt="Android"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License"/>
</p>

---

A **Magic 8-Ball** style app inspired by the beloved green plushie from [**PEAK**](https://store.steampowered.com/app/3527290/PEAK/), the co-op climbing game by [Aggro Crab](https://aggrocrab.com/) & [Landfall](https://landfall.se/peak).

Tap Bing Bong, hear a random voice line, and let the oracle of BingBong Airways guide your life decisions. Just like in the game, except you don't have to carry him up an entire mountain.

<p align="center">
  <img src="assets/readme/Steam_Wallpaper_09_-_Bing_Bong.jpg" alt="Bing Bong in PEAK" width="600"/>
  <br/>
  <sub>Bing Bong on the island, from the <a href="https://peak.wiki.gg/wiki/Bing_Bong">PEAK Wiki</a></sub>
</p>

## Who is Bing Bong?

In **PEAK**, Bing Bong is the stuffed plushie mascot of **BingBong Airlines**, the airline that crashes you onto a mysterious island. You can find him at the crash site on the Shore and squeeze him to hear a random voice line: a positive, negative, uncertain, or hilariously irrelevant response to whatever question you had in mind.

He weighs 5 points in your inventory. He gives you nothing useful. Players carry him to the summit anyway.

> *"Do not cast Bing Bong aside, it will remember."*

For a brief time after PEAK's launch, the developers at Aggro Crab could actually **possess Bing Bong** and talk to players through him in real-time, jump-scaring climbers across the island. That feature was removed, but the legend remains.

<p align="center">
  <img src="assets/readme/Bing_Bong_Airlines.png" alt="BingBong Airlines" width="280"/>
  <br/>
  <sub>BingBong Airlines, the worst airline, the best mascot</sub>
</p>

## Features

- **26 authentic voice lines**: all the classic Bing Bong responses, from *"yeah definitely"* to *"im not comfortable answering that"*
- **Shuffle-bag randomization**: every voice line plays before any repeats, never the same line twice in a row
- **Premium gamified physics**: squash & stretch on tap (non-uniform scale), rotational wobble, spring-elastic button press
- **Shockwave ripple emit**: tapping Bing Bong sends an expanding ring outward — emitted from the character on every voice line trigger
- **Dual-tone breathing halo**: warm yellow + lime green aura that pulses (blur + spread oscillating) while speaking
- **"I'm Bing Bong" button**: dedicated button to hear his iconic catchphrase anytime
- **Live quote display**: Bing Bong's response fades and slides in centered on screen as he speaks
- **Atmospheric stage lighting**: blurred island backdrop + radial vignette + warm spotlight that intensifies on talk + drifting coral/cyan light leaks
- **Typographic contrast**: Daruma Drop One reserved for the character's voice (quote, "tap me", his name); clean system sans for UI chrome
- **About sheet**: glass bottom sheet with app info and a coral-glow link to the developer's GitHub
- **Idle float + breathing**: Bing Bong gently hovers and breathes (asymmetric scale) waiting to be consulted
- **Immersive fullscreen**: no distractions, just you and the oracle

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.41.6 / Dart 3.11.4 |
| State Management | flutter_riverpod (StateNotifier) |
| Audio | audioplayers 6.x (local asset playback) |
| Links | url_launcher (external GitHub link) |
| Typography | Daruma Drop One (character voice) + system sans (UI chrome) |
| Visual Language | Premium Gamified UI + Playful Glassmorphism |
| Architecture | Feature-based Clean Architecture |

## Architecture

```
lib/
├── main.dart                                  # Portrait lock + immersive mode
├── app/
│   ├── app.dart                               # ProviderScope + MaterialApp
│   └── app_theme.dart                         # M3 dark theme + kCharacterFont token
├── core/
│   ├── constants/
│   │   └── audio_constants.dart               # 26 voice line paths
│   ├── theme/
│   │   └── peak_colors.dart                   # Peak palette + glow tones + soft text shadow
│   └── widgets/
│       ├── glass_panel.dart                   # Frosted glass primitive (BackdropFilter + sheen)
│       └── spring_pressable.dart              # Reusable spring-press gesture wrapper
├── features/
│   ├── character/
│   │   ├── logic/
│   │   │   ├── character_state.dart           # { isTalking, quote }
│   │   │   └── character_notifier.dart        # Audio ↔ UI state bridge
│   │   └── presentation/
│   │       ├── character_page.dart            # Main screen composition
│   │       └── widgets/
│   │           ├── about_sheet.dart           # Glass bottom sheet + GitHub link
│   │           ├── ambient_glow.dart          # Breathing dual-tone halo (warm + cool)
│   │           ├── background.dart            # Blurred bg + vignette + spotlight + light leaks
│   │           ├── bing_bong_widget.dart      # Squash & stretch + wobble + ripple emit
│   │           ├── glass_icon_button.dart     # Reusable glass tile w/ spring press
│   │           ├── glass_quote_card.dart      # Glassmorphism quote card
│   │           ├── im_bing_bong_button.dart   # Specialized GlassIconButton (catchphrase)
│   │           ├── pulsing_tap_me.dart        # Pulsing idle prompt
│   │           └── shockwave.dart             # Expanding ring CustomPaint + controller
│   └── splash/
│       └── presentation/
│           └── splash_page.dart               # Vignette-framed opening screen
└── services/
    ├── audio_service.dart                     # AudioPlayer wrapper
    └── audio_randomizer.dart                  # Shuffle-bag algorithm
```

**Data flow:** Tap → `BingBongWidget` triggers `ShockwaveController.pulse()` (visual) and `CharacterNotifier.onTap()` (state) → `AudioService.playNext()` → `AudioRandomizer.next()` → plays mp3 + extracts quote from filename → state goes to `talking` → UI fades/slides the quote text in, `AmbientGlow` ramps up via `_activeAnim`, `Background` opens vignette and lifts warm spotlight → `onPlayerComplete` → state returns to `idle` and the halo fades out. The "i'm bing bong" button follows the same flow via `playSpecific()`, bypassing the randomizer.

**Design system:** generic UI primitives live in `core/widgets/` (currently `GlassPanel`, `SpringPressable`). Feature-specific composition (animated character, halo, ripple, quote card) lives under `features/character/presentation/widgets/`. Color and typography tokens live in `core/theme/` and `app/app_theme.dart` (`kCharacterFont`).

## Getting Started

```bash
# Clone
git clone https://github.com/azevedo1x/bingbong.git
cd bingbong

# Install dependencies
flutter pub get

# Run on connected device
flutter run

# Build release APK
flutter build apk
```

## Voice Lines

Voice line .mp3 files are not included in this repository. To run the app locally, place 26 .mp3 files in `assets/audio/`. Filenames become the displayed quote text; underscores in filenames are rendered as apostrophes
(e.g. `It_s a beautiful day.mp3` → `It's a beautiful day`).

## About PEAK

<p align="center">
  <a href="https://store.steampowered.com/app/3527290/PEAK/">
  </a>
</p>

**PEAK** is a co-op climbing game where the slightest mistake can spell your doom. Solo or as a group of up to four lost nature scouts, your only hope of rescue from a mysterious island is to scale the mountain at its center. The terrain changes every 24 hours. Over **11 million copies sold** on Steam with **Overwhelmingly Positive** reviews (95%).

Developed by **Team PEAK**, a collaboration between [Aggro Crab](https://aggrocrab.com/) (*Another Crab's Treasure*) and [Landfall](https://landfall.se/) (*Content Warning*).

---

<p align="center">
  <sub>This is a fan project. Bing Bong, PEAK, and all related assets belong to Aggro Crab and Landfall Games.</sub>
  <br/>
  <sub>Made with Flutter and an unreasonable attachment to a green plushie.</sub>
</p>
