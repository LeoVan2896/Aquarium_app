# Aquarium

A Flutter app for cycling and maintaining freshwater tanks. Log water tests and maintenance, and the app works out where your tank is in the nitrogen cycle, predicts when it will finish and reminds you when to test.

Everything stays on the device. There's no account and no backend.

## Features

- **Multiple tanks:** size, substrate (including soil), water source, temperatures and cycle method.
- **Test kits set up from your bottle:** enter the step values printed on the strip's color chart, or read them from a photo with on-device OCR and confirm before saving.
- **Readings:** tap the matching step for each parameter (ammonia, nitrite, nitrate, pH, GH, KH, chlorine, temperature).
- **Events:** water changes, doses and ammonia doses, with quick picks for common products.
- **Cycle tracker:** shows the current stage, the reason it's in that stage and the next step. Stages run from not started through the ammonia phase, nitrite phase and dose test to cycled and ready to stock.
- **Predicted finish:** a date range with a confidence level and an explanation of how it was worked out.
- **Softened-water warning:** shown when GH is near 0 but KH is normal.
- **Trends:** one chart per parameter, with markers for water changes and doses.
- **Reminders:** a notification to test every N days at a set time, counted from your last reading.
- **History you can correct:** readings and events are never edited or deleted. A correction is a new entry that replaces the old one, so the full record stays intact.

## Stack

| Area | Choice |
|---|---|
| Framework | Flutter (Dart), Android and iOS |
| Storage | SQLite via [drift](https://drift.simonbinder.eu/) |
| State | [flutter_riverpod](https://riverpod.dev/) |
| Charts | [fl_chart](https://pub.dev/packages/fl_chart) |
| Notifications | flutter_local_notifications + timezone |
| OCR | google_mlkit_text_recognition + image_picker |

## Project layout

```
lib/
  domain/         Pure Dart rules: cycle engine, prediction, softened check, units, chart reader
  data/           drift database, Riverpod providers, row → domain mappers
  notifications/  Local reminder scheduling
  scanning/       Camera/gallery + ML Kit text recognition
  ui/             Screens, widgets and theme tokens
test/
  domain/         Unit tests for every domain rule
  data/           Database tests (append-only guards, corrections)
  ui/             Widget tests for each screen flow
docs/BUILD_BRIEF.md  Product spec and build order
```

Design notes:
- **Cycle stage is computed, not stored.** It's worked out from readings and events every time, much like computing a balance from posted entries instead of saving it.
- **Readings and events are append-only.** SQLite triggers block updates and deletes. Corrections point back at the original through `correctsId`.
- **Thresholds live in one config object** (`lib/domain/config.dart`). Values that no primary source has confirmed carry a note saying where they came from.

## Run it

Requires Flutter 3.47 or later.

```bash
flutter pub get
```

```bash
flutter run
```

Run the checks:

```bash
flutter analyze
```

```bash
flutter test
```

After changing a drift table, regenerate the code:

```bash
dart run build_runner build
```

## iPhone build (free Apple ID)

iOS builds run in the cloud on [Codemagic](https://codemagic.io), so no Mac is needed:

1. Add this repo in Codemagic and run the **iOS unsigned IPA for Sideloadly** workflow (see `codemagic.yaml`).
2. Download `aquarium.ipa` from the build's artifacts.
3. On Windows, install [Sideloadly](https://sideloadly.io) plus iTunes and iCloud from Apple's website (not the Microsoft Store versions).
4. Connect the iPhone and sideload the IPA with your Apple ID.
5. On the iPhone:
   - Settings › General › VPN & Device Management: trust the developer profile.
   - Settings › Privacy & Security: turn on Developer Mode.

A free Apple ID signature lasts 7 days. To keep the app working, re-run Sideloadly with the same IPA; your data is kept.
