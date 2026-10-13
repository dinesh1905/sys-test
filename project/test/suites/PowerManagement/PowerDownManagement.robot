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
EnvD_SysQual_PowerManagementSubsystem_PowerDown Management_VBAT-ON-MaaSBlade-OFFwithQuiescentCurrent_MaaSBladeOnly
    [Documentation]    Click "Shutdown" on CAN simulation to trigger shutdown on Maas Blade. 
    ...    [Expected Result] MaaS Blade power down with shutdown traces in SCC console. Quiescent current
    ...     should not more than 20µA.
    [Tags]    POWER    FID-462078.2119864    TCID-326247        FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Sleep    10s
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.usb toggle debug board switch Off
    Verify DLT keyword offline    [PowerM] KssPowerDown Disable CPU
    Verify DLT keyword offline    [PowerM] KssPowerDown SwitchOffPowerRail
    Verify DLT keyword offline    [PowerM] BswM_RequestMode [PRJ_RackMode_SHUTDOWN]
    Verify DLT keyword offline    [PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE
    Verify DLT keyword offline    [PowerM] Set PWR_HOLD pin to INACTIVE
    Log To Console    Read the Target current less than 20µA
    Read the Target current    target_Current    0.002    Lessthan


EnvD_SysQual_PowerManagementSubsystem_PowerDown Management_VBAT-OFF-MaaSBlade-OFFwithQuiescentCurrent_MPCIRack
    [Documentation]    Power management shall ensure current consumption in system is reduce to a minimum of 1µA, 
    ...    when Power blade cuts off power to MaaS Blade. Target of quiescent current when MaaS blade is in off 
    ...    mode is to realize with the maximum of 1µA.
    [Tags]    POWER    FID-462078.1275356,462078.1275357    TCID-326243        FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Sleep    10s
    prj.sut.can.simulation.PowerBladeOFF
        Verify DLT keyword offline    [PowerM] KssPowerDown Disable CPU
    Verify DLT keyword offline    [PowerM] KssPowerDown SwitchOffPowerRail
    Verify DLT keyword offline    [PowerM] BswM_RequestMode [PRJ_RackMode_SHUTDOWN]
    Verify DLT keyword offline    [PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE
    Verify DLT keyword offline    [PowerM] Set PWR_HOLD pin to INACTIVE
    Log To Console    Read the Target current less than 1µA
    Read the Target current    target_current    0.001    Lessthan