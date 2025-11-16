# Smartian Run Summary

All commands were executed via `scripts/gelo_run.sh`, so each log in this
directory has matching timestamps. The table below consolidates the essentials
for every contract fuzzed: when it started (local time), duration limit, total
executions, and which bug detectors fired (if any).

| Contract | Started (PST) | Limit (s) | Total Exec | Bugs Detected |
|---|---|---|---|---|
| RE | 2025-11-16 10:44:43 PST | 60 | 232589 | Reentrancy (1) |
| AF | 2025-11-16 13:22:00 PST | 120 | 792924 | Assertion Failure (1) |
| AW | 2025-11-16 13:25:48 PST | 120 | 327370 | Assertion Failure (1), Arbitrary Write (1), Integer Bug (2) |
| BD_false | 2025-11-16 13:28:34 PST | 120 | 371029 | None |
| BD_true1 | 2025-11-16 13:31:01 PST | 120 | 379348 | Block state Dependency (1) |
| BD_true2 | 2025-11-16 13:34:15 PST | 120 | 301693 | Assertion Failure (1), Block state Dependency (1), Integer Bug (2) |
| CH_false | 2025-11-16 13:36:51 PST | 120 | 9268 | None |
| CH_true1 | 2025-11-16 13:39:09 PST | 120 | 12064 | Control Hijack (1) |
| CH_true2 | 2025-11-16 13:42:15 PST | 120 | 1171776 | None |
| constructor | 2025-11-16 13:44:46 PST | 120 | 115593 | Integer Bug (12) |
| FE | 2025-11-16 13:52:21 PST | 120 | 715449 | Assertion Failure (1) |
| IB | 2025-11-16 14:08:14 PST | 120 | 204892 | Integer Bug (3) |
| ME_true | 2025-11-16 14:14:44 PST | 120 | 556161 | Ether Leak (1), Mishandled Exception (1) |
| motiv | 2025-11-16 14:17:15 PST | 120 | 708850 | Assertion Failure (1), Integer Bug (1) |
| MS_false | 2025-11-16 14:20:04 PST | 120 | 548025 | None |
| MS_true | 2025-11-16 14:22:44 PST | 120 | 683062 | Multiple Send (1) |
| SC | 2025-11-16 14:25:55 PST | 120 | 250376 | Suicidal Contract (1) |
| TO | 2025-11-16 14:28:12 PST | 120 | 780778 | Transaction Origin Use (1) |

Use this file as a quick index; detailed traces (seed dumps, stack traces, etc.)
remain in the individual `.log` files and the `examples/output/<contract>` dirs.
