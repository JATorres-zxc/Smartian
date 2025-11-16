# Running Smartian on macOS

Follow the steps below exactly from top to bottom on your Mac. All commands are
meant to be executed in **Terminal**. Do not skip a step.

## 1. Prepare macOS for development
1. Open Terminal (`Applications -> Utilities -> Terminal`).
2. Install Command Line Tools if prompted with a dialog, or run
   `xcode-select --install` and follow the prompts.
3. Install Homebrew (skip if already present):  
   `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
4. Add Homebrew to your shell profile if the installer prints instructions
   (usually appending an `eval "$(/opt/homebrew/bin/brew shellenv)"` line to
   `~/.zprofile`).
5. Install the .NET 8 SDK (Smartian is pinned to it via `global.json`). Using
   Homebrew, run `brew install --cask dotnet-sdk@8`. If that cask is not
   available, download the **.NET SDK 8.x (LTS)** installer for macOS directly
   from https://dotnet.microsoft.com/en-us/download/dotnet/8.0 and run it.
6. Close Terminal and reopen it so that the `dotnet` command uses the fresh
   installation.
7. Confirm the SDK is visible by running `dotnet --info` and ensure the reported
   `.NET SDK` version starts with `8.`. (If you still see a newer preview SDK,
   uninstall it with `brew uninstall --cask dotnet-sdk` before installing the
   8.x LTS version.)

## 2. Fetch the Smartian source code
1. Decide where you want the project to live (for example
   `~/Documents/thesis`).
2. From that parent folder, clone your fork:  
   `git clone https://github.com/<your-account>/Smartian.git`
3. Move into the repository root: `cd Smartian`
4. Initialize every submodule (Nethermind and B2R2) the project depends on:  
   `git submodule update --init --recursive`

## 3. Restore and build everything
1. Stay inside the repository root (`/Users/gelo/Documents/thesis/Smartian` on
   this machine).
2. Ensure the `make` tool is available (it is installed together with the
   Command Line Tools from step 1).
3. Build Smartian in Release mode, which also compiles the submodules and drops
   binaries into `./build`:  
   `make`
4. Wait for `dotnet` to finish; a successful build prints `Build succeeded.`.
5. Verify the binary exists: `ls build` should show `Smartian.dll` and related
   files.

## 4. Understand the repo layout
1. `src/` contains the Smartian fuzzer implementation.
2. `EVMAnalysis/` hosts auxiliary analysis tools used during fuzzing.
3. `nethermind/` is a submodule providing the Ethereum execution engine.
4. `examples/` includes Solidity sources (`sol/`), compiled bytecode (`bc/`),
   ABI files (`abi/`), and helper scripts (`run.sh`, `replay.sh`) you can use as
   ready-made targets for testing your setup.

## 5. Run the fuzzer against a contract
1. Decide which compiled contract and ABI you want to fuzz. The example
   `RE` contract is at `examples/bc/RE.bin` and `examples/abi/RE.abi`.
2. Choose how long the fuzzer should run (in seconds). Example: `60` seconds.
3. Create an output directory for results, e.g. `mkdir -p examples/output/RE`.
4. Execute the fuzzing command from the repository root:  
   `dotnet build/Smartian.dll fuzz -p examples/bc/RE.bin -a examples/abi/RE.abi -t 60 -o examples/output/RE`
5. Optional knobs you can add:
   - Increase verbosity: append `-v 1`
   - Enable other oracles: append `--useothersoracle`
6. While the command runs, Smartian prints progress about executed seeds and
   coverage. Wait until it exits on its own (after your chosen time limit).

## 6. Inspect fuzzing outputs
1. Look inside the directory you passed via `-o` (for the example, this is
   `examples/output/RE`).
2. The directory contains two subfolders created automatically:
   - `testcase/`: inputs that expanded code coverage.
   - `bug/`: inputs that triggered specific bug detectors (file names carry a
     short bug-class tag such as `RE` for reentrancy).
3. Each test input is stored as JSON. Open any file to see the function
   selector, arguments, sender, and other metadata required to replay it.

## 7. Replay interesting inputs
1. To replay every test case in a folder, run:  
   `dotnet build/Smartian.dll replay -p examples/bc/RE.bin -i examples/output/RE/testcase`
2. To replay only the bug-triggering inputs, point `-i` to the `bug/`
   directory instead.
3. For a scripted run equivalent to the paper’s artifact workflow, you can use
   the helper scripts inside `examples/`:
   - `./examples/run.sh 60 RE` fuzzes `RE` for 60 seconds and saves logs to
     `examples/log/RE.txt`.
   - `./examples/replay.sh RE` replays both the coverage-improving and
     bug-triggering inputs.

## 9. Automatically log every run in `gelo-run`
1. Use the helper wrapper `scripts/gelo_run.sh` to capture both console output
   and basic metadata (label, command, timestamps) to `gelo-run/`.  
   First make the script executable once: `chmod +x scripts/gelo_run.sh`.
2. Run it by providing a label followed by the exact command you want to
   execute. Example:  
   ```bash
   ./scripts/gelo_run.sh RE dotnet build/Smartian.dll fuzz \
     -p examples/bc/RE.bin -a examples/abi/RE.abi -t 60 \
     -o examples/output/RE --useothersoracle -v 1
   ```
3. Each invocation creates a file named like
   `gelo-run/2024-06-06_11-05-13_RE.log` containing the label, command, start
   time, end time, exit code, and the full console output.
4. Repeat with different labels (e.g., `MS_true`, `AF`) to keep your runs
   organized chronologically in that folder.

## 10. Ready-made commands for every bundled example
Run each line below from the repo root to fuzz a specific example while logging
to `gelo-run/`. Feel free to adjust the `-t` value (seconds) per contract.

```bash
./scripts/gelo_run.sh AF dotnet build/Smartian.dll fuzz -p examples/bc/AF.bin -a examples/abi/AF.abi -t 120 -o examples/output/AF --useothersoracle -v 1
./scripts/gelo_run.sh AW dotnet build/Smartian.dll fuzz -p examples/bc/AW.bin -a examples/abi/AW.abi -t 120 -o examples/output/AW --useothersoracle -v 1
./scripts/gelo_run.sh BD_false dotnet build/Smartian.dll fuzz -p examples/bc/BD_false.bin -a examples/abi/BD_false.abi -t 120 -o examples/output/BD_false --useothersoracle -v 1
./scripts/gelo_run.sh BD_true1 dotnet build/Smartian.dll fuzz -p examples/bc/BD_true1.bin -a examples/abi/BD_true1.abi -t 120 -o examples/output/BD_true1 --useothersoracle -v 1
./scripts/gelo_run.sh BD_true2 dotnet build/Smartian.dll fuzz -p examples/bc/BD_true2.bin -a examples/abi/BD_true2.abi -t 120 -o examples/output/BD_true2 --useothersoracle -v 1
./scripts/gelo_run.sh CH_false dotnet build/Smartian.dll fuzz -p examples/bc/CH_false.bin -a examples/abi/CH_false.abi -t 120 -o examples/output/CH_false --useothersoracle -v 1
./scripts/gelo_run.sh CH_true1 dotnet build/Smartian.dll fuzz -p examples/bc/CH_true1.bin -a examples/abi/CH_true1.abi -t 120 -o examples/output/CH_true1 --useothersoracle -v 1
./scripts/gelo_run.sh CH_true2 dotnet build/Smartian.dll fuzz -p examples/bc/CH_true2.bin -a examples/abi/CH_true2.abi -t 120 -o examples/output/CH_true2 --useothersoracle -v 1
./scripts/gelo_run.sh constructor dotnet build/Smartian.dll fuzz -p examples/bc/constructor.bin -a examples/abi/constructor.abi -t 120 -o examples/output/constructor --useothersoracle -v 1
./scripts/gelo_run.sh FE dotnet build/Smartian.dll fuzz -p examples/bc/FE.bin -a examples/abi/FE.abi -t 120 -o examples/output/FE --useothersoracle -v 1
./scripts/gelo_run.sh IB dotnet build/Smartian.dll fuzz -p examples/bc/IB.bin -a examples/abi/IB.abi -t 120 -o examples/output/IB --useothersoracle -v 1
./scripts/gelo_run.sh ME_true dotnet build/Smartian.dll fuzz -p examples/bc/ME_true.bin -a examples/abi/ME_true.abi -t 120 -o examples/output/ME_true --useothersoracle -v 1
./scripts/gelo_run.sh motiv dotnet build/Smartian.dll fuzz -p examples/bc/motiv.bin -a examples/abi/motiv.abi -t 120 -o examples/output/motiv --useothersoracle -v 1
./scripts/gelo_run.sh MS_false dotnet build/Smartian.dll fuzz -p examples/bc/MS_false.bin -a examples/abi/MS_false.abi -t 120 -o examples/output/MS_false --useothersoracle -v 1
./scripts/gelo_run.sh MS_true dotnet build/Smartian.dll fuzz -p examples/bc/MS_true.bin -a examples/abi/MS_true.abi -t 120 -o examples/output/MS_true --useothersoracle -v 1
./scripts/gelo_run.sh RE dotnet build/Smartian.dll fuzz -p examples/bc/RE.bin -a examples/abi/RE.abi -t 120 -o examples/output/RE --useothersoracle -v 1
./scripts/gelo_run.sh SC dotnet build/Smartian.dll fuzz -p examples/bc/SC.bin -a examples/abi/SC.abi -t 120 -o examples/output/SC --useothersoracle -v 1
./scripts/gelo_run.sh TO dotnet build/Smartian.dll fuzz -p examples/bc/TO.bin -a examples/abi/TO.abi -t 120 -o examples/output/TO --useothersoracle -v 1
```

Each command writes Smartian’s console output to `gelo-run/<timestamp>_<label>.log`
for later reference and stores test cases/bugs under `examples/output/<label>`.

## 8. Explore additional options
1. See every available flag for fuzzing:  
   `dotnet build/Smartian.dll fuzz --help`
2. Inspect replay-only options:  
   `dotnet build/Smartian.dll replay --help`
3. To clean the build artifacts, run `make clean`.

After completing these steps you will have Smartian built locally, and you can
iterate by fuzzing any bytecode/ABI pair you provide.
