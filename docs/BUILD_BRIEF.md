# Aquarium App — Build Brief (Function 1)

Paste this into Claude Code at the root of an empty folder (e.g. `C:\dev\aquarium_app`). Save it in the repo as `docs/BUILD_BRIEF.md` and add a line to `CLAUDE.md`: "Read docs/BUILD_BRIEF.md before working."

## 0. Machine setup (one time, Windows)

1. Install Android Studio → SDK Manager: Android SDK, Platform-Tools, Command-line Tools. Create a Pixel emulator (API 34+).
2. Install Flutter SDK (stable) and add `flutter\bin` to PATH.
3. `flutter doctor --android-licenses` then `flutter doctor` — fix until Android toolchain is green. Ignore the Xcode line (iPhone builds come later via a cloud Mac such as Codemagic).
4. Claude Code: verify with `flutter --version` before scaffolding.

## 1. Locked decisions

| Area | Decision |
|---|---|
| Framework | Flutter (Dart), Android first, iPhone later via cloud Mac build |
| Storage | On-device SQLite via **drift** (+ `drift_flutter`), no account, no backend in v1 |
| State | **flutter_riverpod** |
| Charts | **fl_chart** |
| Notifications | **flutter_local_notifications** (+ `timezone`) |
| Build mode | Claude Code writes code; Huy reviews and runs |
| Code style | No comments unless the WHY is non-obvious. Surgical changes. No compat shims. |

## 2. Scope of Function 1

Tank profiles + test-kit setup + water readings log + events log + cycle tracker with predicted finish + softened-water warning + test reminders. Multiple tanks.

Out of scope now: species, compatibility, photo ID, plants, layout, cost, species-based safety alerts (come with livestock later).

## 3. Data model (drift tables)

Readings and events are **append-only**: never update or delete a row; a correction is a new row pointing at the one it replaces (`correctsId`). UI shows the latest non-superseded value.

- **tanks**: id, name, volumeGal, substrateType (text), hasSoil (bool), waterSource (enum: tap, softened, neighbor, filtered, other), heaterWatts?, lightWatts?, lightHoursPerDay?, roomTempF?, targetTempF?, cycleStartedAt?, cycleMethod (enum: fishless, fishIn), stockedAt?, archived (bool), createdAt
- **testKits**: id, name, brand?, createdAt
- **kitParameters**: id, kitId, parameter (enum: ammonia, nitrite, nitrate, ph, gh, kh, chlorine, temperature), inputMode (enum: steps, free), stepsJson (list of doubles, only for steps), unit (text: ppm, dGH, dKH, pH, F)
- **readings**: id, tankId, kitId?, parameter, value (double), unit, takenAt, enteredAt, correctsId?, note?
- **events**: id, tankId, type (enum: waterChange, dose, ammoniaDose, other), product?, amount?, amountUnit?, percentChanged?, occurredAt, enteredAt, correctsId?, note?
- **reminders**: id, tankId, everyNDays, timeOfDay (HH:mm), enabled, lastFiredAt?

Cycle stage is **derived** from readings + events every time, not stored (single source of truth, like computing a balance from posted entries instead of storing it).

Seed data: one tank "20 gal planted" (hasSoil = true, waterSource = filtered, roomTempF = 74), and two kit templates: "Ammonia strip" and "8-in-1 strip". **Do not invent strip step values** — leave steps empty and prompt Huy on first use to enter the steps printed on his bottle's color chart.

## 4. Domain rules (pure Dart, no Flutter imports, fully unit-tested)

Put these in `lib/domain/`. Thresholds live in one config object so they can be edited later.

### 4.1 Unit conversion
- GH/KH: 1 dGH = 17.86 ppm (mg/L CaCO3). Store as entered; convert to ppm for logic.

### 4.2 Cycle stage engine
Inputs: tank (hasSoil, cycleStartedAt, cycleMethod), readings, events. Output: stage + reason text + next step text.

Stages, in order:
1. **notStarted** — no cycleStartedAt.
2. **ammoniaPhase** — ammonia > 0 and nitrite has never been > 0.
3. **nitritePhase** — nitrite has been > 0 at least once, and latest ammonia or nitrite > 0.
4. **doseTest** — after nitrite was seen, latest ammonia = 0 and nitrite = 0. Next step: "Dose ammonia to 2 ppm, test again in 24 h." The user logs an `ammoniaDose` event.
5. **cycled** — `passesRequired` (default 2) consecutive dose tests where ammonia = 0 and nitrite = 0 on a reading 18–30 h after an `ammoniaDose` event.
6. **readyToStock** — cycled, and latest nitrate < 20 ppm (prompt: large water change to get there).

Soil rule: if hasSoil and fewer than 28 days since cycleStartedAt, never report cycled; show "Soil tanks often leach ammonia early — keep testing" instead of advancing past doseTest.

fishIn method (SafeStart with fish): skip doseTest; show ammonia/nitrite warnings for any reading > 0 and "feed lightly" guidance for 14 days.

### 4.3 Predicted finish
- Fewer than 5 readings since cycleStartedAt → show the typical range only: 4–8 weeks from start (6–8 for soil). Label "low confidence".
- 5+ readings → fit a linear trend on the last 7 days of the parameter currently falling (ammonia in ammoniaPhase, nitrite in nitritePhase), project when it reaches 0, add the typical remaining-stage time, and return a date range (not a single date). Clamp to the typical range ±2 weeks.
- Always return `{earliest, latest, confidence, basis}` so the UI can explain itself.

### 4.4 Softened-water check
Warn when latest GH ≤ 2 dGH (≈ 36 ppm) **and** latest KH ≥ 3 dKH (≈ 54 ppm), within the same 48 h window. Message: "GH near 0 with normal KH usually means softened water. Softener swaps calcium/magnesium for sodium — use your unsoftened source for water changes." Thresholds are editable config.

### 4.5 Unverified values
These came from research but were not confirmed by a primary source. Keep them in config with a `source` note: soil 28-day minimum, passesRequired = 2, the 18–30 h dose window, GH/KH softened thresholds.

## 5. Screens

1. **Tanks list** — cards with name, volume, current cycle stage chip. Add / archive tank.
2. **Tank dashboard** — cycle stage card (stage, reason, next step, predicted finish range + confidence), softened-water banner if triggered, latest value per parameter, chart.
3. **Chart** — one line per parameter (toggle chips), x = date; vertical markers for events (water change, dose, ammonia dose).
4. **Add reading** — pick kit → for each kit parameter: tappable step buttons (steps mode) or number field (free mode). Defaults takenAt = now, editable. One save writes one row per parameter.
5. **Log event** — type, product (quick picks: Prime, SafeStart, root tabs, ammonia), amount, % changed.
6. **History** — chronological readings + events; "Correct" creates a new row with correctsId.
7. **Kit setup** — create kit, add parameters, enter steps from the bottle chart.
8. **Reminder settings** — per tank: every N days at HH:mm, on/off.

## 6. Build order (one PR-sized step at a time; run the app after each)

1. Scaffold project, add packages, drift DB + migrations, seed data. Verify app launches on emulator.
2. Domain layer + unit tests (conversion, cycle engine, prediction, softened check). `flutter test` must pass.
3. Tanks list + tank form.
4. Kit setup screen.
5. Add reading + history (with corrections).
6. Log event.
7. Dashboard: cycle card + softened banner + latest values.
8. Chart with event markers.
9. Reminders with local notifications (request Android 13+ notification permission).

## 7. Done when

- All domain unit tests pass, including: soil tank under 28 days never shows cycled; two passing dose tests → cycled; one failing test resets the streak; softened check fires on GH 0 / KH 6 dKH and not on GH 8 / KH 6.
- Huy can enter his real readings since Oct 18 and see the right stage and a predicted range.
- A test reminder notification fires on the emulator.
