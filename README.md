# Binary Unstripping Validation Framework

Comprehensive validation suite for .eh_frame-based function address recovery in stripped ELF binaries, supporting the doctoral thesis *"Beyond Reachability: Cross-Architecture Binary Libification and Procedural Debugging for Vulnerability Assessment"*.

## Overview

This framework validates three complementary techniques for complete function enumeration in stripped production binaries:

1. **Exception Frame Analysis** (.eh_frame parsing) - Primary method recovering 99.93% of functions
2. **Section Header Analysis** - Deterministic recovery of `_init`, `_fini` section boundaries
3. **Pattern Fingerprinting** - Compiler runtime function identification via stable signatures

### Key Results

- **100% Precision**: Zero false positives across 85,594 function addresses
- **100% Recall**: Complete application function coverage (85,594/85,594)
- **100% Total Coverage**: 85,652/85,652 functions via multi-method approach
- **Scalability**: Validated from 15-function utilities to 61,879-function database servers

## Test Corpus

Ten production binaries from Ubuntu 24.04 LTS:

| Binary | Category | Functions | Security Features |
|--------|----------|-----------|-------------------|
| mysqld | Database | 61,879 | Full RELRO, Canary, NX, PIE |
| postgres | Database | 18,324 | Full RELRO, Canary, NX, PIE |
| proftpd | FTP Server | 2,001 | Full RELRO, Canary, NX, PIE |
| nginx | Web Server | 1,663 | Full RELRO, Canary, NX, PIE |
| sshd | SSH Daemon | 834 | Full RELRO, Canary, NX, PIE |
| libjpeg.so | Library | 369 | Partial RELRO, Canary, NX |
| liblzma.so | Library | 328 | Full RELRO, Canary, NX |
| ls | Utility | 191 | Full RELRO, Canary, NX, PIE |
| smbd | File Server | 48 | Full RELRO, Canary, NX, PIE |
| vlc | Media Player | 15 | Full RELRO, Canary, NX, PIE |

**Total**: 85,652 functions across diverse domains, all stripped, modern security mitigations enabled.

## Quick Start

### Prerequisites

- Docker 20.10+
- x86_64 host system
- 16GB RAM, 5GB disk space
- Internet connection (for debuginfod symbol retrieval)

### Installation
```bash
git clone https://github.com/endrazine/wcc-tests-wunstrip
cd wcc-tests-wunstrip
make  # Build Docker environment (18 minutes)
Run Validation
bashmake test  # Complete validation suite (6.5 hours)
Quick Test (Single Binary)
bashdocker run -it wcc-wunstrip:latest
cd testcases
./test_single.sh /bin/ls
Validation Methodology
Ground Truth Establishment

Symbol Retrieval: Fetch official Ubuntu debug symbols via debuginfod
Binary Reconstruction: Merge debug symbols with stripped production binary
Address Extraction: Extract function addresses using nm
Comparison: Validate recovered addresses against ground truth
Classification: Categorize by recovery method

Metrics
Precision = True Positives / (True Positives + False Positives)

Measures: Are recovered addresses valid?
Result: 85,594/85,594 = 100.000%

Recall = True Positives / (True Positives + False Negatives)

Measures: Are all functions found?
Result: 85,594/85,594 application functions = 100.000%

Coverage = Total Recovered / Total Functions

Measures: Complete enumeration?
Result: 85,652/85,652 = 100.000% (all methods combined)

Expected Output
Small Binary (ls - 191 functions)
[*] Testing /bin/ls

-- .eh_frame recovered: 185
-- Section recovered (_init, _fini): 2  
-- Pattern recovered (CRT): 4
-- Total coverage: 191/191 (100%)

./false_positives.sh ls
[no output - zero false positives]

./false_negatives.sh ls  
[no output - complete coverage]
Large Binary (mysqld - 61,879 functions)
[*] Testing /usr/sbin/mysqld

-- .eh_frame recovered: 61,873
-- Section recovered (_init, _fini): 2
-- Pattern recovered (CRT): 4  
-- Total coverage: 61,879/61,879 (100%)

./false_positives.sh mysqld
[no output - zero false positives]

./false_negatives.sh mysqld
[no output - complete coverage]
Multi-Method Recovery Framework
Method 1: Exception Frame Analysis (.eh_frame)
Coverage: 85,594/85,594 application functions (99.93% of total)
bashwunstrip -e /usr/sbin/binary -o binary.unstripped
Why it works: x86_64 ABI mandates .eh_frame sections for exception handling. All application functions contain this metadata.
Method 2: Section Header Analysis
Coverage: 20 section boundary functions across 10 binaries
bashreadelf -S binary | grep -E '\.init|\.fini'
Functions recovered: _init (section start), _fini (section end)
Method 3: Pattern Fingerprinting
Coverage: 38 compiler runtime functions
bashobjgrep --pattern="__do_global_dtors_aux" binary
Functions recovered: __do_global_dtors_aux, register_tm_clones, deregister_tm_clones, frame_dummy
Validation Scripts
False Positive Detection
Checks if recovered addresses exist in ground truth:
bash#!/bin/bash
# Check every recovered address against debug symbols
nm ${binary}.unstripped -D | grep "T function" | while read input; do
    offset=$(echo $input | awk '{print $1}')
    found=$(nm ${binary}.dbg | grep $offset | wc -l)
    if [ "$found" == "0" ]; then
        echo "ERROR: Spurious detection at $offset"
    fi
done
False Negative Detection
Checks if ground truth addresses were recovered:
bash#!/bin/bash
# Verify all ground truth addresses found
nm ${binary}.dbg | grep -w t | while read input; do
    offset=$(echo $input | awk '{print $1}')
    found=$(nm ${binary}.unstripped -D | grep $offset | wc -l)
    if [ "$found" -lt "1" ]; then
        echo "ERROR: Missed function at $offset"
    fi
done
Thesis Validation
This framework validates claims from Chapter 4 of the thesis:
Claimed Accuracy

"Our parser extracts Frame Description Entries (FDEs) and Common Information Entries (CIEs) to recover function addresses with 99.98% accuracy across diverse binary sizes."

Validated Results

Precision: 100.000% (exceeds 99.98% claim)
Recall: 100.000% for application functions
Coverage: 100.000% via multi-method approach

Statistical Confidence
Wilson score method at 95% confidence level:

Precision: [99.996%, 100.000%]
Recall: [99.996%, 100.000%]

Practical Applications
PSIRT Workflow Integration
Three-phase deployment for regulatory compliance:

Primary Recovery (99.93% coverage, <1s)

bash   wunstrip -e production.bin -o analyzed.bin

Section Supplement (deterministic)

bash   readelf -S production.bin | grep -E '\.init|\.fini'

Pattern Completion (100% coverage)

bash   objgrep --pattern="__do_global_dtors_aux" production.bin
Use Cases

Container Security: Analyze stripped Docker images
IoT/Embedded: Function enumeration without debug symbols
Legacy Systems: Recover functions from binaries without source
Vulnerability Assessment: Rapid CVE triage under 24-hour deadlines

Comparison with Existing Tools
MethodPrecisionCoverageProcessing TimeDeterministic.eh_frame (ours)100%99.93% app<1sYes+ Section/Pattern100%100% total<1sYesIDA Pro CFGProbabilisticVariableMinutesNoGhidra CFGProbabilisticVariableMinutesNoFLIRT SignaturesHighName-basedSecondsPartialPin/DynamoRIO100%Path-limitedRuntimeYes
Technical Details
Address vs. Name Recovery
This framework validates function address recovery (security-critical) rather than name recovery:

Security analysis needs: Code locations for vulnerability assessment
WSH procedural debugging: Invokes functions by address
Symbol aliasing: Multiple names may point to same address

Example (PostgreSQL):
bash# .eh_frame recovery (generic name)
0000000000267d30 T function_267d30

# Debug symbols (original name)  
0000000000267d30 T function_parse_error_transpose

# Both identify the same code location - address recovery is 100%
Architecture-Specific Considerations
Current validation: x86_64 Ubuntu 24.04 LTS (GCC 12.3.0)
Extended validation across 16 architectures in Chapter 5 (separate test suite).
Reproducibility
Full Reproduction
bashgit clone https://github.com/endrazine/wcc-tests-wunstrip
cd wcc-tests-wunstrip
make clean
make        # 18 minutes
make test   # 6.5 hours
Individual Test Cases
bashdocker run -it wcc-wunstrip:latest
cd testcases

# Test specific binary
./test_single.sh /usr/sbin/mysqld

# Run validation scripts
./false_positives.sh mysqld
./false_negatives.sh mysqld
Docker Environment
Pre-built environment includes:

Witchcraft Compiler Collection (WCC)
Ubuntu 24.04 LTS base system
Debug symbol infrastructure (debuginfod)
Validation scripts and ground truth data

Troubleshooting
Debuginfod Connection Issues
If symbol download fails:
bashexport DEBUGINFOD_URLS="https://debuginfod.ubuntu.com"
Memory Issues
Large binaries (mysqld) may require additional RAM:
bashdocker run -it --memory=8g wcc-wunstrip:latest
Validation Mismatches
Check binary integrity:
bashwunstrip -d binary  # Verify build-id matches
Citation
If using this validation framework in academic work:
bibtex@phdthesis{brossard2026beyond,
  title={Beyond Reachability: Cross-Architecture Binary Libification and Procedural Debugging for Vulnerability Assessment},
  author={Brossard, Jonathan},
  year={2026},
  school={Conservatoire national des arts et métiers},
  note={Chapter 4: Binary Unstripping, Appendix G: Validation Framework}
}
Related Projects

Witchcraft Compiler Collection - Main framework
WCC Multi-Architecture Tests - Cross-architecture validation
WCC Unlinking Tests - Binary unlinking validation

License
Dual MIT/BSD License (consistent with WCC framework)
