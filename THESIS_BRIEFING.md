# Smartian Replication Briefing

## Context
- **Origin**: This repository is a fork of Smartian, a public research prototype from KAIST SoftSec (ASE 2021). It implements a grey-box fuzzer for Ethereum smart contracts that combines static and dynamic data-flow analyses.
- **Why it matters**: Smartian embodies the “hybrid” mindset—static analysis (EVM data-flow reasoning) guides dynamic fuzzing (coverage feedback, oracle checks). That matches the motivation of my thesis, which investigates improving vulnerability detection by blending static and dynamic techniques instead of relying on them independently.
- **Replication goal**: Rebuild the original artifact on macOS, understand each component, run the provided benchmarks, and capture the outcomes. This verifies the published results and gives hands-on insight into how hybrid vulnerability detection is engineered end-to-end.

## Architecture Highlights
- **Static layer (EVMAnalysis)**: Performs abstract interpretation on the contract bytecode/ABI to identify function dependencies, storage usage, and taint propagation. The output narrows the dynamic search space (e.g., prioritizing specific function combinations).
- **Dynamic layer (Smartian core)**:
  - Uses the statically derived hints to craft transaction sequences.
  - Executes them on top of a customized Nethermind EVM to collect coverage and detect vulnerabilities via multiple bug oracles (reentrancy, integer bugs, Ether leak, etc.).
  - Supports replaying interesting seeds to reproduce bugs deterministically.
- **Supporting assets**:
  - `examples/` directory bundles known vulnerable contracts (source, bytecode, ABI) to demonstrate each bug class.
  - `scripts/gelo_run.sh` (added locally) ensures every run is logged with timestamps and metadata, simplifying result tracking during replication.

## Replication Procedure
1. Install .NET 8 SDK, initialize submodules (Nethermind + B2R2), and build via `make`. Smartian targets `net8.0`, so pinning the SDK is essential for reproducibility.
2. Execute the provided example contracts with the supplied helper commands (two-minute fuzzing window per contract). Each run produces:
   - Console logs (stored in `gelo-run/…`).
   - Test cases and bug-triggering inputs under `examples/output/<contract>`.
3. Summaries in `RUN_SUMMARY.md` capture the coverage stats and detected vulnerabilities for all runs, providing a quick comparison across bug classes.

## How This Supports the Thesis
- **Hands-on validation**: Running the baseline hybrid system proves that combining static hints with dynamic fuzzing concretely improves bug-finding effectiveness versus pure static or pure dynamic approaches. The results (e.g., Smartian’s detection of reentrancy, assertion failures, control hijacks) illustrate the tangible benefit of the hybrid strategy I aim to extend.
- **Design insight**: Inspecting Smartian’s architecture showcases practical considerations for hybrid tools—e.g., how static data-flow analysis feeds into transaction scheduling, what bug oracles are feasible, and where dynamic execution bottlenecks arise. These lessons inform my own system design choices.
- **Benchmark foundation**: The curated contract corpus can serve as a baseline dataset for my thesis evaluations. Since I already reproduced Smartian’s findings, I can meaningfully compare my hybrid detector’s improvements against this known reference.
- **Upgrade path**: My thesis will build upon the hybrid principles demonstrated here, introducing enhanced static reasoning + dynamic guidance tailored to the vulnerabilities I target. Replicating Smartian ensures I fully understand the state of the art before proposing modifications.

## Key Takeaways to Present
1. Smartian is a proven hybrid (static + dynamic) vulnerability detector for Ethereum smart contracts.
2. Replicating it required setting up the .NET toolchain, compiling F# components, and running the example suite—providing confidence in the original research claims.
3. The replication results (documented in `gelo-run/RUN_SUMMARY.md`) confirm that the hybrid approach effectively uncovers multiple bug classes within seconds/minutes.
4. This replication directly informs my thesis: it validates the feasibility of hybrid detection, supplies architectural patterns to reuse or extend, and gives a benchmark to measure my “upgraded” approach against.
