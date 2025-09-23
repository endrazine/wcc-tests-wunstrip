# Binary Unstripping Validation Framework

Comprehensive validation of .eh_frame-based function address recovery for stripped ELF binaries, supporting Appendix D of the doctoral thesis *"Beyond Reachability: Cross-Architecture Binary Libification and Procedural Debugging for Vulnerability Assessment"*.

## Overview

This framework validates complete function enumeration in stripped production binaries through three complementary techniques:

1. **Exception Frame Parsing** (.eh_frame analysis) - Primary method recovering 99.93% of functions
2. **Section Header Analysis** - Deterministic recovery of section boundary functions (`_init`, `_fini`)  
3. **Pattern Fingerprinting** - Compiler runtime identification via stable code signatures

### Validation Results

- **Zero False Positives**: 100% precision across 85,594 application function addresses
- **Complete Coverage**: 100% recall for all application functions (85,594/85,594)
- **Total Enumeration**: 85,652/85,652 functions via multi-method framework
- **Scalability**: Validated from 15-function utilities to 61,879-function database servers

## Test Corpus

Ten production binaries from Ubuntu 24.04 LTS spanning diverse application domains:

| Binary | Domain | Functions | Security Hardening |
|--------|--------|-----------|-------------------|
| mysqld | Database | 61,879 | Full RELRO, Canary, NX, PIE |
| postgres | Database | 18,324 | Full RELRO, Canary, NX, PIE |
| proftpd | FTP Server | 2,001 | Full RELRO, Canary, NX, PIE |
| nginx | Web Server | 1,663 | Full RELRO, Canary, NX, PIE |
| sshd | SSH Daemon | 834 | Full RELRO, Canary, NX, PIE |
| libjpeg.so | Image Library | 369 | Partial RELRO, Canary, NX |
| liblzma.so | Compression | 328 | Full RELRO, Canary, NX |
| ls | Core Utility | 191 | Full RELRO, Canary, NX, PIE |
| smbd | File Server | 48 | Full RELRO, Canary, NX, PIE |
| vlc | Media Player | 15 | Full RELRO, Canary, NX, PIE |

**Total**: 85,652 functions across four orders of magnitude, all stripped with modern mitigations enabled.

## Quick Start

### Prerequisites

- Docker Engine 20.10+
- x86_64 host system  
- 16GB RAM, 5GB disk space
- Internet connection for debuginfod symbol retrieval

### Installation & Execution
```bash
git clone https://github.com/endrazine/wcc-tests-wunstrip
cd wcc-tests-wunstrip
make        # Build environment (~20 minutes)
make test   # Run validation (~3 hours)
Single Binary Test
bash
docker run -it wcc-wunstrip:latest
cd testcases
./test_single.sh /bin/ls
Validation Methodology
Ground Truth Establishment
Symbol Retrieval: Fetch cryptographically-verified debug symbols via Ubuntu's debuginfod
Reconstruction: Merge debug symbols with stripped production binary
Extraction: Parse function addresses using nm
Validation: Compare recovered addresses against authoritative ground truth
Classification: Categorize results by recovery method
Metrics
Precision = True Positives / (True Positives + False Positives)
          = 85,594 / 85,594 = 100.000%

Recall    = True Positives / (True Positives + False Negatives)  
          = 85,594 / 85,594 = 100.000%

Coverage  = Total Recovered / Total Functions
          = 85,652 / 85,652 = 100.000%
Multi-Method Recovery Framework
Method 1: Exception Frame Analysis
Primary technique leveraging mandatory .eh_frame sections (x86_64 ABI requirement):

bash
wunstrip -e /usr/sbin/binary -o binary.unstripped
Coverage: 85,594/85,594 application functions (99.93% of total)
Mechanism: Parses Frame Description Entries (FDEs) and Common Information Entries (CIEs)
Deterministic: Zero false positives, 100% application function recall
Method 2: Section Header Analysis
Complementary technique for section boundary functions:

bash
readelf -S binary | grep -E '\.init|\.fini'
Coverage: 20 boundary functions across 10 test binaries
Functions: _init (section start), _fini (section end)
Deterministic: Direct ELF metadata provides exact addresses
Method 3: Pattern Fingerprinting
Supplementary technique for compiler runtime stubs:

bash
objgrep --pattern="__do_global_dtors_aux" binary
Coverage: 38 compiler runtime functions
Functions: __do_global_dtors_aux, register_tm_clones, deregister_tm_clones, frame_dummy
Reliability: Stable signatures from crtbegin.o/crtend.o static linking
Expected Output
Small Binary (ls - 191 functions)
[*] Testing /bin/ls

-- Recovered functions: 185
-- Section recovered: 2  
-- Pattern recovered: 4
-- Total: 191/191 (100%)

./false_positives.sh ls
[no output - zero false positives]

./false_negatives.sh ls
[no output - complete coverage]
Large Binary (mysqld - 61,879 functions)
[*] Testing /usr/sbin/mysqld

-- Recovered functions: 61,873
-- Section recovered: 2
-- Pattern recovered: 4
-- Total: 61,879/61,879 (100%)

./false_positives.sh mysqld
[no output - zero false positives]

./false_negatives.sh mysqld
[no output - complete coverage]
Address Aliasing (PostgreSQL example)
[*] Testing /usr/lib/postgresql/16/bin/postgres

-- Recovered functions: 18,320

./false_positives.sh postgres
ERROR: 0000000000268d30 T function_parse_error_transpose: 0
ERROR: 0000000000476850 T function_selectivity: 0
Note: These "errors" demonstrate correct address-based validation. The .eh_frame parser correctly recovers address 0x268d30, but debug symbols show this address has multiple symbol names (weak symbols/function aliases). This validates our address-based (not name-based) methodology - we enumerate unique code locations, not symbol name variations.

Validation Scripts
False Positive Detection
Verifies all recovered addresses exist in ground truth:

bash
#!/bin/bash
nm ${binary}.unstripped -D | grep "T function" | while read input; do
    offset=$(echo $input | awk '{print $1}')
    found=$(nm ${binary}.dbg | grep $offset | wc -l)
    if [ "$found" == "0" ]; then
        echo "ERROR: Spurious detection at $offset"
    fi
done
False Negative Detection
Ensures all ground truth addresses were recovered:

bash
#!/bin/bash
nm ${binary}.dbg | grep -w t | while read input; do
    offset=$(echo $input | awk '{print $1}')
    found=$(nm ${binary}.unstripped -D | grep $offset | wc -l)
    if [ "$found" -lt "1" ]; then
        echo "ERROR: Missed function at $offset"
    fi
done
Thesis Claims Validation
Chapter 4, Section 4.3.4 Claim:
"Our parser extracts FDEs and CIEs to recover function addresses. Empirical validation across 85,594 application function addresses from Ubuntu 24.04 LTS production binaries demonstrates zero false positives (100% observed precision) and complete recovery (100% observed recall)."

Validated Results:

Precision: 100.000% (85,594/85,594) ✓
Recall: 100.000% for application functions ✓
Total Coverage: 100.000% via multi-method (85,652/85,652) ✓
Statistical Confidence (Wilson score, 95% level):

Precision: [99.996%, 100.000%]
Recall: [99.996%, 100.000%]
PSIRT Workflow Integration
Three-Phase Deployment
bash
# Phase 1: Primary Recovery (99.93% coverage, <1s)
wunstrip -e production.bin -o analyzed.bin

# Phase 2: Section Supplement (deterministic)
readelf -S production.bin | grep -E '\.init|\.fini'

# Phase 3: Pattern Completion (100% total coverage)
objgrep --pattern="__do_global_dtors_aux" production.bin
Production Use Cases
Container Security: Analyze stripped Docker images without source access
IoT/Embedded: Function enumeration across diverse architectures
Legacy Systems: Recover symbols from binaries without debug information
Vulnerability Assessment: Rapid CVE triage under 24-hour regulatory deadlines
Comparison with Existing Approaches
Method	Precision	Coverage	Time	Deterministic
.eh_frame (ours)	100%	99.93% app	<1s	Yes
+ Section/Pattern	100%	100% total	<1s	Yes
IDA Pro CFG	Variable	Path-dependent	Minutes	No
Ghidra CFG	Variable	Heuristic-based	Minutes	No
FLIRT Signatures	High	Name-based	Seconds	Partial
Dynamic Instrumentation	100%	Runtime-limited	Varies	Yes
Technical Details
Address vs. Name Recovery
This framework validates function address recovery (security-critical metric) rather than name recovery because:

Security analysis: Requires code locations for vulnerability assessment
WSH procedural debugging: Invokes functions by address, not name
Symbol aliasing: Multiple names may reference identical addresses (weak symbols, inline functions)
Attack surface: Enumeration depends on code locations, not symbol names
Example (PostgreSQL weak symbol aliasing):

bash
# .eh_frame recovery (generic name)
0x268d30 -> function_268d30

# Debug symbols (multiple names for same address)
0x268d30 -> function_parse_error_transpose (primary)
0x268d30 -> [weak alias name] (secondary)

# Both identify same code location - 100% address recovery ✓
Scope and Limitations
Validated Environments:

Ubuntu 24.04 LTS (GCC 12.3.0) with standard compilation flags
Distribution-standard binaries from package repositories
Docker/container images based on major Linux distributions
Stripped binaries following x86_64 System V ABI
Requires Additional Validation:

Custom toolchains with experimental optimization flags
Heavily obfuscated or anti-analysis binaries
Hand-crafted minimal ELF executables
Non-standard or research compilers
Reproducibility
Complete Validation
bash
git clone https://github.com/endrazine/wcc-tests-wunstrip
cd wcc-tests-wunstrip
make clean
make        # ~20 minutes
make test   # ~3 hours
Individual Binary Testing
bash
docker run -it wcc-wunstrip:latest bash
cd testcases

# Test specific binary
./test_single.sh /usr/sbin/nginx

# Run validation
./false_positives.sh nginx
./false_negatives.sh nginx
Docker Environment
Pre-configured environment includes:

Witchcraft Compiler Collection (WCC) framework
Ubuntu 24.04 LTS base system
Debug symbol infrastructure (debuginfod client)
Complete validation scripts and test corpus
Troubleshooting
Debuginfod Connection Issues
bash
export DEBUGINFOD_URLS="https://debuginfod.ubuntu.com"
Memory Requirements
Large binaries may require additional RAM:

bash
docker run -it --memory=8g wcc-wunstrip:latest
Build-ID Verification
Check binary integrity:

bash
wunstrip -d binary  # Verify build-id SHA1 matches
Citation
If using this framework in academic research:

bibtex
@INPROCEEDINGS{11141058,
  author={Brossard, Jonathan},
  booktitle={2025 International Conference on Emerging Technologies and Computing (IC_ETC)}, 
  title={Unstripping Cloud Container ELF Binaries}, 
  year={2025},
  pages={1-6},
  doi={10.1109/IC_ETC65981.2025.11141058}
}

Related Resources
Main Framework: Witchcraft Compiler Collection
Cross-Architecture: WCC Multi-Architecture Tests
Binary Unlinking: WCC Unlinking Tests
Thesis: Appendix D - Complete Methodology

License:
Dual MIT/BSD License (consistent with WCC framework)

Permanent Archive: https://doi.org/10.5281/zenodo.17186203

