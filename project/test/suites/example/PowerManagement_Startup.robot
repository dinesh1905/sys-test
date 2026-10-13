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



*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_Startup_BootupTiming_MCUAurix
    [Documentation]    Boot-up timing for entire subsystem shall follow:
    ...    MCU:Boot timing until full operation: ~500ms and Full funtionality available: 500ms
    [Tags]    POWER    462078.1039421,462078.2203126

    prj.sut.connect.dlt
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Log To Console    Traces in SCC console(DTL)

    # Verify DLT keyword    GssPowerUp SwitchOnPowerRail
    # ...    GssPowerUp CPU Activated
    # ...    BswM_RequestMode [PRJ_OpeMode_RUN]
    # ...    SendCanSignal [RUN_ACK]

    Verify DLT keyword offline    GssPowerUp SwitchOnPowerRail
    ...    GssPowerUp CPU Activated
    ...    BswM_RequestMode [PRJ_OpeMode_RUN]
    ...    SendCanSignal [RUN_ACK]

    Log To Console    Measure timing from "[PowerM] OnInit" until "[EcuM] OnEnterKssRun" in SCC trace
    Check duration    500    DTL    [PowerM] OnInit    [EcuM] OnEnterKssRun


EnvD_SysQual_PowerManagementSubsystem_Startup_ BootupTiming-CANTransceiver
    [Documentation]    Boot-up timing for entire subsystem shall follow:
    ...    CAN Transceiver:Boot timing until full operation: ~30ms Full funtionality available: 500ms
    [Tags]    POWER    462078.1039421,462078.2203126

    prj.sut.connect.dlt
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Log To Console    Traces in SCC console(DTL)

    # Verify DLT keyword
    Verify DLT keyword offline    [PowerM] GssPowerUp SwitchOnPowerRail
    ...    [PowerM] GssPowerUp CPU Activated
    ...    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
    ...    [PowerM] SendCanSignal [RUN_ACK]

    Log To Console    Measure timing from "[PowerM] OnInit" until "[EcuM] OnEnterKssRun" in SCC trace
    # Check duration    30    DTL    [StmProxy] Send ALIVE_REQUEST to soc [INC]    [PowerM] SendCanSignal
    Check duration    210    DTL    [StmProxy] Send ALIVE_REQUEST to soc [INC]    [PowerM] SendCanSignal
    Check duration    500    CAN     Link:Link_up Ports:Blade_MaaS_uC    Authenticat_MaaS

EnvD_SysQual_PowerManagementSubsystem_Startup_ BootupTiming-ETHSwitch
    [Documentation]    Boot-up timing for entire subsystem shall follow:
    ...    ETH Switch:- Boot timing until full operation: more than 300ms- Full funtionality available: 500ms
    [Tags]    POWER    462078.1039421,462078.2203126

    prj.sut.connect.dlt
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Log To Console    Traces in SCC console(DTL)

    # Verify DLT keyword
    Verify DLT keyword offline    [PowerM] GssPowerUp SwitchOnPowerRail
    ...    [PowerM] GssPowerUp CPU Activated
    ...    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
    ...    [PowerM] SendCanSignal [RUN_ACK]

    Log To Console    Measure timing from start of supply voltage until "[PowerM] GssPowerUp Switch on UxxS_ETH_ON" show up in SCC trace.
    Check duration    3500    DTL    [StmProxy] Send ALIVE_REQUEST to soc [INC]    [PowerM] KssPowerUp Switch on UxxS_ETH_ON
    Check duration    500    ETH     Link:Link_up Ports:Blade_MaaS_uC    LinkSpeed:100Mbit/s

# EnvD_SysQual_PowerManagementSubsystem_Startup_ BootupTiming-SoC
#     [Documentation]    Boot-up timing for entire subsystem shall follow:
#     ...    SoC (Other SIP):Boot timing until full operation: ~45 seconds and Full funtionality available: ~ 60 seconds
#     [Tags]    POWER    462078.1039421,462078.2203126

#     prj.sut.connect.dlt
#     prj.sut.power off
#     prj.sut.can.simulation.Stop
#     prj.sut.can.simulation.Start
#     prj.sut.power on
#     prj.sut.can.simulation.PowerBladeON
#     Log To Console    Traces in SCC console(DTL)

#     Verify DLT keyword    [PowerM] GssPowerUp SwitchOnPowerRail
#     ...    [PowerM] GssPowerUp CPU Activated
#     ...    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
#     ...    [PowerM] SendCanSignal [RUN_ACK]

#     Log To Console    Measure timing from start of supply voltage until [StmProxy] Receive COM_READY from soc [INC] show up in SCC trace.
#     Check duration    4500    DTL    Measure timing from start of supply voltage    [StmProxy] Receive COM_READY from soc [INC]

# EnvD_SysQual_PowerManagementSubsystem_Startup_ BootupTiming-SerializerDeserializer
#     [Documentation]    Boot-up timing for entire subsystem shall follow:
#     ...    Serializer & De-serializer:Boot timing until full operation: ~300ms and Full funtionality available: ~ 60 seconds
#     [Tags]    POWER    462078.1039421,462078.2203126

#     # prj.sut.connect.dlt
#     # prj.sut.power off
#     # prj.sut.can.simulation.Stop
#     # prj.sut.can.simulation.Start
#     # prj.sut.power on
#     # prj.sut.can.simulation.PowerBladeON
#     # Log To Console    Traces in SCC console(DTL)

#     Verify DLT keyword    [PowerM] GssPowerUp SwitchOnPowerRail
#     ...    [PowerM] GssPowerUp CPU Activated
#     ...    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
#     ...    [PowerM] SendCanSignal [RUN_ACK]

# EnvD_SysQual_PowerManagementSubsystem_Startup_ BootupTiming-A2B
#     [Documentation]    "Boot-up timing for entire subsystem shall follow:
#     ...    A2B:Boot timing until full operation: ~1.5 seconds and funtionality available: ~ 60 seconds
#     [Tags]    POWER    462078.1039421,462078.2203126

#     prj.sut.connect.dlt
#     prj.sut.power off
#     prj.sut.can.simulation.Stop
#     prj.sut.can.simulation.Start
#     prj.sut.power on
#     prj.sut.can.simulation.PowerBladeON
#     Log To Console    Traces in SCC console(DTL)

#     Verify DLT keyword    [PowerM] GssPowerUp SwitchOnPowerRail
#     ...    [PowerM] GssPowerUp CPU Activated
#     ...    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
#     ...    [PowerM] SendCanSignal [RUN_ACK]

