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
${HightVoltage_Value}    20.8
${NormalVoltage_HighThresholdValue}    12.0
${UnderVoltage}    5.5
${CriticalUnderVoltage}    4.5
${NormalVoltage_LowThresholdValue}    18.1

*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_PowerHandling_LowVoltageCondition_InternalBuck-BoostRegulatorForCamera-A2B-100us
    [Documentation]    Set UBAT from 14.0V to 5.0V and last for 100us before return to 14.0V. 
    ...     A2B and cameras remain working. No hiccup observed.
    ...     Traces related to undervoltage state should not showing up
    [Tags]    POWER    FID-462078.1275402    TCID-408339    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    bits_platform.Output Set Analog Signal Value    powercurve_battery    5
    Sleep    0.0001
    Check Test point voltage    zero    camera_VDC
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    Sleep    60s
    Check Test point voltage    equalto    camera_VDC



EnvD_SysQual_PowerManagementSubsystem_PowerHandling_LowVoltageCondition_InternalBuck-BoostRegulatorForCamera-A2B-1ms
    [Documentation]    Set UBAT from 14.0V to 5.0V and last for 1ms before return to 14.0V.
    ...     A2B and cameras remain working. No hiccup observed. Traces related to undervoltage state should not showing up.
    [Tags]    POWER    FID-462078.1275402    TCID-408337    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    bits_platform.Output Set Analog Signal Value    powercurve_battery    5
    Sleep    0.001
    Check Test point voltage    zero    camera_VDC
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    Check Test point voltage    euqalto    camera_VDC
    Log To Console    Traces in SCC console(DTL)
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.critical_undervoltage_2}
    Verify DLT keyword offline    OnEnterNormalVoltage
    prj.sut.disconnect.QNX

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_LowVoltageCondition_InternalBuck-BoostRegulatorForCamera-A2B-200us
    [Documentation]    Set UBAT from 14.0V to 5.0V and last for 200us before return to 14.0V.
    ...     A2B and cameras remain working. No hiccup observed. Traces related to undervoltage state should not showing up.
    [Tags]    POWER    FID-462078.1275402    TCID-408340    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    bits_platform.Output Set Analog Signal Value    powercurve_battery    5
    Sleep    10s
    Check Test point voltage    zero    camera_VDC
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    Sleep    60s
    Check Test point voltage    equalto    camera_VDC
    Log To Console    Traces in SCC console(DTL)
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.critical_undervoltage_2}
    Verify DLT keyword offline    OnEnterNormalVoltage
    prj.sut.disconnect.QNX

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_LowVoltageCondition_InternalBuck-BoostRegulatorForCamera-A2B-500us
    [Documentation]    Set UBAT from 14.0V to 5.0V and last for 500us before return to 14.0V.
    ...     A2B and cameras remain working. No hiccup observed. Traces related to undervoltage state should not showing up.
    [Tags]    POWER    FID-462078.    TCID-408338    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    bits_platform.Output Set Analog Signal Value    powercurve_battery    5
    Sleep    10s
    Check Test point voltage    zero    camera_VDC
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    Sleep    60s
   Check Test point voltage    equalto    camera_VDC
    Sleep    3s
    Log To Console    Traces in SCC console(DTL)
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.critical_undervoltage_2}
    Verify DLT keyword offline    OnEnterNormalVoltage
    prj.sut.disconnect.QNX

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_HighVoltageDuration
    [Documentation]    Set UBAT to 20.0V for less than predefined duration
    ...    MaaS Blade should not enter overvoltage state
    ...    2. Set UBAT to 20.0V for more than predefined duration
    ...    MaaS Blade should enter overvoltage state
    [Tags]    POWER    FID-462078.    TCID-370077    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    bits_platform.Output Set Analog Signal Value    powercurve_battery    20
    Sleep    ${sut.power.Duration.Predefined_duration}ms
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    prj.sut.connect.dlt.Verify DLT keyword not present in log    [PowerM] Voltage enters OVERVOLTAGE range
    Verify DLT keyword offline    OnEnterNormalVoltage
    bits_platform.Output Set Analog Signal Value    powercurve_battery    20
    Sleep    ${sut.power.Duration.Csample}ms
    Verify DLT keyword offline    [PowerM] Voltage enters OVERVOLTAGE range
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    Sleep    3s
    Verify DLT keyword offline    OnEnterNormalVoltage

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    ...    Set UBAT to 17.5V
    ...    MaaS Blade falls into Normal operation condition with its behavior
    [Tags]    POWER    FID-462078.1456805,462078.1275382,462078.1275387,462078.1275390    TCID-213170        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}    
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerDown. Enter SOC low power mode
    Verify DLT keyword offline  [PowerM] VmPowerDown Disable MAX20877
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    17
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_Memory_load_reduction
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275385,462078.1275386,462078.1275389,462078.1275388    TCID-546127        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}    
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.MaaS_Blade_Reduced_Function_behavior}
    Verify DLT keyword offline  [PowerM] VmPowerDown Disable MAX20877
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_MCU_Autosar_OS
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275391    TCID-546126        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   ${NormalVoltage_HighThresholdValue}    powercurve_battery
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_Camera Phantom
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275392    TCID-546125        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   ${NormalVoltage_HighThresholdValue}    powercurve_battery
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_Microphone Phantom
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275393,462078.1275354    TCID-546130        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   ${NormalVoltage_HighThresholdValue}    powercurve_battery
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON


EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_A2B transceiver
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275394,1043929.3451327    TCID-546129        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   ${NormalVoltage_HighThresholdValue}    powercurve_battery
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_Display_output
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275395,462078.1275354        TCID-546128        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   ${NormalVoltage_HighThresholdValue}    powercurve_battery
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON


EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_Display_input
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275396,462078.1275354        TCID-546124        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   ${NormalVoltage_HighThresholdValue}    powercurve_battery
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_Camera input
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275397,462078.1275354        TCID-546123        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   ${NormalVoltage_HighThresholdValue}    powercurve_battery
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON


EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_CAN_Ethernet_functional
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    [Tags]    POWER    FID-462078.1275398,462078.1275383        TCID-546121        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch off UxxS_CPUPERI_ON
    prj.sut.power.add.voltage.to.dictionary.check   ${NormalVoltage_HighThresholdValue}    powercurve_battery
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline  [PowerM] VmPowerUp. Resume operation
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on MAX20087 VI0123_ON
    Verify DLT keyword offline  [PowerM] VmPowerDown Switch on UxxS_A2B_ON
    Verify DLT keyword offline  [PowerM] VmPowerUp Switch on UxxS_CPUPERI_ON


EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition_to_Normal_functional
    [Documentation]    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition.
    ...    Set UBAT to 17.6V
    ...    MaaS Blade falls into High voltage condition with its behavior.
    ...    Set UBAT to 17.5V
    ...    MaaS Blade remain in Normal operation condition, check functions are back to normal
    [Tags]    POWER    FID-462078.1275398,462078.1275383    TCID-546122        FULLTEST
    Set Test Variable    ${NormalVoltage_HighThresholdValue}    ${NormalVoltage_HighThresholdValue}
    IF    "${sut.auto_flash.hardware_info.sample}" == "sample_C"
        ${HightVoltage_Value}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.HightVoltage_Value}
        ${NormalVoltage_HighThresholdValue}    Set Variable    ${sut.power.channels.sut_Power.output.voltage.Csample.NormalVoltage_HighThresholdValue}
    END
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    ${NormalVoltage_HighThresholdValue}    
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${HightVoltage_Value}    
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.overvoltage_2}
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    ${NormalVoltage_HighThresholdValue}   
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.dlt.disconnect.clear.connect dlt
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Microphone_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
