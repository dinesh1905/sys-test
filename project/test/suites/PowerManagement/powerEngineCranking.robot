*** Settings ***
Documentation       Example script to set and get voltage
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety    prj.sut.Power.Activate Big Toelner
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_EngineCranking_Cold
    [Documentation]    Click ""Startup/shutdown"" on CAN simulation to trigger startup on MaaS Blade.
    ...     Immediately, initiate power curve (Crank-cold start). [Expected Result] MaaS Blade power up and
    ...     observed MCU startup sequence in SCC console.
    ...    Observe the test setup. [Expected Result] No reset happen. No disturbing audible signal from speaker. 
    ...    No flickering on display.
    [Tags]    POWER    FID-462078.1275362,462078.1275364,462078.1275365    TCID-412021    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    20s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Check flickering on display    START
    Load and check Power Curve    ${sut.power.PowerCurve.E_03a_power_curve}
    Sleep    5s
    Check flickering on display    STOP
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Microphone_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}

EnvD_SysQual_PowerManagementSubsystem_EngineCranking_Warm
    [Documentation]    Click ""Startup/shutdown"" on CAN simulation to trigger startup on MaaS Blade. 
    ...    Immediately, initiate power curve (Crank-warm start). [Expected Result] MaaS Blade power up 
    ...    and observed MCU startup sequence in SCC console.
    ...    No reset happen. No reduction of volume. No disturbing audible signal from speaker. 
    ...    No disturbing audible signal from microphone input. No flickering on display
    ...    Observe the test setup. [Expected Result] No reset happen. No disturbing audible signal from speaker. 
    ...    No flickering on display.
    
    [Tags]    POWER    FID-462078.1275362,462078.1275364,462078.1275365    TCID-412020    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    20s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Check flickering on display    START
    Load and check Power Curve    ${sut.power.PowerCurve.E_03a_power_curve}
    Sleep    5s
    Check flickering on display    STOP
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Microphone_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}