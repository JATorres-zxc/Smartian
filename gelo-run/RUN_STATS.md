# Smartian Run Statistics

Detailed metrics extracted from every log captured via `scripts/gelo_run.sh`.
Use this alongside `RUN_SUMMARY.md` when you need coverage numbers or want to
compare fuzzing intensity across contracts.

| Contract | Started (PST) | Limit (s) | Total Exec | Edges | Instructions | Def-Use | Bugs |
|---|---|---|---|---|---|---|---|
| RE | 2025-11-16 10:44:43 PST | 60 | 232589 | 26 | 299 | 29 | Reentrancy (1) |
| AF | 2025-11-16 13:22:00 PST | 120 | 792924 | 19 | 144 | 2 | Assertion Failure (1) |
| AW | 2025-11-16 13:25:48 PST | 120 | 327370 | 51 | 533 | 28 | Assertion Failure (1), Arbitrary Write (1), Integer Bug (2) |
| BD_false | 2025-11-16 13:28:34 PST | 120 | 371029 | 93 | 1007 | 24 | None |
| BD_true1 | 2025-11-16 13:31:01 PST | 120 | 379348 | 74 | 829 | 30 | Block state Dependency (1) |
| BD_true2 | 2025-11-16 13:34:15 PST | 120 | 301693 | 109 | 1593 | 113 | Assertion Failure (1), Block state Dependency (1), Integer Bug (2) |
| CH_false | 2025-11-16 13:36:51 PST | 120 | 9268 | 40 | 469 | 12 | None |
| CH_true1 | 2025-11-16 13:39:09 PST | 120 | 12064 | 38 | 444 | 9 | Control Hijack (1) |
| CH_true2 | 2025-11-16 13:42:15 PST | 120 | 1171776 | 1 | 14 | 0 | None |
| constructor | 2025-11-16 13:44:46 PST | 120 | 115593 | 291 | 5046 | 11133 | Integer Bug (12) |
| FE | 2025-11-16 13:52:21 PST | 120 | 715449 | 29 | 470 | 10 | Assertion Failure (1) |
| IB | 2025-11-16 14:08:14 PST | 120 | 204892 | 92 | 1642 | 165 | Integer Bug (3) |
| ME_true | 2025-11-16 14:14:44 PST | 120 | 556161 | 36 | 455 | 4 | Ether Leak (1), Mishandled Exception (1) |
| motiv | 2025-11-16 14:17:15 PST | 120 | 708850 | 25 | 199 | 2 | Assertion Failure (1), Integer Bug (1) |
| MS_false | 2025-11-16 14:20:04 PST | 120 | 548025 | 27 | 326 | 0 | None |
| MS_true | 2025-11-16 14:22:44 PST | 120 | 683062 | 26 | 266 | 0 | Multiple Send (1) |
| SC | 2025-11-16 14:25:55 PST | 120 | 250376 | 109 | 1735 | 206 | Suicidal Contract (1) |
| TO | 2025-11-16 14:28:12 PST | 120 | 780778 | 11 | 161 | 0 | Transaction Origin Use (1) |

- **Total Exec** – number of transaction executions performed within the time
  limit.
- **Edges / Instructions / Def-Use** – coverage metrics reported by Smartian’s
  instrumentation.
- **Bugs** – bug detectors that fired (with counts). `None` means no oracle was
  triggered during that run.
