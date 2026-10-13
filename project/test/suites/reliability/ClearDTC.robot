*** Settings ***
Documentation    Test case for power onOff non functional test.
Resource    ${TAF_PATH}/import.resource
Library     ${TAF_PATH}/generic/framework/testcase_iterator.py
Library     QConnectBase.ConnectionManager
Metadata    testtype            reliability
Metadata    testarea            sut.shutdown.startup
Metadata    requirements        High-Speed Power Supply
Metadata    preconditions       SuT is running.
Metadata    actions             1. Set ignition off. 2. Play power curve and set ignition on.
Metadata    expectedresults     1. SuT is shutdown. 2. SuT is running.

# Test Automation Framework
# Test Automation Framework
Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Variables ***
@{Failed__SOCstartup}    @{EMPTY}
@{Failed__SOCsendcommand}    @{EMPTY}


*** Test Cases ***
DTC Clear
    [Documentation]    PowerOffOn
    testcase_iterator.Add Test Cases    EnvD_SysQual_Diagnostics_DTC_NoETHConnectionToMainBlade    5


*** Keywords ***
Teststeps
    [Documentation]    The test steps are executed for Power off on test
    Log To Console    Hi Starting the test for clear DTC
    # Clear DTC command
    prj.sut.power cycle
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    2s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

EnvD SysQual Diagnostics DTC NoETHConnectionToMainBlade
    [Documentation]    In case no ethernet link is established to Main Blade(Port 9)
    ...     after 5000ms upon system boot up,DTC shall be logged.
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-371276    FID-2441939

    # Shutdown the System and q5050 switchboard
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    Battery    0
    # bits_platform.Output Set Analog Signal Value    Ignition    0
    bits_platform.Output Set Analog Signal Value    Q5050    0
    Sleep    2s
    # Turn back on the board
    # bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.simulation.PowerBladeON
    Sleep    6s

    # Turn ON Q5050 switch
    bits_platform.Output Set Analog Signal Value    Q5050    12
    Sleep    10s
    # Check DTC
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    Sleep    3s
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_NoETHConnectionDTC_Resp}
