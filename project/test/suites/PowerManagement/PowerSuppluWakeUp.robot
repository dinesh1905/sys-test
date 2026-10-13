*** Settings ***
Documentation       Example script to set and get voltage
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults
Library    OperatingSystem

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Variables ***
${HightVoltage_Value}    18.2
${NormalVoltage_HighThresholdValue}    18.1
${UnderVoltage}    5.5
${CriticalUnderVoltage}    4.5
${NormalVoltage_LowThresholdValue}    18.1

*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_PowerSuppluWakeUp_RecordValidWakeUpOccurenceOnSystem
    [Documentation]    "1. Click ""Startup/shutdown"" on CAN simulation to trigger startup on MaaS Blade.
    ...    [Expected Result] MaaS Blade power up with startup traces in SCC console.
    ...    2. Monitor SCC trace.
    ...    [Expected Result] Trace related of recorded valid wakeup should be showing up."
    [Tags]    POWER    FID-1275360    TCID-408344        FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    20s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline    [PowerM] Read OperationCycleCount
    ${output}    prj.sut.connect.dlt.Search the DLT and return matching patterns    [PowerM] Read OperationCycleCount    D:/tmp/LogFile/${TEST_NAME}/log.txt
    ${extract_number}    Extract Temperature Number    ${output}[0]
    Log    ${extract_number}
    Should Be True    ${extract_number} >= 0
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    30s
    Verify DLT keyword offline    [PowerM] Write OperationCycleCount
    ${output1}=    prj.sut.connect.dlt.Search the DLT and return matching patterns    [PowerM] Write OperationCycleCount    D:/tmp/LogFile/${TEST_NAME}/log.txt
    ${extract_number1}=    Extract Temperature Number    ${output1}[0]
    Log    ${extract_number1}
    Should Be True    ${extract_number1} >= 0