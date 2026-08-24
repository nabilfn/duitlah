# Contributing

## Before committing

Frontend (`apps/web`):

```bash
npm run format:check   # npm run format to fix
npm run lint
npm run typecheck
npm test
npm run build
```

Backend (`apps/api`):

```bash
./mvnw verify   # runs spotless:check, compiles, and runs tests (incl. Testcontainers)
```

Run `./mvnw spotless:apply` to auto-format Java code before committing.

## Commit style

Small, focused commits. Every significant feature should include: the
data model change (migration), the API contract, validation, tests, and
a documentation update if behavior visible outside the code changed.

## Financial code specifically

- Never introduce a `float`/`double` for money — `BigDecimal` in Java,
  `NUMERIC`/`DECIMAL` in Postgres, always.
- Any change to the Bagilah calculation engine (once it exists, from
  Phase 6) must keep `SUM(participant amounts) == bill.finalTotal` exact,
  and should come with a test covering the specific scenario being fixed
  or added — see [bagilah-engine.md](bagilah-engine.md).
- Correctness and security take priority over speed for anything touching
  money.
