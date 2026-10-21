# Aquarium App — Build Brief (Function 2: Fish & Plant Recommendations)

Read `docs/BUILD_BRIEF.md` first: its locked decisions, code style and append-only rules still apply. Open questions in section 8 are answered from `docs/Beginner intermediate fish and plants.md` ("the research") and accepted by Huy.

## 0. Prerequisites

Function 1 is done (steps 1–10). No new machine setup or packages are needed.

## 1. Locked decisions

| Area | Decision |
|---|---|
| Species data | A curated catalog bundled with the app as JSON assets, which works offline. Seeded from the research tables |
| Data entry | **Never invent species values.** Each value carries the source it came from. "not found" stays empty and is never guessed |
| Source priority | Fish: Seriously Fish first, Aquarium Co-Op second. Shrimp: ShrimpKeepers. Plants: Tropica for light, CO₂, growth and height; Flowgrow or Aquasabi for temperature and pH |
| Disagreements | When sources disagree, store both values. Neither is averaged or picked silently |
| Recommendations | Explainable checks (pass / caution / fail / unknown, each with a reason), not a hidden score. Species are matched to the tank, not sorted by beginner or intermediate tier |
| Stock history | Append-only, like readings |
| Rules | Pure Dart in `lib/domain/`. Thresholds go in `DomainConfig` as `Sourced` values |

## 2. Scope of Function 2

- **Species catalog:** fish, shrimp, snails and plants, about 38 animals and 36 plants from the research. It also includes a separate **avoid list**, plus terrestrial plants that are sold as aquatic.
- **Fit check for one tank:** checks each species against the tank's size, water readings, temperature, setup and maturity.
- **Compatibility check:** a candidate against current stock (temperament, predation, fin nipping, temperature range overlap), and fish against plants.
- **Recommendations list:** "What fits this tank", filterable.
- **Stock log:** fish and plants added and removed.
- **Species alert:** a dashboard alert when a reading falls outside the range of a species in the tank.
- **Stocking gate:** discourage adding fish before `readyToStock`, plus a stricter "mature tank" flag for sensitive species.
- **Re-test prompt:** aquasoil buffering lasts 12–18 months, so prompt a fresh pH/GH/KH test when the latest one is old.

Out of scope for now: photo ID of species, layout, cost, breeding, disease, online sync, and stocking capacity (see 4.6).

## 3. Data model

### 3.1 Bundled catalog (`assets/species/*.json`, read-only, versioned)

Every numeric range is stored as `{optimal?: {min, max}, tolerated?: {min, max}, source}`. Optimal and tolerated are separate because shrimp sources give both a comfortable range and a survivable one. A value with no source is left out entirely.

**animals**

| Group | Fields |
|---|---|
| Identity | id, commonName, scientificName, kind (fish, shrimp or snail), tier (beginner, easyIntermediate or intermediate) |
| Water | tempF, ph, gh, kh (ranges as above; KH will mostly be blank for fish) |
| Size and space | adultSizeIn; minTank as `{gallons?, footprintCm?, source}`, because Seriously Fish gives base footprints, not gallons |
| Group | minGroupSize?, groupNote? |
| Behavior | temperament, swimLevel?, finNipper?, longFinned?, eatsPlants?, digs?, eatsShrimp?, eatsSmallFish? |
| Care flags | needsMatureTank, needsLiveFood, needsSand, stockQualityWarning, intermediateReason? |
| Source and notes | notes?, sources[] |

**plants**

| Group | Fields |
|---|---|
| Identity | id, commonName, scientificName, tier |
| Water | tempF, ph, kh |
| Growing needs | light (low, medium or high, stored once per source), co2 (notNeeded, helps or required, stored once per source), growthRate, placement[], epiphyte, rootFeeder? |
| Height | one field per meaning: heightAfter2MonthsCm (Tropica), careHeightCm (Aquasabi), maxHeightCm |
| Source and notes | notes?, sources[] |

**avoid** (scientificName, commonNames[], reason, source): oversized fish, plus terrestrial plants sold as aquatic. Match on scientific name, because trade names like "Brazilian sword" are misleading.

Booleans the sources don't state stay `null` and show as unknown. The research found that swim level and plant-eating are mostly unstated.

### 3.2 New drift tables (schema v2 migration)

- **stockEntries:** id, tankId, speciesId, speciesType, change (int), occurredAt, enteredAt, correctsId?, note?. Append-only triggers.
- **tanks additions:**
  - lightLevel? (low, medium or high)
  - hasCo2 (bool, default false)
  - footprintLengthIn? and footprintWidthIn?, because "20 gal" could be a 20 high or a 20 long, and several fits hinge on base length

## 4. Domain rules (pure Dart, fully unit-tested)

### 4.1 Tank conditions
- **Temperature:** the latest temperature reading, or else `targetTempF`, or else `roomTempF`. Each value is labeled with where it came from.
- **pH, GH and KH:** the latest effective reading within `conditionsMaxAgeDays` (default **30**). An older reading counts as missing.
- **Maturity:** depends on how fast the tank cycled, so there's no fixed day count:
  - **cycleDays:** days from `cycleStartedAt` to the first time the tank reached `readyToStock`.
  - **Established:** the tank has stayed cycled for at least `maturityFactor` × cycleDays. A tank that cycled in 4 weeks is established 4 weeks later, and one that took 8 weeks needs 8 more.
  - **Unknown:** maturity is unknown when there's no `cycleStartedAt` or the tank has never reached `readyToStock`.

### 4.2 Fit checks
- **Water ranges:**
  - **pass:** inside the optimal range (or inside tolerated when no optimal range is given)
  - **caution:** inside tolerated but outside optimal, or within `rangeMargin` of the edge
  - **fail:** outside both
  - **unknown:** no reading or no range
- **Tank size:**
  - **When the source gives a footprint:** compare it to the tank's footprint. If the tank's footprint isn't entered, the result is unknown and the reason asks for dimensions.
  - **Otherwise:** compare gallons to the species' minimum.
- **Group size:** caution when the planned count plus current stock is below `minGroupSize`.
- **Maturity:** a species with `needsMatureTank` gets caution until the tank is established (4.1). The reason shows the date it will be.
- **Substrate:** a species with `needsSand` gets caution unless the substrate is sand.
- **Plants only:**
  - **Light:** check the tank's light level against the plant's light rating. Use the lowest rating among sources for pass and the highest for caution, and say which source said which.
  - **CO₂:** `required` without CO₂ fails; `helps` without CO₂ is caution.
  - **Root feeder:** caution without soil or logged root tabs.

### 4.3 Compatibility checks (a candidate against current stock)
- **Temperature overlap:** fail if the optimal ranges don't overlap at all (for example a German blue ram at 81–86°F with crystal red shrimp at 68–75°F).
- **Temperament:** aggressive with peaceful fails; semiAggressive with peaceful is caution.
- **Predation:**
  - Fail when one species `eatsSmallFish` and the other is at or below `predationSizeRatio` × its size.
  - `eatsShrimp` with any shrimp in the tank is caution.
- **Fin nipping:** a finNipper with longFinned fish fails.
- **Fish and plants:** `eatsPlants` or `digs` with planted stock is caution.
- **Shrimp families:** Caridina with Neocaridina fails, because their water needs are incompatible.

### 4.4 Stocking gate
- **Before `readyToStock` (fishless method):** adding fish shows "Your tank hasn't finished cycling" plus the predicted range. Plants are never gated.
- **After `readyToStock`:** species with `needsMatureTank` still carry the maturity caution from 4.2.
- **Suggested first fish** come from the research's order:
  1. hardy schoolers
  2. corys and a bristlenose
  3. mature-tank species

### 4.5 Recommendations
- **Ranking:** fewest fails first, then cautions, then unknowns.
- **Filters:**
  - kind
  - tier
  - placement or swim level
  - only those that pass everything
- **Tank-specific notes:** each fish result names the readings that would change its verdict. For example, cherry shrimp turn from unknown to pass once a GH reading of 6 or more is logged.

### 4.6 Stocking capacity
Out of scope. The research found no sourced bioload method. Show the total adult size of current stock for information only.

### 4.7 Species alert
When a new effective reading falls outside the tolerated range of any stocked species, show a dashboard banner. A reading outside optimal but inside tolerated shows a caution chip only.

### 4.8 Re-test prompt
If the latest pH, GH or KH reading is older than `conditionsMaxAgeDays`, the Stock section shows "Test pH, GH and KH to update fit checks".

### 4.9 Config (`Sourced` values)
| Value | Default | Source |
|---|---|---|
| `conditionsMaxAgeDays` | 30 | Huy accepted |
| `rangeMargin` | 0 | strict until Huy picks a margin |
| `predationSizeRatio` | — | placeholder; no source found |
| `maturityFactor` | 1.0 | Placeholder. Huy's rule is that maturity depends on cycle speed, but the factor is unverified; the research only says "many months" (ACO). Editable later |
| Temperament matrix | as in 4.3 | placeholder |

## 5. Screens

1. **Species browser:**
   - Fish / Plants tabs, search and a tier filter
   - a "Fits {tank}" toggle
   - an "Avoid" section at the bottom
2. **Species detail:**
   - ranges, with both values shown where sources disagree
   - flags and source links
   - every check with its reason, when opened from a tank
3. **Tank dashboard additions:**
   - a Stock section and an "Add fish / plants" button
   - the species alert banner
   - the re-test prompt
4. **Add stock:** pick a species and a count, then run the fit and compatibility checks before saving. The stocking gate and maturity caution apply.
5. **Stock history:** inside the existing History section, with corrections.
6. **Tank form additions:** light level, CO₂, and footprint length × width.

## 6. Build order (continues from Function 1; run the app after each)

11. Catalog JSON schema, loader and validator. The validator rejects:
    - entries with no source
    - ranges where min is above max
    - duplicate scientific names

    Ship it with test fixtures only.
12. Domain: tank conditions, fit checks and compatibility checks, with unit tests.
13. Schema v2 migration: `stockEntries` and the new tank fields. Include migration tests.
14. Species browser and detail (read-only).
15. Add stock flow and the Stock section, with the stocking gate.
16. Recommendations, the species alert and the re-test prompt.
17. Seed the catalog from the research tables. This step is data only; Huy reviews each entry.

## 7. Done when

All of these pass using clearly labeled fixture species:
- **Water ranges:**
  - inside optimal passes
  - inside tolerated but outside optimal is caution
  - outside both fails
  - no reading gives unknown
- **Reading age:** a pH reading older than `conditionsMaxAgeDays` counts as missing.
- **Footprint:** a species with a 100×30 cm footprint fails on a tank entered as 24×12 in. With no tank footprint entered, the result is unknown.
- **Temperature overlap:** two species whose optimal temperatures don't overlap fail compatibility.
- **Shrimp families:** Caridina with Neocaridina fails.
- **Stocking gate:** a fishless tank in `nitritePhase` shows the gate for fish but not for plants.
- **Maturity:** a tank that cycled in 28 days is established 28 days after `readyToStock`; one that cycled in 56 days isn't. A tank that never reached `readyToStock` gives unknown.
- **Stock and corrections:** stock math works through add, remove and correction rows; the append-only triggers block UPDATE and DELETE.
- **Species alert:** a reading outside a stocked species' tolerated range shows the banner.

Then, on the device:
- Huy's 20 gal shows the research's verdicts. For example, harlequin and ember show "Good", the White Cloud minnow fails on temperature, and guppies show unknown or fail on pH depending on his test.

## 8. Open questions, answered from the research

1. **Data source → bundled catalog.** The research produced about 74 sourced entries. That is small enough to ship as JSON, and no good free plant API exists.
2. **Who fills it → seeded from the research tables, Huy reviews each entry**. Every row in the research already has a source link, so step 17 is transcription plus review, not new research. Trusted sources follow the priority in section 1.
3. **Shrimp and snails → yes.** The research covers cherry, amano and crystal red shrimp and nerite and mystery snails. Their mineral and pH needs are what make them good or bad fits for an aquasoil tank, so the app should check them.
4. **Stocking capacity → skip.** No source in the research gives a bioload method, and the fit checks already cover tank size and group size.
5. **Light level → add a low/medium/high field.** Sources rate plants by category, and Tropica's "medium" is 0.5 W/L, which doesn't map cleanly to LED watts. **CO₂ → none for now**. The research treats your tank as low-tech, and its non-CO₂ plant picks assume that. Also add **footprint length × width**, because several verdicts hinge on 20 high vs 20 long.
6. **Freshness window → 30 days**. The research gives no number. It recommends a single test after cycling, then periodic re-tests as the aquasoil's 12–18-month buffering fades, so 14 days was stricter than needed.
7. **Temperament → simple matrix plus specific flags.** The research's real conflicts are specific behaviors: gouramis eat pygmy corys, sparkling gouramis eat shrimp, pea puffers nip long fins, and Caridina can't live with Neocaridina. Those become the `eatsShrimp`, `eatsSmallFish` and `finNipper` flags and the shrimp-family rule, without per-species "don't keep with" lists.
8. **Starting list → the research's "Good" fits for your tank, in its stocking order:**
   - **Fish:**
     - **First:** harlequin rasbora, ember tetra, cherry barb
     - **Then:** panda cory, pygmy cory, bristlenose pleco, honey gourami
     - **Mature tank only:** chili rasbora, dwarf pencilfish, spotted blue-eye, threadfin rainbow, scarlet badis, sparkling gourami, Apistogramma cacatuoides pair, otocinclus
   - **Pending your pH, GH and KH test:** cherry shrimp, celestial pearl danio, crystal red shrimp
   - **Plants:** Anubias nana, Java fern, Java moss, Crypt wendtii, dwarf sagittaria, Amazon frogbit, Ludwigia repens, Marsilea minuta, Ludwigia 'Super Red', Myriophyllum mattogrossense, Cryptocoryne parva, Hydrocotyle tripartita
   - **Avoid list:** common pleco, iridescent shark, clown loach, bala shark, goldfish, angelfish (for a 20 gal), plus the terrestrial plants from the research
   - **Not seeded until verified:** Hygrophila polysperma (its US legal status is unconfirmed)

### Still needs Huy
- Measure the tank's footprint, and test pH, GH and KH once the cycle finishes.
