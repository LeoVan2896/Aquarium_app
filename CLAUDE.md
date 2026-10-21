# Aquarium App

Personal aquarium management app in Flutter (Android first, iPhone later). Owner: Huy — reviews and runs the code; Claude Code writes it.

Read `docs/BUILD_BRIEF.md` before working. It holds the locked decisions, data model, domain rules, screens and build order.

## Working rules

- Follow the build order in BUILD_BRIEF.md section 6, one step at a time. After each step: `flutter analyze`, `flutter test`, then stop and tell Huy what to run/check on the emulator before starting the next step.
- Domain rules live in `lib/domain/` as pure Dart (no Flutter imports) with unit tests.
- Readings and events are append-only: never UPDATE or DELETE those rows; corrections are new rows with `correctsId`.
- Thresholds go in one editable config object, never hard-coded in widgets.
- Never invent test-strip step values; Huy enters them from his bottle's color chart.
- Code style: no comments unless the WHY is non-obvious. Surgical changes only. No backwards-compat shims. Don't create planning/analysis docs unless asked.
- Explain decisions briefly with the WHY; Huy is using this project as a portfolio/interview story.
