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
EnvD_SysQual_PowerManagementSubsystem_PartiallyHWShutDown_PartiallyHardwareShutDownWithAbilitySwitchOffSubsystem_CriticalUnderVoltage
    [Documentation]    Set KL30 voltage to 5.50 < UBAT < 6.50. [Expected result] MaaS Blade enters critical under voltage state with its behavior.
    ...    Set KL30 to 12.0V. [Expected result] MaaS Blade enters normal operating voltage state with its behavior."
    [Tags]    POWER    FID-462078.1039465,462078.1039466,462078.1039467,462078.1039468,462078.1039469,462078.1039470,462078.1039471,462078.1039472,462078.1039473    TCID-370120        FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    5.9
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.critical_undervoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer}
    Sleep    10s
    prj.sut.dlt.disconnect.clear.connect dlt
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    12.0
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_enabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_enabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer_ON}