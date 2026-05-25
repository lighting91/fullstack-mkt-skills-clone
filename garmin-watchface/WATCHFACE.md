# Stealth Wealth — Garmin Forerunner 965 Watch Face

> Theme: **Luxury Minimal** — looks like a high-end accessory, not a sports tracker.

---

## Visual Reference

```
┌────────────────────────────────────────┐  454 × 454 px AMOLED
│                                        │
│              MON  25                   │  ← Gold Dim  #8A7035  FONT_TINY
│              ───────                   │  ← Divider   #1E1508  1px line
│                                        │
│              21:45                     │  ← Gold      #C9A84C  FONT_NUMBER_MILD
│                                        │
│                                        │
│       4,231            87%             │  ← Gold Dim  #8A7035  FONT_SMALL
│                                        │
└────────────────────────────────────────┘
  Background: pure black #000000
```

---

## Color Palette

| Token         | Hex       | RGB              | Role                          |
|---------------|-----------|------------------|-------------------------------|
| `COLOR_BG`    | `#000000` | 0, 0, 0          | AMOLED background (pixels off)|
| `COLOR_GOLD`  | `#C9A84C` | 201, 168, 76     | Time — warm metallic gold     |
| `COLOR_GOLD_DIM` | `#8A7035` | 138, 112, 53  | Date, steps, battery — 65% gold |
| `COLOR_DIVIDER` | `#1E1508` | 30, 21, 8    | Accent line — near-invisible  |

**Why this gold?** `#C9A84C` is warm (skews amber, not lemon), slightly desaturated —
reads as "aged gold" rather than cheap yellow. Against AMOLED black it creates
the contrast of a luxury watch dial without being harsh.

---

## Layout

| Field    | Position            | Font                 | Color      |
|----------|---------------------|----------------------|------------|
| Date     | Top center, y=84    | `FONT_TINY`          | Gold Dim   |
| Divider  | y=100, cx±36        | 1px line             | Gold Trace |
| Time     | Center, y=210       | `FONT_NUMBER_MILD`   | Gold       |
| Steps    | Bottom-left, y=374  | `FONT_SMALL`         | Gold Dim   |
| Battery  | Bottom-right, y=374 | `FONT_SMALL`         | Gold Dim   |

- **24-hour format** — cleaner, removes the AM/PM clutter
- **No seconds** — prevents the nervous tick; seconds undermine luxury calm
- **Max 4 fields** — empty space is intentional; luxury is about restraint
- **Thousands separator** in steps (4,231 not 4231) — subtle quality signal

---

## Typography

System fonts are used for maximum compatibility. For a truly thin typeface,
replace with a custom font (see `resources/drawables/drawables.xml`):

```xml
<font id="TimeFont"  filename="../fonts/GeistThin-Numbers.fnt" antialias="true"/>
<font id="LabelFont" filename="../fonts/GeistThin.fnt"         antialias="true"/>
```

Suggested thin fonts (convert to `.fnt` with the Connect IQ SDK font tool):
- **Geist Thin** (Vercel) — geometric, clean
- **DM Sans ExtraLight** — modern sans
- **Inter Thin** — screen-optimized, excellent legibility

---

## Sleep / Always-On Mode

When the wrist drops, the watch enters sleep mode automatically:
- Time only — all other fields hidden
- Gold brightness drops to **~30%** (`#3C3015`) — respects AMOLED power budget
- No second hand, no animation

---

## Build Instructions

### Requirements
- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) 4.2+
- Device: `fr965`

### Compile
```bash
cd garmin-watchface/
connectiq build monkey.jungle --device fr965 --output bin/stealth-wealth.prg
```

### Simulate
```bash
connectiqsim --prg bin/stealth-wealth.prg --device fr965
```

### Sideload to watch
```bash
connectiq deploy bin/stealth-wealth.prg --device fr965
```

> **App ID:** The UUID in `manifest.xml` is a placeholder. Register your own at
> [developer.garmin.com](https://developer.garmin.com) before publishing to
> the Connect IQ Store.

---

## Design Rationale

| Decision | Reason |
|----------|--------|
| AMOLED pure black | Pixels are literally off — zero power, infinite contrast |
| No red/green/blue accents | Avoid the sports-gadget palette; gold reads as premium |
| No seconds | Reduces update frequency; calmer, more confident |
| No icons | Icons feel UI-kit; raw numbers feel confident |
| Thin divider line | Breaks the screen into zones without visual noise |
| Sleep at 30% brightness | OLED power + eye comfort; still glanceable |
| Thousands separator in steps | Small detail that signals craft |

---

## File Structure

```
garmin-watchface/
├── manifest.xml                    ← App metadata, device targets
├── monkey.jungle                   ← Build configuration
├── WATCHFACE.md                    ← This file
├── source/
│   ├── StealthWealthApp.mc         ← App entry point
│   └── StealthWealthView.mc        ← All rendering logic
└── resources/
    ├── strings/strings.xml         ← App name string
    └── drawables/drawables.xml     ← Custom font hook (commented)
```
