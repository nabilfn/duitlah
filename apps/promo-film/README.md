# Duitlah product film

30-second launch film, 9:16 (1080×1920) and a recomposed 16:9 (1920×1080), 30 fps.
Remotion + React, with React Three Fiber for the device.

## How it is built

- **Device**: procedural Three.js model (`src/three/PhoneModel.tsx`): extruded titanium frame with
  bevels, glass front/back, side buttons, antenna breaks, camera plateau, speaker slit. Lit by a
  custom studio environment (one large soft key, cool edge strips) instead of a stock HDRI.
- **App UI**: DOM, not screenshots. The Flutter app cannot be mounted in Remotion, so its screens
  are recreated in React from the Flutter source (`apps/mobile/lib`): colours, glass tokens, type
  scale, spacing, radii, icon glyphs, entry timeline and copy are ported one to one (see `src/theme.ts`,
  `src/ui/*`). The UI renders at 3× and is mapped onto the device screen with a homography computed
  from the same camera as the 3D scene (`src/camera.ts`), so it stays crisp at any angle.
- **Timeline**: `src/timeline.ts` holds every beat in seconds; camera poses per layout in `src/camera.ts`.
  Everything is frame-driven and deterministic (no `Date.now`, no `Math.random`).
- **Audio**: `scripts/make_audio.py` synthesises the score (108 BPM), sound design and a guide VO,
  and masters to −14 LUFS (BS.1770 meter included). Seeded, so identical every run.

## Commands

```sh
npm install
npm run audio            # regenerate public/audio/*
npm run studio           # preview
npm run stills           # one still per scene, both layouts → out/stills
python3 scripts/contact_sheet.py both out/Duitlah_Promo_Storyboard.png
npm run draft            # half-resolution drafts
npm run master           # final masters (only after approval)
```

Audio variants are chosen with the `audio` prop: `vo` (recorded narration), `guide-vo` (scratch TTS
narration, for timing review only), `no-vo` (music + SFX) or `none`.

## Feature validation (what the film is allowed to claim)

| Feature | Status | In film |
| --- | --- | --- |
| Entry / `d.` signal animation | Implemented | 0:01 wake (returning-session path, played at 2× duration) |
| Home financial canvas, balance, income ratio | Implemented | 0:03 |
| Transactions list, date groups, row expansion | Implemented | 0:07 |
| Bagilah bills, participants, itemised split, spatial participant nodes | Implemented | 0:11 |
| Analytics: "You kept", spending donut, segment selection | Implemented | 0:16 |
| Assistant (Claude-backed, read-only finance tools) | Implemented | 0:20, uses the app's own suggested question |
| Budgets, Goals, Accounts, Business space, Monthly Wrapped | Implemented | 0:23 montage |
| Auto-categorisation | Implemented in backend rules, **not shown on rows** | not claimed |
| Splitting directly from a transaction | **Not implemented** (Bagilah bills are created separately) | the row → bill move is a visual bridge only; no tap-to-split is shown |
| Duitlah+ checkout | Coming soon in app | not shown |
| App Store / Google Play availability | No evidence in repo | no store badges or availability claim |

All figures are fictional and reconcile: the bill (RM 186.40) splits 52.30 + 41.90 + 45.10 + 47.10;
August spending (RM 3,420.75) is the sum of the six categories; income 6,200.00 − 3,420.75 = 2,779.25 kept.

## Before the master render

- **Narration (ElevenLabs)**: the guide VO is macOS TTS, for pacing only. To record the real read:
  ```sh
  export ELEVENLABS_API_KEY=...     # never commit this
  export ELEVENLABS_VOICE_ID=...
  npm run vo          # records each line in scripts/vo_lines.json → public/audio/vo/<id>.wav
  npm run vo:apply    # remixes and swaps the narrated audio onto out/ masters (no video re-render)
  ```
  Fix a mispronunciation by editing that line's `tts` field, then `python3 scripts/elevenlabs_vo.py --force <id>`.
  The script prints a timing check; a line that overruns its slot needs a faster `ELEVENLABS_SPEED`
  or a later `start`. Music-only masters are kept as `out/*_noVO.mp4`.
- **Narration from one recording**: `out/Duitlah_VO.mp3` is cut into phrases listed in
  `scripts/vo_lines.json` (`source` = where the phrase is in the recording, `start` = where it plays
  in the film). Re-time or re-cut there, then `npm run vo:cut` and swap the audio onto a master
  (see `scripts/apply-vo.sh`). Four phrases that only repeat on-screen text are left out on purpose.
- **CTA**: none by default, because store availability can't be verified from the repo.
