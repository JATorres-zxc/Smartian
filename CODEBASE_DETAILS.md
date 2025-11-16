# Smartian Codebase Details

This guide expands on the top-level overview by describing what lives inside each
major folder/file and how they relate to Smartian’s workflow.

## Root-Level Build and Config Files
- `Makefile` – wraps the full solution build (`dotnet build -c Release -o build`).
- `Smartian.sln` – Visual Studio/JetBrains solution referencing Smartian, EVMAnalysis, and the Nethermind subprojects.
- `global.json` – pins .NET SDK 8.x for reproducible builds regardless of newer SDKs on the machine.
- `README.md` – upstream introduction; `RUNNING_SMARTIAN_MAC.md` gives our macOS-specific instructions; `THESIS_BRIEFING.md` explains the replication context.

## `src/` – Smartian Fuzzer
- `Smartian.fsproj` – project file targeting `net8.0` and referencing Nethermind/EVMAnalysis.
- `Core/` – shared utilities:
  - `Config.fs` handles runtime configuration (timeouts, directories).
  - `Utils.fs`, `BytesUtils.fs`, `Extension.fs`, `Queue.fs`, etc., provide helper functions for byte manipulation, collections, and queueing seeds.
  - `Typedef.fs`, `Address.fs` define the data structures Smartian uses to model contracts and transactions.
- `Seed/` – defines how inputs are represented:
  - `TestCase.fs`, `Transaction.fs`, `Seed.fs`, and related files describe the multi-transaction “seed” format, argument encoding, caller types, etc.
- `GreyConcolic/` – implements Smartian’s hybrid reasoning layer:
  - Files like `BranchTrace.fs`, `LinearEquation.fs`, `Monotonicity.fs`, `PathConstraint.fs` track symbolic information about branch conditions and solve for new inputs.
- `Fuzz/` – the runtime fuzzing engine:
  - `Options.fs` parses CLI flags, `Executor.fs` drives Nethermind to execute sequences, `SeedQueue.fs` manages prioritization, `Fuzz.fs` orchestrates the main loop.
- `Main/` – entry points for `fuzz` and `replay` commands.
- `Agent/` – predefined agent behaviors (e.g., modeling common user accounts) used when constructing transaction sequences.
- `obj/` – build artifacts created by `dotnet`; safe to ignore.

### Flow Inside `src/`
1. CLI (`Main.fs`) parses mode and options.
2. `Fuzz/Options.fs` + `Core/Config.fs` set up directories/timeouts.
3. `Seed` modules create the initial queue.
4. `EVMAnalysis` output guides `GreyConcolic` logic to mutate seeds intelligently.
5. `Fuzz/Executor.fs` runs transactions via Nethermind, feeding coverage/oracle results back into the queue.

## `EVMAnalysis/` – Static Analysis Layer
- `src/` – modular F# analyzer:
  - `Core/` defines abstract value types and config.
  - `FrontEnd/` parses ABI + bytecode into CFG/BasicBlock representations.
  - `Domain/` implements abstract domains (taint, flat integers, SHA outputs, etc.).
  - `Analysis/` runs the abstract interpreter, records def-use chains, and exports function summaries consumed by the fuzzer.
  - `Main.fs` wires the CLI (used internally through Smartian).
- `B2R2/` – submodule providing lifting/disassembly infrastructure smartian relies on to interpret EVM bytecode. You will rarely modify it, but it must be built.
- `Makefile` / `EVMAnalysis.sln` – standalone build entry points, though normally `make` in the root compiles everything.

## `nethermind/` – Execution Engine Submodule
- Fork of Nethermind tailored for Smartian; contains:
  - `src/Nethermind/` – core EVM, ABI, blockchain, store, etc.
  - `src/Dirichlet/`, `src/rocksdb-sharp/` – supporting math/storage libraries pulled as submodules.
- Smartian references several Nethermind projects (Evm, Core, Abi, tests) to execute fuzzed transactions with realistic semantics. Typically left untouched except to pull upstream updates.

## `examples/` – Sample Contracts and Scripts
- `sol/` – Solidity source files showing specific vulnerability patterns (e.g., reentrancy, assertion failure).
- `bc/` – compiled bytecode (`.bin`) corresponding to each Solidity file.
- `abi/` – ABI definitions used by Smartian to craft transactions.
- `run.sh`, `replay.sh`, `test.sh`, `check.py` – artifact scripts from the original paper; they fuzz or replay targets under controlled settings.
- `output/`, `log/` (created at runtime) – store fuzzing results when you use `examples/run.sh`.

## `scripts/`
- `gelo_run.sh` – wrapper that logs every command execution (label, timestamps, stdout/stderr) into `gelo-run/`. Use it to keep a history of fuzzing sessions.
- Future helper scripts (e.g., automation, report generators) can live here.

## `gelo-run/`
- Contains timestamped `.log` files produced by `gelo_run.sh`.
- `RUN_SUMMARY.md` summarizes each run (contract, time limit, total executions, bug findings) for quick reference.

## `build/`
- Populated by `make`. Holds compiled binaries such as `Smartian.dll`, `EVMAnalysis.dll`, and the required Nethermind assemblies. Delete with `make clean` if you need a fresh build.

## `examples/output/<contract>/`
- Created when you run `dotnet build/Smartian.dll fuzz ... -o examples/output/<contract>`.
- `testcase/` – inputs that increased coverage.
- `bug/` – inputs that triggered bug detectors, with filenames labeled by bug class (e.g., `RE` for reentrancy). Each file is JSON describing the transaction sequence for easy replay.

Use this document when reviewing or presenting the project so you can quickly explain where each capability resides and how the folders interplay.
