# Deployment

## Local development

```bash
cp .env.example .env
docker compose up -d
```

This starts four services:

| Service  | URL                                | Notes |
|----------|-------------------------------------|-------|
| postgres | localhost:5432                      | data persisted in the `duitlah_postgres_data` volume |
| redis    | localhost:6380 → container port 6379 | host port remapped to avoid local port conflicts |
| api      | http://localhost:8080                | Spring Boot, health at `/actuator/health` |
| web      | http://localhost:3001 → container port 3000 | Next.js dev server, hot reload via bind mount |

Adjust the host-side port mappings in `docker-compose.yml` if `8080` is
also free to reclaim `3000`/`6379` for local convenience — they were
remapped here only because other local services already held them.

To stop: `docker compose down`. Data survives in the named volume; add
`-v` to also wipe the database.

## Building without Docker

Frontend:

```bash
cd apps/web
npm install
npm run dev     # or: npm run build && npm start
```

Backend requires JDK 17+. If none is installed, either install one or run
everything through `docker compose` instead:

```bash
cd apps/api
./mvnw spring-boot:run
```

## Mobile app (Phase 9.5)

`apps/mobile` is a Flutter project targeting iOS and Android. It talks to
whatever `apps/api` instance `API_BASE_URL` points at — bring up the
backend (`docker compose up -d`, or `./mvnw spring-boot:run`) first.

```bash
cd apps/mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # generates *.freezed.dart / *.g.dart
flutter run                                                # pick a simulator/emulator/device
```

- **iOS simulator**: `API_BASE_URL` defaults to `http://localhost:8080`,
  which reaches a docker-compose `api` container exposed on the host —
  no extra config needed.
- **Android emulator**: `localhost` inside the emulator is the emulator
  itself, not the host machine, so the default falls back to
  `http://10.0.2.2:8080` (the documented host-loopback alias) instead —
  see `core/config/env.dart`. A physical device on the same network needs
  `flutter run --dart-define=API_BASE_URL=http://<host-lan-ip>:8080`.
- **Android SDK licenses**: `flutter doctor --android-licenses` must be
  accepted interactively at least once per machine before an Android
  build will succeed; this is a one-time local machine step, not part of
  the repo.
- **Web companion origin**: `--dart-define=WEB_BASE_URL=...` controls
  what URL the QR-invite screen renders/shares (defaults to
  `http://localhost:3000`, matching `apps/web`'s dev port) — see
  `core/config/env.dart`.

Checks before considering a mobile change done:

```bash
flutter analyze
flutter test
flutter build apk           # or: flutter build ios --no-codesign (needs a real Team ID to codesign)
```

Universal/app-link verification for the Bagilah invite URL (Apple's App
Site Association file at the web origin, Android's `assetlinks.json`)
needs a real registered domain and signing Team ID/package fingerprint —
not available in local dev, so the manifest/entitlement scaffolding is in
place (`android/app/src/main/AndroidManifest.xml`'s intent-filter,
`ios/Runner/Info.plist`'s usage descriptions) but unverified; until a real
domain is deployed, opening the link always falls back to a normal
browser tab (which still serves the guest flow correctly via `apps/web`).

**`mobile_scanner` (QR scanning) doesn't run on Apple-Silicon iOS
simulators.** Its Google MLKit pods don't ship an arm64 simulator slice, so
`flutter build ios --simulator`/`flutter run` on an M-series Mac succeed
but the QR scan screen will fail at runtime in the simulator specifically
— this is an upstream MLKit/CocoaPods constraint, not a bug in this app.
QR scanning needs a real iOS device, an Intel simulator, or an Android
emulator/device to actually exercise.

## Production (future)

Per the product plan, production does **not** reuse `apps/web/Dockerfile`
(that image is dev-only, running `next dev`):

- **Frontend** → Vercel.
- **Backend** → a container host with persistent processes (Railway,
  Render, or AWS/similar) — Vercel cannot host a long-running Spring Boot
  process. `apps/api/Dockerfile`'s multi-stage build produces the
  production image.
- **Database** → managed PostgreSQL.
- **Redis** → managed Redis.
- **Object storage** → S3-compatible, for receipt images and exports.

None of this is wired up yet — Phase 0 only establishes local dev.

## Backup, restore, and performance gates

Create a portable backup with `./scripts/postgres-backup.sh
/secure/path/duitlah.dump`. Verify it with
`./scripts/postgres-restore-smoke-test.sh /secure/path/duitlah.dump`; the
check never overwrites the source database. Run
`./scripts/performance-smoke.sh` against a healthy API to enforce the default
750 ms dashboard p95 over 25 authenticated requests. Production operators
must also encrypt backups, store them outside the primary failure domain,
define retention, and schedule restore drills.
