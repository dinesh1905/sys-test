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
Suite Setup         setups.Set Up Test Suite
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case


*** Variables ***
${COUNTERPLUS1}        1


*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoringWithInterbladeSignal
    [Documentation]    Check on general voltage reading
    [Tags]    POWER    fid-1275341,2655699    tcid-195840    FULLTEST
    Log To Console    Hi

    prj.sut.disconnect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    prj.sut.can.initandloadconfiguration
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON

    bits_platform.Output Set Analog Signal Value    Battery    16.4

    Verify DLT keyword    .*First UBAT voltage is 16.4V*.
    ...    .*SendCanSignal Voltage validity = valid*.    .*SendCanSignal Voltage value = 1640*.

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_VoltageRangeMonitoring
    [Documentation]    To set and get the power voltage
    [Tags]    POWER    fid-1275380,1275382,1275400,1275417    tcid-195842    FULLTEST

    Set Log Level    DEBUG
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    prj.sut.can.simulation.PowerBladeON
    bits_platform.Output Set Analog Signal Value    Battery    12

    # check if DLT captures normal voltage keyword to indicate the voltage is normal
    Verify DLT keyword    ${sut.power.DLT.normalvoltage_3}

    # set voltage to under voltage
    bits_platform.Output Set Analog Signal Value    Battery    7

    # check voltage becomes under voltage in DLT
    Verify DLT keyword    ${sut.power.DLT.undervoltage}

    # set voltage to critical under voltage
    bits_platform.Output Set Analog Signal Value    Battery    5.5

    # check voltage becomes critical under voltage in DLT
    Verify DLT keyword    ${sut.power.DLT.critical_undervoltage}

    # set voltage to over voltage
    bits_platform.Output Set Analog Signal Value    Battery    20.0

    # check voltage becomes over voltage in DLT
    Verify DLT keyword    ${sut.power.DLT.overvoltage}

EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeNotWokenByCANSupportPOR
    [Documentation]    MaaS Blade should no wake up by CAN. MaaS Blade support POR.
    ...    Only Power Blade can enable individial blades to be powered up.
    [Tags]    POWER    fid-1039453    tcid-195833    FULLTEST

    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    prj.sut.can.simulation.PowerBladeON

    # Shut down Maas Blade
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    Battery    0
    ${b_ack}    ${s_result}    bits_platform.Input Get Signal Value    Battery_Current
    Log To Console    Current consumption is ${s_result}
    IF    ${s_result} == 0
        Log To Console    Current shown ${s_result}. Device has been shut down.
    ELSE
        Set Test Status To Fail    Device did not shut down.
    END

    # Sending a CAN Message to check if DUT wakes up.
    ${Status}    Run Keyword And Return Status
    ...    bits_platform.Rbs Set Variable Value
    ...    1
    ...    SYSTEM
    ...    PowerBlade::OpStateSignal
    ...    1

    IF    ${Status} == True
        ${b_ack}    ${s_result}    bits_platform.Input Get Signal Value    Battery_Current
        IF    ${s_result} == 0
            Log    The current ${s_result} .Device did not wake up.Test Case PASS    console=yes
            ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    12
        ELSE
            Log    FAIL!! Device current is ${s_result} and not 0    console=yes
            framework.Set Test Status To Fail
        END
    ELSE
        Log To Console    FAIL!!! Unable to send CAN Message
        framework.Set Test Status To Fail    power    FAIL!!! Unable to send CAN Message
    END

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition
    [Documentation]    MaaS Blade should have following condition/behavior
    ...    when entering HVI Some functions will be switch OFF or switched
    ...    to low power cunsumption mode to protect device from overhearting or damage.
    [Tags]    POWER    fid-1039453    tcid-213170    FULLTEST

    prj.sut.disconnect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    # prj.sut.power cycle
    # prj.sut.can.simulation.PowerBladeON
    prj.sut.connect.dlt

    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    1s
    bits_platform.Output Set Analog Signal Value    Battery    17.5
    prj.sut.can.simulation.PowerBladeON
    Verify DLT keyword    ${sut.power.DLT.normalvoltage_3}

    # Set voltage to high voltage
    bits_platform.Output Set Analog Signal Value    Battery    17.6
    Verify DLT keyword    ${sut.power.DLT.overvoltage}

    bits_platform.Output Set Analog Signal Value    Battery    17.5
    prj.sut.can.simulation.PowerBladeON
    Verify DLT keyword    ${sut.power.DLT.normalvoltage_3}

    # Set voltage to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    16.5
    ${status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME}
    ...    search_pattern=${sut.power.DLT.normalvoltage}
    ...    timeout=20
    Log To Console    Matched! ${status}

    Log To Console    The status of verified step is "${status}"
    IF    ${status} == False
        Log To Console    Pass did not go into normal voltage
    ELSE
        Log To Console    Fail went into normal voltage
        framework.Set Test Status To Fail    power    Fail went into normal voltage
    END

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_LowVoltageCondition
    [Documentation]    MaaS Blade will go to LVI mode when it is below 8.9v
    ...    and above 6.3v
    [Tags]    POWER    fid-1039453    tcid-213172    FULLTEST

    prj.sut.disconnect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    prj.sut.can.simulation.PowerBladeON

    Sleep    1s
    bits_platform.Output Set Analog Signal Value    Battery    8.8
    Verify DLT keyword    ${sut.power.DLT.normalvoltage}

    # Set voltage to under voltage
    bits_platform.Output Set Analog Signal Value    Battery    8.7
    Verify DLT keyword    ${sut.power.DLT.undervoltage}

    # Set voltage to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    9.8
    ${status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME}
    ...    search_pattern=${sut.power.DLT.normalvoltagenormalvoltage}
    ...    timeout=20
    Log To Console    Matched! ${status}

    Log To Console    The status of verified step is "${status}"
    IF    ${status} == False
        Log To Console    Pass did not go into normal voltage
    ELSE
        Log To Console    Fail went into normal voltage
        framework.Set Test Status To Fail    power    Fail went into normal voltage
    END

    # Set voltage to under voltage
    bits_platform.Output Set Analog Signal Value    Battery    6.3
    Verify DLT keyword    ${sut.power.DLT.undervoltage}

    # Set voltage to critical under voltage
    bits_platform.Output Set Analog Signal Value    Battery    6.2
    Verify DLT keyword    ${sut.power.DLT.critical_undervoltage}

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_CriticalLowVoltageCondition
    [Documentation]    MaaS Blade will go to critical LVI mode when it is below 6.3v
    [Tags]    POWER    fid-1039453    tcid-213171    FULLTEST

    prj.sut.disconnect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    prj.sut.can.simulation.PowerBladeON
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s
    Verify DLT keyword    ${sut.power.DLT.undervoltage}

    # Set voltage to under voltage
    bits_platform.Output Set Analog Signal Value    Battery    6.3
    Verify DLT keyword    ${sut.power.DLT.undervoltage}

    # Set voltage to critical under voltage
    bits_platform.Output Set Analog Signal Value    Battery    6.2
    Verify DLT keyword    ${sut.power.DLT.critical_undervoltage}

    bits_platform.Output Set Analog Signal Value    Battery    7.0
    ${status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME}
    ...    search_pattern=${sut.power.DLT.undervoltage}
    ...    timeout=20
    Log To Console    Matched! ${status}

    Log To Console    The status of verified step is "${status}"
    IF    ${status} == False
        Log To Console    Pass did not go into undervoltage and still in critical under voltage
    ELSE
        Log To Console    Fail went into undervoltage
        framework.Set Test Status To Fail    power    Fail went into undervoltage. only when voltage is 7.1V it will go to undervoltage state.
    END

    # Set voltage to under voltage
    bits_platform.Output Set Analog Signal Value    Battery    7.1
    Verify DLT keyword    ${sut.power.DLT.undervoltage}

    # Set voltage to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    12
    Verify DLT keyword    ${sut.power.DLT.normalvoltage}

EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorMCUPowerSequence
    [Documentation]    MCU should follow proper startup and shutdown sequence based on traces from SCC console.(row9)
    [Tags]    POWER    fid-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875    tcid-195843    FULLTEST

    prj.sut.connect.dlt
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON

    Verify DLT keyword    \\[PowerM] OnInit
    ...     Set PWR_HOLD pin to ACTIVE
    ...     Enable UART trace supply
    ...     Enable CPU_RESET
    ...     \\[EcuM] OnEnterWakeup
    ...     RecvCanSignal \\[PRE_RUN]
  #  ...     BswM_RequestMode \\[PRJ_OpeMode_PRE_RUN]
    ...     BswM_RequestMode \\[PRJ_RackMode_PRE_RUN]
    ...     SendCanSignal \\[PRE_RUN_ACK]
    ...     \\[EcuM] OnEnterPreRun
    ...     OnDriveUp
    ...     KssPowerUp InitFusaWdg
    ...     KssPowerUp Disable CPU_RESET
    ...     GssPowerUp Set PMIC_PGOOD_BL2 pin to ACTIVE
  # ...     KssPowerUp SwitchOnMainSupplies
    ...     GssPowerUp SwitchOnPowerRail
    ...     OnDriveUpComReady
    ...     OnEnterRunMode
    ...     OnEnterKssRun
    ...     GssPowerUp Enable MAX20877
    ...     GssPowerUp MiscSupplies
    ...     GssPowerUp Enable CPU
    ...     GssPowerUp CPU Activated
    # wait for YZ comment on the sequence of these 3 signals
    ...     \\[CPF_Test] Simulate SOC startup complete
    ...     BswM_RequestMode \\[PRJ_OpeMode_PRE_RUN_DONE]
    ...     SendCanSignal \\[PRE_RUN_RESPONSE]
    ...     RecvCanSignal \\[RUN]
    ...     BswM_RequestMode \\[PRJ_OpeMode_RUN]
    ...     SendCanSignal \\[RUN_ACK]
    ...     CPF_Test] Simulate SOC RUN complete \\(idle, ready to shutdown\\)
    ...     BswM_RequestMode \\[PRJ_OpeMode_RUN_DONE]
    ...     SendCanSignal \\[RUN_RESPONSE]

    prj.sut.can.simulation.PowerBladeOFF

    Verify DLT keyword    \\[PowerM] RecvCanSignal \\[PREPARE_SHUTDOWN]
    ...    \\[PowerM] BswM_RequestMode \\[PRJ_OpeMode_PRE_SHUTDOWN]
    ...    SendCanSignal \\[PRE_SHUTDOWN_ACK]
    ...    \\[CPF_Test] Simulate SOC shutdown complete
    ...    \\[PowerM] BswM_RequestMode \\[PRJ_OpeMode_PRE_SHUTDOWN_DONE]
    ...    \\[EcuM] OnEnterPostRun
    ...    \\[EcuM] OnEnterPrepShutdown
    ...    \\[PowerM] OnDriveDown
    ...    \\[PowerM] OnEnterUnknownPowerMode
    ...    \\[PowerM] KssPowerDown DoFastCPUPoff
    ...    \\[PowerM] KssPowerDown Disable CPU
    ...    \\[PowerM] KssPowerDown MiscSupplies
    ...    \\[PowerM] KssPowerDown Disable MAX20877
    ...    \\[PowerM] KssPowerDown SwitchOffMainSupplies
    ...    \\[PowerM] OnEnterSleep
    ...    SendCanSignal \\[PRE_SHUTDOWN_RESPONSE]
    ...    \\[PowerM] RecvCanSignal \\[SHUTDOWN]
    ...    \\[PowerM] BswM_RequestMode \\[PRJ_OpeMode_SHUTDOWN]
    ...    SendCanSignal \\[SHUTDOWN_ACK]
    ...    SendCanSignal \\[SHUTDOWN_RESPONSE]
    ...    \\[PowerM] Shutdown ComM Channel Completed
    ...    \\[PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE
    ...    \\[PowerM] Set PWR_HOLD pin to INACTIVE
    Sleep    10s
    # REMOVE THIS VERIFICATION METHOD

    # ${ack}    ${sResult}    bits_platform.Rbs Get Signal Value    1    CAN    1
    # ...    OPMM_MAAS    OperatingModeResponse_MaaSBlade
    # IF    ${sResult} == 8
    #     prj.sut.toellner off
    #     Log to Console    Maas Blade Shutdown Successfully
    # ELSE
    #     Log to Console    Maas Blade FAIL to Shutdown Successfully
    #     ${sResult}    Set Variable    ${sResult}
    #     Set Test Status To Fail    power    OperatingModeResponse_MaaSBlade value is supposed to be 8 but we got ${sResult}
    # END
    ${Canoe_txt}    Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    Should Contain    ${Canoe_txt}    CAN RX: OPMM_MAAS 0x15 [SHUTDOWN_COMPLETED]
    Should Not Contain    ${Canoe_txt}    elapsed without response

    prj.sut.disconnect.dlt

EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorSoCPowerSequence
    [Documentation]    SOC should follow proper startup sequence and shutdown sequence based on traces from SCC console.
    [Tags]    POWER    fid-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875    tcid-195838    FULLTEST
    prj.sut.connect.dlt
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Verify DLT keyword    \\[PowerM] GssPowerUp Set PMIC_PGOOD_BL2 pin to ACTIVE
    ...    \\[PowerM] GssPowerUp Enable MAX20877 success
    ...    \\[PowerM] GssPowerUp Enable CPU
    ...    \\[PowerM] GssPowerUp SwitchOnSocPower  # ---->SwitchOnSocPower --> to check which comes first
    ...    \\[PowerM] GssPowerUp Enable CPU success
    ...    \\[PowerM] GssPowerUp CPU Activated

    Log To Console    SOC startup is correct
    Sleep    60s
    prj.sut.can.simulation.PowerBladeOFF

    Verify DLT keyword    \\[PowerM] KssPowerDown Disable CPU
    ...    \\[PowerM] KssPowerDown SwitchOffPowerRail
    ...    \\[PowerM] KssPowerDown Disable MAX20877
    ...    \\[PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE

    Log To Console    SOC shutdown is correct

    Sleep    30s
    # TO CHANGE NEW VERIFICATION METHOD
    # ${ack}    ${sResult}    bits_platform.Rbs Get Signal Value    1    CAN    1
    # ...    OPMM_MAAS    OperatingModeResponse_MaaSBlade
    # IF    ${sResult} == 8
    #     prj.sut.toellner off
    #     Log to Console    Maas Blade Shutdown Successfully
    # ELSE
    #     Log to Console    Maas Blade FAIL to Shutdown Successfully
    #     ${sResult}    Set Variable    ${sResult}
    #     Set Test Status To Fail    power    OperatingModeResponse_MaaSBlade value is supposed to be 8 but we got ${sResult}
    # END

    ${Canoe_txt}    Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    Should Contain    ${Canoe_txt}    CAN RX: OPMM_MAAS 0x15 [SHUTDOWN_COMPLETED]
    Should Not Contain    ${Canoe_txt}    elapsed without response

EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoring
    [Documentation]    MaaS Blade should produces traces with voltage value in SCC console.
    [Tags]    POWER    fid-1275341    tcid-195837    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    prj.sut.can.simulation.PowerBladeON

    Verify DLT keyword    First UBAT voltage is 12.00V

    # Adjust KL30 voltage to +/- 2.0V.
    bits_platform.Output Set Analog Signal Value    Battery    14
    Verify DLT keyword    UBAT voltage is 14.00V
    Log To Console    Voltage reading is reflected correctly in SCC console

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_NormalOperationCondition
    [Documentation]    When supply voltage is in operation voltage range,power management subsystem and other subsystems will carry out full
    ...    operation mode as per defined.
    [Tags]    POWER    fid-1275380    tcid-213374    FULLTEST

    prj.sut.disconnect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    prj.sut.can.simulation.PowerBladeON

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    1s

    bits_platform.Output Set Analog Signal Value    Battery    17.5
    Verify DLT keyword    ${sut.power.DLT.normalvoltage}

    bits_platform.Output Set Analog Signal Value    Battery    17.6
    Verify DLT keyword    ${sut.power.DLT.overvoltage}

    # Set voltage to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    12.0
    Verify DLT keyword    ${sut.power.DLT.normalvoltage}

    # Set voltage to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    8.8
    ${status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME}
    ...    search_pattern=${sut.power.DLT.undervoltage}
    ...    timeout=20
    Log To Console    Matched! ${status}

    Log To Console    The status of verified step is "${status}"
    IF    ${status} == False
        Log To Console    Pass did not go into undervoltage
    ELSE
        Log To Console    Fail went into undervoltage
        framework.Set Test Status To Fail    power    Fail went into undervoltage. 8.8V should be in normal voltage.
    END

    # Set voltage to under voltage
    bits_platform.Output Set Analog Signal Value    Battery    8.7
    Verify DLT keyword    ${sut.power.DLT.undervoltage}

# EnvD_SysQual_PowerManagementSubsystem_General_TemperatureMonitoringWithInterbladeSignal
#    [Documentation]    MaaS Blade should produces traces with temperature value
#    ...    (with interblade signal, -ve, +ve, 1 degree resolution) in SCC console.
#    [Tags]    POWER    requirementID=
#    ...    TCID-195832    FULLTEST
#    prj.sut.connect.dlt
#    prj.sut.power cycle
#    prj.sut.can.simulation.PowerBladeOFF
#    prj.sut.can.simulation.PowerBladeON

#    # 40    <=    ${normal_temp} <= 43

#    ${startup_list}=    Create List    [PowerM] SendCanSignal MaaS Temperature validity = valid
#    ...    [PowerM] SendCanSignal Raw temperature of NTC sensor near SOC, Display
#    # = 82.

#    ${pattern_length}=    Get Length    ${startup_list}

#    FOR    ${index}    IN RANGE    0    ${pattern_length}
#    Log To Console    ${startup_list[${index}]}
#    ${res}=    Verify    conn_name=${CONNECTION_NAME}
#    ...    search_pattern=${startup_list[${index}]}
#    ...    timeout=20
#    Log To Console    ${res} MaaS Temperature value is displayed correctly
#    END

# EnvD_SysQual_PowerManagementSubsystem_General_MonitorOverallTemperatureValue(HighestValue)
#    [Documentation]    MaaS Blade use highest temperature value as overall temperature value.
#    [Tags]    POWER    FID-1275340
#    ...    TCID-195831
#    prj.sut.connect.dlt
#    prj.sut.power cycle
#    prj.sut.can.simulation.PowerBladeOFF
#    prj.sut.can.simulation.PowerBladeON

#    ${res}=    Verify    conn_name=${CONNECTION_NAME}
#    ...    search_pattern=[Temperature] Current overall Temperature is
#    ...    timeout=20
#    Log To Console    ${res}. MaaS Overall Temp is displayed correctly

EnvD_SysQual_PowerManagementSubsystem_General_CANSimulationToTriggerStartup/ShutdownToMaasBlade
    [Documentation]    Use CAN simulation to trigger MaaS Blade to startup and obtained startup traces.
    ...    Use CAN simulation to trigger Maas Blade to shutdown and obtained shutdown traces.
    [Tags]    POWER    fid-462078.1376730,462078.1039450    tcid-195836    FULLTEST
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.power on
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON

    @{pattern_list}    Create List    CAN TX: OPMM_Power 0x10 [NO_REQUEST]
    ...    CAN TX: OPMM_Power 0x10 [PRE_RUN]
    ...    CAN RX: OPMM_MAAS 0x15 [IN_PRE_RUN]
    ...    CAN RX: OPMM_MAAS 0x15 [PRE_RUN_COMPLETED]
    ...    CAN TX: OPMM_Power 0x10 [RUN]
    ...    CAN RX: OPMM_MAAS 0x15 [IN_RUN]
    Sleep    30s
    ${Canoe_txt}    Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}
        Should Not Contain    ${Canoe_txt}    elapsed without response
    END
    Log To Console    MaaS Startup CAN sequence message is displayed correctly

    prj.sut.can.simulation.PowerBladeOFF

    @{Shutdown_list}    Create List    CAN TX: OPMM_Power 0x10 [PREPARE_SHUTDOWN]
    ...    CAN RX: OPMM_MAAS 0x15 [IN_PREPARE_SHUTDOWN]
    ...    CAN RX: OPMM_MAAS 0x15 [PREPARE_SHUTDOWN_COMPLETED]
    ...    CAN TX: OPMM_Power 0x10 [SHUTDOWN]
    ...    CAN RX: OPMM_MAAS 0x15 [IN_SHUTDOWN]
    ...    CAN RX: OPMM_MAAS 0x15 [SHUTDOWN_COMPLETED]

    Sleep    60s
    ${Canoe_txt}    Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{Shutdown_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}
        Should Not Contain    ${Canoe_txt}    elapsed without response
    END
    Log To Console    MaaS Shutdown CAN sequence message is displayed correctly

EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeOFFState
    [Documentation]    MaaS Blade should be fully OFF and no standby mode upon request from Power Blade.
    [Tags]    POWER    fid-1039451,1039452    tcid-195834    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle

    Verify DLT keyword    # ...    OnDriveUp
    # ...    PowerM_CssPowerUp_InitFusaWdg
    # ...    PowerM_CssPowerUp_SwitchOnMainSupplies
    # ...    OnDriveUpComReady
    # ...    ECU current operational mode ID: 4
    # ...    POWERM_SM_DRIVE_POWER_UP_STATE
    # ...    POWERM_SM_DRIVE_POWER_UP_COMRDY_STATE
    # ...    PowerM_CssPowerUp_MiscSupplies
    #  ...    \\[PowerM] KssPowerUp SwitchOnMainSupplies
    ...    \\[PowerM] GssPowerUp SwitchOnPowerRail
    ...    \\[PowerM] GssPowerUp CPU Activated
    ...    \\[PowerM] BswM_RequestMode \\[PRJ_RackMode_RUN]
    ...    SendCanSignal \\[RUN_ACK]
    Log To Console    SOC startup is correct

    prj.sut.can.simulation.PowerBladeOFF

    Verify DLT keyword    # ...    OnDriveDown
    # ...    ECU current operational mode ID: 6
    # ...    ECU current operational mode ID: 7
    # ...    POWERM_SM_DRIVE_POWER_DOWN_STATE
    # ...    PowerM_CssPowerDown_MiscSupplies
    # ...    PowerM_CssPowerDown_SwitchOffMainSupplies
    ...    \\[PowerM] KssPowerDown Disable CPU
 #   ...    \\[PowerM] KssPowerDown SwitchOffMainSupplies
    ...    \\[PowerM] KssPowerDown SwitchOffPowerRail
    ...    \\[PowerM] BswM_RequestMode \\[PRJ_RackMode_SHUTDOWN]
    ...    \\[PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE
    ...    \\[PowerM] Set PWR_HOLD pin to INACTIVE

    Log To Console    SOC shutdown sequence is correct
    Sleep    15s

    # ${ack}    ${sResult}    bits_platform.Rbs Get Signal Value    1    CAN    1    OPMM_MAAS    OperatingModeResponse_MaaSBlade
    # IF    ${sResult} == 8
    #     prj.sut.toellner off
    #     Log to Console    Maas Blade Shutdown Successfully
    # ELSE
    #     Log to Console    Maas Blade FAIL to Shutdown Successfully
    #     ${sResult}    Set Variable    ${sResult}
    #     Set Test Status To Fail    error_type=RBS    info_text=OperatingModeResponse_MaaSBlade value is supposed to be 8 but we got ${sResult}
    # END

    prj.sut.toellner off
    Log to Console    Maas Blade Shutdown Successfully
    ${b_ack}    ${s_result}    bits_platform.input get signal value    Battery_Current
    Log To Console    ${b_ack} ${s_result}

    IF    "${s_result}" <= "0.0000000000"
        Log    The current is ${s_result}    console=yes
    ELSE
        Log To Console    Current is still available.
        framework.Set Test Status To Fail    power    Current is still available at ${s_result}
    END

EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorSoCPowerSequenceOnQNXConsole
    [Documentation]    SOC should follow proper startup sequence and shutdown sequence based on traces from QNX console.
    [Tags]    POWER    fid-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875    tcid-195839    FULLTEST
    prj.sut.power off
    prj.sut.connect.QNX
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON

    Verify QNX keyword    Startup done
    Sleep    10s
    # Verify console able to send command and receive response
    Verify QNX keyword    VERSION=    command=cat mnt/Buildinfo.txt

    Sleep    30s

    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    Sleep    5s
    # NEW VERIFICATION METHOD BELOW
    # ${ack}    ${sResult}    bits_platform.Rbs Get Signal Value    1    CAN    1
    # ...    OPMM_MAAS    OperatingModeResponse_MaaSBlade
    # Log To Console    OperatingModeResponse_MaaSBlade value is ${sResult}
    # IF    ${sResult} == 8
    #     prj.sut.toellner off
    #     Log to Console    Maas Blade Shutdown Successfully
    # ELSE
    #     Log to Console    Maas Blade FAIL to Shutdown Successfully
    #     ${sResult}    Set Variable    ${sResult}
    #     Set Test Status To Fail    error_type=RBS    info_text=OperatingModeResponse_MaaSBlade value is supposed to be 8 but we got ${sResult}
    # END

    Verify DLT keyword    \\[PowerM] Set PWR_HOLD pin to INACTIVE
    prj.sut.toellner off
    Log to Console    Maas Blade Shutdown Successfully

    ${Status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME_QNX}
    ...                                                      send_cmd=cat /mnt/Buildinfo.txt
    ...                                                      search_pattern=.*
    ...                                                      timeout=10

    Log To Console    The status of verified step is "${Status}"
    IF    ${Status} == False
        Log To Console    QNX Shutdown Successfully.Test Case PASS
    ELSE
        Log To Console    QNX Shutdown Sequence Failed
        framework.Set Test Status To Fail    power    QNX Shutdown Sequence Failed
    END
