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
Suite Teardown      run keywords    teardowns.Tear Down Test Suite    prj.sut.Power.Deactivate Big Toelner
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_Startup_BootupTiming-MCUAurix
    [Documentation]    Boot-up timing for entire subsystem shall follow:
    ...    MCU:Boot timing until full operation: ~500ms and Full funtionality available: 500ms
    [Tags]    POWER    FID-462078.1039421,462078.2203126    TCID-369366    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
   Log To Console    Measure timing from "[PowerM] OnInit" until "[PowerM] KssPowerUp SwitchOnPowerRail" in SCC trace
   prj.sut.Power.Check duration    500    DTL    [PowerM] OnInit    [PowerM] KssPowerUp SwitchOnPowerRail    Less Than


EnvD_SysQual_PowerManagementSubsystem_Startup_BootupTiming-CANTransceiver
    [Documentation]    Boot-up timing for entire subsystem shall follow:
    ...    CAN Transceiver:Boot timing until full operation: ~30ms Full funtionality available: 500ms
    [Tags]    POWER    FID-462078.1039421,462078.2203126    TCID-369364    FULLTEST

    ${sreach_word}    Set Variable    Authenticat_MaaS
    ${expected_ms}    Set Variable    35
    prj.sut.power inital preconditions    powercurve_battery    12.0
    ${Time_Stamp1}    Get Current Timestamp
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Log To Console    Measure timing from "[PowerM] OnInit" until "[PowerM] SendCanSignal" in SCC trace
    ${Time_Stamp2}    Get the Time log from DTL    [PowerM] SendCanSignal
    ${actual_total_ms}    subtract date from date    ${Time_Stamp2}    ${Time_Stamp1}    Number    False    %Y-%m-%d %H:%M:%S.%f    %Y-%m-%d %H:%M:%S.%f
    IF     ${actual_total_ms} <= ${expected_ms}
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
    ELSE
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
        framework.Set Test Status To Fail    error_type=Power time    info_text=Expected timing be to lees than ${expected_ms}±5 ms, but got ${actual_total_ms} s
    END
    CANlog String Search    Authenticat_MaaS

EnvD_SysQual_PowerManagementSubsystem_Startup_BootupTiming-SoC
    [Documentation]    Boot-up timing for entire subsystem shall follow:
    ...    SoC (Other SIP):Boot timing until full operation: ~45 seconds and Full funtionality available: ~ 60 seconds
    [Tags]    POWER    FID-462078.1039421,462078.2203126    TCID-369365    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    20s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Log To Console    Measure timing from start of supply voltage until [StmProxy] Receive COM_READY from soc [INC] show up in SCC trace.
    prj.sut.Power.Check duration   50000    DTL    [PowerM] OnInit    [StmProxy] Receive COM_READY from soc [INC]    Less Than
    prj.sut.Power.Check duration   65000    DTL    [PowerM] OnInit    [StmProxy] Receive MODE_RUN ack from soc [INC]    Less Than
    Close All Connections
    Open Connection   172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful

EnvD_SysQual_PowerManagementSubsystem_Startup_BootupTiming-SerializerDeserializer
    [Documentation]    Boot-up timing for entire subsystem shall follow:
    ...    Serializer & De-serializer:Boot timing until full operation: ~300ms and Full funtionality available: ~ 60 seconds
    [Tags]    POWER    FID-462078.1039421,462078.2203126    TCID-369362    FULLTEST

    ${expected_ms}    Set Variable    305
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    powercurve_battery    0
    prj.sut.connect.dlt
    prj.sut.can.simulation.PowerBladeON
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    ${Time_Stamp1}    Get Current Timestamp
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12
    prj.sut.connect.QNX
    Sleep    3s
    ${Time_Stamp2}    Get the Time log from DTL    [PowerM] SendCanSignal
    ${actual_total_ms}    subtract date from date    ${Time_Stamp2}    ${Time_Stamp1}    Number    False    %Y-%m-%d %H:%M:%S.%f    %Y-%m-%d %H:%M:%S.%f
    IF     ${actual_total_ms} <= ${expected_ms}
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
    ELSE
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
        framework.Set Test Status To Fail    error_type=Power time    info_text=Expected timing be to lees than ${expected_ms}±5 ms, but got ${actual_total_ms} s
    END
    prj.sut.Power.Check duration    300    DTL    CERBERUS APPLICATION STARTED    [PowerM] KssPowerUp Switch on UxxS_CPUPERI_ON    Less Than
    Sleep    10s
    prj.sut.Power.Start video    Not_Connected
    Sleep    3s
    prj.sut.disconnect.QNX

EnvD_SysQual_PowerManagementSubsystem_Startup_BootupTiming-A2B
    [Documentation]    "Boot-up timing for entire subsystem shall follow:
    ...    A2B:Boot timing until full operation: ~1.5 seconds and funtionality available: ~ 60 seconds
    [Tags]    POWER    FID-462078.1039421,462078.2203126    TCID-369363    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    20s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Log To Console    Traces in SCC console(DTL)
    prj.sut.Power.Check duration    1700    DTL    CERBERUS APPLICATION STARTED    [PowerM] GssPowerUp Switch on UxxS_A2B_ON    Less Than
    Log To Console    A2B network node discovery
    Sleep    3s
    prj.sut.thread.A2BVoltageCheck
    Sleep    3s
    prj.sut.disconnect.QNX

EnvD_SysQual_PowerManagementSubsystem_Startup_ BootupTiming-ETHSwitch
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Measure timing from start of supply voltage until "[PowerM] GssPowerUp Switch on UxxS_ETH_ON" show up in SCC trace.
    ...     [Expected result] The duration should be around 300ms.
    ...    Measure timing from start of supply voltage until CAN simulation show "Link up, 100Mbit/s".
    ...     [Expected result] The duration should be around 500ms.
    [Tags]    POWER    FID-462078.1039421,462078.2203126    TCID-369367    FULLTEST

    ${expected_ms}    Set Variable    305
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    powercurve_battery    0
    prj.sut.connect.dlt
    prj.sut.can.simulation.PowerBladeON
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    ${Time_Stamp1}    Get Current Timestamp
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12
    Sleep    10s
    Log To Console    Measure timing from start of supply voltage until "[PowerM] GssPowerUp Switch on UxxS_ETH_ON
    ${Time_Stamp2}    Get the Time log from DTL    [PowerM] GssPowerUp Switch on UxxS_ETH_ON
    ${actual_total_ms}    subtract date from date    ${Time_Stamp2}    ${Time_Stamp1}    Number    False    %Y-%m-%d %H:%M:%S.%f    %Y-%m-%d %H:%M:%S.%f
    IF     ${actual_total_ms} <= ${expected_ms}
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
    ELSE
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
        framework.Set Test Status To Fail    error_type=Power time    info_text=Expected timing be to lees than ${expected_ms}±5 ms, but got ${actual_total_ms} s
    END
    prj.sut.Power.Check duration    500    CAN     OPMM_MAAS 0x15 [IN_RUN]    Link up, 100Mbit/s    Less Than