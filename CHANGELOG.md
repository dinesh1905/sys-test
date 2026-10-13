# Changelog

## [1.3.0] - 2023-09-15

### Changes

- Added development and release pipeline for Linux variant of TA-Framework
  - Added VS Code workspace setup script for Linux
  - Added second testbench configuration for BITS-Platform running on remote machine (robotremoteserver)
- Added automatic test result folder creation based on test suite name and test execution start time
- Restructuring of configuration files
- Shifted database component to framework.report.mbits component
- Switched VS Code workspace setup scripts from .bat to .ps1 (Windows)
- Changes after updating RF-AIO to reference version 0.8.2.2
  - Correct syntax of configuration files contents
  - Renaming of config files (.json -> .jsonp)
  - Make use of RF 6.x syntax (IF ELSE END, RETURN, ...)

## [1.2.0] - 2023-07-12

### Changes

- Added project specific csv report updates (feature: csv_reporting)
- Optimzation: changed access to bits_platform interface to single instance access instead of
  creating an interface instance for every bits-platform command (feature: bits_platform)

## [1.1.0] - 2023-05-24

### Changes

- Added database support/integration of BITS.DB.Client (feature: db_support) 
- Added creation of a csv file for additional reporting (feature: csv_reporting)
- Added creation of dynamic test cases at runtime (feature: testcase_iterator)

## [1.0.1] - 2023-01-24

### Changes

- Adapted imports of RobotFramework_Testsuites after renaming to RobotFramework_TestsuitesManagement (see RF AIO changes)

## [1.0.0] - 2022-12-05

_First major release: Feature baseline for upcoming releases._\
Overall cleanup and restructuring of the TA-Framework was done.\
BITS-Platform interface library was moved from TA-Framework to BITS-Platform (is now shipped with BITS-Platform).\
Changed from 4-layers to 2-layer concept:\
generic, project, variant, local => generic, project (project layer now contains all specific implementations).\
Started change to continuous development and operation process for TA-Framework.

### Changes

- Added hierarchical concept for importing test libraries
- Added test suite initialization (based on folder structure)
- Added multi-layer configuration management (definition of configuration groups, group parameters and libraries  are shared among all configurations inside a group)
- Added easy configuration of IDE workspace  (batch file to configure the Visual Studio Code/VS Codium)
- Added static code analysis with pylint and robocop, coding convention checked while typing (.pylintrc and .robocop files in workspace configuration)
- Added generic Setups and Teardowns for all levels (Initial Test Suite, Test Suite, Test Case, Final Test Suite; Test Case Failure Teardown)
- Added keywords to control the test flow:
  - test case can be set to fail (continuing or with skipping all test steps after the failure)
  - test cases can be set to unknown (unexpected failure in test environment)
  - test run can be stopped
- Added support of generic keywords to stop a running test case if the project layer reports an execution exception
- Added test status and error statistics
- Added support of .resource and .py files (all generic libraries are implemented in Python)
- Added test libraries for testbench _Audio (Media)_
- Added test libraries for testbench _Power_
- Added test libraries for testbench _Relays_
- Added test libraries for testbench _Robotarm_
- Added test libraries for testbench _AM Tuner_
- Added test libraries for testbench _FM Tuner_
- Added test libraries for testbench _RDS Tuner_
- Added test libraries for testbench _DAB Tuner_
- Added test libraries for testbench _Video (Media)_
- Added test libraries for system under test _Audio (Media)_
- Added test libraries for system under test _Image (Media)_
- Added test libraries for system under test _Video (Media)_
- Added test libraries for system under test _System_
- Added test libraries for system under test _AM Tuner_
- Added test libraries for system under test _FM Tuner_
- Added project templates for all generic sut libraries
- Added project templates for all generic testbench libraries
