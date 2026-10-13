*** Settings ***
Documentation       Full Test for all Modules SysTest
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager
Library             Screenshot

# Test Automation Framework
#Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety
Suite Setup    Run Keywords
...    setups.Set Up Test Suite
...    AND    prj.sut.disconnect.safety
...    AND    prj.sut.diag.CopyFile    ${Excel_Source}    ${Excel_Destination}
...    AND    prj.sut.diag.PartNumberUpdate    ${AURIX_VERSION}    ${Excel_Destination}    ${Jsonp_Path}

Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          run keywords    setups.Set Up Test Case    prj.sut.diag.SetVehicleSpeedToZero
Test Teardown       run keywords    teardowns.Tear Down Test Case    prj.sut.diag.SetVehicleSpeedToZero


*** Variables ***
${COUNTERPLUS1}        1
${AURIXDEBUG_VERSION}    ${AURIXDEBUG_VERSION}
${AURIXDEBUG_URL}    ${AURIXDEBUG_URL}
${KDS_FLASH}    ${KDS_FLASH}
${AURIX_VERSION}    ${AURIX_VERSION}
#${AURIX_VERSION}    MAAS_AURIX_PI26.2.0_RC4.2
${SOC_VERSION}    ${SOC_VERSION}
${SAIL_VERSION}    ${SAIL_VERSION}
${Excel_Source}       \\\\bosch.com\\DfsRB\\DfsMY\\LOC\\Pg\\CM\\CM-CI1_ENG\\ENG_Common\\ID_Buzz\\Diagnostic\\VWN-MPCI-PartNumberList.xlsx
${Excel_Destination}    ${TAF_PATH}\\project\\testbench\\config\\Partnumber_code\\VWN-MPCI-PartNumberList.xlsx
${Jsonp_Path}    ${TAF_PATH}\\project\\sut\\all_sut\\diagnostic\\diagnostic.jsonp


*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoringWithInterbladeSignal
    [Documentation]    Check on general voltage reading
    [Tags]    POWER    FID-1275341,2655699    TCID-195840    FULLTEST
    Log To Console    Hi Test is starting

    prj.sut.disconnect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    prj.sut.can.initandloadconfiguration
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON

    prj.sut.power.add.voltage.to.dictionary.check    Battery    16.4

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_VoltageRangeMonitoring
    [Documentation]    To set and get the power voltage
    [Tags]    POWER    FID-1275380,1275382,1275400,1275417    TCID-195842    FULLTEST

    Set Log Level    DEBUG
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    prj.sut.can.simulation.PowerBladeON
    prj.sut.power.add.voltage.to.dictionary.check    Battery    12

    # check if DLT captures normal voltage keyword to indicate the voltage is normal
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}

    # set voltage to under voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    7

    # check voltage becomes under voltage in DLT
    Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

    # set voltage to critical under voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    5.5

    # check voltage becomes critical under voltage in DLT
    Verify DLT keyword offline    ${sut.power.DLT.critical_undervoltage}

    # set voltage to over voltage
    #  prj.sut.power.add.voltage.to.dictionary.check    Battery    20.0
    prj.sut.power.add.voltage.to.dictionary.check    Battery    21.0    #    considering threshold, tolerance and boundary conditions for C sample (new change)

    # check voltage becomes over voltage in DLT
    Verify DLT keyword offline    ${sut.power.DLT.overvoltage}

EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeNotWokenByCANSupportPOR
    [Documentation]    MaaS Blade should no wake up by CAN. MaaS Blade support POR.
    ...    Only Power Blade can enable individial blades to be powered up.
    [Tags]    POWER    FID-1039453    TCID-195833    FULLTEST

    prj.sut.power cycle

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

# EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition    # Commented as the values are for B sample
#     [Documentation]    MaaS Blade should have following condition/behavior
#     ...    when entering HVI Some functions will be switch OFF or switched
#     ...    to low power cunsumption mode to protect device from overhearting or damage.
#     [Tags]    POWER    FID-1039453    TCID-213170    FULLTEST

#     prj.sut.connect.dlt
#     prj.sut.can.simulation.PowerBladeOFF
#     bits_platform.Output Set Analog Signal Value    Battery    0
#     Sleep    1s

#     # Set voltage to normal voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    16.4
#     prj.sut.can.simulation.PowerBladeON
#     Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}

#     # Set voltage to high voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    18.6
#     Verify DLT keyword offline    ${sut.power.DLT.overvoltage}
#     prj.sut.disconnect.dlt
#     Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log1.txt
#     prj.sut.connect.dlt
#     # Set voltage to mantain high voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    18.5
#     prj.sut.can.simulation.PowerBladeON
#     ${status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}
#     Log To Console    Matched! ${status}
#     Log To Console    The status of verified step is "${status}"
#     IF    ${status} == False
#         Log To Console    Pass did not go into normal voltage
#     ELSE
#         Log To Console    Fail went into normal voltage
#         framework.Set Test Status To Fail    power    Fail went into normal voltage
#     END

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_HighVoltageCondition    # C Sample New Change
    [Documentation]    MaaS Blade should have following condition/behavior
    ...    when entering HVI Some functions will be switch OFF or switched
    ...    to low power cunsumption mode to protect device from overhearting or damage.
    [Tags]    POWER    FID-1039453    TCID-213170    FULLTEST

    prj.sut.connect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    1s

    # Set voltage to normal voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    20.0
    prj.sut.can.simulation.PowerBladeON
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}

    # Set voltage to high voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    20.9
    Verify DLT keyword offline    ${sut.power.DLT.overvoltage}
    prj.sut.disconnect.dlt
    Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log1.txt
    prj.sut.connect.dlt
    # Set voltage to mantain high voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    20
    prj.sut.can.simulation.PowerBladeON
    ${status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}
    Log To Console    Matched! ${status}
    Log To Console    The status of verified step is "${status}"
    IF    ${status} == False
        Log To Console    Pass did not go into normal voltage
    ELSE
        Log To Console    Fail went into normal voltage
        framework.Set Test Status To Fail    power    Fail went into normal voltage
    END

# EnvD_SysQual_PowerManagementSubsystem_PowerHandling_LowVoltageCondition   # Commented as the values are for B sample
#     [Documentation]    MaaS Blade will go to LVI mode when it is below 8.9v
#     ...    and above 6.3v
#     [Tags]    POWER    FID-1039453    TCID-213172    FULLTEST

#     bits_platform.Output Set Analog Signal Value    Battery    0
#     prj.sut.connect.dlt

#     Sleep    1s
#     # Set voltage to normal voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    9
#     Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}

#     # Set voltage to under voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    8.3
#     Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

#     prj.sut.disconnect.dlt
#     Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log1.txt
#     prj.sut.connect.dlt

#     # Set voltage to maintain under voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    9
#     ${status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}

#     Log To Console    Matched! ${status}

#     Log To Console    The status of verified step is "${status}"
#     IF    ${status} == False
#         Log To Console    Pass did not go into normal voltage
#     ELSE
#         Log To Console    Fail went into normal voltage
#         framework.Set Test Status To Fail    power    Fail went into normal voltage
#     END

#     # Set voltage to under voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    10.5
#     Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_LowVoltageCondition   # C sample new changes
    [Documentation]    MaaS Blade will go to LVI mode when it is below 8.9v
    ...    and above 6.3v
    [Tags]    POWER    FID-1039453    TCID-213172    FULLTEST

    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt

    Sleep    1s
    # Set voltage to normal voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    9
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}

    # Set voltage to under voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    8
    Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

    prj.sut.disconnect.dlt
    Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log1.txt
    prj.sut.connect.dlt

    # Set voltage to maintain under voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    8.3
    ${status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}

    Log To Console    Matched! ${status}

    Log To Console    The status of verified step is "${status}"
    IF    ${status} == False
        Log To Console    Pass did not go into normal voltage
    ELSE
        Log To Console    Fail went into normal voltage
        framework.Set Test Status To Fail    power    Fail went into normal voltage
    END

    # Set voltage to under voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    8.9
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}

# EnvD_SysQual_PowerManagementSubsystem_PowerHandling_CriticalLowVoltageCondition    # Commented as the values are for B sample
#     [Documentation]    MaaS Blade will go to critical LVI mode when it is below 6.3v
#     [Tags]    POWER    FID-1039453    TCID-213171    FULLTEST

#     prj.sut.disconnect.dlt
#     prj.sut.can.simulation.PowerBladeOFF
#     prj.sut.power cycle
#     prj.sut.can.simulation.PowerBladeON
#     prj.sut.connect.dlt

#     # Set voltage to under voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    6.9
#     Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

#     # Set voltage to critical under voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    6.6
#     Verify DLT keyword offline    ${sut.power.DLT.critical_undervoltage}

#     prj.sut.disconnect.dlt
#     Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log1.txt
#     prj.sut.connect.dlt

#     # Set voltage mantain critical under voltage (still in hysteresis)
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    7.4
#     ${status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

#     Log To Console    Matched! ${status}

#     Log To Console    The status of verified step is "${status}"
#     IF    ${status} == False
#         Log To Console    Pass did not go into undervoltage and still in critical under voltage
#     ELSE
#         Log To Console    Fail went into undervoltage
#         framework.Set Test Status To Fail    power    Fail went into undervoltage. only when voltage is 7.1V it will go to undervoltage state.
#     END

#     prj.sut.disconnect.dlt
#     Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log2.txt
#     prj.sut.connect.dlt

#     # Set voltage to under voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    7.7
#     Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

#     prj.sut.disconnect.dlt
#     Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log3.txt
#     prj.sut.connect.dlt

#     # Set voltage to normal voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    12
#     Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_CriticalLowVoltageCondition    # C sample new changes
    [Documentation]    MaaS Blade will go to critical LVI mode when it is below 6.3v
    [Tags]    POWER    FID-1039453    TCID-213171    FULLTEST

    prj.sut.disconnect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    prj.sut.can.simulation.PowerBladeON
    prj.sut.connect.dlt

    # Set voltage to under voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    7.3
    Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

    # Set voltage to critical under voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    6.6
    Verify DLT keyword offline    ${sut.power.DLT.critical_undervoltage}

    prj.sut.disconnect.dlt
    Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log1.txt
    prj.sut.connect.dlt

    # Set voltage mantain critical under voltage (still in hysteresis)
    prj.sut.power.add.voltage.to.dictionary.check    Battery    6.9
    ${status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

    Log To Console    Matched! ${status}

    Log To Console    The status of verified step is "${status}"
    IF    ${status} == False
        Log To Console    Pass did not go into undervoltage and still in critical under voltage
    ELSE
        Log To Console    Fail went into undervoltage
        framework.Set Test Status To Fail    power    Fail went into undervoltage. only when voltage is 7.1V it will go to undervoltage state.
    END

    prj.sut.disconnect.dlt
    Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log2.txt
    prj.sut.connect.dlt

    # Set voltage to under voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    7.7
    Verify DLT keyword offline    ${sut.power.DLT.undervoltage}

    prj.sut.disconnect.dlt
    Move file    D:/tmp/LogFile/${TEST_NAME}/log.txt    D:/tmp/LogFile/${TEST_NAME}/log3.txt
    prj.sut.connect.dlt

    # Set voltage to normal voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    12
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}


# EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorMCUPowerSequence
#     [Documentation]    MCU should follow proper startup and shutdown sequence based on traces from SCC console.(row9)
#     [Tags]    POWER    FID-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875    TCID-195843    FULLTEST

#     prj.sut.connect.dlt
#     prj.sut.power off
#     prj.sut.can.simulation.Stop
#     prj.sut.can.simulation.Start
#     prj.sut.power on
#     prj.sut.can.simulation.PowerBladeON
#     Sleep    10s
#     Verify DLT keyword offline    \\[PowerM] OnInit
#     ...    \\[PowerM] OnInit LastResetReason \\[MULTIPLE_RESET]
#     ...    \\[PowerM] KssPowerUp SwitchOnPowerRails
#     ...    \\[PowerM] OnInit Enable CPU_RESET
#     ...    \\[PowerM] KssPowerUp Switch on UxxS_U33R_CPU_ON
#     ...    \\[PowerM] KssPowerUp Switch on UxxS_CPUPERI_ON
#     ...    \\[PowerM] KssPowerUp Switch on UxxS_ETH_ON
#     ...    \\[PowerM] KssPowerUp Switch on U105S_PHTM_ON
#     ...    \\[PowerM] KssPowerUp Switch on UxxS_A2B_ON \\(A2B phantom)
#     ...    \\[PowerM] KssPowerUp Switch on MAX20087 VI0123_ON \\(camera phantom)
#     ...    \\[PowerM]  SendCanSignal \\[STATE_INTERNAL_PRERUN]
#     ...    \\[PowerM]  SendCanSignal \\[PRE_RUN_STATE_REACHED]
#     ...    \\[PowerM] SendCanSignal \\[READY_TO_RUN]

#     # OLD KEYWORD
#     # \\[PowerM] OnInit
#     #     ...     Set PWR_HOLD pin to ACTIVE
#     #     ...     Enable UART trace supply
#     #     ...     Enable CPU_RESET
#     #     ...     \\[EcuM] OnEnterWakeup
#     #     ...     RecvCanSignal \\[PRE_RUN]
#     #   #  ...     BswM_RequestMode \\[PRJ_OpeMode_PRE_RUN]
#     #     ...     BswM_RequestMode \\[PRJ_RackMode_PRE_RUN]
#     #     ...     SendCanSignal \\[PRE_RUN_ACK]
#     #     ...     \\[EcuM] OnEnterPreRun
#     #     ...     OnDriveUp
#     #     ...     KssPowerUp InitFusaWdg
#     #     ...     KssPowerUp Disable CPU_RESET
#     #     ...     GssPowerUp Set PMIC_PGOOD_BL2 pin to ACTIVE
#     #   # ...     KssPowerUp SwitchOnMainSupplies
#     #     ...     GssPowerUp SwitchOnPowerRail
#     #     ...     OnDriveUpComReady
#     #     ...     OnEnterRunMode
#     #     ...     OnEnterKssRun
#     #     ...     GssPowerUp Enable MAX20877
#     #     ...     GssPowerUp MiscSupplies
#     #     ...     GssPowerUp Enable CPU
#     #     ...     GssPowerUp CPU Activated
#     #     # wait for YZ comment on the sequence of these 3 signals
#     #     ...     \\[CPF_Test] Simulate SOC startup complete
#     #     ...     BswM_RequestMode \\[PRJ_OpeMode_PRE_RUN_DONE]
#     #     ...     SendCanSignal \\[PRE_RUN_RESPONSE]
#     #     ...     RecvCanSignal \\[RUN]
#     #     ...     BswM_RequestMode \\[PRJ_OpeMode_RUN]
#     #     ...     SendCanSignal \\[RUN_ACK]
#     #     ...     CPF_Test] Simulate SOC RUN complete \\(idle, ready to shutdown\\)
#     #     ...     BswM_RequestMode \\[PRJ_OpeMode_RUN_DONE]
#     #     ...     SendCanSignal \\[RUN_RESPONSE]

#     prj.sut.can.simulation.PowerBladeOFF

#     Verify DLT keyword offline    \\[PowerM] RunRequest pin is INACTIVE
#     ...    \\[PowerM] Shutdown Simulate RecvCanSignal \\[SHUTDOWN]
#     ...    \\[PowerM]  SendCanSignal \\[STATE_INTERNAL_SHUTDOWN]
#     ...    \\[PowerM]  SendCanSignal \\[SHUTDOWN_STATE_REACHED]
#     ...    \\[PowerM] KssPowerDown DoFastCPUPoff
#     ...    \\[PowerM] KssPowerDown Switch off MAX20087 VI0123_ON \\(camera phantom)
#     ...    \\[PowerM] KssPowerDown Switch off UxxS_A2B_ON \\(A2B phantom)
#     ...    \\[PowerM] KssPowerDown Switch off U105S_PHTM_ON
#     ...    \\[PowerM] KssPowerDown Switch off UxxS_ETH_ON
#     ...    \\[PowerM] KssPowerDown Switch off UxxS_CPUPERI_ON
#     ...    \\[PowerM] KssPowerDown Switch off U33R_CPU_ON
#     ...    \\[PowerM] KssPowerDown SwitchOffPowerRail
#     ...    \\[PowerM] SendCanSignal \\[READY_TO_SHUTDOWN]
#     ...    \\[PowerM] All critical operations executed successfully

#     # OLD KEYWORD
#     # \\[PowerM] RecvCanSignal \\[PREPARE_SHUTDOWN]
#     #     ...    \\[PowerM] BswM_RequestMode \\[PRJ_OpeMode_PRE_SHUTDOWN]
#     #     ...    SendCanSignal \\[PRE_SHUTDOWN_ACK]
#     #     ...    \\[CPF_Test] Simulate SOC shutdown complete
#     #     ...    \\[PowerM] BswM_RequestMode \\[PRJ_OpeMode_PRE_SHUTDOWN_DONE]
#     #     ...    \\[EcuM] OnEnterPostRun
#     #     ...    \\[EcuM] OnEnterPrepShutdown
#     #     ...    \\[PowerM] OnDriveDown
#     #     ...    \\[PowerM] OnEnterUnknownPowerMode
#     #     ...    \\[PowerM] KssPowerDown DoFastCPUPoff
#     #     ...    \\[PowerM] KssPowerDown Disable CPU
#     #     ...    \\[PowerM] KssPowerDown MiscSupplies
#     #     ...    \\[PowerM] KssPowerDown Disable MAX20877
#     #     ...    \\[PowerM] KssPowerDown SwitchOffMainSupplies
#     #     ...    \\[PowerM] OnEnterSleep
#     #     ...    SendCanSignal \\[PRE_SHUTDOWN_RESPONSE]
#     #     ...    \\[PowerM] RecvCanSignal \\[SHUTDOWN]
#     #     ...    \\[PowerM] BswM_RequestMode \\[PRJ_OpeMode_SHUTDOWN]
#     #     ...    SendCanSignal \\[SHUTDOWN_ACK]
#     #     ...    SendCanSignal \\[SHUTDOWN_RESPONSE]
#     #     ...    \\[PowerM] Shutdown ComM Channel Completed
#     #     ...    \\[PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE
#     #     ...    \\[PowerM] Set PWR_HOLD pin to INACTIVE
#     Sleep    10s
#     # REMOVE THIS VERIFICATION METHOD

#     # ${ack}    ${sResult}    bits_platform.Rbs Get Signal Value    1    CAN    1
#     # ...    OPMM_MAAS    OperatingModeResponse_MaaSBlade
#     # IF    ${sResult} == 8
#     #     prj.sut.toellner off
#     #     Log to Console    Maas Blade Shutdown Successfully
#     # ELSE
#     #     Log to Console    Maas Blade FAIL to Shutdown Successfully
#     #     ${sResult}    Set Variable    ${sResult}
#     #     Set Test Status To Fail    power    OperatingModeResponse_MaaSBlade value is supposed to be 8 but we got ${sResult}
#     # END
#     ${Canoe_txt}    Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
#     Should Contain    ${Canoe_txt}    CAN RX: OPMM_MAAS 0x15 [SHUTDOWN_COMPLETED]
#     Should Not Contain    ${Canoe_txt}    elapsed without response

#     prj.sut.disconnect.dlt

EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorMCUPowerSequence   # New changes Raised a bug ticket for failure
    [Documentation]    MCU should follow proper startup and shutdown sequence based on traces from SCC console.(row9)
    [Tags]    POWER    FID-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875    TCID-195843    FULLTEST

    prj.sut.connect.dlt
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Sleep    70s
    Verify DLT keyword offline    [PowerM] OnInit
    Verify DLT keyword offline    [PowerM] OnInit LastResetReason [MULTIPLE_RESET]
    Verify DLT keyword offline    [PowerM] KssPowerUp SwitchOnPowerRails
    Verify DLT keyword offline    [PowerM] OnInit Enable CPU_RESET
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on UxxS_U33R_CPU_ON
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on UxxS_CPUPERI_ON
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on UxxS_ETH_ON
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on U105S_PHTM_ON
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on UxxS_A2B_ON (A2B phantom)
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on MAX20087 VI0123_ON (camera phantom)
    Verify DLT keyword offline    [PowerM]  SendCanSignal [STATE_INTERNAL_PRERUN]
    Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    Verify DLT keyword offline    [PowerM] SendCanSignal [READY_TO_RUN]

    prj.sut.can.simulation.PowerBladeOFF
    Sleep    70s
    Verify DLT keyword offline    [PowerM] RunRequest pin is INACTIVE
    Verify DLT keyword offline    [PowerM] Shutdown Simulate RecvCanSignal [SHUTDOWN]
    Verify DLT keyword offline    [PowerM]  SendCanSignal [STATE_INTERNAL_SHUTDOWN]
    Verify DLT keyword offline    [PowerM]  SendCanSignal [SHUTDOWN_STATE_REACHED]
    Verify DLT keyword offline    [PowerM] KssPowerDown DoFastCPUPoff
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off MAX20087 VI0123_ON (camera phantom)
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off UxxS_A2B_ON (A2B phantom)
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off U105S_PHTM_ON
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off UxxS_ETH_ON
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off UxxS_CPUPERI_ON
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off U33R_CPU_ON
    Verify DLT keyword offline    [PowerM] KssPowerDown SwitchOffPowerRail
    Verify DLT keyword offline    [PowerM] SendCanSignal [READY_TO_SHUTDOWN]
    Verify DLT keyword offline    [PowerM] All critical operations executed successfully
    prj.sut.disconnect.dlt

# EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorSoCPowerSequence    # Commented
#     [Documentation]    SOC should follow proper startup sequence and shutdown sequence based on traces from SCC console.
#     [Tags]    POWER    FID-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875    TCID-195838    FULLTEST
#     prj.sut.connect.dlt
#     prj.sut.power off
#     prj.sut.can.simulation.Stop
#     prj.sut.can.simulation.Start
#     prj.sut.power on
#     prj.sut.can.simulation.PowerBladeON
#     Verify DLT keyword    \\[PowerM] GssPowerUp Set PMIC_PGOOD_BL2 pin to ACTIVE
#     ...    \\[PowerM] GssPowerUp Enable MAX20877 success
#     ...    \\[PowerM] GssPowerUp Enable CPU
#     ...    \\[PowerM] GssPowerUp SwitchOnSocPower  # ---->SwitchOnSocPower --> to check which comes first
#     ...    \\[PowerM] GssPowerUp Enable CPU success
#     ...    \\[PowerM] GssPowerUp CPU Activated

#     Log To Console    SOC startup is correct
#     Sleep    60s
#     prj.sut.can.simulation.PowerBladeOFF

#     Verify DLT keyword    \\[PowerM] KssPowerDown Disable CPU
#     ...    \\[PowerM] KssPowerDown Disable MAX20877
#     ...    \\[PowerM] KssPowerDown SwitchOffPowerRail
#     ...    \\[PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE

#     Log To Console    SOC shutdown is correct

#     Sleep    30s
#     # TO CHANGE NEW VERIFICATION METHOD
#     # ${ack}    ${sResult}    bits_platform.Rbs Get Signal Value    1    CAN    1
#     # ...    OPMM_MAAS    OperatingModeResponse_MaaSBlade
#     # IF    ${sResult} == 8
#     #     prj.sut.toellner off
#     #     Log to Console    Maas Blade Shutdown Successfully
#     # ELSE
#     #     Log to Console    Maas Blade FAIL to Shutdown Successfully
#     #     ${sResult}    Set Variable    ${sResult}
#     #     Set Test Status To Fail    power    OperatingModeResponse_MaaSBlade value is supposed to be 8 but we got ${sResult}
#     # END

#     ${Canoe_txt}    Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
#     Should Contain    ${Canoe_txt}    CAN RX: OPMM_MAAS 0x15 [SHUTDOWN_COMPLETED]
#     Should Not Contain    ${Canoe_txt}    elapsed without response

EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorSoCPowerSequence    # new Changes
    [Documentation]    SOC should follow proper startup sequence and shutdown sequence based on traces from SCC console.
    [Tags]    POWER    FID-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875    TCID-195838    FULLTEST
    prj.sut.connect.dlt
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Sleep    100s
    Verify DLT keyword offline    [PowerM] OnInit Enable CPU_RESET
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on UxxS_U33R_CPU_ON
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on UxxS_CPUPERI_ON
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on UxxS_ETH_ON
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on U105S_PHTM_ON
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on UxxS_A2B_ON (A2B phantom)
    Verify DLT keyword offline    [PowerM] KssPowerUp Switch on MAX20087 VI0123_ON (camera phantom)
    Log To Console    SOC startup is correct
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    100s
    Verify DLT keyword offline    [PowerM] KssPowerDown DoFastCPUPoff
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off MAX20087 VI0123_ON (camera phantom)
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off UxxS_A2B_ON (A2B phantom)
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off U105S_PHTM_ON
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off UxxS_ETH_ON
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off UxxS_CPUPERI_ON
    Verify DLT keyword offline    [PowerM] KssPowerDown Switch off U33R_CPU_ON
    prj.sut.disconnect.dlt

EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoring
    [Documentation]    MaaS Blade should produces traces with voltage value in SCC console.
    [Tags]    POWER    FID-1275341    TCID-195837    FULLTEST
    prj.sut.connect.dlt
    prj.sut.power cycle

    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.power.add.voltage.to.dictionary.check    Battery    12

    Log To Console    Voltage reading is reflected correctly in SCC console

# EnvD_SysQual_PowerManagementSubsystem_PowerHandling_NormalOperationCondition  # Commented as the values are for B sample
#     [Documentation]    When supply voltage is in operation voltage range,power management subsystem and other subsystems will carry out full
#     ...    operation mode as per defined.
#     [Tags]    POWER    FID-1275380    TCID-213374    FULLTEST

#     prj.sut.disconnect.dlt
#     prj.sut.can.simulation.PowerBladeOFF
#     prj.sut.connect.dlt
#     prj.sut.power cycle
#     prj.sut.can.simulation.PowerBladeON

#     bits_platform.Output Set Analog Signal Value    Battery    0
#     Sleep    1s

#     prj.sut.power.add.voltage.to.dictionary.check    Battery    17.4
#     Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}

#     prj.sut.power.add.voltage.to.dictionary.check    Battery    18.8
#     Verify DLT keyword offline    ${sut.power.DLT.overvoltage}

#     # Set voltage to normal voltage
#     prj.sut.power.add.voltage.to.dictionary.check    Battery    16.5
#     Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_NormalOperationCondition  # C sample Changes
    [Documentation]    When supply voltage is in operation voltage range,power management subsystem and other subsystems will carry out full
    ...    operation mode as per defined.
    [Tags]    POWER    FID-1275380    TCID-213374    FULLTEST

    prj.sut.disconnect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    prj.sut.can.simulation.PowerBladeON

    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    1s

    prj.sut.power.add.voltage.to.dictionary.check    Battery    20
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}

    prj.sut.power.add.voltage.to.dictionary.check    Battery    20.5
    Verify DLT keyword offline    ${sut.power.DLT.overvoltage}

    # Set voltage to normal voltage
    prj.sut.power.add.voltage.to.dictionary.check    Battery    18.9
    Verify DLT keyword offline    ${sut.power.DLT.normalvoltage}

# EnvD_SysQual_PowerManagementSubsystem_General_TemperatureMonitoringWithInterbladeSignal    # Commented
#    [Documentation]    MaaS Blade should produces traces with temperature value
#    ...    (with interblade signal, -ve, +ve, 1 degree resolution) in SCC console.
#    [Tags]    POWER    FID-    TCID-195832    FULLTEST
#    prj.sut.connect.dlt
#    prj.sut.power cycle
#    prj.sut.can.simulation.PowerBladeOFF
#    prj.sut.can.simulation.PowerBladeON

#    # 40    <=    ${normal_temp} <= 43

#    ${startup_list}    Create List    [PowerM] SendCanSignal MaaS Temperature validity = valid
#    ...    [PowerM] SendCanSignal Raw temperature of NTC sensor near SOC, Display
#    # = 82.

#    ${pattern_length}    Get Length    ${startup_list}

#    FOR    ${index}    IN RANGE    0    ${pattern_length}
#      Log To Console    ${startup_list[${index}]}
#      ${res}    Verify    conn_name=${CONNECTION_NAME}
#      ...    search_pattern=${startup_list[${index}]}
#      ...    timeout=20
#      Log To Console    ${res} MaaS Temperature value is displayed correctly
#    END

# EnvD_SysQual_PowerManagementSubsystem_General_MonitorOverallTemperatureValue(HighestValue)   # Commented
#    [Documentation]    MaaS Blade use highest temperature value as overall temperature value.
#    [Tags]    POWER    FID-1275340    TCID-195831    FULLTEST
#    prj.sut.connect.dlt
#    prj.sut.power cycle
#    prj.sut.can.simulation.PowerBladeOFF
#    prj.sut.can.simulation.PowerBladeON

#    ${res}    Verify    conn_name=${CONNECTION_NAME}
#    ...    search_pattern=[Temperature] Current overall Temperature is
#    ...    timeout=20
#    Log To Console    ${res}. MaaS Overall Temp is displayed correctly

EnvD_SysQual_PowerManagementSubsystem_General_TemperatureMonitoringWithInterbladeSignal    # new changes
   [Documentation]    MaaS Blade should produces traces with temperature value
   ...    (with interblade signal, -ve, +ve, 1 degree resolution) in SCC console.
   [Tags]    POWER    FID-1275340    TCID-195832    FULLTEST
   prj.sut.connect.dlt
   prj.sut.power cycle
   prj.sut.can.simulation.PowerBladeOFF
   prj.sut.can.simulation.PowerBladeON

   Verify DLT keyword offline    [PowerM] SendCanSignal Safety Temperature validity = valid
   Sleep    2s
   Verify DLT keyword offline    [PowerM] SendCanSignal Safety Temperature value

   prj.sut.disconnect.dlt

EnvD_SysQual_PowerManagementSubsystem_General_MonitorOverallTemperatureValue(HighestValue)   # new changes
   [Documentation]    MaaS Blade use highest temperature value as overall temperature value.
   [Tags]    POWER    FID-1275340    TCID-195831    FULLTEST
   prj.sut.connect.dlt
   prj.sut.power cycle
   prj.sut.can.simulation.PowerBladeOFF
   prj.sut.can.simulation.PowerBladeON
   Sleep    2s
   Verify DLT keyword offline    [PowerM] BswM_RequestMode
   Sleep    2s
   Verify DLT keyword offline    [Temperature] Overall temperature =

   prj.sut.disconnect.dlt

EnvD_SysQual_PowerManagementSubsystem_General_CANSimulationToTriggerStartup/ShutdownToMaasBlade
    [Documentation]    Use CAN simulation to trigger MaaS Blade to startup and obtained startup traces.
    ...    Use CAN simulation to trigger Maas Blade to shutdown and obtained shutdown traces.
    [Tags]    POWER    FID-1376730    TCID-195836    FULLTEST
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
    Sleep    60s
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
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
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{Shutdown_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}
        Should Not Contain    ${Canoe_txt}    elapsed without response
    END
    Log To Console    MaaS Shutdown CAN sequence message is displayed correctly

EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeOFFState
    [Documentation]    MaaS Blade should be fully OFF and no standby mode upon request from Power Blade.
    [Tags]    POWER    FID-1039451,1039452    TCID-195834    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    Sleep    60s  # new change
    Verify DLT keyword    # ...    OnDriveUp
    # ...    PowerM_CssPowerUp_InitFusaWdg
    # ...    PowerM_CssPowerUp_SwitchOnMainSupplies
    # ...    OnDriveUpComReady
    # ...    ECU current operational mode ID: 4
    # ...    POWERM_SM_DRIVE_POWER_UP_STATE
    # ...    POWERM_SM_DRIVE_POWER_UP_COMRDY_STATE
    # ...    PowerM_CssPowerUp_MiscSupplies
    #  ...    \\[PowerM] KssPowerUp SwitchOnMainSupplies
    ...    \\[PowerM] KssPowerUp SwitchOnPowerRail
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
    [Tags]    POWER    FID-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875    TCID-195839    FULLTEST
    prj.sut.power off
    prj.sut.connect.QNX
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Sleep    60s  # new change
    Verify QNX keyword offline    Startup done  # new change
    Sleep    10s
    # Verify console able to send command and receive response
    Verify QNX keyword    VERSION=    command= cat /mnt/Buildinfo.txt  # new change

    prj.sut.connect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    60s
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

    Verify DLT keyword offline    [PowerM] Set PWR_HOLD pin to INACTIVE  # new change
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
    [Teardown]    run keywords    prj.sut.power cycle    AND    Sleep    60s


EnvD_SysQual_Communication_CANSubsystem_standard_format
    [Documentation]    The CAN database in MaaS system in NIP file format shall be converted to a standard format
    ...    dbc,Autosar ECU Extract format
    [Tags]    COMMUNICATION    FID-1340691,13406989  TCID-437645    FULLTEST   Comunication_tag
    # Search for the files in the listed folder
    ${files}=    List Files In Directory    ${sut.can.filepath}
    ${arxml_found}=    Evaluate    any(f.endswith('.arxml') for f in ${files})
    IF    ${arxml_found}
        Log    .arxml file found. Test case passed.
        Pass Execution    .arxml file is present.
    ELSE
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=No .arxml file found in ${sut.can.filepath
    END

EnvD_SysQual_Communication_ETHNetwork_IPV4&IPV6support
    [Documentation]    The Ethernet subsystem shall support the definition of virtual LANs (VLANs)
    ...    according to IEEE 802.1Q
    [Tags]    COMMUNICATION    FID-1337817,1337819,1337731  TCID-427039    FULLTEST   Comunication_tag
    # Perform the ping test
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    pfctl -d
    sleep    5s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_qnx_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_mcu_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_linux_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_android_ipv6}
    sleep    2s

EnvD_SysQual_Communication_Firewall_Scan-LinuxGVM-OpenPort
    [Documentation]    The firewalls shall be configured such that a separation of domains (internet, vehicle,
    ...    external blades, SoC subsystem, Microcontrollersubsystem and etc) is assured and unused ports are closed
    [Tags]    COMMUNICATION    FID-1338726,1338728    TCID-377015    FULLTEST    Communication_tag
    # Perform the Ping test and firewall scan on Linux to validate the results
    prj.sut.com.Perform Firewall Scan
    ...    ${sut.com.expected_linux_ipv6}    ${sut.com.expected_linux_ports}
    ...    ${sut.com.expected_linux_mac}    -p- --open    OPEN

EnvD_SysQual_Communication_Firewall_Scan-QNXOpenPort
    [Documentation]    This Test is to perform Firewall Scan for QNX GVM.The firewalls shall be configured such
    ...    that a separation of domains (internet, vehicle,
    ...    external blades, SoC subsystem, Microcontrollersubsystem and etc)
    ...    is assured and unused ports are closed
    [Tags]    COMMUNICATION    FID-1338726,1338728    TCID-377014    FULLTEST
    # Perform the Ping test and firewall scan on QNX to validate the results
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_qnx_ipv6}
    ...    ${sut.com.expected_qnx_ports}    ${sut.com.expected_qnx_mac}
    ...    -p- --open    OPEN

EnvD_SysQual_Communication_Firewall_Scan- MCU-OpenPort
    [Documentation]    This Test is to perform Firewall Scan for MCU GVM.The firewalls shall be configured such
    ...    that a separation of domains (internet, vehicle,
    ...    external blades, SoC subsystem, Microcontrollersubsystem and etc)
    ...    is assured and unused ports are closed
    [Tags]    COMMUNICATION    FID-1338726,1338728    TCID-377012    FULLTEST
    # Perform the Ping test and firewall scan on MCU to validate the results
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_mcu_ipv6}
    ...    ${sut.com.expected_mcu_ports}    ${sut.com.expected_mcu_mac}    -p- --open    OPEN

EnvD_SysQual_Communication_Firewall_Scan-Android-OpenPort
    [Documentation]    This Test is to perform Firewall Scan for Android GVM.The firewalls shall be configured such
    ...    that a separation of domains (internet, vehicle,
    ...    external blades, SoC subsystem, Microcontrollersubsystem and etc)
    ...    is assured and unused ports are closed
    [Tags]    COMMUNICATION    FID-1338726,1338728    TCID-377013    FULLTEST
    # Once the device is powered on , Need to wait 40sec for stabilization
    # Perform the Ping test and firewall scan on Android to validate the results
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_android_ipv6}
    ...    ${sut.com.expected_android_ports}    ${sut.com.expected_android_mac}    -p- --open    OPEN

EnvD_SysQual_Communication_ETHNetwork_SecureCheck02
    [Documentation]    This Test is to perform Penetration Scan for QNX GVM.
    ...    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1337822,1338677,1453798,1338725,1338724    TCID-427051    FULLTEST
    # Perform the Penetration test on QNX to validate the results
    prj.sut.com.Run Nmap Scan    ${sut.com.expected_qnx_ipv6}
    ...    []    ${sut.com.expected_qnx_mac}    -sX    SKIP

EnvD_SysQual_Communication_ETHNetwork_DOIPActivation-Positive
    [Documentation]    This Test is to validate the DOIP activation for the Ethernet network.
    ...                The system may support DoIP activation via dedicated 'Activation Line' but can also
    ...                 activate the DoIP
    ...                 stack based on other events. (e.g.interface status changes from operation system)
    [Tags]    COMMUNICATION    FID-1338690    TCID-427043    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}

EnvD_SysQual_Communication_ETHNetwork_SecureCheck03
    [Documentation]    This Test is to perform Penetration Scan for Linux GVM.
    ...    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1338677,1337822,1338724,1338725,1453798     TCID-427050    FULLTEST
    # Once the device is powered on , Need to wait 40sec for stabilization
    prj.sut.com.Countdown Timer    40
    # Perform the Penetration test on QNX to validate the results
    prj.sut.com.Run Nmap Scan    ${sut.com.expected_linux_ipv6}
    ...     ${sut.com.expected_linux_ports_Xmas_scan}    ${sut.com.expected_linux_mac}    -sX -6 -Pn -v    SKIP

EnvD_SysQual_Communication_ETHNetwork_SecureCheck04
    [Documentation]    This Test is to perform Penetration Scan for Android GVM
    ...    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1338677,1337822,1338724,1338725,1453798    TCID-427045    FULLTEST
    # Perform the Penetration test on Android to validate the results
    prj.sut.com.Run Nmap Scan    ${sut.com.expected_android_ipv6}
    ...    ${sut.com.expected_android_ports_Xmas_scan}
    ...    ${sut.com.expected_android_mac}    -sX -6 -Pn -v    SKIP

EnvD_SysQual_Communication_ETHNetwork_SecureCheck05
    [Documentation]    This Test is to perform Penetration Scan for MCU.
    ...    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1338677,1337822,1338724,1338725,1453798    TCID-427044    FULLTEST
    # Perform the Penetration test on MCU to validate the results
    prj.sut.com.Run Nmap Scan    ${sut.com.expected_mcu_ipv6}
    ...    []    ${sut.com.expected_mcu_mac}    -sX -6 -Pn -v    OPEN

EnvD_SysQual_Communication_ETHNetwork_COMinterface
    [Documentation]    This Test is to perform the check  for
    ...                Ethernet communication interface to external debug subsystem
    [Tags]    COMMUNICATION    FID-1337801    TCID-427046         FULLTEST

    Log To Console    Connect 100BaseT cable from VN5620 to device's Debug Adapter.
    # Perform the ping test
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_qnx_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_mcu_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_linux_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_android_ipv6}
    sleep    2s

EnvD_SysQual_Communication_DoIPCommunication_SessionControlSendReceive
    [Documentation]    The system shall support DoIP communication according to standard ISO 13400-2
    [Tags]    COMMUNICATION    FID-1338689    TCID-427070    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

EnvD_SysQual_Communication_ETHNetwork_disable_external_debug
    [Documentation]    The Ethernet subsystem shall ensure the connection to external debug subsystem
    ...    must be disable after start of production
    [Tags]    COMMUNICATION    FID-1338704    TCID-437829    FULLTEST
    # Perform the Ping test and firewall scan on Linux to validate the results
    prj.sut.com.Perform Firewall Scan
    ...    ${sut.com.expected_linux_ipv6}    ${sut.com.expected_linux_ports}
    ...    ${sut.com.expected_linux_mac}    -p- --open    OPEN
    # Perform the Ping test and firewall scan on QNX to validate the results
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_qnx_ipv6}
    ...    ${sut.com.expected_qnx_ports}    ${sut.com.expected_qnx_mac}
    ...    -p- --open    OPEN
    # Perform the Ping test and firewall scan on MCU to validate the results
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_mcu_ipv6}
    ...    ${sut.com.expected_mcu_ports}    ${sut.com.expected_mcu_mac}    -p- --open    OPEN
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_android_ipv6}
    ...    ${sut.com.expected_android_ports}    ${sut.com.expected_android_mac}    -p- --open    OPEN
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_android_ipv6}
    ...    ${sut.com.expected_android_ports}    ${sut.com.expected_android_mac}    -p- --open    OPEN

EnvD_SysQual_Communication_ETHNetwork_TCP/IP-support
    [Documentation]    The Ethernet subsystem shall support TCP/IP (TCP & UDP).
    [Tags]    COMMUNICATION    FID-1338718    TCID-427042    FULLTEST    Comunication_tag
    Close All Connections

    # Test QNX Host
    prj.sut.com.Connect And Test Host    ${sut.com.QNX_HOST}    QNX

    # Test LINUX Host
    prj.sut.com.Connect And Test Host    ${sut.com.LINUX_HOST}    LINUX

EnvD_SysQual_Communication_ETHNetwork_OpenAliance
    [Documentation]    . 2.5 GB Ethernet switch is used for Ethernet network communication.
    ...    Ethernet subsystem shall support automotive Ethernet test defined by Open Alliance
    [Tags]    COMMUNICATION    FID-1338716,1039406    TCID-427040    FULLTEST    ${COMMUNICATION_TAG}
    # Perform the Ping test and firewall scan on QNX to validate the results
    # Start iPerf3 server
    Start Process    iperf3    -s    -6    alias=iperf_server
    Sleep    3s
    # Connect and run client
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -c FD53:7CB8:0383:0018:0000:0000:0001:0271 -t 60 -i 5
    prj.sut.com.Countdown Timer    100
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    Run Keyword And Ignore Error   prj.sut.com.Check Speed    ${output}
    Close Connection
    Terminate Process    iperf_server

    # Start iPerf3 server
    Open Connection   ${sut.com.QNX_HOST}    maasdev    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    ${result}    Run Process    cmd    /c    iperf3 -c FD53:7CB8:0383:0018:0000:0000:0001:0268 -t 60 -i 5
    ...    shell=True    timeout=200s
    Log To Console    Return Code: ${result.rc}
    Log To Console    STDOUT:\n${result.stdout}
    Log To Console    STDERR:\n${result.stderr}
    prj.sut.com.Check Speed     ${result.stdout}
    Close All Connections

EnvD_SysQual_Communication_ETHNetwork_TCP/IP-firewall
    [Documentation]    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1338677    TCID-427048    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.QNX
    prj.sut.power cycle
    Sleep    60s
    ${Status}    Run Keyword And Return Status    Verify QNX keyword    pf enabled    command=pfctl -e
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END
    ${Status}    Run Keyword And Return Status    Verify QNX keyword with long timout    packets captured    command=tcpdump -i pflog0 -vvvv & PID=$! ; sleep 60 ; kill -INT $PID
    sleep    5s
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

    ${Status}    Run Keyword And Return Status    Verify QNX keyword    pf disabled    command=pfctl -d
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END
    ${Status}    Run Keyword And Return Status    Verify QNX keyword with long timout    packets captured    command=tcpdump -i pflog0 -vvvv & PID=$! ; sleep 60 ; kill -INT $PID
    sleep    5s
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Close All Connections
        Log To Console    QNX command Successfully.
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

EnvD_SysQual_Communication_CANSubsystem_ConfigurableCANbaudrate   # Testcase is updated
    [Documentation]    The baudrate of each CAN bus shall be individually configurable
    ...    via a software parameter to the pre-defined speeds.
    [Tags]    COMMUNICATION    FID-1338744,1339498    TCID-427028    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.set Message ID Logging Active
    sleep    20s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ✓ ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen
    prj.sut.com.set Baud rate 300.channel1
    prj.sut.com.set Baud rate 300.channel2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    'CAN 1 : Message with ID' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ✓ CAN 1 : Message with ID is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=CAN 1 : Message with ID is not found in CAN data
        END
    END
    Log To Console    Error message is seen
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.set Message ID Logging Active
    sleep    6s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ✓ ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen

EnvD_SysQual_Communication_CANSubsystem_CANbaudrate
    [Documentation]    The CAN subsystem shall support the baudrate of as specified
    ...    in 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6 Chapter 3.2 CAN-Controller.
    [Tags]    COMMUNICATION    FID-1338744,1339489    TCID-427033    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    # Configuring the baud rate
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.Countdown Timer    3
    prj.sut.com.set Message ID Logging Active
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    prj.sut.com.set Message ID Logging Deactive
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ✓ ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen

EnvD_SysQual_Communication_CANSubsystem_CANbaudrateCANFD
    [Documentation]    The baudrate of each CAN bus shall be individually configurable
    ...    via a software parameter to the pre-defined speeds.
    [Tags]    COMMUNICATION    FID-1338744,1339491    TCID-427034    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.set Message ID Logging Active
    sleep    6s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ✓ ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen
    prj.sut.com.set Baud rate 300.channel1
    prj.sut.com.set Baud rate 300.channel2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    'CAN 1 : Message with ID' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ✓ CAN 1 : Message with ID is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=CAN 1 : Message with ID is not found in CAN data
        END
    END
    Log To Console    Error message is seen
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.set Message ID Logging Active
    sleep    6s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ✓ ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen

EnvD_SysQual_Communication_CANSubsystem_CANFD_abitrary_bitrate
    [Documentation]    The arbitration bitrate should be configurable for CANFD channels as per NIP File
    [Tags]    COMMUNICATION    FID-1340694    TCID-437648    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Baud rate 500.channel1
    sleep    2s
    prj.sut.com.set Arbitration and Data Log to 1 channel1
    prj.sut.com.set Arbitration and Data Log to 0 channel1
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END
    prj.sut.com.set Arbitration and Data Log to 1 channel2
    prj.sut.com.set Arbitration and Data Log to 0 channel2
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END
    Log To Console    Arbitration bitrate logged

EnvD_SysQual_Communication_CANSubsystem_CANFD_abitrary_bitrate_data_phase_bitrate
    [Documentation]    The arbitration & data phase bitrate should be configurable for CANFD channels as per NIP File
    [Tags]    COMMUNICATION    FID-1340696    TCID-437651    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Baud rate 500.channel1
    sleep    2s
    prj.sut.com.set Arbitration and Data Log to 1 channel1
    prj.sut.com.set Arbitration and Data Log to 0 channel1
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    ...    Data settings: baud= 2000000.000000, tseg1 = 15, tseg2= 4, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END
    prj.sut.com.set Arbitration and Data Log to 1 channel2
    prj.sut.com.set Arbitration and Data Log to 0 channel2
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    ...    Data settings: baud= 2000000.000000, tseg1 = 15, tseg2= 4, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END

EnvD_SysQual_Communication_CANSubsystem_CANFD_data_phase_bitrate
    [Documentation]    The data phase bitrate should be configurable for CANFD channels as per NIP File
    [Tags]    COMMUNICATION    FID-1340695    TCID-437652    FULLTEST    Communication_tag
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Baud rate 500.channel1
    sleep    2s
    prj.sut.com.set Arbitration and Data Log to 1 channel1
    prj.sut.com.set Arbitration and Data Log to 0 channel1
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    # FOR    ${index}    IN    @{pattern_list}
    #     Log To Console    Checking if pattern "${index}" exists in CANoe log
    #     ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
    #     IF    not ${contains}
    #         Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
    #     ELSE
    #         Log To Console    Pattern "${index}" found in CANoe log
    #     END
    # END
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console     ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    prj.sut.com.set Arbitration and Data Log to 1 channel2
    prj.sut.com.set Arbitration and Data Log to 0 channel2
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    # FOR    ${index}    IN    @{pattern_list}
    #     Log To Console    Checking if pattern "${index}" exists in CANoe log
    #     ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
    #     IF    not ${contains}
    #         Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
    #     ELSE
    #         Log To Console    Pattern "${index}" found in CANoe log
    #     END
    # END
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console     ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Arbitration bitrate logged

# EnvD_SysQual_Communication_CANSubsystem_CANFD_abitrary_bitrate_data_phase_bitrate1
#     [Documentation]    The arbitration & data phase bitrate should be configurable for CANFD channels as per NIP File
#     [Tags]    COMMUNICATION    FID-1340696    TCID-    FULLTEST
#     prj.sut.can.simulation.Stop
#     prj.sut.can.simulation.Start
#     prj.sut.com.Countdown Timer    5
#     prj.sut.can.simulation.PowerBladeON
#     prj.sut.com.Countdown Timer    5
#     prj.sut.com.set Baud rate 500.channel1
#     sleep    2s
#     prj.sut.com.set Arbitration and Data Log to 1 channel1
#     prj.sut.com.set Arbitration and Data Log to 0 channel1
#     @{pattern_list}    Create List    Data settings: baud= 2000000.000000, tseg1 = 15, tseg2= 4, sjw = 2
#     prj.sut.com.Countdown Timer    5
#     ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
#     FOR    ${index}    IN    @{pattern_list}
#         Log To Console    Checking if pattern "${index}" exists in CANoe log
#         ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
#         IF    not ${contains}
#             Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
#         ELSE
#             Log To Console    Pattern "${index}" found in CANoe log
#         END
#     END
#     prj.sut.com.set Arbitration and Data Log to 1 channel2
#     prj.sut.com.set Arbitration and Data Log to 0 channel2
#     @{pattern_list}    Create List    Data settings: baud= 2000000.000000, tseg1 = 15, tseg2= 4, sjw = 2
#     prj.sut.com.Countdown Timer    5
#     ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
#     FOR    ${index}    IN    @{pattern_list}
#         Log To Console    Checking if pattern "${index}" exists in CANoe log
#         ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
#         IF    not ${contains}
#             Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
#         ELSE
#             Log To Console    Pattern "${index}" found in CANoe log
#         END
#     END

EnvD_SysQual_Communication_CANSubsystem_CANFD_maximum_payload
    [Documentation]    The CAN Subsystem shall
    ...    support maximum bytes of payload in CANFD communication as per NIP file
    [Tags]    COMMUNICATION    FID-1340692    TCID-437646    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.set Message ID Logging Active
    @{pattern_list}    Create List
    ...   OPMM_Network_DBS | ID:0x016 | DLC:8
    ...   OPMM_Power | ID:0x010 | DLC:7
    ...   OPMM_ASW_KeepAwake_Req_Main | ID:0x103 | DLC:8
    ...   OPMM_MAIN | ID:0x013 | DLC:8
    ...   Global_Health_Status_DBS | ID:0x220 | DLC:4
    ...   OPMM_Network_DBP | ID:0x017 | DLC:8
    ...   GlobalAliveness_DBS | ID:0x223 | DLC:3
    prj.sut.com.Countdown Timer    30
    prj.sut.com.set Message ID Logging Deactive
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console     ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    CAN messages are seen and DLC is verified

EnvD_SysQual_Communication_CANSubsystem_CAN_messages
    [Documentation]    Ensure the CAN SW stack shall provide an interface to send and receive direct CAN messages from /
    ...    to application.
    [Tags]    COMMUNICATION    FID-1340707,1340709,1340706    TCID-437644    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    # configuring the baud rate
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.Countdown Timer    3
    prj.sut.com.set Message ID Logging Active
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    prj.sut.com.set Message ID Logging Deactive
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}
    END

EnvD_SysQual_Communication_CANSubsystem_vehicle_data
    [Documentation]    The CAN subsystem shall provide access to vehicle data only to authorized applications.
    ...    The CAN subsystem shall support to get data from the vehicle communication network.
    ...    The data shall be available for all devices.
    ...    Authorization shall be required to grant arbitrary access, depending on project requirements.
    [Tags]    COMMUNICATION    FID-1340699,1340734,1340700    TCID-437643    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.can.diag.tester.present.active
    prj.sut.com.Countdown Timer    5
    # configuring the baud rate
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.Countdown Timer    3
    prj.sut.com.set Message ID Logging Active
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    prj.sut.com.set Message ID Logging Deactive
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}
    END
    prj.sut.can.diag.tester.present.active
    #  prj.sut.com.Countdown Timer    5
    # # Send command VWECUHardwareNumber
    # prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Req}
    # prj.sut.diag.compare    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Resp}
    # # Go to extended session
    # prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    # prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # # Send command VWECUHardwareNumber
    # prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Req}
    # prj.sut.diag.compare    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Resp}
    Log To Console    Vehicle CAN data is seen

EnvD_SysQual_Communication_ETHNetwork_DOIPActivation-Negative
    [Documentation]    This Test is to validate the DOIP activation for the Ethernet network.
    ...                The system may support DoIP activation via dedicated 'Activation Line' but can also
    ...                 activate the DoIP
    ...                 stack based on other events. (e.g.interface status changes from operation system)
    [Tags]    COMMUNICATION    FID-1338690    TCID-427049    FULLTEST

    prj.sut.connect.dlt
    prj.sut.power cycle
    Sleep    60s
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}
    sleep    5s
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    ON
    sleep    10s
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    sleep    20s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline   EthMgmtLinkDownCounter:
    IF  ${Status}
        Log To Console    DLT keyword is matched
        Log To Console    Ethernet link is down
    ELSE
        Log To Console    DLT keyword not matched
        Log To Console    Ethernet link is Down
        Close All Connections
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        prj.sut.power cycle
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet link is Down.DLT keyword not matched
    END
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
    sleep    10s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline  EthMgmt_Trace_EthMgmt_vGetLinkStateCyclic: 0 1 2

    IF    ${Status}
        Log To Console    DLT keyword is matched
        Log To Console    Ethernet link is Up
    ELSE
        Log To Console    DLT keyword not matched
        Log To Console    Ethernet link is Down
        Close All Connections
        prj.sut.power cycle
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet link is Down.DLT keyword not matched
    END

EnvD_SysQual_Communication_ETHNetwork_InterfacetoSoC-Negative
    [Documentation]    Connection interface to SoC subsystem
    [Tags]    COMMUNICATION    FID-1338698  TCID-427036    FULLTEST   Comunication_tag

    # Perform the DoIP cable disconnection/Malfunction
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    ON
    prj.sut.com.Countdown Timer    5
    # Sleep    5s
    ${status}    Run Keyword And Return Status   prj.sut.com.Run Ping Test    ${sut.com.expected_qnx_ipv6}
    Log    Status: ${status}
    Should Be Equal    ${status}    ${False}
    ...    msg=Expected failure but ping succeeded!
    sleep    2s
    # ${status}    Run Keyword And Return Status   prj.sut.com.Run Ping Test    ${sut.com.expected_mcu_ipv6}
    # Log    Status: ${status}
    # Should Be Equal    ${status}    ${False}
    # ...    msg=Expected failure but ping succeeded!
    sleep    2s
    ${status}    Run Keyword And Return Status   prj.sut.com.Run Ping Test    ${sut.com.expected_linux_ipv6}
    Log    Status: ${status}
    Should Be Equal    ${status}    ${False}
    ...    msg=Expected failure but ping succeeded!
    sleep    2s
    ${status}    Run Keyword And Return Status   prj.sut.com.Run Ping Test    ${sut.com.expected_android_ipv6}
    Log    Status: ${status}
    Should Be Equal    ${status}    ${False}
    ...    msg=Expected failure but ping succeeded!
    sleep    2s
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
    prj.sut.com.Countdown Timer    5

EnvD_SysQual_Communication_FaultDetection_OpenLine
    [Documentation]    Connection interface to SoC subsystem
    [Tags]    COMMUNICATION    FID-1338731  TCID-427068    FULLTEST   Comunication_tag

    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    ON
    prj.sut.com.Countdown Timer    10
    ${Status}    Run Keyword And Return Status    Verify DLT keyword    EthMgmtLinkDownCounter:
    sleep    10s
    IF  ${Status}
        Log To Console    DLT keyword is matched
        Log To Console    Ethernet link is Down
    ELSE
        Log To Console    DLT keyword not matched
        Log To Console    Ethernet link is Down
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        prj.sut.power cycle
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet link is Down.DLT keyword not matched
    END
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
    sleep    10s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline  EthMgmt_Trace_EthMgmt_vGetLinkStateCyclic: 0 1 2
    IF    ${Status}
        Log To Console    DLT keyword is matched
        Log To Console    Ethernet link is Up
    ELSE
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        Log To Console    DLT keyword not matched
        Log To Console    Ethernet link is Down
        prj.sut.power cycle
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet link is Down.DLT keyword not matched
    END

#  NEW CASES ADDED

EnvD_SysQual_Communication_CANSubsystem_CANInterface_back_CAN1
    [Documentation]    CAN transceiver is used for CAN network communication, 2xCANFD in backplane is use for inter blades communication on rack ,
    ...    2 xCANFD is used for future CAN communication with other ECUs on vehicle
    ...    The system shall support DoIP communication via UDS according to ISO 14229-2:2013 to be used by SW applications.
    ...    2xCAN bus interface to back connector
    ...    The system shall equipped with CAN subsystem with below interface:-
    [Tags]    COMMUNICATION    FID-1039407,1340712,1338745,1338743    TCID-435334    FULLTEST
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.can.simulation.PowerBladeON
    # prj.sut.com.Countdown Timer    10
    # prj.sut.can.diag.tester.present.active
    # prj.sut.com.Countdown Timer    10
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send tester present
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}
    Log To Console    CAN 1 device is up and running

EnvD_SysQual_Communication_CANSubsystem_CANInterface_back_CAN2
    [Documentation]    CAN transceiver is used for CAN network communication, 2xCANFD in backplane is use for inter blades communication on rack ,
    ...    2 xCANFD is used for future CAN communication with other ECUs on vehicle
    ...    The system shall support DoIP communication via UDS according to ISO 14229-2:2013 to be used by SW applications.
    ...    2xCAN bus interface to back connector
    ...    The system shall equipped with CAN subsystem with below interface:-
    [Tags]    COMMUNICATION    FID-1039407,1340712,1338745,1338743    TCID-435333    FULLTEST
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.can.simulation.PowerBladeON
    # prj.sut.com.Countdown Timer    10
    # prj.sut.can.diag.tester.present.active
    # prj.sut.com.Countdown Timer    10
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send tester present
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}
    Log To Console    CAN 2 device is up and runningc

EnvD_SysQual_Communication_CANSubsystem_CAN_baudrate
    [Documentation]    The CAN Subsystem shall configure baud rate for all CAN channels as per NIP file
    [Tags]    COMMUNICATION    FID-1340692    TCID-437647    FULLTEST
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    # prj.sut.com.Countdown Timer    5
    # Configuring the baud rate
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.Countdown Timer    3
    prj.sut.com.set Message ID Logging Active
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    prj.sut.com.set Message ID Logging Deactive
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console   CAN baud rate is verified for both the CAN1 and CAN2

EnvD_SysQual_Communication_ETHSwitch_Bank_Size_Sufficient_For_Flashing
    [Documentation]    The external flash connected to Ethernet switch shall have sufficient flash size to contain primary
    ...    and secondary Ethernet switch firmware and switch configuration image.
    [Tags]    COMMUNICATION    FID-1338705    TCID-435331    FULLTEST   Comunication_tag
    prj.sut.connect.dlt
    ${Status}    Run Keyword And Return Status    prj.sut.com.Ethernet Switch Flashing
    ...    ${sut.com.ETH_Path}    88Q5152_flash_devSigned.bin
    IF    ${Status}
        Log To Console    Ethernet Flashing is successful , Partition 1 and Partition 2 are successfully flashed
    ELSE
        Log To Console    Ethernet Flashing is unsuccessful
    END
    prj.sut.power cycle
    Sleep    20
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.com.ETH_Switch_Version}
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet sw version is not updated
    END
 
EnvD_SysQual_Communication_ETHNetwork_Diagnostic_EthernetSwitchFlashing_RMUPort
    [Documentation]    The Automotive Ethernet switch software execution shall boot and operate from external QSPI flash
    [Tags]    COMMUNICATION    FID-1338687,1338716    TCID-435332    FULLTEST   Comunication_tag    
    prj.sut.connect.dlt
    ${Status}    Run Keyword And Return Status    prj.sut.com.Ethernet Switch Flashing
    ...    ${sut.com.ETH_Path}    88Q5152_flash_devSigned.bin
    IF    ${Status}
        Log To Console    Ethernet Flashing is successful , Partition 1 and Partition 2 are successfully flashed
    ELSE
        Log To Console    Ethernet Flashing is unsuccessful
    END
    prj.sut.power cycle
    Sleep    20
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.com.ETH_Switch_Version}
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet sw version is not updated
    END

EnvD_SysQual_Communication_Eth_Switch_heartbeat_To_MCU
    [Documentation]    The Ecosystem Network should support prioritization stateful protocol communication based connections.
    [Tags]    COMMUNICATION    FID-2387856  TCID-568057    FULLTEST   Comunication_tag
    # Perform the ping test
    Close All Connections
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    sleep    20s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    heartbeatVersion API
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet sw version is not updated
    END

EnvD_SysQual_Communication_ETHNetwork_FixedIP_Errorentry
    [Documentation]    If an application tries to change the IP address in its corresponding operating system environment,
    ...    theEcosystem Network shall indicate such intrusion attempts via error memory entry,
    ...    while the number of attempts shall be registered via the event manager.
    [Tags]    COMMUNICATION    FID-4662487  TCID-569467    FULLTEST   Comunication_tag
    # Perform the ping test
    Close All Connections
    prj.sut.connect.dlt
    prj.sut.connect.QNX
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    ifconfig vdev-1
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    inet6 fd53:7cb8:383:18::1:268 prefixlen 64
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    IP is successfully verified
    # Change the ip address and do the ping test again
    write    ifconfig vdev-1 inet6 fd53:7cb8:383:18::1:700
    write    ifconfig vdev-1 inet6 fd53:7cb8:383:18::1:700
    write    ifconfig vdev-1 inet6 fd53:7cb8:383:18::1:700
    write    ifconfig vdev-1 inet6 fd53:7cb8:383:18::1:700
    write    slog2info -v | grep -i networkmanager
    sleep    10s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    [WARNING] [InterfaceMonitor::compareIpLists] IP ADDRESS change detected in vdev-1 from fd53:7cb8:383:18::1:700 to fd53:7cb8:383:18::1:268
    Verify Dumper Paths    ${output}    @{expected_paths}
    @{expected_paths}    Create List    [INFO] [InterfaceMonitor::resetIpList] Removed extra IPv6 fd53:7cb8:383:18::1:700 from vdev-1
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    ifconfig vdev-1
    sleep    5s
    ${output}    Read
    
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    inet6 fd53:7cb8:383:18::1:700
    FOR    ${path}    IN    @{expected_paths}
        ${found}    Run Keyword And Return Status    Should Contain    ${output}    ${path}
        IF    not ${found}
            Log To Console    Expected path "${path}" not found in output. The IP is automatically reset
        END
    END

EnvD_SysQual_Communication_Ecosystem_Network_Stateful_Protocol_Communication_Prioritization
    [Documentation]    The Ecosystem Network should support prioritization stateful protocol communication based connections.
    [Tags]    COMMUNICATION    FID-4967719  TCID-539191    FULLTEST   Comunication_tag
    # Perform the ping test
    Close All Connections
    prj.sut.connect.dlt
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    tcpdump -i vdev-1 -vvv -n net fd53:7cb8:383:18::/64
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    IP6 (class 0x48, flowlabel
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    IP Header is successfully verified

EnvD_SysQual_Communication_CANSubsystem_CANBusLoad 
    [Documentation]    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    ...    .CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6
    ...    but refer to Communication Value Stream on therequirements deviation list
    ...    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    [Tags]    COMMUNICATION    FID-1339503,1338744,1339501    TCID-427032    FULLTEST   Comunication_tag
#   Read the current bus load
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    Sleep    10s
    prj.sut.com.set Environment Variable    Can_Statistics    1    SYSTEM    BusLoad_Read
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    Can_Statistics    0    SYSTEM    BusLoad_Read

    ${Canoe_txt}=    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}

    # Validate: Less than 50%
    prj.sut.com.Validate BusLoad    ${Canoe_txt}    operator=<    threshold=50.0

#   SCENARIO 2: High Load Test (Bus Load > 60%)
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    Sleep    10s
    prj.sut.com.set Environment Variable    TxCtrl    1    SYSTEM    Start_3ms
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    TxCtrl    0    SYSTEM    Start_3ms
    prj.sut.com.set Environment Variable    Can_Statistics    1    SYSTEM    BusLoad_Read
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    Can_Statistics    0    SYSTEM    BusLoad_Read

    ${Canoe_txt}=    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}

    # Validate: Less than 50%
    prj.sut.com.Validate BusLoad    ${Canoe_txt}    operator=>    threshold=60.0

# # SCENARIO 3: Stress Test (Bus Load > 80%)
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    Sleep    10s
    prj.sut.com.set Environment Variable    TxCtrl    1    SYSTEM    Start_2ms
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    TxCtrl    0    SYSTEM    Start_2ms
    prj.sut.com.set Environment Variable    Can_Statistics    1    SYSTEM    BusLoad_Read
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    Can_Statistics    0    SYSTEM    BusLoad_Read

    ${Canoe_txt}=    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}

    # Validate: Less than 50%
    prj.sut.com.Validate BusLoad    ${Canoe_txt}    operator=>    threshold=80.0

EnvD_SysQual_Communication_Ethernet_Speed
    [Documentation]    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    ...    .CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6
    ...    but refer to Communication Value Stream on therequirements deviation list
    ...    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    [Tags]    COMMUNICATION    FID-1039405,1039406    TCID-539197    FULLTEST   Comunication_tag
    # Connect and run client
    # Start iPerf3 server
    Start Process    iperf3    -s    -6    alias=iperf_server
    Sleep    3s
    # Connect and run client
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -c FD53:7CB8:0383:0018:0000:0000:0001:0271 -t 60 -i 5
    prj.sut.com.Countdown Timer    100
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    Run Keyword And Ignore Error   prj.sut.com.Check Speed    ${output}
    Close Connection
    Terminate Process    iperf_server

    # Start iPerf3 server
    Open Connection   ${sut.com.QNX_HOST}    maasdev    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    ${result}    Run Process    cmd    /c    iperf3 -c FD53:7CB8:0383:0018:0000:0000:0001:0268 -t 60 -i 5
    ...    shell=True    timeout=200s
    Log To Console    Return Code: ${result.rc}
    Log To Console    STDOUT:\n${result.stdout}
    Log To Console    STDERR:\n${result.stderr}
    prj.sut.com.Check Speed     ${result.stdout}
    Close All Connections

#  Diagnostic Start Here ########################################################

EnvD_SysQual_Diagnostics_AUTOSARStandardApplicationSoftwareIdentification(0xF1AF)(Default Session)
    [Documentation]    The DID identifies the standard software component(SSW) that are
    ...    integrated onto the project along with the vendor and component version code
    [Tags]    CustomerDiagnostic    TCID-272507    FULLTEST	FID-1132976,1132977,1132978,1132980,1132981,1133008,1133011
    prj.sut.can.diag.tester.present.active
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_Resp}

EnvD_SysQual_Diagnostics_AUTOSARStandardApplicationSoftwareIdentification(0xF1AF)(Extended Session)
    [Documentation]    The DID identifies the standard software component(SSW) that are
    ...    integrated onto the project along with the vendor and component version code
    [Tags]    CustomerDiagnostic    TCID-272506    FULLTEST	FID-1132976,1132977,1132978,1132980,1132981,1133008,1133011

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_Resp}

EnvD_SysQual_Diagnostics_BasicSettingStatus(0x0102)(Default Session)
    [Documentation]    The DID BasicSettingStatus shall give the information
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-272583    FULLTEST	FID-1132896,1132897,1132898,1132900,1132901

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_Req}
    prj.sut.diag.compare    ${sut.diag.BasicSettingStatus_NoRoutineActive_Resp}

EnvD_SysQual_Diagnostics_BasicSettingStatus(0x0102)(Extended Session)
    [Documentation]    The DID BasicSettingStatus shall give the information
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-272582    FULLTEST	FID-1132896,1132897,1132898,1132900,1132901

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_Req}
    prj.sut.diag.compare    ${sut.diag.BasicSettingStatus_NoRoutineActive_Resp}

EnvD_SysQual_Diagnostics_Check_Programming_Preconditions(0x0203)(Default Session)
    [Documentation]    This RoutineIdentifier allows the client to retrieve the
    ...     state of the programming prerequisites in the server.
    [Tags]    CustomerDiagnostic    TCID-272630    FULLTEST	FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1381301,1337931,1453623,1453624,1337933,1337908

    prj.sut.diag.SetETHSignal    0    600
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Check_Programming_Preconditions_Req}
    prj.sut.diag.compare    ${sut.diag.Check_Programming_Preconditions_VehicleSpeedNonZero_Resp}

EnvD_SysQual_Diagnostics_Check_Programming_Preconditions(0x0203)(Extended Session)
    [Documentation]    This RoutineIdentifier allows the client to retrieve the
    ...     state of the programming prerequisites in the server.
    [Tags]    CustomerDiagnostic    TCID-272623    FULLTEST	FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1381301,1337931,1453623,1453624,1337933,1337908
    prj.sut.diag.SetETHSignal    0    600
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Check_Programming_Preconditions_Req}
    prj.sut.diag.compare    ${sut.diag.Check_Programming_Preconditions_VehicleSpeedNonZero_Resp}

EnvD_SysQual_Diagnostics_Default_Session(0x01)
    [Documentation]    This service shall be used to enable different diagnostic sessions in the server(s)
    [Tags]    CustomerDiagnostic    TCID-272530    FULLTEST	FID-1069702,1069706,1069761,1069763

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

EnvD_SysQual_Diagnostics_ECUExtractAR-CVersionNumber(0xFD07)(Default Session)
    [Documentation]    also known as ECUExtractVersionInformation(0xFD07) in requirement.
    ...    The DID ECUExtractVersionInformation shall give the information about
    ...     the ECU Extract Information integrated for that particular PI
    [Tags]    CustomerDiagnostic    TCID-272577    FULLTEST	FID-1435087,1435088,1435089,1435091,1435092

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUExtractAR_CVersionNumber_Resp}

EnvD_SysQual_Diagnostics_ECUExtractAR-CVersionNumber(0xFD07)(Extended Session)
    [Documentation]    also known as ECUExtractVersionInformation(0xFD07) in requirement.
    ...    The DID ECUExtractVersionInformation shall give the information about
    ...     the ECU Extract Information integrated for that particular PI
    [Tags]    CustomerDiagnostic    TCID-272569    FULLTEST	FID-1435087,1435088,1435089,1435091,1435092

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUExtractAR_CVersionNumber_Resp}

EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Default Session)
    [Documentation]    The DID ECUSerialNumber shall give the Serial Number of each of the Blade
    [Tags]    CustomerDiagnostic    TCID-272614    FULLTEST	FID-1150970,1150971,1150972,1150974,1150975

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUSerialNumber_Resp}

EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Extended Session)
    [Documentation]    The DID ECUSerialNumber shall give the Serial Number of each of the Blade
    [Tags]    CustomerDiagnostic    TCID-272611    FULLTEST	FID-1150970,1150971,1150972,1150974,1150975

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUSerialNumber_Resp}

EnvD_SysQual_Diagnostics_Enable_Rx_And_Disable_Tx_Control(0x01)(Default Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-272571    FULLTEST	FID-1453617,1453618,1367233,1367234
    prj.sut.diag.SetETHSignal    0    0
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    prj.sut.diag.compare    ${sut.diag.EnableRxAndDisableTxControl_Resp}

EnvD_SysQual_Diagnostics_Enable_Rx_And_Disable_Tx_Control(0x01)(Extended Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-272627    FULLTEST	FID-1453617,1453618,1367233,1367234
    prj.sut.diag.SetETHSignal    0    0
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    prj.sut.diag.compare    ${sut.diag.EnableRxAndDisableTxControl_Resp}

EnvD_SysQual_Diagnostics_Enable_Rx_And_Tx_Control(0x00)(Default Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-272568    FULLTEST	FID-1453617,1453618,1367233,1367234
    prj.sut.diag.SetETHSignal    0    0
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_Req}
    prj.sut.diag.compare    ${sut.diag.EnableRxAndTxControl_Resp}

EnvD_SysQual_Diagnostics_Enable_Rx_And_Tx_Control(0x00)(Extended Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-272572    FULLTEST	FID-1453617,1453618,1367233,1367234
    prj.sut.diag.SetETHSignal    0    0
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_Req}
    prj.sut.diag.compare    ${sut.diag.EnableRxAndTxControl_Resp}

EnvD_SysQual_Diagnostics_Extended_Session(0x03)
    [Documentation]    This service shall be used to enable different diagnostic sessions in the server(s)
    [Tags]    CustomerDiagnostic    TCID-272527    FULLTEST	FID-1069702,1069705,1069718,1069761,1069763

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

EnvD_SysQual_Diagnostics_OFF_Control_DTC_Setting(0x02)
    [Documentation]    This service is used to deactivate and reactivate the update of
    ...    the StatusOfDTC bits of events and notices in the event memory
    [Tags]    CustomerDiagnostic    TCID-272642    FULLTEST    FID-1286027,1286042,1286049,1286050,1287772,1287773    DTC

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21

    Sleep     3s

    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s

    # Set DTC setting to OFF
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    # Qualify Overvoltage DTC again
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s
    # Check DTC should not be logged
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}

    # post condition
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ON_Control_DTC_Setting(0x01)
    [Documentation]    This service is used to deactivate and reactivate the update of
    ...    the StatusOfDTC bits of events and notices in the event memory
    [Tags]    CustomerDiagnostic    TCID-272640    FULLTEST	FID-1286027,1286042,1286049,1286050,1287772,1287773    DTC

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s

    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}

    # Check if DTC is cleared
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}
    # Set DTC setting to ON
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON_Resp}

    # Qualify Overvoltage DTC again
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep     3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s

    # Check DTC should be logged
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    # post condition
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Report_DTC_By_Status_Mask(0x02)(Default Session)
    [Documentation]    The client can retrieve a list of DTCs, which satisfy a client defined
    ...     status mask by sending a request with the SubFunction byte set to reportDTCByStatusMask.
    [Tags]    CustomerDiagnostic    TCID-272540    FULLTEST	FID-1287925,1290752,1287925,1290752,1290762,1290764,1290765

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep     3s

EnvD_SysQual_Diagnostics_VWSystemNameOrEngineType(0xF197)(Default Session)
    [Documentation]    The DID SystemNameOrEngineType shall give the information
    ...    about the system name of the Blade
    [Tags]    CustomerDiagnostic    TCID-272580    FULLTEST	FID-1383247,1383248,1383249,1383251,1383252

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemNameOrEngineType_Resp}

EnvD_SysQual_Diagnostics_VWSystemNameOrEngineType(0xF197)(Extended Session)
    [Documentation]    The DID SystemNameOrEngineType shall give the information
    ...    about the system name of the Blade
    [Tags]    CustomerDiagnostic    TCID-272579    FULLTEST	FID-1383247,1383248,1383249,1383251,1383252

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemNameOrEngineType_Resp}

EnvD_SysQual_Diagnostics_VWSystemFirmwareVersion(0xF1B8)(Default Session)
    [Documentation]    This DataIdentifier identifies the hardware-related software versions of the Blade
    [Tags]    CustomerDiagnostic    TCID-272567    FULLTEST	FID-1453704,1453705,1453706,1453708,1453709

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemFirmwareVersion_Resp}

EnvD_SysQual_Diagnostics_VWSystemFirmwareVersion(0xF1B8)(Extended Session)
    [Documentation]    This DataIdentifier identifies the hardware-related software versions of the Blade
    [Tags]    CustomerDiagnostic    TCID-272574    FULLTEST	FID-1453704,1453705,1453706,1453708,1453709

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemFirmwareVersion_Resp}

EnvD_SysQual_Diagnostics_VW_Spare_Part_Number(0xF187)(Default Session)
    [Documentation]    This DataIdentifier identifies the Blade specific part number of a control unit.
    [Tags]    CustomerDiagnostic    TCID-272585    FULLTEST	FID-1440269,1440270,1440271,1440273,1440274

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWSparePartNumber_Resp}

EnvD_SysQual_Diagnostics_VW_Spare_Part_Number(0xF187)(Extended Session)
    [Documentation]    This DataIdentifier identifies the Blade specific part number of a control unit.
    [Tags]    CustomerDiagnostic    TCID-272586    FULLTEST	FID-1440269,1440270,1440271,1440273,1440274

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWSparePartNumber_Resp}

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockLockValue(0x040F)(Default Session)
    [Documentation]    This Data Identifier identifies blocking values for the counters of
    ...     the programming attempts (lock value) of the corresponding logical software block #1-#n
    [Tags]    CustomerDiagnostic    TCID-272634    FULLTEST	FID-1691094,1691095,1691096,1691098,1691099

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockLockValue_Resp}

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockLockValue(0x040F)(Extended Session)
    [Documentation]    This Data Identifier identifies blocking values for the counters of
    ...     the programming attempts (lock value) of the corresponding logical software block #1-#n
    [Tags]    CustomerDiagnostic    TCID-272633    FULLTEST	FID-1691094,1691095,1691096,1691098,1691099

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockLockValue_Resp}

EnvD_SysQual_Diagnostics_RollerTestStandMode(0x04FB)(Default Session)
    [Documentation]    The DID RollerTestStandMode shall be used to Activate/Deactivate
    ...    the Roller test stand mode for the ECU in default mode.
    [Tags]    CustomerDiagnostic    TCID-272514    FULLTEST	FID-1132910,1132911,1132912,1132914,1132915,1069815,1069829

    # precondition
    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_00_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of RollerTestStandMode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandMode_Resp}

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Check is what is written is reflected.
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWriteUpdate_Resp}

EnvD_SysQual_Diagnostics_RollerTestStandMode(0x04FB)(Extended Session)
    [Documentation]    The DID RollerTestStandMode shall be used to Activate/Deactivate
    ...    the Roller test stand mode for the ECU in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272491    FULLTEST	FID-1132910,1132911,1132912,1132914,1132915,1069815,1069829

    # precondition
    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_00_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command of RollerTestStandMode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandMode_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Check is what is written is reflected.
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWriteUpdate_Resp}

EnvD_SysQual_Diagnostics_SendRequest_ReferringCDD
    [Documentation]    To verify that ReadDataByIdentifier($22) service allows
    ...    the client to request data record values from the server
    ...    identified by one or more dataIdentifiers via CDD.
    [Tags]    CustomerDiagnostic    TCID-272529    FULLTEST	FID-1069770

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_RollerTestStandMode_Write(0x04FB)
    [Documentation]    The DID RollerTestStandMode shall be used to Activate/Deactivate the Roller test stand mode for the ECU
    [Tags]    CustomerDiagnostic    TCID-272629    FULLTEST	FID-1151240,1151246,1151257,1151277,1151260,1151264,1151267,1151272

    # precondition

    prj.sut.diag.SetETHSignal    0    0
    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_00_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Send command of RollerTestStandMode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandMode_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Check is what is written is reflected.
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWriteUpdate_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareNumber(0xF192)(Default Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW number in default mode.
    [Tags]    CustomerDiagnostic    TCID-272617    FULLTEST	FID-1150982,1150983,1150984,1150986,1150987

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # send command for SystemSupplierECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareNumber(0xF192)(Extended Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW number in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272604    FULLTEST	FID-1150982,1150983,1150984,1150986,1150987

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # send command for SystemSupplierECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareVersionNumber(0xF193)(Default Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW version number

    [Tags]    CustomerDiagnostic    TCID-272607    FULLTEST	FID-1150992,1150994,1150995,1150997,1150998

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareVersionNumber(0xF193)(Extended Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW version number in extended mode

    [Tags]    CustomerDiagnostic    TCID-272621    FULLTEST	FID-1150992,1150994,1150995,1150997,1150998

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # send command for ECU hardware version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSoftwareVersionNumber(0xF195)(Default Session)
    [Documentation]    The DID SystemSupplierECUSoftwareVersionNumber identifies
    ...    the versions of the different Software elements
    [Tags]    CustomerDiagnostic    TCID-272625    FULLTEST    FID-1151146,1151148,1151149,1151151,1151152,2872998,2872999,2873000,2873002,2873003

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Resp}

# tell aizat test case need to modify in manual step

EnvD_SysQual_Diagnostics_SystemSupplierECUSoftwareVersionNumber(0xF195)(Extended Session)
    [Documentation]    The DID SystemSupplierECUSoftwareVersionNumber identifies
    ...    the versions of the different Software elements
    [Tags]    CustomerDiagnostic    TCID-272622    FULLTEST	FID-1151146,1151148,1151149,1151151,1151152,2872998,2872999,2873000,2873002,2873003

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSWNumber(0xF194)(Default Session)
    [Documentation]    The DID SystemSupplierECUSWNumber shall give the information
    ...    about the SW part Number of the ECU in default mode

    [Tags]    CustomerDiagnostic    TCID-272641    FULLTEST	FID-1150959,1150960,1150961,1150966,1150963

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of system supplier supplier ECUSW number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSWNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSWNumber(0xF194)(Extended Session)
    [Documentation]   The DID SystemSupplierECUSWNumber shall give the information
    ...    about the SW part Number of the ECU in extended mode.

    [Tags]    CustomerDiagnostic    TCID-272638    FULLTEST	FID-1150959,1150960,1150961,1150966,1150963

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command of system supplier supplier ECUSW number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSWNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierIdentification(0xF18A)(Default Session)
    [Documentation]    The DID SystemSupplierIdentification shall give the information
    ...    about the name and address of the Supplier of the Blade

    [Tags]    CustomerDiagnostic    TCID-272631    FULLTEST	FID-1150949,1150950,1150951,1150953,1150954

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of system supplier identification
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierIdentification_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierIdentification(0xF18A)(Extended Session)
    [Documentation]    The DID SystemSupplierIdentification shall give the information
    ...    about the name and address of the Supplier of the Blade

    [Tags]    CustomerDiagnostic    TCID-272628    FULLTEST	FID-1150949,1150950,1150951,1150953,1150954

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command of system supplier identification
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierIdentification_Resp}

EnvD_SysQual_Diagnostics_TechnicalSpecificationsVersion(0xF1B4)(Default Session)
    [Documentation]    The DID TechnicalSpecificationVershion shall identified
    ...    the designations and versions of implemented specifications in default session

    [Tags]    CustomerDiagnostic    TCID-272570    FULLTEST	FID-1132921,1132922,1132923,1132925,1132926

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command for TechnicalSpecificationsVersion
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_Req}
    prj.sut.diag.compare    ${sut.diag.TechnicalSpecificationsVersion_Resp}

EnvD_SysQual_Diagnostics_TechnicalSpecificationsVersion(0xF1B4)(Extended Session)
    [Documentation]    The DID TechnicalSpecificationVershion shall identified
    ...    the designations and versions of implemented specifications in extended session

    [Tags]    CustomerDiagnostic    TCID-272576    FULLTEST	FID-1132921,1132922,1132923,1132925,1132926

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command for TechnicalSpecificationsVersion
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_Req}
    prj.sut.diag.compare    ${sut.diag.TechnicalSpecificationsVersion_Resp}

EnvD_SysQual_Diagnostics_Tester_Present(Extended Session)
    [Documentation]    This service shall be used to keep the server in a diagnostic session other than the default Session.
    ...    This service is used to indicate to a server (or servers)
    ...    that a client is still connected to the vehicle and that
    ...    certain diagnostic services and/or communication that
    ...    have been previously activated are to remain active.

    [Tags]    CustomerDiagnostic    TCID-272533    FULLTEST	FID-1069374,1069377,1069379

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send tester present
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}

    # Wait for 4.5s
    Sleep    4.5s

    # Check active session
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

EnvD_SysQual_Diagnostics_VehicleIdentificationNumber(0xF190)(Default Session)
    [Documentation]    The DID VehicleIdentificationNumber shall give the chassis number
    [Tags]    CustomerDiagnostic    TCID-272600    FULLTEST	FID-1132964,1132965,1132967,1132968

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.VIN    ${sut.diag.VehicleIdentificationNumber_0000}
    Sleep    3s

    # Send VehicleIdentificationNumber
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_0000_Resp}

EnvD_SysQual_Diagnostics_VehicleIdentificationNumber(0xF190)(Extended Session)
    [Documentation]    The DID VehicleIdentificationNumber shall give the chassis number in extended mode
    [Tags]    CustomerDiagnostic    TCID-272602    FULLTEST	FID-1132964,1132965,1132967,1132968

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.VIN    ${sut.diag.VehicleIdentificationNumber_1234}
    Sleep    3s

    # Send VehicleIdentificationNumber
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_1234_Resp}

EnvD_SysQual_Diagnostics_VW_FAZIT_Identification(0xF17C)(Default Session)
    [Documentation]    This Data Identifier identifies the FAZIT identification number of a blade in default mode.
    [Tags]    CustomerDiagnostic    TCID-272618    FULLTEST    FID-1692043,1692044,1692045,1692047,1692048

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # send VW spare part number
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_Req}
    prj.sut.diag.compare    ${sut.diag.VW_FAZIT_Identification_Resp}

EnvD_SysQual_Diagnostics_VW_FAZIT_Identification(0xF17C)(Extended Session)
    [Documentation]    This Data Identifier identifies the FAZIT identification number of a blade in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272619    FULLTEST    FID-1692043,1692044,1692045,1692047,1692048

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # send VW spare part number
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_Req}
    prj.sut.diag.compare    ${sut.diag.VW_FAZIT_Identification_Resp}

EnvD_SysQual_Diagnostics_Group_of_DTC(0xFFFFFF)(Default Session)
    [Documentation]    The Clear Diagnostics Service is used to clear/delete the entries from the Primary memory.
    [Tags]    CustomerDiagnostic    TCID-272522    FULLTEST	FID-1287691,1287693,1287744,1287745,1287764,1287765

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_None_Resp}    #    new change

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     10s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_None_Resp}    #    new change

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Group_of_DTC(0xFFFFFF)(Extended Session)
    [Documentation]    The Clear Diagnostics Service is used to clear/delete the entries from the Primary memory.
    [Tags]    CustomerDiagnostic    TCID-272548    FULLTEST	FID-1287691,1287693,1287744,1287745,1287764,1287765

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_None_Resp}    #    new change

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     10s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_None_Resp}    #    new change

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)(Default Session)
    [Documentation]    This Data Identifier identifies all current IPv6 addresses of the
    ...    control unit which are not IPv6 multicast addresses.
    [Tags]    CustomerDiagnostic    TCID-272593    FULLTEST	FID-1691409,1691410,1691411,1691413,1691414

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6AddressesList_Resp}

EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)(Extended Session)
    [Documentation]    This Data Identifier identifies all current IPv6 addresses of the
    ...    control unit which are not IPv6 multicast addresses.
    [Tags]    CustomerDiagnostic    TCID-272578    FULLTEST	FID-1691409,1691410,1691411,1691413,1691414

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6AddressesList_Resp}

EnvD_SysQual_Diagnostics_IpIpv6MulticastAddressesList(0x013E)(Default Session)
    [Documentation]    This Data Identifier identifies all current IPv6 multicast addresses
    ...    of the Blade.
    [Tags]    CustomerDiagnostic    TCID-272562    FULLTEST	FID-1691418,1691419,1691420,1691422,1691423

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6MultiCastAddressesList_Resp}

EnvD_SysQual_Diagnostics_IpIpv6MulticastAddressesList(0x013E)(Extended Session)
    [Documentation]    This Data Identifier identifies all current IPv6 multicast addresses
    ...    of the Blade.
    [Tags]    CustomerDiagnostic    TCID-272564    FULLTEST	FID-1691418,1691419,1691420,1691422,1691423

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6MultiCastAddressesList_Resp}

EnvD_SysQual_Diagnostics_NRC$13_IncorrectMessageLengthorInvalidFormat
    [Documentation]    This NRC shall be sent if:
    ...    1) the length of the request message is invalid (minimum length check or modulo 2 division)
    ...    2) the client exceeded the maximum number of dataIdentifiers allowed to be
    ...    requested at a time (max. length check).
    [Tags]    CustomerDiagnostic    TCID-272501    FULLTEST	FID-1151358,1151359,1071149,1069774

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_9DID_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_NRC$13_IncorrectMessageLengthOrInvalidFormat_Write
    [Documentation]    This NRC shall be sent if the length of the message is wrong (min. length check)
    [Tags]    CustomerDiagnostic    TCID-272499    FULLTEST	FID-1151438,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Write_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

EnvD_SysQual_Diagnostics_NRC$13_RequestLengthExceeded_Write
    [Documentation]    This NRC shall be sent if the length of the message is wrong (max. length check)
    [Tags]    CustomerDiagnostic    TCID-272496    FULLTEST	FID-1151441,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Write_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

EnvD_SysQual_Diagnostics_Programming_Preconditions(0x0448)(Default Session)
    [Documentation]    This DataIdentifier identifies the programming pre-requisites of the Blade
    [Tags]    CustomerDiagnostic    TCID-272603    FULLTEST	FID-1665039,1665040,1665041,1665043,1665044

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_Req}
    prj.sut.diag.compare    ${sut.diag.ProgrammingPreconditions_Resp}

EnvD_SysQual_Diagnostics_Programming_Preconditions(0x0448)(Extended Session)
    [Documentation]    This DataIdentifier identifies the programming pre-requisites of the Blade
    [Tags]    CustomerDiagnostic    TCID-272610    FULLTEST	FID-1665039,1665040,1665041,1665043,1665044

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_Req}
    prj.sut.diag.compare    ${sut.diag.ProgrammingPreconditions_Resp}

EnvD_SysQual_Diagnostics_VWApplicationSoftwareVersionNumber(0xF189)(Default Session)
    [Documentation]    The DID VWApplicationSoftwareVersionNumber shall give the
    ...    information about the overall SW(ASW+BSW) version number of
    ...    the Blade.
    [Tags]    CustomerDiagnostic    TCID-272573    FULLTEST	FID-1151031,1151033,1151034,1151036,1151037

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command VWApplicationSoftwareVersionNumber
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWApplicationSoftwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWApplicationSoftwareVersionNumber(0xF189)(Extended Session)
    [Documentation]    The DID VWApplicationSoftwareVersionNumber shall give the
    ...    information about the overall SW(ASW+BSW) version number of
    ...    the Blade in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272560    FULLTEST	FID-1151031,1151033,1151034,1151036,1151037

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command VWApplicationSoftwareVersionNumber
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWApplicationSoftwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareNumber(0xF191)(Default Session)
    [Documentation]    The DID VWECUHardwareNumber shall give the information about the VW HW version number of each blade
    [Tags]    CustomerDiagnostic    TCID-272566    FULLTEST	FID-1151010,1151012,1151013,1151015,1151016

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareNumber(0xF191)(Extended Session)
    [Documentation]    The DID VWECUHardwareNumber shall give the information about the VW HW version number of each blade in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272563    FULLTEST	FID-1151010,1151012,1151013,1151015,1151016

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareVersionNumber(0xF1A3)(Default Session)
    [Documentation]    The DID SystemSupplierECUHardwareVersionNumber shall give
    ...    the information about VW ECU HW version number
    [Tags]    CustomerDiagnostic    TCID-272591    FULLTEST	FID-1151021,1151023,1151024,1151026,1151027

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareVersionNumber(0xF1A3)(Extended Session)
    [Documentation]    The DID SystemSupplierECUHardwareVersionNumber shall give
    ...    the information about VW ECU HW version number in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272597    FULLTEST	FID-1151021,1151023,1151024,1151026,1151027

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_NRC$31_RequestOutOfRange
    [Documentation]    This NRC shall be returned if none of the requested
    ...                dataIdentifier values are supported by the device
    [Tags]    CustomerDiagnostic    TCID-272503    FULLTEST	FID-1151358,1151362,1071149

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.NotSupportedDID_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_NRC$31_RequestOutOfRange_Write
    [Documentation]    This NRC shall be returned if any data transmitted
    ...     in the request message after the dataIdentifier is invalid.
    [Tags]    CustomerDiagnostic    TCID-272511    FULLTEST	FID-1151440,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Write_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

EnvD_SysQual_Diagnostics_NRC$31_RequestOutOfRange_Write_2
    [Documentation]    This NRC shall be returned if the
    ...    dataIdentifier in the request message is not supported in the server
    [Tags]    CustomerDiagnostic    TCID-272510    FULLTEST	FID-1151443,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Write_IncorrectData_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

EnvD_SysQual_Diagnostics_Multi_DID_Request_check
    [Documentation]    To verify that- Multi DID (Up to 8 DID's) request shall be supported using service 0x22.
    [Tags]    CustomerDiagnostic    TCID-272502    FULLTEST	FID-1069773

    ${MultiDID_Resp}    Catenate    ${sut.diag.MultiDID_Resp}
    ...  ${sut.diag.ProgrammingPreconditions_MultiDID_Resp}
    ...  ${sut.diag.VWSystemNameOrEngineType_MultiDID_Resp}
    ...  ${sut.diag.VWSystemFirmwareVersion_MultiDID_Resp}
    ...  ${sut.diag.VWSparePartNumber_MultiDID_Resp}
    ...  ${sut.diag.VWLogicalSoftwareBlockLockValue_MultiDID_Resp}
    ...  ${sut.diag.ECUProgrammingInformation_Programmable_MultiDID_Resp}
    ...  ${sut.diag.ProgrammingPreconditions_MultiDID_Resp}
    ...  ${sut.diag.ActiveDiagnosticSession_DefaultSession_MultiDID_Resp}

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MultiDID_Req}
    prj.sut.diag.compare    ${MultiDID_Resp}

    ${MultiDID_Resp}    Catenate    ${sut.diag.MultiDID_Resp}
    ...  ${sut.diag.ProgrammingPreconditions_MultiDID_Resp}
    ...  ${sut.diag.VWSystemNameOrEngineType_MultiDID_Resp}
    ...  ${sut.diag.VWSystemFirmwareVersion_MultiDID_Resp}
    ...  ${sut.diag.VWSparePartNumber_MultiDID_Resp}
    ...  ${sut.diag.VWLogicalSoftwareBlockLockValue_MultiDID_Resp}
    ...  ${sut.diag.ECUProgrammingInformation_Programmable_MultiDID_Resp}
    ...  ${sut.diag.ProgrammingPreconditions_MultiDID_Resp}
    ...  ${sut.diag.ActiveDiagnosticSession_ExtendedSession_MultiDID_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MultiDID_Req}
    prj.sut.diag.compare    ${MultiDID_Resp}

EnvD_SysQual_Diagnostics_MultipleTimeNegativeRequest
    [Documentation]    In a multi DID request, the negative response shall be sent only
    ...     when all the DIDs are responded with negative response
    [Tags]    CustomerDiagnostic    TCID-272556    FULLTEST	FID-1069777

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Multi_Negative_DID_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_MultipleTimeNegativeRequest_WithPositiveRequest
    [Documentation]    In a muti DID request, if any DID is reported as negative response,
    ...     then that particular response shall be skipped
    [Tags]    CustomerDiagnostic    TCID-272615    FULLTEST	FID-1069776

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Multi_Negative_with_Positive_DID_Req}
    prj.sut.diag.compare    ${sut.diag.Multi_Negative_with_Positive_DID_Resp}

EnvD_SysQual_Diagnostics_MultipleTimeRequest
    [Documentation]    In a multi DID request, if the same DID is requested multiple times
    ...     then the DID shall be responded multiple times
    [Tags]    CustomerDiagnostic    TCID-272613    FULLTEST	FID-1069775

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Multi_Same_DID_Req}
    prj.sut.diag.compare    ${sut.diag.Multi_Same_DID_Resp}

    # 24.3 new test case starts here

EnvD_SysQual_Diagnostics_DTC_Overvoltage
    [Documentation]    The Operating Mode Subsystem shall set DTC when system voltage enters OVERVOLTAGE state.
    [Tags]    CustomerDiagnostic    TCID-353659    FID-2889309

    # Clear DTC command

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    ${status}    Run keyword and return status    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    IF    ${status} == $True
        Set test status to fail    error_type=Diagnostic    info_text=Overvoltage DTC is still seen
    ELSE
        Log to Console    Overvoltage DTC is cleared andnot seen. Continue test
    END
    prj.sut.connect.dlt

    # Adjust KL30 voltage to Overvoltage 18V
    bits_platform.Output Set Analog Signal Value    Battery    21
    Verify DLT keyword    Voltage enters OVERVOLTAGE range
    Log To Console    Maas Blade enters Overvoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    # Return back to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s

EnvD_SysQual_Diagnostics_DTC_Undervoltage
    [Documentation]    The Operating Mode Subsystem shall set DTC when system voltage enters UNDERVOLTAGE state.
    [Tags]    CustomerDiagnostic    TCID-353660    FID-2881566
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    ${status}    Run keyword and return status    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_UndervoltageDTC_Resp}
    IF    ${status} == $True
        Set test status to fail    error_type=Diagnostic    info_text=Undervoltage DTC is still seen
    ELSE
        Log to Console    Undervoltage DTC is cleared andnot seen. Continue test
    END
    prj.sut.connect.dlt

    # Adjust KL30 voltage to UnderVoltage 7V
    bits_platform.Output Set Analog Signal Value    Battery    7
    Verify DLT keyword    Voltage enters UNDERVOLTAGE range
    Log To Console    Maas Blade enters Undervoltage
    Sleep    10s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_UndervoltageDTC_Resp}

    # Return back to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s

EnvD_SysQual_Diagnostics_IpCounterDroppedIpv6PacketsLayer3(0x01A0)(Default Session)
    [Documentation]    The DID IpCounterDroppedIpv6PacketsLayer3 shall give the count
    ...    about discarded IPv6 packets
    [Tags]    CustomerDiagnostic    TCID-272596    FULLTEST    FID-1383436,1383437,1383438,1383440,1383441
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    Log To Console    counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_0x01A0_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Resp}    0    8

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the 1st variable +1
    IF    ${Counter_Int_new} == ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
    ELSE
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
    END

EnvD_SysQual_Diagnostics_IpCounterDroppedIpv6PacketsLayer3(0x01A0)(Extended Session)
    [Documentation]    The DID IpCounterDroppedIpv6PacketsLayer3 shall give the count
    ...    about discarded IPv6 packets
    [Tags]    CustomerDiagnostic    TCID-272595    FULLTEST    FID-1383436,1383437,1383438,1383440,1383441

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_0x01A0_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Resp}    0    8

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the 1st variable +1
    IF    ${Counter_Int_new} == ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
    ELSE
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
    END

EnvD_SysQual_Diagnostics_ResetIpCounterDroppedIpv6PacketsLayer(0x068C)
    [Documentation]    This RID shall reset the Count of the Dropped IPV6 packets
    [Tags]    CustomerDiagnostic    TCID-272624    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1378481,1378482,1378484,1378489,1378490

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Increase the counter
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_0x01A0_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Resp}

        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterDroppedIpv6PacketsLayer(0x068C)(Extended Session)
    [Documentation]    This RID shall reset the Count of the Dropped IPV6 packets
    [Tags]    CustomerDiagnostic    TCID-353707    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1378481,1378482,1378484,1378489,1378490

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Increase the counter
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_0x01A0_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Resp}

        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_IpCounterDroppedUdpTcpPacketsLayer4(0x01A1)(Default Session)
    [Documentation]    This Data Identifier identifies counter UDP and TCP messages with
    ...    wrong ports
    [Tags]    CustomerDiagnostic    TCID-272599    FULLTEST    FID-1692033,1692034,1692035,1692037,1692038

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Resp}    0    8

    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # Calculate the expected new counter value
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    ${bAck}    Set Variable    ${False}
    # FOR loop for retries
    FOR    ${i}    IN RANGE    3
        Log To Console    Attempt #${i+1} to increase and verify the counter

        # Increase the counter for the signal
        prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_0x01A1_CounterAdd}

        # Send command again to get the new value
        prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
        prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
        prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Resp}    0    8

        # Take the new last Byte
        ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
        ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
        Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

        # Compare with the 1st variable +1
        IF    ${Counter_Int_new} == ${Counter2_Int_new}
            Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
            Log To Console    Test Case PASS!!
            ${bAck}    Set Variable    ${True}
            BREAK
        ELSE
            Log To Console    The new counter ${Counter2_Int_new} is not the same as expected ${Counter_Int_new}
        END
    END

    IF    ${bAck} == ${False}
            Set Test Status To Fail    info_text=The new counter ${Counter2_Int_new} is not the same as expected ${Counter_Int_new}
    END

EnvD_SysQual_Diagnostics_IpCounterDroppedUdpTcpPacketsLayer4(0x01A1)(Extended Session)
    [Documentation]    This Data Identifier identifies counter UDP and TCP messages with
    ...    wrong ports
    [Tags]    CustomerDiagnostic    TCID-272598    FULLTEST    FID-1692033,1692034,1692035,1692037,1692038

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Resp}    0    8

    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # Calculate the expected new counter value
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    ${bAck}    Set Variable    ${False}
    # FOR loop for retries
    FOR    ${i}    IN RANGE    3
        Log To Console    Attempt #${i+1} to increase and verify the counter

        # Increase the counter for the signal
        prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_0x01A1_CounterAdd}

        # Send command again to get the new value
        prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
        prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
        prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Resp}    0    8

        # Take the new last Byte
        ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
        ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
        Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

        # Compare with the 1st variable +1
        IF    ${Counter_Int_new} == ${Counter2_Int_new}
            Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
            Log To Console    Test Case PASS!!
            ${bAck}    Set Variable    ${True}
            BREAK
        ELSE
            Log To Console    The new counter ${Counter2_Int_new} is not the same as expected ${Counter_Int_new}
        END
    END

    IF    ${bAck} == ${False}
            Set Test Status To Fail    info_text=The new counter ${Counter2_Int_new} is not the same as expected ${Counter_Int_new}
    END

EnvD_SysQual_Diagnostics_ResetIpCounterDroppedUdpTcpPacketsLayer4(0x068D)
    [Documentation]    The routine "Reset, counter discarded UDP/TCP packets, layer 4"
    ...    must reset the measured value "Counter discarded UDP/TCP packets, layer 4" to the value 0.
    [Tags]    CustomerDiagnostic    TCID-272639    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1805364,1805365,1805366,1805368,1805369

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_0x01A1_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Req}
        # prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterDroppedUdpTcpPacketsLayer4(0x068D)(Extended_Session)
    [Documentation]    The routine "Reset, counter discarded UDP/TCP packets, layer 4"
    ...    must reset the measured value "Counter discarded UDP/TCP packets, layer 4" to the value 0.
    [Tags]    CustomerDiagnostic    TCID-353725    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1805364,1805365,1805366,1805368,1805369

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_0x01A1_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Req}
        # prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_IpCounterWrongIpv6Addresses(0x0A2C)(Default Session)
    [Documentation]    This Data Identifier identifies counter messages with invalid IPv6
    ...    addresses.
    [Tags]    CustomerDiagnostic    TCID-272565    FULLTEST    FID-1858015,1858016,1858017,1858019,1858020

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongIpv6Addresses_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongIpv6Addresses_0x0A2C_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongIpv6Addresses_Resp}    0    8

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the 1st variable +1
    IF    ${Counter_Int_new} == ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
    ELSE
        Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_IpCounterWrongIpv6Addresses(0x0A2C)(Extended Session)
    [Documentation]    This Data Identifier identifies counter messages with invalid IPv6
    ...    addresses.
    [Tags]    CustomerDiagnostic    TCID-272558    FULLTEST    FID-1858015,1858016,1858017,1858019,1858020

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongIpv6Addresses_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongIpv6Addresses_0x0A2C_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongIpv6Addresses_Resp}    0    8

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the 1st variable +1
    IF    ${Counter_Int_new} == ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
    ELSE
        Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_IpCounterWrongUdpPorts(0x0A2F)(Default Session)
    [Documentation]    The DID IpCounterWrongUdpPorts shall give the count about
    ...    wrong UDP ports via which the ethernet packets are sent
    [Tags]    CustomerDiagnostic    TCID-272590    FULLTEST    FID-1394231,1394232,1394233,1394235,1394236

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongUdpPorts_Resp}    0    8
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # Calculate the expected new counter value
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    ${bAck}    Set Variable    ${False}

    # FOR loop for retries
    FOR    ${i}    IN RANGE    3
        Log To Console    Attempt #${i+1} to increase and verify the counter

        # Increase the counter for the signal
        prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongUdpPorts_0x0A2F_CounterAdd}

        # Send command again to get the new value
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongUdpPorts_Resp}    0    8

        # Take the new last Byte
        ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
        ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
        Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

        # Compare with the 1st variable +1
        IF    ${Counter_Int_new} == ${Counter2_Int_new}
            Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
            Log To Console    Test Case PASS!!
            ${bAck}    Set Variable    ${True}
            BREAK
        ELSE
            Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        END
    END

    # After all retries, fail the test if the flag was never set to True
    IF    ${bAck} == ${False}
        Set Test Status to Fail    info_text=The new counter ${Counter2_Int_new} is not the same as expected ${Counter_Int_new} after all retries.
    END

EnvD_SysQual_Diagnostics_IpCounterWrongUdpPorts(0x0A2F)(Extended Session)
    [Documentation]    The DID IpCounterWrongUdpPorts shall give the count about
    ...    wrong UDP ports via which the ethernet packets are sent
    [Tags]    CustomerDiagnostic    TCID-272592    FULLTEST    FID-1394231,1394232,1394233,1394235,1394236

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongUdpPorts_Resp}    0    8
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # Calculate the expected new counter value
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    ${bAck}    Set Variable    ${False}

    # FOR loop for retries
    FOR    ${i}    IN RANGE    3
        Log To Console    Attempt #${i+1} to increase and verify the counter

        # Increase the counter for the signal
        prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongUdpPorts_0x0A2F_CounterAdd}

        # Send command again to get the new value
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongUdpPorts_Resp}    0    8

        # Take the new last Byte
        ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
        ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
        Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

        # Compare with the 1st variable +1
        IF    ${Counter_Int_new} == ${Counter2_Int_new}
            Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
            Log To Console    Test Case PASS!!
            ${bAck}    Set Variable    ${True}
            BREAK
        ELSE
            Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        END
    END

    # After all retries, fail the test if the flag was never set to True
    IF    ${bAck} == ${False}
        Set Test Status to Fail    info_text=The new counter ${Counter2_Int_new} is not the same as expected ${Counter_Int_new} after all retries.
    END

EnvD_SysQual_Diagnostics_ResetIpCounterWrongUdpPorts(0x05EB)
    [Documentation]    The routine "ResetIpCounterWrongUdpPorts" shall reset the
    ...    measured value "counter messages with invalid UDP ports" to the
    ...    value 0
    [Tags]    CustomerDiagnostic    TCID-272626    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1378495,1378496,1378497,1378499,1378500

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongUdpPorts_0x0A2F_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongUdpPorts_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterWrongUdpPorts(0x05EB)(Extended Session)
    [Documentation]    The routine "ResetIpCounterWrongUdpPorts" shall reset the
    ...    measured value "counter messages with invalid UDP ports" to the
    ...    value 0
    [Tags]    CustomerDiagnostic    TCID-353728    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1378495,1378496,1378497,1378499,1378500

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongUdpPorts_0x0A2F_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_Req}
        # prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongUdpPorts_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_ResetIpCounterWrongTcpPorts(0x05E5)
    [Documentation]    The routine "ResetIpCounterWrongTcpPorts" shall reset the
    ...    measured value "counter messages with invalid TCP ports" to the
    ...    value 0
    [Tags]    CustomerDiagnostic    TCID-272632    FULLTEST
    ...       FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1805353,1805354,1805355,1805357,1805358

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Increase the counter
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongTcpPorts_0x0A2E_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongTcpPorts_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterWrongTcpPorts_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongTcpPorts_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongTcpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterWrongTcpPorts_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

# 24.4RC1


# tower 3

# EnvD_SysQual_Diagnostics_DTC_NoETHConnectionToMainBlade
#     [Documentation]    In case no ethernet link is established to Main Blade(Port 9)
#     ...     after 5000ms upon system boot up,DTC shall be logged.
#     [Tags]    FULLTEST    CustomerDiagnostic    TCID-371276    FID-2441939

#     # Shutdown the System and q5050 switchboard
#     prj.sut.can.simulation.PowerBladeOFF
#     ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    0
#     # ${b_ack}    bits_platform.Output Set Analog Signal Value    Ignition    0
#     ${b_ack}    bits_platform.Output Set Analog Signal Value    Q5050    0
#     Sleep    2s
#     # Turn back on the board
#     # ${b_ack}    bits_platform.Output Set Analog Signal Value    Ignition    12
#     ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    12
#     prj.sut.can.simulation.PowerBladeON
#     Sleep    6s

#     # Turn ON Q5050 switch
#     ${b_ack}    bits_platform.Output Set Analog Signal Value    Q5050    12
#     Sleep    8s
#     # Check DTC
#     prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
#     Sleep    3s
#     prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_NoETHConnectionDTC_Resp}

EnvD_SysQual_Diagnostics_DTC_NonVolatileMemory
    [Documentation]    Each blade must have a non-volatile memory (e.g. EEPROM)
    ...    in which the events with the associated ambient data can be stored.
    [Tags]    CustomerDiagnostic    TCID-371297    FULLTEST	FID-1446835

    prj.sut.DID.Test.case.setups
    Sleep    10s
    prj.sut.diag.SetVehicleSpeedToZero
    prj.sut.can.diag.tester.present.active
    Sleep    3s

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.connect.dlt

    # Adjust KL30 voltage to Overvoltage 18V
    bits_platform.Output Set Analog Signal Value    Battery    21
    Verify DLT keyword    Voltage enters OVERVOLTAGE range
    Log To Console    Maas Blade enters Overvoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    # Return back to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    2s
    # powercycle
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    5s
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_NonVolatileMemory_Req}
    Sleep    5s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_NonVolatileMemory_Resp}

    [Teardown]    run keywords    prj.sut.power cycle    AND    Sleep    60s

EnvD_SysQual_Diagnostics_DTC_StatusOfDTC
    [Documentation]    To check DTC status value for DTC symptom
    [Tags]    CustomerDiagnostic    TCID-371295    FULLTEST	FID-1446837,1446838,1446840

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt

    # Adjust KL30 voltage to Overvoltage 18V
    bits_platform.Output Set Analog Signal Value    Battery    21
    Verify DLT keyword    Voltage enters OVERVOLTAGE range
    Log To Console    Maas Blade enters Overvoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    prj.sut.diag.compare.byte.range    ${sut.diag.StatusOfDTC}    -2    ${NONE}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_DTC_CameraPhantomPowerSupply
    [Documentation]    The Operating Mode Subsystem shall set DTC when
    ...    Camera Phantom Power Supply failure occurs.
    [Tags]    CustomerDiagnostic    TCID-371296    FULLTEST	FID-2881581

    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Trigger Short to ground Camera Power Supply
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    ON
    Sleep    10s
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraPhantomPowerFailure_Resp}

    # tower 1

EnvD_SysQual_Diagnostics_ExtendedRecord2_Mileage
    [Documentation]    The Mileage shall be capture with 3bytes of data from the received message
    [Tags]    CustomerDiagnostic    TCID-371279    FULLTEST	FID-1447007,1447011
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    1    999999
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    prj.sut.diag.SetETHSignal    1    12345
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_AgingCounter_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Mileage12345_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ExtendedRecord2_Mileage(NegativeTest)
    [Documentation]    The Mileage shall be capture with 3bytes of data from the received message
    [Tags]    CustomerDiagnostic    TCID-371283    FULLTEST	FID-1447007,1447011    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    1    10000
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.diag.SetETHSignal    1    12345
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_AgingCounter_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Mileage10000_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ExtendedRecord2_Timestamp
    [Documentation]    The timestamp shall be captured in 5bytes of data from the received message Diagnose_01
    [Tags]    CustomerDiagnostic    TCID-371278    FULLTEST	FID-1447007,1447015,1447016
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    10s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_AgingCounter_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Timestamp_Variation2_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ExtendedRecord2_Timestamp(NegativeTest)
    [Documentation]    The timestamp shall be captured in 5bytes of data from the received message Diagnose_01
    [Tags]    CustomerDiagnostic    TCID-371285    FULLTEST	FID-1447007,1447015,1447016    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_AgingCounter_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Timestamp_Variation1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleSpeed
    [Documentation]    This DID(0x2B16) shall give the Vehicle Speed when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371294    FULLTEST	FID-1818668,1826246
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    0    20
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_20_Resp}

    prj.sut.diag.SetETHSignal    0    50
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleSpeed_50_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_50_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleSpeed(NegativeTest)
    [Documentation]    This DID(0x2B16) shall give the Vehicle Speed when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371299    FULLTEST	FID-1818668,1826246    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    0    20
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_20_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.diag.SetETHSignal    0    50
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleSpeed_20_Resp}
    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_50_Resp}
    Log To Console    Snapshot data is not updated to the latest value. Test case PASS!

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_IgnitionStatus
    [Documentation]    This DID(0x030D) shall give the Ignition status when the DTC was qualified for the blade under test
    [Tags]    CustomerDiagnostic    TCID-371288    FULLTEST	FID-1826286,1826288
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    8    0
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.IgnitionStatus_Req}
    prj.sut.diag.compare    ${sut.diag.IgnitionStatus_0_Resp}

    prj.sut.diag.SetETHSignal    8    1
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_IgnitionStatus_1_Resp}

    prj.sut.can.diag.send    ${sut.diag.IgnitionStatus_Req}
    prj.sut.diag.compare    ${sut.diag.IgnitionStatus_1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_IgnitionStatus(NegativeTest)
    [Documentation]    This DID(0x030D) shall give the Ignition status when the DTC was qualified for the blade under test
    [Tags]    CustomerDiagnostic    TCID-371289    FULLTEST	FID-1826286,1826288    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    8    0
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.IgnitionStatus_Req}
    prj.sut.diag.compare    ${sut.diag.IgnitionStatus_0_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.diag.SetETHSignal    8    1
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_IgnitionStatus_0_Resp}

    prj.sut.can.diag.send    ${sut.diag.IgnitionStatus_Req}
    prj.sut.diag.compare    ${sut.diag.IgnitionStatus_1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_EngineStatus
    [Documentation]    This DID(0x02B7) shall give the Engine status when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371290    FULLTEST	FID-1826298,1826299
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    9    0
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    prj.sut.diag.compare    ${sut.diag.EngineStatus_0_Resp}

    prj.sut.diag.SetETHSignal    9    1
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_EngineStatus_1_Resp}

    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    prj.sut.diag.compare    ${sut.diag.EngineStatus_1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_EngineStatus(NegativeTest)
    [Documentation]    This DID(0x02B7) shall give the Engine status when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371291    FULLTEST	FID-1826298,1826299    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    9    0
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    prj.sut.diag.compare    ${sut.diag.EngineStatus_0_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.diag.SetETHSignal    9    1
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_EngineStatus_0_Resp}

    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    prj.sut.diag.compare    ${sut.diag.EngineStatus_1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleTimeStamp
    [Documentation]    This DID(0x2BC1) shall give the Vehicle Time stamp when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371292    FULLTEST	FID-1826336,1826335
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation1_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleTimeStamp_Variation2_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation2_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleTimeStamp(NegativeTest)
    [Documentation]    This DID(0x2BC1) shall give the Vehicle Time stamp when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371286    FULLTEST	FID-1826336,1826335    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleTimeStamp_Variation1_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation2_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleMileage
    [Documentation]    This DID(0x295A) shall give the Vehicle Mileage when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371287    FULLTEST	FID-1826339,1826340
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    1    10000
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_10000_Resp}
    Sleep    3s
    prj.sut.diag.SetETHSignal    1    12345
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleMileage_12345_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_12345_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleMileage(NegativeTest)
    [Documentation]    This DID(0x295A) shall give the Vehicle Mileage when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371293    FULLTEST	FID-1826339,1826340    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    1    10000
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_10000_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.diag.SetETHSignal    1    12345
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleMileage_10000_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_12345_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_SupplyVoltageOfTheBlade
    [Documentation]    This DID(0x1906) shall give the Supply Voltage when the DTC was qualified for the blade under test
    [Tags]    CustomerDiagnostic    TCID-371298    FULLTEST	FID-1826342,1826343

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_12V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 12V. Comparing with 11.9V
        ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_119V_Resp}
        IF    ${Status} == False
            Log To Console    Supply value is not 11.9V Comparing with 11.8V
            prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_118V_Resp}
        ELSE
            Log To Console    Supply voltage is 11.9V
        END
    ELSE
        Log To Console    Supply value is 12V
    END

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_21V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 21V. Comparing with 20.9V
        ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_209V_Resp}
        IF    ${Status} == False
            Log To Console    Supply value is not 20.9V. Comparing with 20.8V
            prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_208V_Resp}
            prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
            prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_208V_Resp}
        ELSE
            Log To Console    Supply Value is 20.9V
            prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
            prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_209V_Resp}
        END
    ELSE
        Log To Console    Supply value is 21V
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_21V_Resp}
    END

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_ComputeElementTemperatureOfTheBlade
    [Documentation]    This DID(0x1906) shall give the Supply Voltage when the DTC was qualified for the blade under test
    [Tags]    CustomerDiagnostic    TCID-371300    FULLTEST	FID-1826351

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.connect.dlt
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.BladeComputeInternalTemperature_Resp}

    ${McTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${MC}    Convert To Integer    0x${McTemp}
    Log To Console    Microcontroller temp is ${MC}
    ${MpTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${MP}    Convert To Integer    0x${MpTemp}
    Log To Console    Microprocessor temp is ${MP}
    ${PMICTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${PMIC}    Convert To Integer    0x${PMICTemp}
    Log To Console    PMIC temp is ${PMIC}
    ${ETHTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${ETH}    Convert To Integer    0x${ETHTemp}
    Log To Console    PMIC temp is ${ETH}

    prj.sut.disconnect.dlt
    Sleep    3s
    @{pattern_list}    Create List    [Temperature] DID request [MicroController Temperature] = ${MC}
    ...    [Temperature] DID request [MicroProcessor Temperature] = ${MP}
    ...    [Temperature] DID request [PMIC Temperature] = ${PMIC}
    ...    [Temperature] DID request [Ethernet Switch Temperature] = ${ETH}

    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Searching for "${index}"
        ${Status}    Run Keyword And Return Status    Should Contain    ${Temp_Log}    ${index}
        IF    ${Status} == True
            Log To Console    Keyword "${index}" found!
        ELSE
            Log to COnsole    Keyword "${index}" is NOT found
            ${Keyword_var}        Set Variable        ${index}
            ${Keyword_var_update} =    Replace String    ${Keyword_var}    =    -
            Set Test Status To Fail    error_type=DLT    info_text=Keyword ${Keyword_var_update} is NOT found
        END
    END

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_Req}
    ${ElementTemp}    prj.sut.can.diag.get.byte.range    3    20

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${ElementTemp}
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)(Default Session)
    [Documentation]    This Data Identifier indicates the date of the event recorder deletion.The Timestamp shall be read from the message Diagnose_01
    [Tags]    FID-1665051,1665050,1665049,1665054,1665053    TCID-272559    CustomerDiagnostic    FULLTEST
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Req}
    prj.sut.diag.compare    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Variation1_Resp}

EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)(Extended Session)
    [Documentation]    This Data Identifier indicates the date of the event recorder deletion.The Timestamp shall be read from the message Diagnose_01
    [Tags]    FID-1665053,1665049,1665050,1665051,1665054    TCID-272561    CustomerDiagnostic    FULLTEST
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Req}
    prj.sut.diag.compare    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Variation2_Resp}

EnvD_SysQual_Diagnostics_Report_Number_of_DTC_by_Status_Mask(0x01)(Default Session)
    [Documentation]    A client can retrieve a count of the number of DTCs matching a client defined status mask
    ...    by sending a request for this service with the SubFunction set to reportNumberOfDTCByStatusMask.
    [Tags]    FID-1290752,1287925,1290755,1290753,1290756    TCID-272554    CustomerDiagnostic    FULLTEST
    bits_platform.Output Set Analog Signal Value    Battery    12

    bits_platform.Output Set Analog Signal Value    Battery    12

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    ${Counter}    prj.sut.can.diag.get.byte.range    12    17
    Log To Console    Initial counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}
    Log to console    Initially, there are ${Counter_Int} DTC found

    ${Previous_DTC_Count}    Set Variable    ${Counter_Int}
    Log to Console    Triggering Overvoltage DTC

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}

    ${Counter}    prj.sut.can.diag.get.byte.range    12    17
    Log To Console    Counter after overvoltage in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}
    Log to console    After overvoltage, there are ${Counter_Int} DTC found. Previous count was ${Previous_DTC_Count}.

    IF    ${Counter_Int} > ${Previous_DTC_Count}
        Log to Console    DTC count has increased from ${Previous_DTC_Count} to ${Counter_Int}. Overvoltage DTC is triggered and detected correctly.
    ELSE
        Set Test Status to Fail    info_text=DTC count did NOT increase from ${Previous_DTC_Count} after overvoltage. Overvoltage DTC was not detected or count remained same.
    END

    ${Previous_DTC_Count}    Set Variable    ${Counter_Int}
    Log to Console    Triggering Undervoltage DTC

    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}

    ${Counter}    prj.sut.can.diag.get.byte.range    12    17
    Log To Console    Counter after undervoltage in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}
    Log to console    After undervoltage, there are ${Counter_Int} DTC found. Previous count was ${Previous_DTC_Count}.

    IF    ${Counter_Int} > ${Previous_DTC_Count}
        Log to Console    DTC count has increased from ${Previous_DTC_Count} to ${Counter_Int}. Undervoltage DTC is triggered and detected correctly.
    ELSE
        Set Test Status to Fail    info_text=DTC count did NOT increase from ${Previous_DTC_Count} after undervoltage. Undervoltage DTC was not detected or count remained same.
    END

    [Teardown]    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Report_Number_of_DTC_by_Status_Mask(0x01)(Extended Session)
    [Documentation]    A client can retrieve a count of the number of DTCs matching a client defined status mask
    ...    by sending a request for this service with the SubFunction set to reportNumberOfDTCByStatusMask.
    [Tags]    FID-1290752,1287925,1290755,1290753,1290756    TCID-272551    CustomerDiagnostic    FULLTEST


    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    ${Counter}    prj.sut.can.diag.get.byte.range    12    17
    Log To Console    Initial counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}
    Log to console    Initially, there are ${Counter_Int} DTC found

    ${Previous_DTC_Count}    Set Variable    ${Counter_Int}
    Log to Console    Triggering Overvoltage DTC

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}

    ${Counter}    prj.sut.can.diag.get.byte.range    12    17
    Log To Console    Counter after overvoltage in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}
    Log to console    After overvoltage, there are ${Counter_Int} DTC found. Previous count was ${Previous_DTC_Count}.

    IF    ${Counter_Int} > ${Previous_DTC_Count}
        Log to Console    DTC count has increased from ${Previous_DTC_Count} to ${Counter_Int}. Overvoltage DTC is triggered and detected correctly.
    ELSE
        Set Test Status to Fail    info_text=DTC count did NOT increase from ${Previous_DTC_Count} after overvoltage. Overvoltage DTC was not detected or count remained same.
    END

    ${Previous_DTC_Count}    Set Variable    ${Counter_Int}
    Log to Console    Triggering Undervoltage DTC

    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}

    ${Counter}    prj.sut.can.diag.get.byte.range    12    17
    Log To Console    Counter after undervoltage in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}
    Log to console    After undervoltage, there are ${Counter_Int} DTC found. Previous count was ${Previous_DTC_Count}.

    IF    ${Counter_Int} > ${Previous_DTC_Count}
        Log to Console    DTC count has increased from ${Previous_DTC_Count} to ${Counter_Int}. Undervoltage DTC is triggered and detected correctly.
    ELSE
        Set Test Status to Fail    info_text=DTC count did NOT increase from ${Previous_DTC_Count} after undervoltage. Undervoltage DTC was not detected or count remained same.
    END

    [Teardown]    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Report_DTC_By_Status_Mask(0x02)(Extended Session)
    [Documentation]    The client can retrieve a list of DTCs, which satisfy a client defined
    ...     status mask by sending a request with the SubFunction byte set to reportDTCByStatusMask.
    [Tags]    CustomerDiagnostic    TCID-272537    FULLTEST    FID-1290764,1290752,1287925,1290765,1290762

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    # Post Condition
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Report_DTC_Ext_Data_Record_By_DTC_Number(0x06)
    [Documentation]    A client queries extended data (environment data) for a defined DTC
    ...    in conjunction with a DTCExtendedDataRecordNumber by sending a request with the service
    ...     19hex with the subfunction ReportDTCExtendedDataRecordByDTCNumber (0x06).
    [Tags]    CustomerDiagnostic    TCID-272543    FULLTEST    FID-1290752,1287925,1443754,1443757,1443756

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Resp}

    # Post Condition
    bits_platform.Output Set Analog Signal Value    Battery    12

# 25.1 Development

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCSWVersion(0x031F)(Default Session)
    [Documentation]    The DID  SoCSWVersion shall give the information about the SW Version
    ...     of diagnostics process under QNX.
    [Tags]    CustomerDiagnostic    TCID-404431    FULLTEST    FID-2845882,2845883,2845884,2845886,2845887

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_Req}
    Sleep    10s
    prj.sut.diag.compare    ${sut.diag.SoC_SWVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCSWVersion(0x031F)(Extended Session)
    [Documentation]    The DID  SoCSWVersion shall give the information about the SW Version
    ...     of diagnostics process under QNX.
    [Tags]    CustomerDiagnostic    TCID-404432    FULLTEST    FID-2845882,2845883,2845884,2845886,2845887

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_Req}
    Sleep    10s
    prj.sut.diag.compare    ${sut.diag.SoC_SWVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus1(0x0313)(Default Session)
    [Documentation]    The DID  DisplayLinkStatus1 shall give the information about the
    ...      Status of link to Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404429    FULLTEST    FID-2845893,2845894,2845895,2845897,2845898

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus1(0x0313)(Extended Session)
    [Documentation]    The DID  DisplayLinkStatus1 shall give the information about the
    ...      Status of link to Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404430    FULLTEST    FID-2845893,2845894,2845895,2845897,2845898

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus2(0x0314)(Default Session)
    [Documentation]    The DID  DisplayLinkStatus2 shall give the information about the
    ...     Status of link to Display#1 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404439    FULLTEST    FID-2845902,2845903,2845904,2845906,2845907

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus2_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus2(0x0314)(Extended Session)
    [Documentation]    The DID  DisplayLinkStatus2 shall give the information about the
    ...     Status of link to Display#1 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404434    FULLTEST    FID-2845902,2845903,2845904,2845906,2845907

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus2_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails1(0x031A)(Default Session)
    [Documentation]    The DID  SerializerDetails1 shall give the information about the
    ...     Serializer Details for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404419    FULLTEST    FID-2845911,2845912,2845913,2845915,2845916

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails1(0x031A)(Extended Session)
    [Documentation]    The DID  SerializerDetails1 shall give the information about the
    ...     Serializer Details for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404420    FULLTEST    FID-2845911,2845912,2845913,2845915,2845916

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails2(0x031B)(Default Session)
    [Documentation]    The DID  SerializerDetails2 shall give the information about the
    ...     Serializer Details for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404417    FULLTEST    FID-2845920,2845921,2845922,2845924,2845925

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails2(0x031B)(Extended Session)
    [Documentation]    The DID  SerializerDetails2 shall give the information about the
    ...     Serializer Details for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404418    FULLTEST    FID-2845920,2845921,2845922,2845924,2845925

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails2_Resp}


EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters1(0x0318)(Default Session)
    [Documentation]    The DID  SelectedCounters1 shall give the information about the
    ...     Selected counters for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404427    FULLTEST    FID-2845929,2845930,2845931,2845933,2845934

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters1(0x0318)(Extended Session)
    [Documentation]    The DID  SelectedCounters1 shall give the information about the
    ...     Selected counters for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404422    FULLTEST    FID-2845929,2845930,2845931,2845933,2845934

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters2(0x0319)(Default Session)
    [Documentation]    The DID  SelectedCounters2 shall give the information about
    ...     Selected counters for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404455    FULLTEST    FID-2845938,2845939,2845940,2845942,2845943

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters2(0x0319)(Extended Session)
    [Documentation]    The DID  SelectedCounters2 shall give the information about
    ...     Selected counters for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404456    FULLTEST    FID-2845938,2845939,2845940,2845942,2845943

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature1(0x0315)(Default Session)
    [Documentation]    The DID  SerializerTemperature1 shall give the Serializer Temperature
    ...     for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404453    FULLTEST    FID-2845947,2845948,2845949,2845951,2845952

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature1(0x0315)(Extended Session)
    [Documentation]    The DID  SerializerTemperature1 shall give the Serializer Temperature
    ...     for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404454    FULLTEST    FID-2845947,2845948,2845949,2845951,2845952

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature2(0x0316)(Default Session)
    [Documentation]    The DID  SerializerTemperature2 shall give the Serializer Temperature
    ...     for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404463    FULLTEST    FID-2845957,2845958,2845959,2845961,2845962

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature2(0x0316)(Extended Session)
    [Documentation]    The DID  SerializerTemperature2 shall give the Serializer Temperature
    ...     for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404458    FULLTEST    FID-2845957,2845958,2845959,2845961,2845962

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0x0322)(Default Session)
    [Documentation]    The DID  GVM_Status shall give the information about the  Status of Guest Virtual Machines (GVM) .
    [Tags]    CustomerDiagnostic    TCID-404443    FULLTEST    FID-2845966,2845967,2845968,2845970,2845971

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.GVMStatus_Req}
    prj.sut.diag.compare    ${sut.diag.GVMStatus_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0x0322)(Extended Session)
    [Documentation]    The DID  GVM_Status shall give the information about the  Status of Guest Virtual Machines (GVM) .
    [Tags]    CustomerDiagnostic    TCID-404444    FULLTEST    FID-2845966,2845967,2845968,2845970,2845971

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.GVMStatus_Req}
    prj.sut.diag.compare    ${sut.diag.GVMStatus_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VWLogicalSoftwareBlockVersion(F1AB)(Default Session)
    [Documentation]    The DID VWLogicalSoftwareBlockVersion shall give the information about the SW Block version number.
    [Tags]    CustomerDiagnostic    TCID-404398    FULLTEST    FID-2844632,2844634,2844635,2844637,2844638

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VWLogicalSoftwareBlockVersion(F1AB)(Extended Session)
    [Documentation]    The DID VWLogicalSoftwareBlockVersion shall give the information about the SW Block version number.
    [Tags]    CustomerDiagnostic    TCID-404400    FULLTEST    FID-2844632,2844634,2844635,2844637,2844638

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileIdentifier(0xF19E)(Default Session)
    [Documentation]    The DID  ASAMODXFileIdentifier shall give the information about the ASAM ODX File Identifier.
    [Tags]    CustomerDiagnostic    TCID-404409    FULLTEST    FID-2850080,2850081,2850082,2850084,2850085

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileIdentifier_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileIdentifier(0xF19E)(Extended Session)
    [Documentation]    The DID  ASAMODXFileIdentifier shall give the information about the ASAM ODX File Identifier.
    [Tags]    CustomerDiagnostic    TCID-404415    FULLTEST    FID-2850080,2850081,2850082,2850084,2850085

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileIdentifier_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileVersion(0xF1A2)(Default Session)
    [Documentation]    The DID  ASAMODXFileVersion shall give the information about the ASAM ODX File Version.
    [Tags]    CustomerDiagnostic    TCID-404406    FULLTEST    FID-2845975,2845976,2845977,2845979,2845980

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileVersion(0xF1A2)(Extended Session)
    [Documentation]    The DID  ASAMODXFileVersion shall give the information about the ASAM ODX File Version.
    [Tags]    CustomerDiagnostic    TCID-404408    FULLTEST    FID-2845975,2845976,2845977,2845979,2845980

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_BladeComputeInternalTemperature(0x0320)(Default Session)
    [Documentation]    The DID  BladeComputeInternalTemperature shall give the information about temperatures of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404397    FULLTEST    FID-2872923,2872924,2872925,2872927,2872928

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.connect.dlt
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.BladeComputeInternalTemperature_Resp}

    ${McTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${MC}    Convert To Integer    0x${McTemp}
    Log To Console    Microcontroller temp is ${MC}
    ${MpTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${MP}    Convert To Integer    0x${MpTemp}
    Log To Console    Microprocessor temp is ${MP}
    ${PMICTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${PMIC}    Convert To Integer    0x${PMICTemp}
    Log To Console    PMIC temp is ${PMIC}
    ${ETHTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${ETH}    Convert To Integer    0x${ETHTemp}
    Log To Console    PMIC temp is ${ETH}

    prj.sut.disconnect.dlt
    Sleep    2s
    @{pattern_list}    Create List    [Temperature] DID request [MicroController Temperature] = ${MC}
    ...    [Temperature] DID request [MicroProcessor Temperature] = ${MP}
    ...    [Temperature] DID request [PMIC Temperature] = ${PMIC}
    ...    [Temperature] DID request [Ethernet Switch Temperature] = ${ETH}

    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Searching for "${index}"
        ${Status}    Run Keyword And Return Status    Should Contain    ${Temp_Log}    ${index}
        IF    ${Status} == True
            Log To Console    Keyword "${index}" found!
        ELSE
            Log to COnsole    Keyword "${index}" is NOT found
            ${Keyword_var}        Set Variable        ${index}
            ${Keyword_var_update} =    Replace String    ${Keyword_var}    =    -
            Set Test Status To Fail    error_type=DLT    info_text=Keyword ${Keyword_var_update} is NOT found
        END
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_BladeComputeInternalTemperature(0x0320)(Extended Session)
    [Documentation]    The DID  BladeComputeInternalTemperature shall give the information about temperatures of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404395    FULLTEST    FID-2872923,2872924,2872925,2872927,2872928

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.connect.dlt
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.BladeComputeInternalTemperature_Resp}

    ${McTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${MC}    Convert To Integer    0x${McTemp}
    Log To Console    Microcontroller temp is ${MC}
    ${MpTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${MP}    Convert To Integer    0x${MpTemp}
    Log To Console    Microprocessor temp is ${MP}
    ${PMICTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${PMIC}    Convert To Integer    0x${PMICTemp}
    Log To Console    PMIC temp is ${PMIC}
    ${ETHTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${ETH}    Convert To Integer    0x${ETHTemp}
    Log To Console    PMIC temp is ${ETH}

    prj.sut.disconnect.dlt
    Sleep    2s
    @{pattern_list}    Create List    [Temperature] DID request [MicroController Temperature] = ${MC}
    ...    [Temperature] DID request [MicroProcessor Temperature] = ${MP}
    ...    [Temperature] DID request [PMIC Temperature] = ${PMIC}
    ...    [Temperature] DID request [Ethernet Switch Temperature] = ${ETH}

    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Searching for "${index}"
        ${Status}    Run Keyword And Return Status    Should Contain    ${Temp_Log}    ${index}
        IF    ${Status} == True
            Log To Console    Keyword "${index}" found!
        ELSE
            Log to COnsole    Keyword "${index}" is NOT found
            ${Keyword_var}        Set Variable        ${index}
            ${Keyword_var_update} =    Replace String    ${Keyword_var}    =    -
            Set Test Status To Fail    error_type=DLT    info_text=Keyword ${Keyword_var_update} is NOT found
        END
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VoltageTerminal30(0x1906)(Default Session)
    [Documentation]    The DID  VoltageTerminal30 shall give the information about the volage level for KL30.
    [Tags]    CustomerDiagnostic    TCID-404402    FULLTEST    FID-2872971,2872972,2872973,2872975,2872976

    bits_platform.Output Set Analog Signal Value    Battery    10
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_12V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 12V. Comparing with 11.9V
        ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_119V_Resp}
        IF    ${Status} == False
            Log To Console    Supply value is not 11.9V. Comparing with 11.8V
            prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_118V_Resp}
            Log to Console    Voltage terminal is read as 11.8V
        ELSE
            Log to Console    Voltage terminal is read as 11.9V
        END
    ELSE
        Log to Console    Voltage terminal is read as 12V
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VoltageTerminal30(0x1906)(Extended Session)
    [Documentation]    The DID  VoltageTerminal30 shall give the information about the volage level for KL30.
    [Tags]    CustomerDiagnostic    TCID-404407    FULLTEST    FID-2872971,2872972,2872973,2872975,2872976

    bits_platform.Output Set Analog Signal Value    Battery    10
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_12V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 12V. Comparing with 11.9V
        ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_119V_Resp}
        IF    ${Status} == False
            Log To Console    Supply value is not 11.9V. Comparing with 11.8V
            prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_118V_Resp}
            Log to Console    Voltage terminal is read as 11.8V
        ELSE
            Log to Console    Voltage terminal is read as 11.9V
        END
    ELSE
        Log to Console    Voltage terminal is read as 12V
    END


EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_MaaSBladeInternalTemperature(0xFA01)(Default Session)
    [Documentation]    The DID  MaaSBladeInternalTemperature shall give the MaaS Blade specific temperature of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404410    FULLTEST    FID-2872984,2872985,2872986,2872988,2872989
    prj.sut.connect.dlt
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.MaaSBladeInternalTemperature_Resp}

    ${VideoTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${VideoTemp}    Convert To Integer    0x${VideoTemp}
    Log To Console    Video Display Temp is ${VideoTemp}
    ${CameraTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${CameraTemp}    Convert To Integer    0x${CameraTemp}
    Log To Console    Camera Display Temp is ${CameraTemp}
    ${UFSTopTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${UFSTopTemp}    Convert To Integer    0x${UFSTopTemp}
    ${UFSTopTemp}    Set Variable    ${UFSTopTemp}
    Log To Console    UFS Top PCB Temp is ${UFSTopTemp}
    ${BottomPCBTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${BottomPCBTemp}    Convert To Integer    0x${BottomPCBTemp}
    Log To Console    Bottom PCB Temp is ${BottomPCBTemp}
    Sleep    5s
    prj.sut.disconnect.dlt
    Sleep    3s
    @{pattern_list}    Create List    [Temperature] DID request [Video Display Temperature] = ${VideoTemp}
    ...    [Temperature] DID request [Camera Display Temperature] = ${CameraTemp}
    ...    [Temperature] DID request [UFS TOP PCB Temperature] = ${UFSTopTemp}
    ...    [Temperature] DID request [BOTTOM PCB Temperature] = ${BottomPCBTemp}

    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Searching for "${index}"
        ${Status}    Run Keyword And Return Status    Should Contain    ${Temp_Log}    ${index}
        IF    ${Status} == True
            Log To Console    Keyword "${index}" found!
        ELSE
            Log to COnsole    Keyword "${index}" is NOT found
            ${Keyword_var}        Set Variable        ${index}
            ${Keyword_var_update} =    Replace String    ${Keyword_var}    =    -
            Set Test Status To Fail    error_type=DLT    info_text=Keyword ${Keyword_var_update} is NOT found
        END
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_MaaSBladeInternalTemperature(0xFA01)(Extended Session)
    [Documentation]    The DID  MaaSBladeInternalTemperature shall give the MaaS Blade specific temperature of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404392    FULLTEST    FID-2872984,2872985,2872986,2872988,2872989
    prj.sut.connect.dlt
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.MaaSBladeInternalTemperature_Resp}

    ${VideoTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${VideoTemp}    Convert To Integer    0x${VideoTemp}
    Log To Console    Video Display Temp is ${VideoTemp}
    ${CameraTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${CameraTemp}    Convert To Integer    0x${CameraTemp}
    Log To Console    Camera Display Temp is ${CameraTemp}
    ${UFSTopTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${UFSTopTemp}    Convert To Integer    0x${UFSTopTemp}
    ${UFSTopTemp}    Set Variable    ${UFSTopTemp}
    Log To Console    UFS Top PCB Temp is ${UFSTopTemp}
    ${BottomPCBTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${BottomPCBTemp}    Convert To Integer    0x${BottomPCBTemp}
    Log To Console    Bottom PCB Temp is ${BottomPCBTemp}
    Sleep    5s
    prj.sut.disconnect.dlt
    Sleep    3s
    @{pattern_list}    Create List    [Temperature] DID request [Video Display Temperature] = ${VideoTemp}
    ...    [Temperature] DID request [Camera Display Temperature] = ${CameraTemp}
    ...    [Temperature] DID request [UFS TOP PCB Temperature] = ${UFSTopTemp}
    ...    [Temperature] DID request [BOTTOM PCB Temperature] = ${BottomPCBTemp}

    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Searching for "${index}"
        ${Status}    Run Keyword And Return Status    Should Contain    ${Temp_Log}    ${index}
        IF    ${Status} == True
            Log To Console    Keyword "${index}" found!
        ELSE
            Log to COnsole    Keyword "${index}" is NOT found
            ${Keyword_var}        Set Variable        ${index}
            ${Keyword_var_update} =    Replace String    ${Keyword_var}    =    -
            Set Test Status To Fail    error_type=DLT    info_text=Keyword ${Keyword_var_update} is NOT found
        END
    END

EnvD_SysQual_Diagnostics_TesterPresenceService($3E)_TesterPresent(NegativeResponse)
    [Documentation]    To test negative response for Tester Present ($3E)

    [Tags]    CustomerDiagnostic    TCID-414739    FULLTEST    FID-1069455,1151322    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.Tester_Present_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.TesterPresent_IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.Tester_Present_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.TesterPresent_IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.Tester_Present_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.TesterPresent_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_SpecificDiagnosticServices
    [Documentation]    A diagnostic session shall enables a specific set of diagnostic services and/or functionality in the server

    [Tags]    CustomerDiagnostic    TCID-414741    FULLTEST    FID-1069704

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send the request to write the RollerTestMode 2E 04 FB 01 in extended session
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_DefaultSessionReinitialize/Setting/ControlReset    #    New change
    [Documentation]    Default Session: When the server is in the default Session and the client requests to start the default Session then
    ...    the server shall re-initialize the default Session completely. The server shall reset all activated/initiated/changed
    ...    settings/controls during the activated session.

    [Tags]    CustomerDiagnostic    TCID-414734    FULLTEST    FID-1069754

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     10s

    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Check if DTC is cleared
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}    # change
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status} == ${TRUE}
        Log To Console    DTC is not Cleared
        framework.Set Test Status To Fail    error_type=Diagnostic
    ELSE
        Log To Console    DTC is Cleared
    END
    # prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}
    # Set DTC setting to OFF

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}

    # Qualify Overvoltage DTC again
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s
    # Check DTC should not be logged
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}    # change
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status} == ${TRUE}
        Log To Console    DTC is Logged
        framework.Set Test Status To Fail    error_type=Diagnostic
    ELSE
        Log To Console    DTC is Not Logged
    END
    # prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}

    # return to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep     3s
    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s

    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_SessionExitCriteriaS3Timeout
    [Documentation]    S3 Timeout -Timeout for Non-Default Session
    ...    Note:S3 value shall be 5s
    [Tags]    CustomerDiagnostic    TCID-414752    FULLTEST    FID-1069767

    prj.sut.can.diag.tester.present.deactive
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    4.4s
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    5.1s
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}
    [Teardown]    prj.sut.can.diag.tester.present.active

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_SessionExitCriteriaDefaultSession
    [Documentation]    Default Session -Timeout for Non-Default Session
    [Tags]    CustomerDiagnostic    TCID-414756    FULLTEST    FID-1069768

    prj.sut.can.diag.tester.present.deactive
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}
    [Teardown]    prj.sut.can.diag.tester.present.active

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_SessionExitCriteriaServerReset
    [Documentation]    Server Reset -Timeout for Non-Default Session
    [Tags]    CustomerDiagnostic    TCID-414745    FULLTEST    FID-1069769

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # perform ECU reset
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    12

    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_EthernetLinkQuality(0x010D)(Default Session)
    [Documentation]    The "Ethernet signal quality" shall return the signal quality of all Ethernet interfaces of the ECU.

    [Tags]    CustomerDiagnostic    TCID-414750    FULLTEST    FID-2840362,2840363,2840364,2840366,2840367

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_Req}
    prj.sut.diag.compare    ${sut.diag.EthernetLinkQuality_Good_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_EthernetLinkQuality(0x010D)(Extended Session)
    [Documentation]    The "Ethernet signal quality" shall return the signal quality of all Ethernet interfaces of the ECU.

    [Tags]    CustomerDiagnostic    TCID-414751    FULLTEST    FID-2840362,2840363,2840364,2840366,2840367

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_Req}
    prj.sut.diag.compare    ${sut.diag.EthernetLinkQuality_Good_Resp}

EnvD_SysQual_Diagnostics_ControlDTCSetting($85)_ExistingDTC
    [Documentation]    This service is used to deactivate and reactivate the update of
    ...    the StatusOfDTC bits of events and notices in the event memory
    [Tags]    CustomerDiagnostic    TCID-414757    FULLTEST    FID-1286047

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s

    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s

    # Set DTC setting to OFF
    prj.sut.diag.SetETHSignal    0    0
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}

    # Qualify Undervoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep     3s
    # Check DTC should not be logged
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_UndervoltageDTC_Resp}
    IF    ${Status} == ${False}
        Log to Console    No Undervoltage DTC is seen. OK!
    ELSE
        Log To Console    Undervoltage DTC is seen. NOK!!
        Set test status to Fail    error_type=Diagnostic    info_text=DTC is logged when DTC setting is turned to OFF
    END

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportDTCSnapshotRecordByDTCNumber(0x04)
    [Documentation]    The typical usage of DTC Snapshots is to store data upon detection of a system malfunction. The DTC Snapshots
    ...    will act as a snapshot of data values from the time of the system malfunction occurrence.
    [Tags]    CustomerDiagnostic    TCID-414754    FULLTEST    FID-2811062,2811063
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    0    50
    prj.sut.diag.SetETHSignal    1    12345
    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    prj.sut.diag.SetETHSignal    8    1    # set IgnitionStatus to 1
    prj.sut.diag.SetETHSignal    9    1    # set EngineStatus to 1
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    7s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}

    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleSpeed_50_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleMileage_12345_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleTimeStamp_Variation2_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_IgnitionStatus_1_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_EngineStatus_1_Resp}

EnvD_SysQual_Diagnostics_SuppressPositiveResponse_VerifySession
    [Documentation]    If the MSB of the Sub-Function is set, then the positive response shall be suppressed for that perticular request

    [Tags]    CustomerDiagnostic    TCID-428383    FULLTEST    FID-1348229,1348230

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.ExtendedSession_Suppress_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.can.diag.get
    IF    ${Status} == ${True}
        Set Test Status To Fail    error_type=Diagnostic    info_text=.Able to get a response.Positive Response is NOT suppressed
    END
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.DefaultSession_Suppress_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.can.diag.get
    IF    ${Status} == ${True}
        Set Test Status To Fail    error_type=Diagnostic    info_text=.Able to get a response.Positive Response is NOT suppressed
    END
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponse_NotSupportedSID
    [Documentation]    To test negative response of NRC 11

    [Tags]    CustomerDiagnostic    TCID-428387    FULLTEST    FID-1151329,1151335    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.NotSupportedSID_Req}
    prj.sut.diag.compare    ${sut.diag.ServiceNotSupported50_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponse_NotSupportedSIDinActiveSession
    [Documentation]    To test negative response of NRC 7F

    [Tags]    CustomerDiagnostic    TCID-428382    FULLTEST    FID-1151329,1151336    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Hard_Reset_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_ServiceNotSupportedInActiveSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_ServiceNotSupportedInActiveSession_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponseWithSubfunction_IncorrectMessageLength
    [Documentation]    To test negative response of NRC 13
    [Tags]    CustomerDiagnostic    TCID-428379    FULLTEST    FID-1151339,1151333    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponseWithSubfunction_SubFunctionNotSupported
    [Documentation]    To test negative response of NRC 12

    [Tags]    CustomerDiagnostic    TCID-428380    FULLTEST    FID-1151340,1151333    NegativeTest
    prj.sut.diag.SetETHSignal    0   0
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_IncorrectSubfunction_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ServiceNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_ExtendedRecord1_Priority
    [Documentation]    For each fault record, the ECU shall support a Priority indicating the Priority of that event/DTC

    [Tags]    CustomerDiagnostic    TCID-434194    FULLTEST    FID-2930862
    # Trigger Overvoltage
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_OvervoltageDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Priority1_Resp}    21    23

# EnvD_SysQual_Diagnostics_ExtendedRecord3_EngineCoolantTemperature
# Set to obsolete due to requirement is obsolete
#     [Documentation]    The engine coolant temparature shall be 1 byte in size and captured with the message OBD_Eng_Cool_Temp
#     [Tags]    CustomerDiagnostic    TCID-434193    FULLTEST    FID-1447019
#     # Set Engine Coolant to xx
#     prj.sut.diag.SetETHSignal    0    50    # to create ETH signal for engine coolant

#     # Trigger Overvoltage
#     bits_platform.Output Set Analog Signal Value    Battery    21
#     Sleep     3s

#     prj.sut.can.diag.send    ${sut.diag.ReportDTCExtendedDataRecordByDTCNumber_OvervoltageDTC_EngineCoolant_Req}
#     Set test status to fail    info_text=Engine Coolant Failed (KIV)
#     prj.sut.diag.compare    ${sut.diag.ReportDTCExtendedDataRecordByDTCNumber_OvervoltageDTC_EngineCoolant_Resp}    # Pending reply from hakim

EnvD_SysQual_Diagnostics_ExtendedRecord0F_MonitoringData
    [Documentation]    The debug data of each DTC shall be captured in this Extended record of size 8 Byte

    [Tags]    CustomerDiagnostic    TCID-434192    FULLTEST    FID-1818192

    # Trigger Overvoltage
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep     3s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtendedDataRecordByDTCNumber_OvervoltageDTC_MonitoringData_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCExtendedDataRecordByDTCNumber_Resp}
    ${sResult}    prj.sut.can.diag.get
    # Checking byte length
    ${MonitoringData_Length}    Get Length    ${sResult}
    Log To Console    Byte length is ${MonitoringData_Length}
    IF    ${MonitoringData_Length} == ${sut.diag.MonitoringData_Length}
        Log To Console    Byte Length check is OK
    ELSE
        Log To Console    Byte Length check is NOK!
        ${MonitoringData_Length}    Set Variable    ${MonitoringData_Length}
        Set Test Status To Fail    error_type=Diagnostic    info_text=Response does not contain 8 bytes Monitoring Data
    END

# ###############################################Diag Tanisha ###########################################

EnvD_SysQual_Diagnostics_CurrentConsumptionOfBlade_DefaultSession
    [Documentation]    This function is to get specific request response
    [Tags]    Customer_Diagnostic    TCID-518825    FID-3666430,3666431

    # Step 1: Switch to Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Step 2: Send the response request
    prj.sut.can.diag.send    ${sut.diag.CurrentConsumption_Req}
    prj.sut.diag.compare.byte.range    FF FF    9    14

EnvD_SysQual_Diagnostics_CurrentConsumption_value
       [Documentation]    the function will give value of current consumed
       [Tags]    Customer_Diagnostic    TCID-518828    FID-3666429

       ${bAck}    ${sCuurent}    bits_platform.input get signal value    Battery_Current
       Log To Console    ${bAck}, amp is ${sCuurent}

EnvD_SysQual_Diagnostics_CurrentConsumption_ExtendedSession
    [Documentation]    testcase to get current consumption in extended session
    [Tags]    Customer_Diagnostic    TCID-518819    FID-3666430,3666431

    # Step 1: Switch to Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Step 2: Send the response request
    prj.sut.can.diag.send    ${sut.diag.CurrentConsumption_Req}
    prj.sut.diag.compare.byte.range    FF FF    9    14

EnvD_SysQual_Diagnostics_CurrentConsumption_ReadDataByte
    [Documentation]    Data byte needed to be read of the response
    [Tags]    Customer_Diagnostic    TCID-518822    FID-3666432

    # Step 1: Switch to Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Step 2: Send DID request
    prj.sut.can.diag.send    ${sut.diag.CurrentConsumption_Req}

    # Step 3: Check response byte by byte
    # Byte 1 → Response ID (62)
    prj.sut.diag.compare.byte.range    62    0    2
    # Byte 2 → DID MSB (03)
    prj.sut.diag.compare.byte.range    03    3    5
    # Byte 3 → DID LSB (21)
    prj.sut.diag.compare.byte.range    21    6    8

EnvD_SysQual_Diagnostics_OPMMStatusOfBlade_Default&Extended_Session
    [Documentation]    Getting response request for OPMM lade in default & extended mode
    [Tags]    Customer_Diagnostic    TCID-518840    FID-3666445,3666446,3666447

    # Step 1 Switch to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Step 2 Send the DID request
    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBladeCAN_Resp}

    # Step 3: Switch to Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Step 4: Send the DID request
    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBladeCAN_Resp}

EnvD_SysQual_Diagnostics_OPMMStatusOfBlade_ByteResponse
    [Documentation]    getting byte by byte reponse of the requested DID
    [Tags]    Customer_Diagnostic    TCID-518830    FID-3666448,3666449

    # Step 3: Check response byte by byte
    # Byte 1 → Response ID (62)
    prj.sut.diag.compare.byte.range    62    0    2
    # Byte 2 → DID MSB (03)
    prj.sut.diag.compare.byte.range    03    3    5
    # Byte 3 → DID LSB (0B)
    prj.sut.diag.compare.byte.range    0B    6    8

EnvD_SysQual_Diagnostics_VIN_StorageAndUpdate
    [Documentation]    testing for string manipulation to get ASCII values of given VIN
    [Tags]    Customer_Diagnostic    TCID-518807    FID-3674085

    # Step 1: Send the DID for VIN
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    ${resp}    prj.sut.can.diag.get
    Log To Console    Raw ECU Response: ${resp}

    # Step 2: Extract just the VIN reponse
    ${vin_hex}    prj.sut.diag.vinStringExtract    ${resp}
    Log To Console    Extracted VIN (Hex): ${vin_hex}

    # Step 3: Convert VIN hex into ASCII using your existing keyword
    ${vin_ascii}    prj.sut.diag.HexToASCIIExtraction    ${vin_hex}
    Log To Console    Extracted VIN (ASCII): ${vin_ascii}

    # Step 4 Switch off the power blade and recheck
    prj.sut.power cycle
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    ${resp_1}    prj.sut.can.diag.get
    ${vin_hex_1}    prj.sut.diag.vinStringExtract    ${resp_1}
    ${vin_ascii_1}    prj.sut.diag.HexToASCIIExtraction    ${vin_hex_1}

    # Step 5: Compare both VINs
    IF    "${vin_ascii}" == "${vin_ascii_1}"
        Log To Console    VIN values match before and after power cycle: ${vin_ascii}
    ELSE
        Log To Console    VIN mismatch! Before: ${vin_ascii}, After: ${vin_ascii_1}
        Set Test Status To Fail    error_type=VIN Validation
        ...    info_text=Expected VIN: ${vin_ascii} but got: ${vin_ascii_1} after power cycle
    END

############## Naveen ##########################################

EnvD_SysQual_Diagnostics_Ethernet_CRC_error_counter(0x010F)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 01 0F and see the response as 62 01 0F 00 00.
    ...    Send the Ethernet messages with incorrect CRC and send request 22 01 0F in extended session/Default session
    ...    Observe the positive response 62 01 0F

    [Tags]    CustomerDiagnostic    TCID-518844    FID-2870644    FULLTEST

    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req}    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Resp}
    ...    ${sut.diag.DID.Lenght_20}
    prj.sut.diag.DID.Data.Validation.non.zero.data   ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req}    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Resp}    Non Zero
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Resp}    0    8
    prj.sut.diag.DID.Data.Validation.non.zero.data   ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req}    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Resp}    Non Zero
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req}    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Resp}
    ...    ${sut.diag.DID.Lenght_20}

EnvD_SysQual_Diagnostics_ComputeElementTemperatureOfBlade(0x0320)_(Default_Session)_(Extended_Session)
    [Documentation]     Make sure that DUT is communicating and the handshaking with the tester is established.
    ...    Send the request 22 03 20 and see the response as 62 03 20<4 Bytes> of response
    [Tags]    CustomerDiagnostic    FID-3666209,3666210,3666211,3666213,3666214    TCID-518853    FULLTEST

    # prj.sut.can.diag.tester.present.active
    # prj.sut.can.simulation.PowerBladeOFF
    # bits_platform.Output Set Analog Signal Value    Battery    0
    # prj.sut.connect.dlt
    # prj.sut.can.simulation.PowerBladeON
    # prj.sut.power.add.voltage.to.dictionary.check    12
    # prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.ComputeElementTemperatureOfBlade_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.ComputeElementTemperatureOfBlade_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.ComputeElementTemperatureOfBlade_Req}    ${sut.diag.ComputeElementTemperatureOfBlade_Resp}    ${sut.diag.DID.Lenght_20}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.ComputeElementTemperatureOfBlade_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.ComputeElementTemperatureOfBlade_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.ComputeElementTemperatureOfBlade_Req}    ${sut.diag.ComputeElementTemperatureOfBlade_Resp}    ${sut.diag.DID.Lenght_20}
    # ${clean_line}    ${Searched}    prj.sut.connect.dlt.Search the DLT and return matching patterns    Overall temperature
    # Log To Console    ${clean_line}    ${Searched}

EnvD_SysQual_Diagnostics_IgnitionStatus(0x030D)_(Default_Session)_(Extended_Session)
    [Documentation]    Make sure that DUT is communicating and the handshaking with the tester is established and Update
    ...    Ignition status (ZAS_Kl_15) with the value. Send the request 22 03 0D and see the response as 62 03 0D
    [Tags]    CustomerDiagnostic    TCID-518850    FID-3666253,3666254,3666255,3666257,3666258    FULLTEST

    Sleep    3s
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.ZAS_Kl_15_XIX_Klemmen_Status_01_XIX_E3V_VLAN_MPCI}    ${sut.can.SysVar.ETNMsg.SigVal_1}
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.IgnitionStatusOfTheBlade_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.IgnitionStatusOfTheBlade_Resp}    0    8
    Sleep    500ms
    prj.sut.diag.DID.Length.Validation    ${sut.diag.IgnitionStatusOfTheBlade_Req}    ${sut.diag.IgnitionStatusOfTheBlade_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.DID.Data.Validation    ${sut.can.SysVar.ETNMsg.SigVal_1}    ${sut.diag.IgnitionStatusOfTheBlade_Resp}
    ...    Raw_value    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.ZAS_Kl_15_XIX_Klemmen_Status_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.SigVal_0}
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.IgnitionStatusOfTheBlade_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.IgnitionStatusOfTheBlade_Resp}    0    8
    Sleep    500ms
    prj.sut.diag.DID.Length.Validation    ${sut.diag.IgnitionStatusOfTheBlade_Req}    ${sut.diag.IgnitionStatusOfTheBlade_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.DID.Data.Validation    ${sut.can.SysVar.ETNMsg.SigVal_0}    ${sut.diag.IgnitionStatusOfTheBlade_Resp}
    ...    Raw_value    ${sut.diag.DID.Lenght_11}

EnvD_SysQual_Diagnostics_EngineStatus(0x02B7)_(Default_Session)_(Extended_Session)
    [Documentation]    Update the Engine status (Message Motor_14 Signal:MO_HYB_Fahrbereitschaft) is updated with the value
    ...    as xx Send the request 22 02 B7 and see the response as 62 02 B7<1 Byte>
    ...    the response shall be equivalent value of the message xx
    [Tags]    CustomerDiagnostic    TCID-518885    FID-3666346,3666347,3666348,3666350    FULLTEST

    Log To Console    set Message Motor_14 Signal:MO_HYB_Fahrbereitschaft
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.MO_HYB_Fahrbereitschaft_XIX_Motor_14_XIX_E3V_VLAN_MPCI}    ${sut.can.SysVar.ETNMsg.SigVal_1}
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.EngineStatus_Resp}    0    8
    Sleep    500ms
    prj.sut.diag.DID.Length.Validation    ${sut.diag.EngineStatus_Req}    ${sut.diag.EngineStatus_Resp}    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.DID.Data.Validation    ${sut.can.SysVar.ETNMsg.SigVal_1}    ${sut.diag.EngineStatus_Resp}
    ...    Raw_value    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.MO_HYB_Fahrbereitschaft_XIX_Motor_14_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.SigVal_0}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.EngineStatus_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.EngineStatus_Req}    ${sut.diag.EngineStatus_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.DID.Data.Validation    ${sut.can.SysVar.ETNMsg.SigVal_0}    ${sut.diag.EngineStatus_Resp}
    ...    Raw_value    ${sut.diag.DID.Lenght_11}


EnvD_SysQual_Diagnostics_VWWorkshopSystemName_(0xF1AA)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 F1 AA in extended/default session
    ...    Observe the positive response 62 F1 AA<5 Bytes>
    [Tags]    CustomerDiagnostic    TCID-518882    FID-3786751,3786752,3786753,3786755    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.VWWorkshopSystemName_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.VWWorkshopSystemName_Resp}    0    8
    Sleep    500ms
    prj.sut.diag.DID.Length.Validation    ${sut.diag.VWWorkshopSystemName_Req}    ${sut.diag.VWWorkshopSystemName_Resp}
    ...    ${sut.diag.DID.Lenght_23}
    prj.sut.diag.VWWorkshopSystemName.DID.Data.Validation    ${sut.diag.VWWorkshopSystemName_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.VWWorkshopSystemName_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.VWWorkshopSystemName_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.VWWorkshopSystemName_Req}    ${sut.diag.VWWorkshopSystemName_Resp}
    ...    ${sut.diag.DID.Lenght_23}
    prj.sut.can.diag.send    ${sut.diag.VWWorkshopSystemName_Req}
    prj.sut.diag.VWWorkshopSystemName.DID.Data.Validation    ${sut.diag.VWWorkshopSystemName_Resp}

EnvD_SysQual_Diagnostics_Ambient_Brightness(0x25B8)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 25 B8 in extended/default session
    ...    Observe the positive response 62 25 B8 xx
    [Tags]    CustomerDiagnostic    TCID-518888    FID-4112880,4112881,4112882,4112884,4112885    FULLTEST

    prj.sut.DID.Test.case.setups
    Sleep    10s
    prj.sut.diag.SetVehicleSpeedToZero
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.LS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsgLS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI_Min}
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ambient_Brightness_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Ambient_Brightness_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Ambient_Brightness_Req}    ${sut.diag.Ambient_Brightness_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation.With.Data.Convert    ${sut.can.SysVar.ETNMsgLS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI_Min}
    # ...    ${sut.diag.Ambient_Brightness_Resp}    ${sut.diag.DID.Lenght_11}
    # ...    ${sut.can.SysVar.ETNMsgLS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI_resolution}
    # ...    ${sut.can.SysVar.ETNMsgLS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI_offest}
    Sleep    500ms
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.LS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsgLS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI_Max}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ambient_Brightness_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Ambient_Brightness_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Ambient_Brightness_Req}    ${sut.diag.Ambient_Brightness_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation.With.Data.Convert    400
    # ...    ${sut.diag.Ambient_Brightness_Resp}
    # ...    ${sut.diag.DID.Lenght_11}    ${sut.can.SysVar.ETNMsgLS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI_resolution}
    # ...    ${sut.can.SysVar.ETNMsgLS_Helligkeit_IR_XIX_RLS_01_XIX_E3V_VLAN_MPCI_offest}

EnvD_SysQual_Diagnostics_Rain_Internsity(0x0343)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 03 43 in extended/default session
    ...    Observe the positive response 62 25 B8 xx
    [Tags]    CustomerDiagnostic    TCID-518871    FID-4112888,4112889,4112890,4112892,4112893    FULLTEST

    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.RS_Regenmenge_XIX_RLS_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsgRS_Regenmenge_XIX_RLS_01_XIX_E3V_VLAN_MPCI_Max}
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Rain_Internsity_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Rain_Internsity_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Rain_Internsity_Req}    ${sut.diag.Rain_Internsity_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation    ${sut.can.SysVar.ETNMsgRS_Regenmenge_XIX_RLS_01_XIX_E3V_VLAN_MPCI_Max}
    # ...    ${sut.diag.Rain_Internsity_Resp}
    # ...    Phy_value    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.RS_Regenmenge_XIX_RLS_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsgRS_Regenmenge_XIX_RLS_01_XIX_E3V_VLAN_MPCI_Min}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Rain_Internsity_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Rain_Internsity_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Rain_Internsity_Req}    ${sut.diag.Rain_Internsity_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation    ${sut.can.SysVar.ETNMsgRS_Regenmenge_XIX_RLS_01_XIX_E3V_VLAN_MPCI_Min}
    # ...    ${sut.diag.Rain_Internsity_Resp}
    # ...    Phy_value    ${sut.diag.DID.Lenght_11}

EnvD_SysQual_Diagnostics_LvSupplyVoltages1StatusKd(0x0353)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 03 53 in extended/default session
    ...    Observe the positive response 62 03 53 xx
    [Tags]    CustomerDiagnostic    TCID-518868    FID-4112894,4112896,4112897,4112898,4112900,4112901    FULLTEST

    Log To Console    Set DC_IstSpannung_NV_XIX_DCDC_01_XIX_E3V_VLAN_MPCI Signal
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.DC_IstSpannung_NV_XIX_DCDC_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.DC_IstSpannung_NV_XIX_DCDC_01_XIX_E3V_VLAN_MPCI_Min}
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages1StatusKd_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.LvSupplyVoltages1StatusKd_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.LvSupplyVoltages1StatusKd_Req}    ${sut.diag.LvSupplyVoltages1StatusKd_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation.With.Data.Convert    ${sut.can.SysVar.ETNMsg.DC_IstSpannung_NV_XIX_DCDC_01_XIX_E3V_VLAN_MPCI_Min}
    # ...    ${sut.diag.LvSupplyVoltages1StatusKd_Resp}    ${sut.diag.DID.Lenght_11}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_resolution}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_offest}
    Log To Console    Set NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI Signal
    Sleep    500ms
    Log To Console    Set DC_IstSpannung_NV_XIX_DCDC_01_XIX_E3V_VLAN_MPCI Signal
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.DC_IstSpannung_NV_XIX_DCDC_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.DC_IstSpannung_NV_XIX_DCDC_01_XIX_E3V_VLAN_MPCI_max}
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages1StatusKd_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.LvSupplyVoltages1StatusKd_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.LvSupplyVoltages1StatusKd_Req}    ${sut.diag.LvSupplyVoltages1StatusKd_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation.With.Data.Convert    ${sut.can.SysVar.ETNMsg.DC_IstSpannung_NV_XIX_DCDC_01_XIX_E3V_VLAN_MPCI_max}
    # ...    ${sut.diag.LvSupplyVoltages1StatusKd_Resp}    ${sut.diag.DID.Lenght_11}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_resolution}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_offest}
    Log To Console    Set NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI Signal

EnvD_SysQual_Diagnostics_LvSupplyVoltages2StatusKd(0x0354)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 03 54 in extended/default session
    ...    Observe the positive response 62 03 54 xx
    [Tags]    CustomerDiagnostic    TCID-518877    FID-4112958,4112959,4112960,4112962,4112963    FULLTEST

    Log To Console    Set NVHR_DC_IstSpannung_NV_NV2_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI Signal
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV2_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV2_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_Max}
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_2StatusKd_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.LvSupplyVoltages_2StatusKd_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.LvSupplyVoltages_2StatusKd_Req}    ${sut.diag.LvSupplyVoltages_2StatusKd_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation.With.Data.Convert    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV2_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_Max}
    # ...    ${sut.diag.LvSupplyVoltages_2StatusKd_Resp}    ${sut.diag.DID.Lenght_11}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_resolution}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_offest}
    Log To Console    Set NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI Signal
    Sleep    500ms
    Log To Console    Set NVHR_DC_IstSpannung_NV_NV2_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI Signal
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV2_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV2_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_Min}
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_2StatusKd_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.LvSupplyVoltages_2StatusKd_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.LvSupplyVoltages_2StatusKd_Req}    ${sut.diag.LvSupplyVoltages_2StatusKd_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation.With.Data.Convert    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV2_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_Min}
    # ...    ${sut.diag.LvSupplyVoltages_2StatusKd_Resp}    ${sut.diag.DID.Lenght_11}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_resolution}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_offest}

EnvD_SysQual_Diagnostics_LvSupplyVoltages3StatusKd(0x0355)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 03 55 in extended/default session
    ...    Observe the positive response 62 03 55 xx
    [Tags]    CustomerDiagnostic    TCID-518874    FID-4112966,4112967,4112968,4112970,4112971    FULLTEST

    Log To Console    Set NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI Signal
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_Max}
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_3StatusKd_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.LvSupplyVoltages_3StatusKd_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.LvSupplyVoltages_3StatusKd_Req}    ${sut.diag.LvSupplyVoltages_3StatusKd_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation.With.Data.Convert    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_Max}
    # ...    ${sut.diag.LvSupplyVoltages_3StatusKd_Resp}    ${sut.diag.DID.Lenght_11}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_resolution}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_offest}
    Log To Console    Set NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI Signal
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_Min}
    Sleep    1s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_3StatusKd_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.LvSupplyVoltages_3StatusKd_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.LvSupplyVoltages_3StatusKd_Req}    ${sut.diag.LvSupplyVoltages_3StatusKd_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    # prj.sut.diag.DID.Data.Validation.With.Data.Convert    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_Min}
    # ...    ${sut.diag.LvSupplyVoltages_3StatusKd_Resp}    ${sut.diag.DID.Lenght_11}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_resolution}
    # ...    ${sut.can.SysVar.ETNMsg.NVHR_DC_IstSpannung_NV_NV3_XIX_NVHR_DCDC_02_XIX_E3V_VLAN_MPCI_offest}


EnvD_SysQual_Diagnostics_Connectivity_status(0x0356)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 03 56 in extended/default session
    ...    Observe the positive response 62 03 56 xx
    [Tags]    CustomerDiagnostic    TCID-518805    FID-4112974,4112975,4112976,4112978,4112979    FULLTEST

    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.DMAD_Connectivity_State_XIX_DMAD_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.DMAD_Connectivity_State_XIX_DMAD_01_XIX_E3V_VLAN_MPCI_Max}
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Connectivity_status_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Connectivity_status_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Connectivity_status_Req}    ${sut.diag.Connectivity_status_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.DID.Data.Validation    ${sut.can.SysVar.ETNMsg.DMAD_Connectivity_State_XIX_DMAD_01_XIX_E3V_VLAN_MPCI_Max}
    ...    ${sut.diag.Connectivity_status_Resp}
    ...    Raw_value    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.DMAD_Connectivity_State_XIX_DMAD_01_XIX_E3V_VLAN_MPCI}
    ...    ${sut.can.SysVar.ETNMsg.DMAD_Connectivity_State_XIX_DMAD_01_XIX_E3V_VLAN_MPCI_Min}
    Sleep    1s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Connectivity_status_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Connectivity_status_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Connectivity_status_Req}    ${sut.diag.Connectivity_status_Resp}
    ...    ${sut.diag.DID.Lenght_11}
    prj.sut.diag.DID.Data.Validation    ${sut.can.SysVar.ETNMsg.DMAD_Connectivity_State_XIX_DMAD_01_XIX_E3V_VLAN_MPCI_Min}
    ...    ${sut.diag.Connectivity_status_Resp}
    ...    Raw_value    ${sut.diag.DID.Lenght_11}

EnvD_SysQual_Diagnostics_Control DTC Setting($85)_Extended session_with_The service shall be accepted only when the Vehicle_Speed is <5kmph.
    [Documentation]    DTC Setting($85) The service shall be accepted only when the Vehicle_Speed is <5kmph.
    [Tags]    CustomerDiagnostic    TCID-518809    FID-3845731    FULLTEST

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    Log To Console    Set speed to 0 check for Positive response
    prj.sut.diag.SetVehicleSpeedToZero
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}
    Log To Console    Set speed less than than 5 check for Positive response
    prj.sut.diag.SetVehicleSpeed    400
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}
    Log To Console    Set speed equal to 6 check for NRC 88
    prj.sut.diag.SetVehicleSpeed    600
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON.VehicleSpeedTooHigh_Resp}
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON.VehicleSpeedTooHigh_Resp}
    Log To Console    Set speed equal to 5 check for NRC 88
    prj.sut.diag.SetVehicleSpeed    500
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON.VehicleSpeedTooHigh_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON.VehicleSpeedTooHigh_Resp}

EnvD_SysQual_Diagnostics_Communication_Control($28)_(Default_Session)_(Extended_session)_with_<5kmph.
    [Documentation]    Communication Control($28) The service shall be accepted only when the Vehicle_Speed is <5kmph.
    [Tags]    CustomerDiagnostic    TCID-518804    FID-3845741    FULLTEST

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    Log To Console    Set speed to 0 check for Positive response
    prj.sut.diag.SetVehicleSpeedToZero
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.EnableRxAndDisableTxControl_Resp}
    Log To Console    Set speed less than than 5 check for Positive response
    prj.sut.diag.SetVehicleSpeed    400
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.EnableRxAndDisableTxControl_Resp}
    Log To Console    Set speed equal to 6 check for NRC 88
    prj.sut.diag.SetVehicleSpeed    600
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Communication_Control.VehicleSpeedTooHigh_Resp}
    Log To Console    Set speed equal to 5 check for NRC 88
    prj.sut.diag.SetVehicleSpeed    500
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Communication_Control.VehicleSpeedTooHigh_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    Log To Console    Set speed to 0 check for Positive response
    prj.sut.diag.SetVehicleSpeedToZero
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.EnableRxAndDisableTxControl_Resp}
    Log To Console    Set speed less than than 5 check for Positive response
    prj.sut.diag.SetVehicleSpeed    400
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.EnableRxAndDisableTxControl_Resp}
    Log To Console    Set speed equal to 6 check for NRC 88
    prj.sut.diag.SetVehicleSpeed    600
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Communication_Control.VehicleSpeedTooHigh_Resp}
    Log To Console    Set speed equal to 5 check for NRC 88
    prj.sut.diag.SetVehicleSpeed    500
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Communication_Control.VehicleSpeedTooHigh_Resp}

EnvD_SysQual_Diagnostics_IP_Network_Max_Correction_SyncClock(0x0173)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 01 73 in extended/default session
    ...    Observe the positive response 62 01 73 xx
    [Tags]    CustomerDiagnostic    TCID-518812    FID-3701920,3701921,3701922,3701925    FULLTEST

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.IP_Network_Max_Correction_SyncClock_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    # Go to Extend session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.IP_Network_Max_Correction_SyncClock_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.IP_Network_Max_Correction_SyncClock_Resp}    0    8
    prj.sut.diag.DID.Length.Validation    ${sut.diag.IP_Network_Max_Correction_SyncClock_Req}
    ...    ${sut.diag.IP_Network_Max_Correction_SyncClock_Resp}    ${sut.diag.DID.Lenght_20}
    prj.sut.diag.DID.Data.Validation.non.zero.data    ${sut.diag.IP_Network_Max_Correction_SyncClock_Req}    ${sut.diag.IP_Network_Max_Correction_SyncClock_Resp}    Zero

EnvD_SysQual_Diagnostics_SlaveComponentListECUIdentification_(0x061C)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 06 1C in extended/default session
    ...    Observe the positive response 62 06 1C xx XX XX XX
    [Tags]    CustomerDiagnostic    TCID-518814    FID-3569291,3569292,3569293,3569295,3569296    FULLTEST

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListECUIdentification_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.SlaveComponentListECUIdentification_Resp_Full}
    prj.sut.diag.DID.Length.Validation    ${sut.diag.SlaveComponentListECUIdentification_Req}
    ...    ${sut.diag.SlaveComponentListECUIdentification_Resp}    ${sut.diag.DID.Lenght_20}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListECUIdentification_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.SlaveComponentListECUIdentification_Resp_Full}
    prj.sut.diag.DID.Length.Validation    ${sut.diag.SlaveComponentListECUIdentification_Req}
    ...    ${sut.diag.SlaveComponentListECUIdentification_Resp}    ${sut.diag.DID.Lenght_20}

EnvD_SysQual_Diagnostics_SlaveComponentListPresent(0x061D)_(Default_Session)_(Extended_Session)
    [Documentation]    Send the request 22 06 1D in extended/default session
    ...    Observe the positive response 62 06 1D xx XX XX XX
    [Tags]    CustomerDiagnostic    TCID-518806    FID-4282468,4282469,4282470,4282472,4282473    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListPresent_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.SlaveComponentListPresent_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListPresent_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.SlaveComponentListPresent_Resp}

######################## Yathin ########################################

EnvD_SysQual_Diagnostics_Vehicle_time_stamp(0x2BC1)(Default Session)
    [Documentation]    This DID(0x2BC1) shall give the Vehicle Time stamp of the Blade.
    ...    The DID shall be supported in the Default and Extended.
    ...    The DID shall require no security level.
    [Tags]    CustomerDiagnostic    TCID-518839    FID-3666405,3666406,3666407,3666409,3666410    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation1_Resp}

EnvD_SysQual_Diagnostics_Vehicle_time_stamp(0x2BC1)(Extended Session)
    [Documentation]    This DID(0x2BC1) shall give the Vehicle Time stamp of the Blade.
    ...    The DID shall be supported in the Default and Extended.
    ...    The DID shall require no security level.
    [Tags]    CustomerDiagnostic    TCID-518841    FID-3666405,3666406,3666407,3666409,3666410    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation2_Resp}

EnvD_SysQual_Diagnostics_Vehicle_time_stamp(0x2BC1)(NegativeResponse)
    [Documentation]    Test Negative Response for DID(0x2BC1) Vehicle Time stamp of the Blade.
    [Tags]    CustomerDiagnostic    TCID-518836    FID-3666411    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_VehicleMileage(0x295A)(Default Session)
    [Documentation]    This DID(0x295A) shall give the Vehicle Mileage of the Blade.
    ...    The DID shall be supported in the Default and Extended.
    ...    The DID shall require no security level.
    [Tags]    CustomerDiagnostic    TCID-518838    FID-3666413,3666414,3666415,3666417,3666418    FULLTEST
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.diag.SetETHSignal    1    10000

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_10000_Resp}

EnvD_SysQual_Diagnostics_VehicleMileage(0x295A)(Extended Session)
    [Documentation]    This DID(0x295A) shall give the Vehicle Mileage of the Blade.
    ...    The DID shall be supported in the Default and Extended.
    ...    The DID shall require no security level.
    [Tags]    CustomerDiagnostic    TCID-518821    FID-3666413,3666414,3666415,3666417,3666418    FULLTEST
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.diag.SetETHSignal    1    12345
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_12345_Resp}

EnvD_SysQual_Diagnostics_VehicleMileage(0x295A)(NegativeResponse)
    [Documentation]   Test Negative Response for DID(0x295A) Vehicle Mileage of the Blade.
    [Tags]    CustomerDiagnostic    TCID-518823    FID-3666419    FULLTEST
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_SupplyVoltage(0x1906)(Default Session)
    [Documentation]    This DID(0x1906) shall give the Supply Voltage of the Blade.
    ...    The DID shall be supported in the Default and Extended.
    ...    The DID shall require no security level.
    [Tags]    CustomerDiagnostic    TCID-518818    FID-3666421,3666422,3666423,3666424,3666426    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # set supply voltage to 12
    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    Sleep    3s
    prj.sut.diag.compareSupplyVoltage    ${sut.diag.VoltageTerminal30_119V_Resp}    ${sut.diag.VoltageTerminal30_12V_Resp}
    ...        ${sut.diag.VoltageTerminal30_118V_Resp}
    # set supply voltage to 16
    bits_platform.Output Set Analog Signal Value    Battery    16
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    Sleep    3s
    prj.sut.diag.compareSupplyVoltage    ${sut.diag.VoltageTerminal30_1590V_Resp}    ${sut.diag.VoltageTerminal30_16V_Resp}
    ...    ${sut.diag.VoltageTerminal30_1580V_Resp}
    # post condition
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SupplyVoltage(0x1906)(Extended Session)
    [Documentation]    This DID(0x1906) shall give the Supply Voltage of the Blade.
    ...    The DID shall be supported in the Default and Extended.
    ...    The DID shall require no security level.
    [Tags]    CustomerDiagnostic    TCID-518820    FID-3666421,3666422,3666423,3666424,3666426    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # set supply voltage to 12
    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    Sleep    3s
    prj.sut.diag.compareSupplyVoltage    ${sut.diag.VoltageTerminal30_119V_Resp}    ${sut.diag.VoltageTerminal30_12V_Resp}
    ...        ${sut.diag.VoltageTerminal30_118V_Resp}
    # set supply voltage to 16
    bits_platform.Output Set Analog Signal Value    Battery    16
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    Sleep    3s
    prj.sut.diag.compareSupplyVoltage    ${sut.diag.VoltageTerminal30_1590V_Resp}    ${sut.diag.VoltageTerminal30_16V_Resp}
    ...    ${sut.diag.VoltageTerminal30_1580V_Resp}
    # post condition
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SupplyVoltage(0x1906)(NegativeResponse)
    [Documentation]  Test Negative Response for DID(0x1906) Supply Voltage of the Blade.
    [Tags]    CustomerDiagnostic    TCID-518827    FID-3666427   FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.SupplyVoltage_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # check in Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.SupplyVoltage_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

######################################## RAVI ############################################################

# EnvD_SysQual_Diagnostics_VehicleIdentificationNumber_Chassisnumber(0xF190)(Default Session)
#     [Documentation]    The data shall be obtained from the Message "VIN_01_MUX".
#     ...    The DID VehicleIdentificationNumber shall give the chassis number.

#     [Tags]    CustomerDiagnostic    FID-1132964,1132965,1132967,1132968    TCID-272601    FULLTEST

#     # Set the New VIN value to the VIN_01 message
#     prj.sut.com.set VIN Value    23456789123456781
#     # Go to default session
#     prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
#     # Send the VIN request
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Modified_Default_Resp_New}
#     sleep    3s
#     prj.sut.power cycle
#     sleep    5s
#     prj.sut.can.diag.tester.present.active
#     Sleep    3s
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
#     Sleep    3s
#     prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Modified_Default_Resp_New}
#     # Set the VIN value to the Default value
#     prj.sut.com.set VIN Value    12345678912345678
#     # Go to default session
#     prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Default_Resp_New}

# EnvD_SysQual_Diagnostics_VehicleIdentificationNumber_Chassisnumber(0xF190)(Extended Session)
#     [Documentation]    The DID VehicleIdentificationNumber shall give the chassis number in extended mode
#     [Tags]    CustomerDiagnostic    TCID-272602    FULLTEST    FID-1132964,1132965,1132967,1132968

#     # Set the New VIN value to the VIN_01 message
#     prj.sut.com.set VIN Value    23456789123456781
#     # Go to default session
#     prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
#     # Send the VIN request
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Modified_Default_Resp_New}
#     sleep    3s
#     prj.sut.power cycle
#     sleep    5s
#     prj.sut.can.diag.tester.present.active
#     Sleep    3s
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
#     Sleep    3s
#     prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Modified_Default_Resp_New}
#     # Set the VIN value to the Default value
#     prj.sut.com.set VIN Value    12345678912345678
#     # Go to default session
#     prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Default_Resp_New}

 EnvD_SysQual_Diagnostics_IpNdpCacheList(0x0142)(Default Session)
    [Documentation]    This Data Identifier identifies all entries of the NDP cache of the control unit
    ...    that are currently in the REACHABLE state.
    ...    The DID shall be supported in Default session.The DID shall require no security level
    [Tags]    CustomerDiagnostic    FID-1691103,1691104,1691105,1691107,1691108    TCID-518815    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send the VIN request
    prj.sut.can.diag.send    ${sut.diag.IpNdpCacheList_Req}
    sleep    3s
    # prj.sut.diag.compare.list    ${sut.diag.IpNdpCacheList_Resp}
    # prj.sut.diag.compare.byte.range.flexible    ${sut.diag.macs}    9   27   MAC Address
    # # prj.sut.diag.compare.byte.range.flexible    ${sut.diag.ipv6}    27  75   IPv6 Address
    # prj.sut.diag.compare.byte.range.flexible    ${sut.diag.VLAN}    45  51   VLAN Tag
    prj.sut.diag.compare.byte.range    ${sut.diag.IpNdpCacheList_Resp1}    0    8

 EnvD_SysQual_Diagnostics_IpNdpCacheList(0x0142)(Extended Session)
    [Documentation]    This Data Identifier identifies all entries of the NDP cache of the control unit
    ...    that are currently in the REACHABLE state.
    ...    The DID shall be supported in Extended session.The DID shall require no security level
    [Tags]    CustomerDiagnostic    FID-1691103,1691104,1691105,1691107,1691108    TCID-518876    FULLTEST

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send the VIN request
    prj.sut.can.diag.send    ${sut.diag.IpNdpCacheList_Req}
    sleep    3s
    # prj.sut.diag.compare.list    ${sut.diag.IpNdpCacheList_Resp}
    # prj.sut.diag.compare.byte.range.flexible    ${sut.diag.macs}    9   27   MAC Address
    # # prj.sut.diag.compare.byte.range.flexible    ${sut.diag.ipv6}    27  75   IPv6 Address
    # prj.sut.diag.compare.byte.range.flexible    ${sut.diag.VLAN}    45  51   VLAN Tag
    prj.sut.diag.compare.byte.range    ${sut.diag.IpNdpCacheList_Resp1}    0    8

EnvD_SysQual_Diagnostics_IpNdpCacheList(0x0142)_NegativeResponse
    [Documentation]    To test negative response for IpNdpCacheList(0x0142)
    [Tags]    CustomerDiagnostic    TCID-518879    FULLTEST     FID-1132969
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.IpNdpCacheList_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.IpNdpCacheList_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.IpNdpCacheList_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.IpNdpCacheList_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Enter Programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.IpNdpCacheList_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_Ip_counter_dropped_ethernet_frames_layer_2(0x019f)(Default Session)
    [Documentation]    The measured value "Counter discarded Ethernet frames, layer 2" must return the number of Ethernet frames
	...    discarded in ISO/OSI layer 2 by the MAC functionality.
	...    The below Failures shall lead to increase in counter
	...    Incorrect frame format (e.g. double VLAN tag)
	...     CRC error
	...    Incorrect target MAC address
	...    Invalid VLAN
	...    Invalid EtherType
	...    The DID shall be supported in the Default session.The DID shall require no security level .
	...    Request and Response Format
	[Tags]    CustomerDiagnostic    TCID-518884    FID-2845406,2845407,2845408,2845410,2845411        FULLTEST
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    Log To Console    counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    ${bAck}    Set Variable    ${False}
    # FOR loop for retries
    FOR    ${i}    IN RANGE    3
        Log To Console    Attempt #${i+1} to increase and verify the counter

        # Increase the counter for the signal
        prj.sut.diag.IpDrop    ${sut.diag.IpCounterDropEthernetFramesLayer2_0x065F_CounterAdd}

        # send command again
        prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Req}
        prj.sut.diag.compare.byte.range    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Resp}    0    8

        # take the new last Byte
        ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
        ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
        Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

        # Compare with the 1st variable +1
        IF    ${Counter_Int_new} == ${Counter2_Int_new}
            ${bAck}    Set Variable    ${True}
            BREAK
        ELSE
            Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        END
    END

    IF    ${bAck} == ${True}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
    ELSE
        Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new} after all retries.
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=The counter did not increase to ${Counter_Int_new} as expected after all retries.
    END

EnvD_SysQual_Diagnostics_Ip_counter_dropped_ethernet_frames_layer_2(0x019f)(Extended Session)
    [Documentation]    The measured value "Counter discarded Ethernet frames, layer 2" must return the number of Ethernet frames
	...    discarded in ISO/OSI layer 2 by the MAC functionality.
	...    The below Failures shall lead to increase in counter
	...    Incorrect frame format (e.g. double VLAN tag)
	...     CRC error
	...    Incorrect target MAC address
	...    Invalid VLAN
	...    Invalid EtherType
	...    The DID shall be supported in the Extended session.The DID shall require no security level .
	...    Request and Response Format
	[Tags]    CustomerDiagnostic    TCID-518849    FID-2845406,2845407,2845408,2845410,2845411    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    Log To Console    counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    ${bAck}    Set Variable    ${False}
    # FOR loop for retries
    FOR    ${i}    IN RANGE    3
        Log To Console    Attempt #${i+1} to increase and verify the counter

        # Increase the counter for the signal
        prj.sut.diag.IpDrop    ${sut.diag.IpCounterDropEthernetFramesLayer2_0x065F_CounterAdd}

        # send command again
        prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Req}
        prj.sut.diag.compare.byte.range    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Resp}    0    8

        # take the new last Byte
        ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
        ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
        Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

        # Compare with the 1st variable +1
        IF    ${Counter_Int_new} == ${Counter2_Int_new}
            ${bAck}    Set Variable    ${True}
            BREAK
        ELSE
            Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        END
    END

    IF    ${bAck} == ${True}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
    ELSE
        Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new} after all retries.
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=The counter did not increase to ${Counter_Int_new} as expected after all retries.
    END

EnvD_SysQual_Diagnostics_Ip_counter_wrong_vlans(0x0A2B)(Default Session)
    [Documentation]    The measured value "Counter messages with impermissible VLAN ID" must return the number of received Ethernet
    ...    frames with a VLAN not permissible for this interface.The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
	[Tags]    CustomerDiagnostic    TCID-518887    FID-2840373,2840374,2840375,2840377,2840378    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongVlans_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongVlans_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Ip_counter_wrong_vlans_Resp}    0    14

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    Log To Console    counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongVlans_0x05E3_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_Req}
    prj.sut.diag.compare.byte.range    62 0A 2B 00 01    0    14

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the 1st variable +1
    IF    ${Counter_Int_new} == ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongVlans_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongVlans_Resp}
    ELSE

        Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongVlans_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongVlans_Resp}
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_Ip_counter_wrong_vlans(0x0A2B)(Extended Session)
    [Documentation]    The measured value "Counter messages with impermissible VLAN ID" must return the number of received Ethernet
    ...    frames with a VLAN not permissible for this interface.The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
	[Tags]    CustomerDiagnostic    TCID-518890    FID-2840373,2840374,2840375,2840377,2840378    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongVlans_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongVlans_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Ip_counter_wrong_vlans_Resp}    0    14

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    09    14
    Log To Console    counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongVlans_0x05E3_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_Req}
    prj.sut.diag.compare.byte.range    62 0A 2B 00 01    0    14

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    09    14
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the 1st variable +1
    IF    ${Counter_Int_new} == ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongVlans_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongVlans_Resp}

    ELSE
        Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongVlans_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongVlans_Resp}
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_Ethernet_Link_Lost_Counter(0x010E)(Default Session)
    [Documentation]    This Data Identifier identifier returns the number of link interruptions in that Power On Cycle.
    ...    The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518870    FID-2839633,2839634,2839635,2839637,2839638    FULLTEST

    prj.sut.power cycle
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Ethernet_Link_Lost_Counter_Resp}    0    20

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    18    20
    Log To Console    counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}
    Log To Console    The counter is currently ${Counter_Int}

    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    ON
    sleep    10s
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
    sleep    30s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_Req}

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    18    20
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the inital and Final value
    IF    ${Counter_Int} != ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!

    ELSE
        Log To Console    The new counter ${Counter2_Int_new} is same as the old counter ${Counter_Int}
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_Ethernet_Link_Lost_Counter(0x010E)(Extended Session)
    [Documentation]    The measured value "Counter messages with impermissible VLAN ID" must return the number of received Ethernet
    ...    frames with a VLAN not permissible for this interface.The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518873    FID-2839633,2839634,2839635,2839637,2839638    FULLTEST

    prj.sut.power cycle
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Ethernet_Link_Lost_Counter_Resp}    0    20

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    18    20
    Log To Console    counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}
    Log To Console    The counter is currently ${Counter_Int}

    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    ON
    sleep    10s
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
    sleep    30s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_Req}

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    18    20
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the inital and Final value
    IF    ${Counter_Int} != ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!

    ELSE
        Log To Console    The new counter ${Counter2_Int_new} is same as the old counter ${Counter_Int}
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_Ambient_air_temperature_from_CAN(0x3DA9)(Default Session)
    [Documentation]    This Data Identifier shows the ambient temperature in the received CAN message(BCM1_Aussen_Temp_ungef).
    ...    The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518843    FID-4112833,4112834,4112835,4112837,4112838    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.BCM1_Aussen_Temp_ungef_XIX_Klima_Sensor_02_MQB_XIX_E3V_VLAN_MPCI}
    ...    0
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Ambient_air_temperature_from_CAN_Resp_Value_0}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.BCM1_Aussen_Temp_ungef_XIX_Klima_Sensor_02_MQB_XIX_E3V_VLAN_MPCI}
    ...    100
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Ambient_air_temperature_from_CAN_Resp_Value_100}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.BCM1_Aussen_Temp_ungef_XIX_Klima_Sensor_02_MQB_XIX_E3V_VLAN_MPCI}
    ...    252
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Ambient_air_temperature_from_CAN_Resp_Value_252}
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    5s
    # prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    # sleep    500ms
    # prj.sut.diag.compare     ${sut.diag.Ambient_air_temperature_from_CAN_Resp_Value_252}

EnvD_SysQual_Diagnostics_Ambient_air_temperature_from_CAN(0x3DA9)(Extended Session)
    [Documentation]    This Data Identifier shows the ambient temperature in the received CAN message(BCM1_Aussen_Temp_ungef).
    ...    The DID shall be supported in the Extended session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518846    FID-4112833,4112834,4112835,4112837,4112838    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.BCM1_Aussen_Temp_ungef_XIX_Klima_Sensor_02_MQB_XIX_E3V_VLAN_MPCI}
    ...    0
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Ambient_air_temperature_from_CAN_Resp_Value_0}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.BCM1_Aussen_Temp_ungef_XIX_Klima_Sensor_02_MQB_XIX_E3V_VLAN_MPCI}
    ...    100
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Ambient_air_temperature_from_CAN_Resp_Value_100}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.BCM1_Aussen_Temp_ungef_XIX_Klima_Sensor_02_MQB_XIX_E3V_VLAN_MPCI}
    ...    252
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Ambient_air_temperature_from_CAN_Resp_Value_252}
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    5s
    # prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    # prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    # sleep    500ms
    # prj.sut.diag.compare     ${sut.diag.Ambient_air_temperature_from_CAN_Resp_Value_252}

EnvD_SysQual_Diagnostics_GPS_position(0x2430)(Default Session)
    [Documentation]    This Data Identifier shows  the Longitude and Latitude values (GNSS_Breite_Ortung GNSS_Laenge_Ortung).
    ...    The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518866    FID-4112855,4112856,4112857,4112859,4112860    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.GNSS_Breite_Ortung_XIX_GNSS_01_XIX_E3V_VLAN_MPCI}    10
    sleep    500ms
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.GNSS_Laenge_Ortung_XIX_GNSS_01_XIX_E3V_VLAN_MPCI}    10
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.GPS_position_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.GPS_position_Resp}
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    5s
    # prj.sut.can.diag.send    ${sut.diag.GPS_position_Req}
    # sleep    500ms
    # prj.sut.diag.compare     ${sut.diag.GPS_position_Resp}

EnvD_SysQual_Diagnostics_GPS_position(0x2430)(Extended Session)
    [Documentation]    This Data Identifier shows  the Longitude and Latitude values (GNSS_Breite_Ortung GNSS_Laenge_Ortung).
    ...    The DID shall be supported in the Extended session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518857    FID-4112855,4112856,4112857,4112859,4112860    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.GNSS_Breite_Ortung_XIX_GNSS_01_XIX_E3V_VLAN_MPCI}    10
    sleep    500ms
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.GNSS_Laenge_Ortung_XIX_GNSS_01_XIX_E3V_VLAN_MPCI}    10
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.GPS_position_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.GPS_position_Resp}
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    5s
    # prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    # prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # prj.sut.can.diag.send    ${sut.diag.GPS_position_Req}
    # sleep    500ms
    # prj.sut.diag.compare     ${sut.diag.GPS_position_Resp}


EnvD_SysQual_Diagnostics_Coolant_temperature_external(0x06A0)(Default Session)
    [Documentation]    The reading shows the Coolant Temp (eTM_Temperatur_1) External.
    ...    The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518858    FID-4112863,4112864,4112865,4112859,4112860    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.eTM_Temperatur_1_XIX_eTM_01_XIX_E3V_VLAN_MPCI}    0
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Coolant_temperature_external_Resp_Value_0}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.eTM_Temperatur_1_XIX_eTM_01_XIX_E3V_VLAN_MPCI}    100
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Coolant_temperature_external_Resp_Value_100}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.eTM_Temperatur_1_XIX_eTM_01_XIX_E3V_VLAN_MPCI}    253
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Coolant_temperature_external_Resp_Value_253}
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    5s
    # prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    # sleep    500ms
    # prj.sut.diag.compare     ${sut.diag.Coolant_temperature_external_Resp_Value_253}

EnvD_SysQual_Diagnostics_Coolant_temperature_external(0x06A0)(Extended Session)
    [Documentation]    The reading shows the Coolant Temp (eTM_Temperatur_1) External.
    ...    The DID shall be supported in the Extended session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518859    FID-4112863,4112864,4112865,4112859,4112860    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.eTM_Temperatur_1_XIX_eTM_01_XIX_E3V_VLAN_MPCI}    0
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Coolant_temperature_external_Resp_Value_0}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.eTM_Temperatur_1_XIX_eTM_01_XIX_E3V_VLAN_MPCI}    100
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Coolant_temperature_external_Resp_Value_100}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.eTM_Temperatur_1_XIX_eTM_01_XIX_E3V_VLAN_MPCI}    253
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Coolant_temperature_external_Resp_Value_253}
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    5s
    # prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    # prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    # sleep    500ms
    # prj.sut.diag.compare     ${sut.diag.Coolant_temperature_external_Resp_Value_253}

EnvD_SysQual_Diagnostics_Humidity_Sensor_Outside(0x27C3)(Default Session)
    [Documentation]    The reading shows the Outside Humidity_Sensor.
    ...    The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518856    FID-4112871,4112872,4112873,4112875,4112876    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.FS_Luftfeuchte_rel_XIX_Klima_Sensor_01_XIX_E3V_VLAN_MPCI}    1
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Humidity_Sensor_Outside_Resp_Value_1}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.FS_Luftfeuchte_rel_XIX_Klima_Sensor_01_XIX_E3V_VLAN_MPCI}    100
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Humidity_Sensor_Outside_Resp_Value_100}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.FS_Luftfeuchte_rel_XIX_Klima_Sensor_01_XIX_E3V_VLAN_MPCI}    201
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Humidity_Sensor_Outside_Resp_Value_201}
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    5s
    # prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    # sleep    500ms
    # prj.sut.diag.compare     ${sut.diag.Humidity_Sensor_Outside_Resp_Value_201}

EnvD_SysQual_Diagnostics_Humidity_Sensor_Outside(0x27C3)(Extended Session)
    [Documentation]    The reading shows the Outside Humidity_Sensor.
    ...    The DID shall be supported in the Extended session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518864    FID-4112871,4112872,4112873,4112875,4112876    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.FS_Luftfeuchte_rel_XIX_Klima_Sensor_01_XIX_E3V_VLAN_MPCI}    1
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Humidity_Sensor_Outside_Resp_Value_1}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.FS_Luftfeuchte_rel_XIX_Klima_Sensor_01_XIX_E3V_VLAN_MPCI}    100
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Humidity_Sensor_Outside_Resp_Value_100}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.FS_Luftfeuchte_rel_XIX_Klima_Sensor_01_XIX_E3V_VLAN_MPCI}    201
    sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Humidity_Sensor_Outside_Resp_Value_201}
    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    5s
    # prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    # prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    # sleep    500ms
    # prj.sut.diag.compare     ${sut.diag.Humidity_Sensor_Outside_Resp_Value_201}

EnvD_SysQual_Diagnostics_Read_SlaveComponentList(0x061A)(Default Session)
    [Documentation]    The DID shows the Read_SlaveComponentList.
    ...    The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518861    FID-3569001,3569002,3569003,3569005,3569006    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentList_Req}
    sleep    500ms
    prj.sut.diag.slavecompare     ${sut.diag.Read_SlaveComponentList_Resp}

EnvD_SysQual_Diagnostics_Read_SlaveComponentList(0x061A)(Extended Session)
    [Documentation]    The DID shows the Read_SlaveComponentList.
    ...    The DID shall be supported in the Extended session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518862    FID-3569001,3569002,3569003,3569005,3569006    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentList_Req}
    sleep    500ms
    prj.sut.diag.slavecompare     ${sut.diag.Read_SlaveComponentList_Resp}

EnvD_SysQual_Diagnostics_Read_SlaveComponentListDatabusIdentification(0x061B)(Default Session)
    [Documentation]    The DID shows the Read_SlaveComponentListDatabusIdentification.
    ...    The DID shall be supported in the Basic session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518845    FID-3569301,3569302,3569303,3569305,3569306    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Read_SlaveComponentListDatabusIdentification_Resp}

EnvD_SysQual_Diagnostics_Read_SlaveComponentListDatabusIdentification(0x061B)(Extended Session)
    [Documentation]    The DID shows the Read_SlaveComponentListDatabusIdentification.
    ...    The DID shall be supported in the Extended session.
    ...    The DID shall require no security level
    [Tags]    CustomerDiagnostic    TCID-518847    FID-3569301,3569302,3569303,3569305,3569306    FULLTEST
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    sleep    500ms
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Req}
    sleep    500ms
    prj.sut.diag.compare     ${sut.diag.Read_SlaveComponentListDatabusIdentification_Resp}

EnvD_SysQual_SW_Programming_MaaSBlade_Lumclient_Startup
    [Documentation]    The MaaS Blade shall startup it's LUM client automatically after bootup
    [Tags]    COMMUNICATION    FID-4513039    TCID-435332    FULLTEST   Comunication_tag
    Close All Connections
    prj.sut.connect.dlt
    # prj.sut.power cycle
    # sleep    5s
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    pidin ar| grep -i lumClient
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    rbLumClientBswAdaptorMaas /mnt/etc/lum_clientbsw_adapter/LumClientConfigMaasQnxBlade.txt
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    version is successfully verified
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-Provide-Mechanism-Persistenly-Log-Data-at-Runtime
    [Documentation]    1338698: b. Connection interface to SoC subsystem
    ...    The logging subsystem shall provide a mechanism to persistently log data at runtime.

    [Tags]    CustomerDiagnostic    FID-1398698,2510837  TCID-329835    FULLTEST
    Close All Connections
    # prj.sut.can.simulation.PowerBladeOFF
    # prj.sut.connect.dlt
    # prj.sut.power cycle
    # sleep    5s
    # Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    # Log To Console    SOC startup is correct
    Sleep    10s
    Close All Connections
    ${proc}    Start Process    ${sut.can.DLT_VIEWER_EXE}    -p    ${sut.can.DLP_FILE}
    ...    cwd=${sut.can.DLT_VIEWER_PATH}    shell=True    stdout=PIPE    stderr=PIPE

    # do whatever checks you need here (sleep, wait for UI, take screenshot, etc.)
    Sleep    5s
    Take Screenshot    ${sut.can.SCREENSHOT_PATH}
    Log    <img src="${sut.can.SCREENSHOT_PATH}">    HTML
    Log    Linux trace is seen in the log
    Terminate Process    ${proc}    kill=True

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-RemoteDebuggingSubsystemShallSupportRemoteAccesstoShellofOS
    [Documentation]    The remote debugging subsystem shall support remote access to the shell of the Operating System.
    [Tags]    CustomerDiagnostic    FID-2510890  TCID-369374    FULLTEST
    Close All Connections
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    sleep    5s
    Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Log To Console    SOC startup is correct
    Sleep    10s
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    cat mnt/Buildinfo.txt
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    ${SOC_VERSION}
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    version is successfully verified
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-DebuggingSubsystemMechanismStoreDumpPersistenly    # Updated the below testcase
    [Documentation]    The debugging subsystem shall provide a mechanism to retrieve the dump from the device.
    ...   The debugging subsystem shall provide a mechanism to store dump persistently.
    [Tags]    CustomerDiagnostic    FID-2510957,2510956  TCID-369379    FULLTEST
    Close All Connections
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    find -name dumper
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    ./proc/dumper    ./mnt/bin/dumper    ./ifs/bin/dumper
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    pidin -fA | grep dumper
    sleep    10s
    ${output}    Read
    @{expected_paths}    Create List    -d /var/log
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    cd /var/
    sleep    1s
    write    ls -l
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    log
    Verify Dumper Paths    ${output}    @{expected_paths}
    Close All Connections

EnvD_SysQual_Diagnostics_LoggingQNX_DLT-SSH-Connection
    [Documentation]    The logging subsystem shall provide a mechanism to retrieve the logged data from the device.
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-540531   FID-2510849,2510853
    Close All Connections
    Open Connection    ${sut.com.QNX_HOST}
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection

    # Step 1: Remount /var as writable
    Write    mount -uw /mnt

    # Step 2: Navigate to the directory of config file
    Write    cd /mnt/var/dlt

    # Step 3: List files to confirm file existence
    Write    ls
    ${output}    Read
    Should Contain    ${output}    dlt_logstorage.conf
    Log To Console    dlt_logstorage.conf file exists!

    # Step 4: Change the values of conf file
    Write    sed -i 's/^NOFiles=.*/NOFiles=2/' dlt_logstorage.conf
    Write    sed -i 's/^FileSize=.*/FileSize=2000000/' dlt_logstorage.conf
    Write    sync

    # Step 5: Confirm the change
    Write    grep FileSize dlt_logstorage.conf
    ${new_output_1}    Read
    Log To Console    The Size of the file: ${new_output_1}
    Sleep    5s
    Should Contain    ${new_output_1}    FileSize=2000000
    Sleep    5s
    Write    grep NOFiles dlt_logstorage.conf
    ${new_output}    Read
    Log To Console    The Size of the file: ${new_output}
    Should Contain    ${new_output}    NOFiles=2
    Log To Console    No of files value and size changed successfully
    Close Connection

    # Step 6: Power cycle
    prj.sut.power cycle
    Sleep    60s

    # Step 7: Reconnect and verify changes
    Close All Connections
    Open Connection    ${sut.com.QNX_HOST}
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Log To Console    Connection is successful

    Write    cd mnt/var/dlt
    Write    ls
    ${output}    Read
    Should Contain    ${output}    dlt_logstorage.conf
    Log To Console    dlt_logstorage.conf file exists!
    Sleep    60s
    Write    cat dlt_logstorage.conf
    ${output}    Read
    Should Contain    ${output}    NOFiles=2
    Log To Console    No of files value changes persist after power cycle
    # Check file no
    Write    ls -1 | wc -l
    ${file_count}    Read
    Log To Console    ${file_count}
    Should Contain    ${file_count}    1
    Log To Console    Test Case PASS!
    # Check file size
    Write    for f in *.dlt; do size=$(stat -c%s "$f"); echo "$f: $size bytes" $( [ "$size" -lt 2000000 ] && echo "OK" || echo "Too big" ); done
    ${size_check}    Read
    Should Not Contain    ${size_check}    Too big
    Log To Console    ${size_check}
    Log To Console    All files are under 200 KB

EnvD_SysQual_Diagnostics_ErrorStorage_QNXCOnnection
    [Documentation]    Check errmem processes and validate error memory entry
    [Tags]    FULLTEST    CustomerDiagnostic    TCID-540530    FID-2510882,2510885,2510887
    Close All Connections
    Open Connection    ${sut.com.QNX_HOST}
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Log To Console     Connection is successful
    Get Connection

    # Check running errmem processes

    SSHLibrary.Write    pidin ar | grep errmem
    ${output}    SSHLibrary.Read    delay=0.5s
    Should Contain    ${output}    errmem_rm
    Should Contain    ${output}    errmem_dump_scc

    ${count}    Evaluate    '''${output}'''.count("errmem_dump_al")

    Should Be Equal As Integers    ${count}    2

    Write    em_trace -c
    Sleep    5s
    Write    utilprc -e Testing1
    Write    em_trace -f /tmp/test.txt
    Sleep    5s
    Write    cat /tmp/test.txt | grep Testing
    ${trace}    Read    delay=5s
    Log to console    Trace is ${trace}
    Should Contain    ${trace}    Testing1

    Close Connection

EnvD_SysQual_Diagnostics_TracingQNX_DLT-SSH-Connection
    [Documentation]    The tracing subsystem shall provide a mechanism which allows SW components to output their tracing debug information.
    [Tags]    FULLTEST        CustomerDiagnostic    TCID-540529    FID-2510871
    Close All Connections
    Open Connection    ${sut.com.QNX_HOST}
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection

    Sleep    5s
    Write    find -name slogger2
    Sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    ./mnt/bin/slogger2
    Verify Dumper Paths    ${output}    @{expected_paths}
    Sleep    10s
    Write    pidin -fA | grep slogger2
    Sleep    10s
    ${output}    Read
    Log To Console    ${output}
    # Should Contain    ${output}    slogger2
    @{expected_paths}    Create List    slogger2
    Verify Dumper Paths    ${output}    @{expected_paths}

    Sleep    5s
    Write    find -name dlt-daemon
    Sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    ./mnt/usr/bin/dlt-daemon
    Verify Dumper Paths    ${output}    @{expected_paths}
    Sleep    5s
    Write    pidin -fA | grep dlt-daemon
    Sleep    5s
    ${output}    Read
    Log To Console    ${output}
    # Should Contain    ${output}    dlt-daemon
    @{expected_paths}    Create List    dlt-daemon
    Verify Dumper Paths    ${output}    @{expected_paths}

    Sleep    5s
    # Write    slog2info
    # Sleep    25s
    # ${output}    Read
    # @{expected_paths}    Create List   i2c-adapter-core
    # prj.sut.diag.Verify Dumper Paths    ${output}    @{expected_paths}
    Write    pidin -fA | grep slog2info
    Sleep    5s
    ${output}    Read
    Log To Console    ${output}
    # Should Contain    ${output}    slog2info
    @{expected_paths}    Create List    slog2info
    Verify Dumper Paths    ${output}    @{expected_paths}

    Close Connection

EnvD_SysQual_Diagnostics_Debugging_AllowRemoteDebuggingApplication
    [Documentation]    The remote debugging subsystem shall allow remote debugging of applications in the device..
    [Tags]    CustomerDiagnostic    TCID-369375    FULLTEST    FID-2510902

    Close All Connections
    Open Connection    ${sut.com.QNX_HOST}
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection

    # Step 1
    Write    find -name valgrind
    Sleep    3s

    ${output}    Read
    Should Contain    ${output}    /valgrind
    Log To Console    valgrind file exists!

    Write    valgrind /mnt/bin/cp
    Sleep    3s

    ${output}    Read
    Should Contain    ${output}    HEAP SUMMARY
    Log To Console    Valgrind traces showing up

EnvD_SysQual_Diagnostics_Debugging_DebuggingSubsystemProvideDebuggingTools
    [Documentation]    The debugging subsystem shall provide debugging tools in the device..
    [Tags]    CustomerDiagnostic    TCID-369377    FULLTEST    FID-2510958

    Close All Connections
    Open Connection    ${sut.com.QNX_HOST}
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection

    # Step 1
    Write    find -name tcpdump
    Sleep    3s

    ${output}    Read
    Should Contain    ${output}    /tcpdump
    Log To Console    tcpdump file exists!

    # Step 2
    Write    find -name valgrind
    Sleep    3s

    ${output}    Read
    Should Contain    ${output}    /valgrind
    Log To Console    valgrind file exists!

EnvD_SysQual_Diagnostics_MPCIRackStatus(0x031E)(Default Session)
    [Documentation]    This DID(0x031E) shall give the MPCI Rack status of the blade in default session.
    [Tags]    CustomerDiagnostic    TCID-534787    FULLTEST FID-3666397,3666398,3666399,3666401,3666402

    # Go to Default Session
    prj.sut.can.diag.send       ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare        ${sut.diag.Default_Session_Resp}

    # Read DID 0x031E
    prj.sut.can.diag.send       ${sut.diag.MPCIRackStatus_Req}

    # Validate header (62 03 1E)
    prj.sut.diag.compare.byte.range    ${sut.diag.MPCIRackStatus_Resp}    0    8

    # Get complete response
    ${sResult}    prj.sut.can.diag.get
    Log To Console    Response = ${sResult}

    # Get response length
    ${len}    Get Length    ${sResult}
    ${byte_len}    Evaluate    int(${len}/2)

    Log To Console    Hex Length  = ${len}
    Log To Console    Byte Length = ${byte_len}

    # Split response into bytes
    @{resp}    Split String    ${sResult}

    Log To Console    Byte0 = ${resp}[0]
    Log To Console    Byte1 = ${resp}[1]
    Log To Console    Byte2 = ${resp}[2]
    Log To Console    Byte3 = ${resp}[3]
    Log To Console    Byte4 = ${resp}[4]
    Log To Console    Byte5 = ${resp}[5]
    Log To Console    Byte6 = ${resp}[6]

    # MPCI Rack Status
    ${status_byte}    Set Variable    ${resp}[6]

    Log To Console    MPCI Status Byte = ${status_byte}

    # Validate status
    Should Match Regexp    ${status_byte}    ^(01|02|03|04)$

EnvD_SysQual_Diagnostics_MPCIRackStatus(0x031E)(Extended Session)
    [Documentation]    This DID(0x031E) shall give the MPCI Rack status of the blade in Extended session
    [Tags]    CustomerDiagnostic    TCID-534788    FULLTEST FID-3666397,3666398,3666399,3666401,3666402

    # Go to Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Read DID 0x031E
    prj.sut.can.diag.send       ${sut.diag.MPCIRackStatus_Req}

    # Validate header (62 03 1E)
    prj.sut.diag.compare.byte.range    ${sut.diag.MPCIRackStatus_Resp}    0    8

    # Get complete response
    ${sResult}    prj.sut.can.diag.get
    Log To Console    Response = ${sResult}

    # Get response length
    ${len}    Get Length    ${sResult}
    ${byte_len}    Evaluate    int(${len}/2)

    Log To Console    Hex Length  = ${len}
    Log To Console    Byte Length = ${byte_len}

    # Split response into bytes
    @{resp}    Split String    ${sResult}

    Log To Console    Byte0 = ${resp}[0]
    Log To Console    Byte1 = ${resp}[1]
    Log To Console    Byte2 = ${resp}[2]
    Log To Console    Byte3 = ${resp}[3]
    Log To Console    Byte4 = ${resp}[4]
    Log To Console    Byte5 = ${resp}[5]
    Log To Console    Byte6 = ${resp}[6]

    # MPCI Rack Status
    ${status_byte}    Set Variable    ${resp}[6]

    Log To Console    MPCI Status Byte = ${status_byte}

    # Validate status
    Should Match Regexp    ${status_byte}    ^(01|02|03|04)$


# EnvD_SysQual_Diagnostics_LoggingDLT_DisabledReleaseVariant
#     [Documentation]    The logging subsystem shall be disabled on release variant
#     [Tags]    FULLTEST    CustomerDiagnostic    TCID-541075    FID-2510862

#     Close All Connections
#     prj.sut.connect.dlt
#     prj.sut.power cycle
#     Sleep    10s
#     Log To Console    Traces in SCC console(DTL)

#     # Flash release variant and check no log is found
#     Set Test Status To Fail    COM_ERROR    Failed to Release variant flash
#     # Verify DLT keyword there should be no log displaying in DLT viewer.

#     Verify DLT keyword offline    ${AURIX_VERSION}
#     Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.disconnect.dlt

################################## MCU #############################################

EnvD_SysQual_MCUSubsystem_General_Support-COMMWithSoCViaETH
    [Documentation]    Check recent SOC version
    [Tags]    Mcu    FULLTEST    FID-1275469    TCID-431592
    prj.sut.connect.dlt
    prj.sut.power cycle

    Sleep    10s
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline
#   ...    [PowerM] GssPowerUp SwitchOnPowerRail
    ...    [PowerM] GssPowerUp CPU Activated
    ...    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
    ...    [PowerM] SendCanSignal [RUN_ACK]
    ...    [PowerM] SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.disconnect.dlt
    prj.sut.connect.QNX
    prj.sut.power cycle
    Sleep    10s
    Verify QNX keyword    0.0% packet loss    command= ping -c 10 172.21.2.20
    prj.sut.disconnect.QNX

EnvD_SysQual_MCUSubsystem_General_Support4-CAN-FD-Interface-OPL
    [Documentation]    Check CAN FD Traces and CANFD Channel connection
    [Tags]    Mcu    FULLTEST    FID-1275467    TCID-431591
    prj.sut.connect.dlt
    prj.sut.power cycle
    Sleep    10s
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline
#   ...    [PowerM] GssPowerUp SwitchOnPowerRail
    ...    [PowerM] GssPowerUp CPU Activated
    ...    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
    ...    [PowerM] SendCanSignal [RUN_ACK]
    ...    [PowerM] SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.disconnect.dlt
    prj.sut.com.set Message ID Logging Active    # Only 2 CAN FD Channels are in use
    @{pattern_list}    Create List    'CAN_GL2'    Channel 1
    ...    'CAN_GL1'    Channel 2
    @{pattern_list1}    Create List    Channel 3    Channel 4
    prj.sut.com.Countdown Timer    10
    prj.sut.com.set Message ID Logging Deactive
    Sleep    5s
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}

    END
    Sleep    3s
    FOR    ${index}    IN    @{pattern_list1}
        Log To Console    ${index}
        Should Not Contain    ${Canoe_txt}    ${index}

    END

EnvD_SysQual_MCUSubsystem_DebugInterface-Support_UARTSupport
    [Documentation]    Check recent SOC version
    [Tags]    Mcu    FULLTEST    FID-1275475    TCID-371659
    prj.sut.connect.QNX
    prj.sut.power cycle
    Sleep    60s    # New Change
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    Sleep    3s
    prj.sut.disconnect.QNX

EnvD_SysQual_MCUSubsystem_General_PowerManagementThermalManagement
    [Documentation]    Check power and temperature traces are recorded time to time
    [Tags]    Mcu    FULLTEST    FID-1039403    TCID-427018

    prj.sut.connect.dlt
    prj.sut.power cycle
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    [PowerM]    [Temperature]
    prj.sut.clear.logs.dlt
    Log To Console    Recorded logs are cleared
    Sleep    10s
    Verify DLT keyword offline    [PowerM]    [Temperature]
    prj.sut.clear.logs.dlt
    Log To Console    Recorded logs are cleared
    Sleep    10s
    Verify DLT keyword offline    [PowerM]    [Temperature]
    prj.sut.disconnect.dlt

EnvD_SysQual_MCUSubsystem_General_SWUpdate-FlashGUI
    [Documentation]    Check MCU with latest Aurix version
    [Tags]    Mcu    FULLTEST    FID-1275466    TCID-427017

    prj.sut.connect.dlt
    prj.sut.power cycle
    Sleep    20s
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    ${AURIX_VERSION}
    prj.sut.disconnect.dlt

# EnvD_SysQual_MCUSubsystem_General_CANFD-Performance-RGMII
#     [Documentation]    Check CAN FD traces and Bus Load
#     [Tags]    Mcu    FULLTEST    FID-1275461    TCID-427019
#     #    prj.sut.can.initandloadconfigurationbusload
#     prj.sut.power cycle
#     Sleep    10s
#     prj.sut.com.CAN bus load read
#     prj.sut.com.set Message ID Logging Active
#     @{pattern_list}    Create List    'CAN_GL2'
#     ...    OPMM_Power | ID:0x010 | DLC:7
#     ...    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
#     ...    Global_Health_Status_DBP | ID:0x21F | DLC:4
#     ...    OPMM_Network_DBP | ID:0x017 | DLC:8
#     ...    OPMM_SECURITY | ID:0x014 | DLC:7
#     @{pattern_list1}    Create List    CAN1 BusLoad:    CAN2 BusLoad:
#     prj.sut.com.Countdown Timer    10
#     prj.sut.com.set Message ID Logging Deactive
#     ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
#     FOR    ${index}    IN    @{pattern_list}
#         Log To Console    ${index}
#         Should Contain    ${Canoe_txt}    ${index}
#     END
#     Sleep    3s
#     ${lines}    Split To Lines    ${Canoe_txt}
#     FOR    ${index}    IN    @{pattern_list1}
#         Log To Console    Searching for: ${index}
#         FOR    ${line}    IN    @{lines}
#             ${found}    Run Keyword And Return Status    Should Contain    ${line}    ${index}
#             IF    ${found}
#                 Log To Console    ${line}
#                 ${matches}    Get Regexp Matches    ${line}    ${index}.*?([0-9]+(?:\.[0-9]+)?)    1
#                 Should Not Be Empty    ${matches}    msg=No value found after ${index}
#                 ${value}    Set Variable    ${matches[0]}
#                 Log To Console    Value after ${index}: ${value}
#                 BREAK
#             END
#         END
#     END

EnvD_SysQual_MCUSubsystem_General_3-CAN-FDInterfaceForB0-4-CAN-FDInterfaceForB1-OPL
    [Documentation]    will check the CAN Traces in the simulation
    [Tags]    Mcu    FULLTEST    FID-1275467    TCID-427015
    prj.sut.power cycle
    Sleep    10s
    prj.sut.com.check CAN traces

EnvD_SysQual_MCUSubsystem_General_CAN-ETH
    [Documentation]    Check ETH traces and CAN traces time to time
    [Tags]    Mcu    FULLTEST    FID-1039403    TCID-427020
    prj.sut.power cycle
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}    # Check ETH traces via Diag
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.com.check CAN traces
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}    # Check ETH traces via Diag
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.com.check CAN traces

EnvD_SysQual_MCUSubsystem_General_MCUBootUpTime
    [Documentation]    Check ETH traces and CAN traces time to time
    [Tags]    Mcu    FULLTEST    FID-1039403    TCID-427021
    ${expected_ms}    Set Variable    500
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    prj.sut.can.simulation.Stop
    Sleep    3s
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    ${Time_Stamp1}    prj.sut.get current Timedata
    Sleep    3s
    ${Time_Stamp2}    prj.sut.get time log from dlt    SwitchOnPowerRail
    Log To Console    Voltage time start     ${Time_Stamp1}
    Log To Console    Expected keyword time     ${Time_Stamp2}
    ${actual_total_ms}    subtract date from date    ${Time_Stamp2}    ${Time_Stamp1}    Number    False    %Y-%m-%d %H:%M:%S.%f    %Y-%m-%d %H:%M:%S.%f
    IF     ${actual_total_ms} <= ${expected_ms}
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
    ELSE
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
        Set Test Status To Fail    error_type=Power time    info_text=Expected timing be to less than ${expected_ms}±5 ms, but got ${actual_total_ms} s
    END
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline
#   ...    [PowerM] GssPowerUp SwitchOnPowerRail
    ...    [PowerM] GssPowerUp CPU Activated
    ...    [PowerM] BswM_RequestMode [PRJ_OpeMode_RUN]
    ...    [PowerM] SendCanSignal [RUN_ACK]
    ...    [PowerM] SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.disconnect.dlt

EnvD_SysQual_MCUSubsystem_General_FutureUpdatenotRestrictedByLowComputingPower
    [Documentation]    Check Aurix version and startup time
    [Tags]    Mcu    FULLTEST    FID-1275466    TCID-431593
    ${expected_ms}    Set Variable    500
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    prj.sut.can.simulation.Stop
    Sleep    3s
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    ${Time_Stamp1}    prj.sut.get current Timedata
    Sleep    3s
    ${Time_Stamp2}    prj.sut.get time log from dlt    SwitchOnPowerRail
    Log To Console    Voltage time start     ${Time_Stamp1}
    Log To Console    Expected keyword time     ${Time_Stamp2}
    ${actual_total_ms}    subtract date from date    ${Time_Stamp2}    ${Time_Stamp1}    Number    False    %Y-%m-%d %H:%M:%S.%f    %Y-%m-%d %H:%M:%S.%f
    IF     ${actual_total_ms} <= ${expected_ms}
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
    ELSE
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
        Set Test Status To Fail    error_type=Power time    info_text=Expected timing be to less than ${expected_ms}±5 ms, but got ${actual_total_ms} s
    END
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    ${AURIX_VERSION}
    prj.sut.disconnect.dlt

######################################## Memory ###########################################

EnvD_SysQual_MemorySubsystem_SystemRequirement_SOC-MAIN-Flashing
    [Documentation]    Check recent SOC MAIN flashed version
    [Tags]    Memory    FULLTEST    FID-1039408,1039409    TCID-404510
    prj.sut.power cycle
    Sleep    60s
    prj.sut.connect.QNX
    Sleep    3s
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    #  Verify QNX keyword    MAAS_SOC_hqx_4.5.6.0_r000015.1_PI26.1.0_RC4_DEV    command= cat /mnt/Buildinfo.txt
    Sleep    3s
    prj.sut.disconnect.QNX

EnvD_SysQual_MemorySubsystem_SystemRequirement_SOC-SAIL-Flashing
    [Documentation]    Check recent SOC MAIN flashed version
    [Tags]    Memory    FULLTEST    FID-1039408,1039410    TCID-404511
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.SAIL
    prj.sut.power cycle
    Sleep    60s    # New Change
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    Verify SAIL keyword offline   ${SAIL_VERSION}
    Log To Console    SAIL trace is coming
    prj.sut.disconnect.SAIL

EnvD_SysQual_MemorySubsystem_SystemRequirement_SOC-MCU-Flashing
    [Documentation]    Check recent MCU flashed version
    [Tags]    Memory    FULLTEST    FID-1039408,1039413    TCID-404512

    prj.sut.connect.dlt
    prj.sut.power cycle
    Sleep    40s
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    ${AURIX_VERSION}
    prj.sut.disconnect.dlt

EnvD_SysQual_MemorySubsystem_SystemRequirement_MCUAllowSaveNonVolatileDataInFlashPersistently
    [Documentation]    Check recent MCU flashed version
    [Tags]    Memory    FULLTEST    FID-1039415    TCID-434287

    prj.sut.connect.dlt
    prj.sut.power cycle
    Sleep    60s
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    ${AURIX_VERSION}
    Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.disconnect.dlt
    prj.sut.connect.QNX
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    prj.sut.disconnect.QNX

EnvD_SysQual_MemorySubsystem_UFSUniversalFlashStorage12.4_PowerFailSafe_PowerLoss
    [Documentation]    Check recent MCU flashed version
    [Tags]    Memory    FULLTEST    FID-1039577    TCID-371648

    prj.sut.connect.dlt
    prj.sut.power cycle
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.clear.logs.dlt
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status} == $True
        Log To Console    Trace is still loggining after power off
        framework.Set Test Status To Fail    error_type=MEMORY
    ELSE
        Log To Console    No Trace observed after power off
    END
    prj.sut.power cycle
    Sleep    60s
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.disconnect.dlt
    prj.sut.connect.QNX
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    prj.sut.disconnect.QNX

EnvD_SysQual_MemorySubsystem_UFSUniversalFlashStorage12.4_SystemRequirement
    [Documentation]    Check recent MCU flashed version
    [Tags]    Memory    FULLTEST    FID-1039411    TCID-371651
    prj.sut.connect.QNX
    prj.sut.power cycle
    Sleep    60s
    # Verify QNX keyword offline    UFS INQUIRY ID: SAMSUNG KLUFGAUHYB-B0EQ   #B_Sample
    Verify QNX keyword offline    UFS INQUIRY ID: WDC  SDINFDQ6-512G-Z    # C2.1 Sample
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    Sleep    3s
    prj.sut.disconnect.QNX

EnvD_SysQual_MemorySubsystem_NonVolatileMemory_VoltageDropHaveNoInfluenceOnWriteCycles
    [Documentation]    Check SoC version and MaaS Blade run state
    [Tags]    Memory    FULLTEST    FID-1039569    TCID-433959

    prj.sut.connect.dlt
    prj.sut.power cycle
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.power off
    prj.sut.can.simulation.Stop
    prj.sut.clear.logs.dlt
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status} == $True
        Log To Console    Trace is still loggining after power off
        framework.Set Test Status To Fail    error_type=MEMORY
    ELSE
        Log To Console    No Trace observed after power off
    END
    prj.sut.power cycle
    Sleep    60s
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    [PowerM]  SendCanSignal [PRE_RUN_STATE_REACHED]
    prj.sut.disconnect.dlt
    prj.sut.connect.QNX
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    prj.sut.disconnect.QNX
######################################## Memory END ###########################################

#########################################CAN START################################################

EnvD_SysQual_Communication_CANSubsystem_CANBuss_ShorttoUbat
    [Documentation]    CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6
    ...    but refer to Communication Value Stream on the requirements deviation list. All CAN busses of the system shall
    ...    be protected against short to Ubat up to the defined range as specified in VW80000.
    ...    The CAN subsystem shall detect CAN bus off conditions for all CAN interfaces.
    [Tags]    COMMUNICATION    FID-1338744,1339777,1340688  TCID-427026    FULLTEST   Comunication_tag

    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    Sleep    6s
    prj.sut.can.diag.tester.present.active
    Sleep    10s
    # Inject fault - Turn ON CAN1_Short_High_Gnd
    bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_Vbat    ON
    Sleep    3s
    # Check DTC with fault present - expecting C1 05 0F 2F
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    3s
    ${fault_active_status}    Run Keyword And Return Status
    ...    prj.sut.diag.checkbyte    C1 05 0F 2F
    IF    not ${fault_active_status}
        Log To Console    ✗ ERROR: C1 05 0F 2F not found with fault active
        bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_Vbat    OFF
        prj.sut.can.initandloadconfiguration
        prj.sut.can.simulation.Start
        prj.sut.can.simulation.PowerBladeON
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2F not detected with fault active
    END
    # Only continue if fault was detected
    IF    ${fault_active_status}
        Log To Console    ✓ C1 05 0F 2F detected with fault active
        # Remove fault - Turn OFF CAN1_Short_High_Gnd
        bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_Vbat    OFF
        Sleep    3s
        # Check DTC with fault removed - expecting C1 05 0F 2E
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
        Sleep    3s
        ${fault_inactive_status}    Run Keyword And Return Status
        ...    prj.sut.diag.checkbyte    C1 05 0F 2E
        IF    not ${fault_inactive_status}
            Log To Console    ✗ ERROR: C1 05 0F 2E not found after fault removal
            Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2E not detected after fault removal
        ELSE
            Log To Console    ✓ C1 05 0F 2E detected after fault removal
        END
    END

EnvD_SysQual_Communication_CANSubsystem_DeviceSupportsCANFD
    [Documentation]    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    ...    .CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6
    ...    but refer to Communication Value Stream on therequirements deviation list
    ...    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    [Tags]    COMMUNICATION    FID-1339503,1338744,1339501    TCID-427027    FULLTEST   Comunication_tag
    # By default simulation is configured with ISO FD
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    # sleep    6s
    prj.sut.com.set Message ID Logging Active
    sleep    10s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    $index in $Canoe_txt
        IF    ${contains}
            Log To Console    ✓ ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    CAN FD is supported

EnvD_SysQual_Communication_CANSubsystem_CANhighspeed
    [Documentation]    Each CAN bus of the system shall support Highspeed CAN 2.0 according to ISO 11898-2
    ...    CAN subsystem shall comply with VWN general CAN specification
    ...    030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6 but refer to Communication Value Stream on the requirements
    ...    deviation list
    [Tags]    COMMUNICATION    FID-1338744,1339501    TCID-427030    FULLTEST   Comunication_tag

    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    @{pattern_list}    Create List    0x146 On board CAN 1057G (Highspeed)
    prj.sut.com.Countdown Timer    10
    ${canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.Hardware_Tracepath}
    ${pattern_found}    Run Keyword And Return Status
    ...    Should Contain    ${canoe_txt}    @{pattern_list}
    IF    ${pattern_found}
        Log To Console    ✓ Pattern found: 0x146 On board CAN 1057G (Highspeed)
    ELSE
        # Try with regex to handle multiple spaces
        ${regex_found}    Evaluate    bool(re.search(r'0x146\\s+On board CAN 1057G \\(Highspeed\\)', '''${canoe_txt}'''))    re
        IF    ${regex_found}
            Log To Console    ✓ Pattern found with regex: 0x146 On board CAN 1057G (Highspeed)
        ELSE
            Fail    Pattern NOT found: 0x146 On board CAN 1057G (Highspeed)
        END
    END
    Log To Console    CAN FD is supported

EnvD_SysQual_Communication_CANSubsystem_CANBuss_ShorttoGND
    [Documentation]    CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE
    ...    _EN_V6.6 but refer to Communication Value Stream on the requirements deviation list
    ...    All CAN busses of the system shall be protected against short to GND.

    [Tags]    COMMUNICATION    FID-1338744,1339775  TCID-427031    FULLTEST   Comunication_tag
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    # Sleep    6s
    # prj.sut.can.diag.tester.present.active
    # Sleep    10s
    # Inject fault - Turn ON CAN1_Short_High_Gnd
    bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_GND    ON
    Sleep    5s
    # Check DTC with fault present - expecting C1 05 0F 2F
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    5s
    ${fault_active_status}    Run Keyword And Return Status
    ...    prj.sut.diag.checkbyte    C1 05 0F 2E
    IF    not ${fault_active_status}
        Log To Console    ERROR: C1 05 0F 2E not found
        bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_GND    OFF
        prj.sut.can.initandloadconfiguration
        prj.sut.can.simulation.Start
        prj.sut.can.simulation.PowerBladeON
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2E not detected with fault active
    END
    # Only continue if fault was detected
    IF    ${fault_active_status}
        Log To Console    C1 05 0F 2E detected with fault inactive
        # Remove fault - Turn OFF CAN1_Short_High_Gnd
        bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_GND    OFF
        Sleep    3s
        # Check DTC with fault removed - expecting C1 05 0F 2E
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
        Sleep    3s
        ${fault_inactive_status}    Run Keyword And Return Status
        ...    prj.sut.diag.checkbyte    C1 05 0F 2E
        IF    not ${fault_inactive_status}
            Log To Console    ERROR: C1 05 0F 2E not found after fault removal
            Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2E not detected after fault removal
        ELSE
            Log To Console    C1 05 0F 2E detected after fault removal
        END
    END

# EnvD_SysQual_Communication_CANSubsystem_CAN_baaudrate
#     [Documentation]    The CAN Subsystem shall configure baud rate for all CAN channels as per NIP file
#     [Tags]    COMMUNICATION    FID-1340692    TCID-437647    FULLTEST
#     # prj.sut.can.simulation.Stop
#     # prj.sut.can.simulation.Start
#     # prj.sut.com.Countdown Timer    5
#     # prj.sut.can.simulation.PowerBladeON
#     # prj.sut.com.Countdown Timer    5
#     # Configuring the baud rate
#     prj.sut.com.set Baud rate 500.channel1
#     prj.sut.com.set Baud rate 500.channel2
#     prj.sut.com.Countdown Timer    3
#     prj.sut.com.set Message ID Logging Active
#     @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
#     ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
#     prj.sut.com.Countdown Timer    10
#     prj.sut.com.set Message ID Logging Deactive
#     ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
#     FOR    ${index}    IN    @{pattern_list}
#         Log To Console    ${index}
#         ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
#         IF    ${contains}
#             Log To Console    ✓ ${index} is found in CAN data
#         ELSE
#             Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
#         END
#     END
#     Log To Console   CAN baud rate is verified for both the CAN1 and CAN2

# EnvD_SysQual_Communication_CANSubsystem_CANInterface_back_CAN1
#     [Documentation]    CAN transceiver is used for CAN network communication, 2xCANFD in backplane is use for inter blades communication on rack ,
#     ...    2 xCANFD is used for future CAN communication with other ECUs on vehicle
#     ...    The system shall support DoIP communication via UDS according to ISO 14229-2:2013 to be used by SW applications.
#     ...    2xCAN bus interface to back connector
#     ...    The system shall equipped with CAN subsystem with below interface:-
#     [Tags]    COMMUNICATION    FID-1039407,1340712,1338745,1338743    TCID-435334    FULLTEST
#     # prj.sut.can.simulation.Stop
#     # prj.sut.can.simulation.Start
#     # prj.sut.can.simulation.PowerBladeON
#     # prj.sut.com.Countdown Timer    10
#     # prj.sut.can.diag.tester.present.active
#     # prj.sut.com.Countdown Timer    10
#     # Go to default session
#     prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
#     sleep    3s
#     prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
#     # Send tester present
#     prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}
#     Log To Console    CAN 1 device is up and running

# EnvD_SysQual_Communication_CANSubsystem_CANInterface_back_CAN2
#     [Documentation]    CAN transceiver is used for CAN network communication, 2xCANFD in backplane is use for inter blades communication on rack ,
#     ...    2 xCANFD is used for future CAN communication with other ECUs on vehicle
#     ...    The system shall support DoIP communication via UDS according to ISO 14229-2:2013 to be used by SW applications.
#     ...    2xCAN bus interface to back connector
#     ...    The system shall equipped with CAN subsystem with below interface:-
#     [Tags]    COMMUNICATION    FID-1039407,1340712,1338745,1338743    TCID-435333    FULLTEST
#     # prj.sut.can.simulation.Stop
#     # prj.sut.can.simulation.Start
#     # prj.sut.can.simulation.PowerBladeON
#     # prj.sut.com.Countdown Timer    10
#     # prj.sut.can.diag.tester.present.active
#     # prj.sut.com.Countdown Timer    10
#     # Go to default session
#     prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
#     # Send tester present
#     prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
#     sleep    3s
#     prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}
#     Log To Console    CAN 2 device is up and running

EnvD_SysQual_Communication_CANSubsystem_recovery_from_CAN_bus_off
    [Documentation]    The CAN subsystem shall recover by itself from a CAN bus off condition.
    [Tags]    COMMUNICATION    FID-1340690  TCID-437650    FULLTEST   Comunication_tag

    bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Low    ON
    Sleep    10s
    # Check DTC with fault present - expecting C1 05 0F 2F
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    5s
    ${fault_active_status}    Run Keyword And Return Status
    ...    prj.sut.diag.checkbyte    C1 05 0F 2F
    IF    not ${fault_active_status}
        Log To Console    ERROR: C1 05 0F 2F not found with fault active
        bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Gnd    OFF
        prj.sut.can.simulation.Stop
        prj.sut.can.simulation.Start
        prj.sut.can.simulation.PowerBladeON
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2F not detected with fault active
    END
    # Only continue if fault was detected
    IF    ${fault_active_status}
        Log To Console    C1 05 0F 2F detected with fault active
        # Remove fault - Turn OFF CAN1_Short_High_Gnd
        bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Low    OFF
        Sleep    3s
        # Check DTC with fault removed - expecting C1 05 0F 2E
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
        Sleep    3s
        ${fault_inactive_status}    Run Keyword And Return Status
        ...    prj.sut.diag.checkbyte    C1 05 0F 2E
        IF    not ${fault_inactive_status}
            Log To Console    ERROR: C1 05 0F 2E not found after fault removal
            prj.sut.can.simulation.Stop
            prj.sut.can.simulation.Start
            prj.sut.can.simulation.PowerBladeON
            Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2E not detected after fault removal
        ELSE
            prj.sut.can.simulation.Stop
            prj.sut.can.simulation.Start
            prj.sut.can.simulation.PowerBladeON
            Log To Console    C1 05 0F 2E detected after fault removal
        END
    END
########################################################CAN END#####################################################
EnvD_SysQual_Diagnostics_DTC_D20090-PREPARERUNMODEREQNOTREC(Normal Range)
    [Documentation]    Checking Dtc for PREPARERUN_MODE_REQ_NOTREC
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-371277    FULLTEST FID-2607038

    prj.sut.can.simulation.PowerBladeON
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.simulation.Stop
    prj.sut.power off
    prj.sut.can.simulation.Start
    prj.sut.power on
    Sleep    1.5s        # Sleep 1s only as to reach function on line 4214 will happen in ~1.8s
    prj.sut.can.simulation.PowerBladeON
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    sleep    3s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PREPARERUN_MODE_REQ_NOTREC_Resp}

EnvD_SysQual_Diagnostics_DTC_D20090-PREPARERUNMODEREQNOTREC(Lower Limit)
    [Documentation]    Checking Dtc for PREPARERUN_MODE_REQ_NOTREC
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-371275    FULLTEST FID-2607038

    prj.sut.can.simulation.PowerBladeON
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.simulation.Stop
    prj.sut.power off
    prj.sut.can.simulation.Start
    prj.sut.power on
    Sleep    0.9s        # Sleep 0.9s only as to reach function on line 4233 will happen in ~1.6s
    prj.sut.can.simulation.PowerBladeON
    ${result}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PREPARERUN_MODE_REQ_NOTREC_Resp}
    IF    ${result} == ${True}
        Set Test Status To Fail    error_type=DTCCode    info_text= DTC code is seen.NOK!
    ELSE
        Log To Console    Test case PASS
    END

EnvD_SysQual_Diagnostics_DTC_D20090-PREPARERUNMODEREQNOTREC(Upper Limit)
    [Documentation]    Checking Dtc for PREPARERUN_MODE_REQ_NOTREC
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-371274    FULLTEST FID-2607038

    prj.sut.can.simulation.PowerBladeON
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power off
    Sleep    2s
    prj.sut.power on
    Sleep    0.8s        # Sleep 0.8s only as to reach function on line 4233 will happen in ~1.4s
    prj.sut.can.simulation.PowerBladeON
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    sleep    3s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_PREPARERUN_MODE_REQ_NOTREC_Resp}
####################################################### SOC ####################################################################

EnvD_SysQual_MainSoCSubsystem_MSoC_ExternalMemoryInterface_NORFlash_OctalSPI_QuadSPI
    [Documentation]    External memory interface to NOR flash via Octal-SPI or Quad-SPI
    ...    MSoC subsystem shall support below hardware elements with same architecture for system in order to support
    ...    a common software implementation:-
    [Tags]    SOC    FID-1378822,1378728  TCID-296582    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.connect.SAIL
    prj.sut.connect.QNX
    prj.sut.can.diag.send    ${sut.diag.MPCIRackStatus_Req}
    ${byte_range}=    prj.sut.can.diag.get.byte.range    18    20
    Log To Console    ${byte_range}
    # IF    "${byte_range}" != "02"
    #     prj.sut.usb toggle debug board switch Off
    #     prj.sut.power cycle
    #     Sleep    60s    # New Change
    #     ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]    # New Change
    #     Log To Console    SOC startup is correct
    #     IF    ${Status}
    #         Log To Console    DLT keyword is matched
    #     ELSE
    #         Log To Console    DLT keyword not matched
    #         Close All Connections
    #         framework.Set Test Status To Fail    power    QNX
    #     END
    # ELSE
        prj.sut.power cycle
        Sleep    60s    # New Change
        ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]    # New Change
        Log To Console    SOC startup is correct
        IF    ${Status}
            Log To Console    DLT keyword is matched
        ELSE
            Log To Console    DLT keyword not matched
            Close All Connections
            framework.Set Test Status To Fail    power    QNX
        END
    #END
    Sleep    10s
    # Verify SAIL keyword offline   SAIL image id:
    Verify SAIL keyword offline    ${SAIL_VERSION}
    Log To Console    SAIL trace is coming
    Verify QNX keyword    ${SOC_VERSION}    command=cat mnt/Buildinfo.txt
    Sleep    30s
    ${Status}    Run Keyword And Return Status    Verify QNX keyword    ${SOC_VERSION}    command=cat mnt/Buildinfo.txt
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.Test Case PASS
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

EnvD_SysQual_MainSoCSubsystem_MSoC_EthernetInterface-RGMII-SGMII
    [Documentation]    Ethernet interface on RGMII (up until max 1000Mbps) and SGMII(up until 2.5Gbps)
    ...   MSoC shall provide SGMII interface to communicate with Ethernet Switch
    ...   MSoC subsystem shall support below hardware elements with same architecture for system in order to support a common
    ...   software implementation.
    ...   SGMII baud rate shall able to support 2.5GBit/s
    [Tags]    SOC    FID-1378827,1592421,1378728,1592423  TCID-296576    FULLTEST
    prj.sut.power off
    prj.sut.connect.dlt
    prj.sut.connect.QNX
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    Sleep    60s    # New Change
    Verify DLT keyword offline    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]    # New Change
    Start Process    iperf3    -s    alias=iperf_server
    Sleep    3s
    # Connect and run client
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -c FD53:7CB8:0383:0018:0000:0000:0001:0267 -t 60 -i 5
    prj.sut.com.Countdown Timer    100
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    Run Keyword And Ignore Error   prj.sut.com.Check Speed    ${output}
    Close Connection
    Terminate Process    iperf_server

    # Start iPerf3 server
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    ${result}    Run Process    cmd    /c    iperf3 -c FD53:7CB8:0383:0018:0000:0000:0001:0268 -t 60 -i 5
    ...    shell=True    timeout=200s
    Log To Console    Return Code: ${result.rc}
    Log To Console    STDOUT:\n${result.stdout}
    Log To Console    STDERR:\n${result.stderr}
    prj.sut.com.Check Speed    ${result.stdout}
    Close All Connections

EnvD_SysQual_MainSoCSubsystem_MSoC_ExternalMemoryInterface_UFS3.1
    [Documentation]    External memory Interface to up until UFS3.1 memory
    ...    MSoC subsystem shall support below hardware elements with same architecture for system in order to support
    ...    a common software implementation:-
    [Tags]    SOC    FID-1378749,1378728  TCID-296584    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.connect.QNX
    prj.sut.power cycle
    Sleep    60s    # New Change
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]    # New Change
    Log To Console    SOC startup is correct
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

    Sleep    10s
    ${Status}    Run Keyword And Return Status    Verify QNX keyword offline    Boot Interface: UFS
    ...    UFS INQUIRY ID: SAMSUNG KLUFGAUHYB-B0EQ 5300
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.Test Case PASS
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

EnvD_SysQual_MainSoCSubsystem_MSoC_SupportCPUProcessingUnit
    [Documentation]    CPU processing unit
    ...    MSoC subsystem shall support below hardware elements with same architecture for system in order to support
    ...    a common software implementation:-
    [Tags]    SOC    FID-1378823,1378728  TCID-296579    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    Sleep    60s    # New Change
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]    # New Change
    Log To Console    SOC startup is correct
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    power    dlt
    END
    sleep    5s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    Send ALIVE_REQUEST to soc    # New Change
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    power    dlt
    END

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-DebuggingSubsystemProvideDebuggingTools-TCPDumper
    [Documentation]    The debugging subsystem shall provide debugging tools in the device.
    ...    (e.g. tcpdump, valgrind and etc)
    [Tags]    SOC    FID-2510958  TCID-369376    FULLTEST
    Close All Connections
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    tcpdump -i emac0 -vvv -e -n vlan 2050
    sleep    5s
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    find -name tcpdump
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    ./mnt/usr/sbin/tcpdump
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    pidin -fA | grep tcpdump
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    tcpdump -i emac0 -vvv -e -n vlan 2050
    Verify Dumper Paths    ${output}    @{expected_paths}
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-DebuggingSubsystemProvideDebuggingTools-valgrind
    [Documentation]    Ethernet interface on RGMII (up until max 1000Mbps) and SGMII(up until 2.5Gbps)
    ...   MSoC shall provide SGMII interface to communicate with Ethernet Switch
    [Tags]    SOC    FID-2510958,  TCID-369371    FULLTEST
    Close All Connections
    Open Connection   FD53:7CB8:0383:0018:0000:0000:0001:0268    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    find -name valgrind
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    ./mnt/usr/bin/valgrind    ./mnt/usr/lib64/valgrind
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    valgrind --help
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    --version                 show version
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    valgrind --version
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    valgrind-    # New Change
    Verify Dumper Paths    ${output}    @{expected_paths}
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-DebuggingSubsystemProvideDebuggingTools-backtrace
    [Documentation]     The debugging subsystem shall provide debugging tools in the device
    ...    . (e.g. tcpdump, valgrind and etc)
    [Tags]    SOC    FID-2510958  TCID-369372    FULLTEST
    Close All Connections
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    find -name backtrace
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    backtrace
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    pidin -fA | grep backtrace
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    -d /var/log
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    cd /var/
    sleep    1s
    write    ls -l
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    log
    Verify Dumper Paths    ${output}    @{expected_paths}
    Close All Connections

EnvD_SysQual_MainSoCSubsystem_MSoC_PowerManagementUnit-PMIC
    [Documentation]    Power management unit and PMIC that manage the external
    ...    power that supply to SoC subsystem.MSoC subsystem shall support
    ...    below hardware elements with same architecture for system in order
    ...    to support a common software implementation:-

    [Tags]    SOC    FID-1378835,1378728  TCID-296570    FULLTEST
    Close All Connections
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    sleep    60s    # New Change
    Verify DLT keyword offline    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]    # New Change
    Log To Console    SOC startup is correct
    Sleep    10s
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    cat mnt/Buildinfo.txt
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    ${SOC_VERSION}
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    version is successfully verified
    Verify DLT keyword    Eth Klima_Sensor_01_XIX_E3V_VLAN_MPCI Received
    Log To Console    Etherent signal is verified
    Close All Connections

EnvD_SysQual_MainSoCSubsystem_MSoC_USB2&3.1-Interface
    [Documentation]    Check recent SOC MAIN flashed version.MSoC subsystem shall support USB2 USB3.1 interface
    [Tags]    SOC    FULLTEST    FID-159246   TCID-435421
    prj.sut.power cycle
    Sleep    60s    # New Change
    prj.sut.connect.QNX
    Sleep    3s
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    Sleep    3s
    prj.sut.disconnect.QNX

EnvD_SysQual_MainSoCSubsystem_MSoC_USBInterface-USB3.1Gen2-USB2.0
    [Documentation]    USB interfaces that can support USB 3.1 Gen 2 (HS + SS, support device and host modes)
    ...    and USB2.0 (HS, support device and host modes).: MSoC subsystem shall support below hardware elements with
    ...    same architecture for system in order to support a common software implementation
    [Tags]    SOC    FULLTEST    FID-1378828,1378728   TCID-296572
    Close All Connections
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.QNX
    Sleep    3s
    prj.sut.connect.dlt
    Sleep    3s
    prj.sut.power cycle
    sleep    60s
    Verify DLT keyword offline   \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Log To Console    SOC startup is correct
    Sleep    10s
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    Sleep    3s
    prj.sut.disconnect.QNX
    Close All Connections

##################################################### SOC END###################################################################

EnvD_SysQual_Diagnostics_DTC_FrequencyCounter-IncrementalGeneric
    [Documentation]  For each fault record, the ECU shall
    ...    support a Frequency Counter indicating the total number
    ...    of times a a DTC is qulaified and dequalified i.e.
    ...    DTC status bit 0 (TestFailed) has transitioned from FALSE to TRUE.
    [Tags]    CustomerDiagnostic    TCID-371284    FULLTEST	FID-1447001

    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
    ${byte_range}    prj.sut.can.diag.get.byte.range    15    17
    IF    "${byte_range}" != "2F"
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=DTC did not activate!
    ELSE
        ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
        ${byte_value}    Convert To Integer    ${byte_value}
        bits_platform.Output Set Analog Signal Value    Battery    12
        Sleep    2s
        bits_platform.Output Set Analog Signal Value    Battery    7
        Sleep    2s

        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
        ${byte_range}    prj.sut.can.diag.get.byte.range    15    17
        IF    "${byte_range}" != "2F"
            Set Test Status To Fail    error_type=DIAGNOSIS
            ...    info_text=DTC did not activate!
        ELSE
            ${byte_value_2}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
            ${byte_value_2}    Convert To Integer    ${byte_value_2}
            IF    ${byte_value} < ${byte_value_2}
               Log To Console    Counter increased to ${byte_value_2}

            ELSE
               Set Test Status To Fail    error_type=DIAGNOSIS
               ...    info_text=The incrementing did not happen. Current increment is still same with ${byte_value}
            END
        END
    END
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_DTC_FrequencyCounter-FirstOccurance
    [Documentation]  At the first occurence of a DTC the Frequency Counter shall initially be set to 1.
    [Tags]    CustomerDiagnostic    TCID-371282    FULLTEST	FID-1447002

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
    ${byte_range}    prj.sut.can.diag.get.byte.range    15    17
    IF    "${byte_range}" != "2F"
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=DTC did not activate!
    ELSE
        ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
        ${byte_value}    Convert To Integer    ${byte_value}
        IF    ${byte_value} == ${1}
           Log To Console    Counter increased to ${byte_value}

        ELSE
           Set Test Status To Fail    error_type=DIAGNOSIS
           ...    info_text=The expected result is: ${1} but we are getting: ${byte_value} from DUT!
        END
    END
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_DTC_FrequencyCounter-IncrementalCheck
    [Documentation]  Each time the DTC is qualified from not qualified state , the Frequency Counter value shall be incremented by 1.
    [Tags]    CustomerDiagnostic    TCID-371280    FULLTEST	FID-1447003

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    FOR     ${i}     IN RANGE     0    10
        ${j}    Set Variable    ${${i}+${1}}
        bits_platform.Output Set Analog Signal Value    Battery    7
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
        ${byte_range}    prj.sut.can.diag.get.byte.range    15    17
        IF    "${byte_range}" != "2F"
             Set Test Status To Fail    error_type=DIAGNOSIS
             ...    info_text=DTC did not activate!
        ELSE
             ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
             ${byte_value}    Convert To Integer    0x${byte_value}
             IF    ${byte_value} == ${j}
               Log To Console    Counter increased to ${byte_value}
               bits_platform.Output Set Analog Signal Value    Battery    12
               Sleep    2s
             ELSE
               Set Test Status To Fail    error_type=DIAGNOSIS
               ...    info_text=The expected result is: ${j} but we are getting: ${byte_value} from DUT!
             END
        END
    END

EnvD_SysQual_Diagnostics_DTC_FrequencyCounter-IncrementalCheck255
     [Documentation]  Each time the DTC is qualified from not qualified state , the Frequency Counter value shall be incremented by 1.
     [Tags]    CustomerDiagnostic    TCID-371281    FULLTEST	FID-1447004
     bits_platform.Output Set Analog Signal Value    Battery    12
     Sleep    2s
     prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
     prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
     FOR     ${i}     IN RANGE     0    255
        ${j}    Set Variable    ${${i} + ${1}}
        bits_platform.Output Set Analog Signal Value    Battery    7
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
        ${byte_range}    prj.sut.can.diag.get.byte.range    15    17

        IF    "${byte_range}" != "2F"
            Set Test Status To Fail    error_type=DIAGNOSIS
           ...    info_text=DTC did not activate!
        ELSE
            Log To Console    DTC is activated
            ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
            ${byte_value}    Convert To Integer    0x${byte_value}
            IF    ${byte_value} == ${j}
               Log To Console    Counter increased to ${byte_value}
               bits_platform.Output Set Analog Signal Value    Battery    12
               Sleep    2s
            ELSE
               Set Test Status To Fail    error_type=DIAGNOSIS
               ...    info_text=The expected result is: ${j} but we are getting: ${byte_value} from DUT!
            END
        END

     END
     # now check if the 255 is latched at 255

     bits_platform.Output Set Analog Signal Value    Battery    7
     Sleep    2s
     prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}

     ${byte_range}    prj.sut.can.diag.get.byte.range    15    17

     IF    "${byte_range}" != "2F"
         Set Test Status To Fail    error_type=DIAGNOSIS
         ...    info_text=DTC did not activate!
     ELSE
         ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
         ${byte_value}    Convert To Integer    0x${byte_value}
         IF    ${byte_value} == ${255}
            Log To Console    Counter latched at ${byte_value}
            bits_platform.Output Set Analog Signal Value    Battery    12
         ELSE
            Set Test Status To Fail    error_type=DIAGNOSIS
            ...    info_text=The counter should be 255 but the counter we are getting: ${byte_value} from DUT!
         END
     END

EnvD_SysQual_Diagnostics_FailureManagement_Coolant_Temp_positiveResponse
    [Documentation]    To change and read the External Coolant Temperature once a DTC is triggered and compare it's value using a routine in DTC snapshots
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-540244    FID-3784653,3784654

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    83    180        # setting the value to B4
    prj.sut.can.diag.send    ${sut.diag.ExternalCoolantTemp_Req}
    prj.sut.diag.compare    ${sut.diag.ExternalCoolantTemp_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_ExternalCoolantTemp_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_CameraSensorTemperature(0x0348)(Default_session)
    [Documentation]    To check the camera temperature response of 8 bytes in default
    [Tags]    CustomerDiagnostic    TCID-558045    FID-5184682,5184683,5184684,5184686,5184687

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.CameraTemp_req}
    Sleep    2s
    ${temp_byte}    prj.sut.can.diag.get
    ${byte_list}    Split String    ${temp_byte}    ${SPACE}

    # Get last 8 bytes
    ${temp_list}    Get Slice From List    ${byte_list}    -8
    Log To console    The extracted temp ofcamera sensor is: ${temp_list}
    ${length}    Get Length    ${temp_list}

    IF    ${length} == 8
        Log To Console    Camera temperature length is correct (8 bytes)
    ELSE
        Fail    Expected 8 bytes but received ${length}
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_CameraSensorTemperature(0x0348)(Extended_session)
    [Documentation]    To check the camera temperature response of 8 bytes in extended session
    [Tags]    CustomerDiagnostic    TCID-558365    FID-5184682,5184683,5184684,5184686,5184687

    # prj.sut.can.simulation.Stop
    # Sleep    3s
    # bits_platform.Output Set Analog Signal Value    Battery    0
    # Sleep    3s
    # bits_platform.Output Set Analog Signal Value    Battery    12
    # prj.sut.can.simulation.Start
    # Sleep    3s
    # prj.sut.can.simulation.PowerBladeON
    # Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.CameraTemp_req}
    Sleep    2s
    ${temp_byte}    prj.sut.can.diag.get
    ${byte_list}    Split String    ${temp_byte}    ${SPACE}

    # Get last 8 bytes
    ${temp_list}    Get Slice From List    ${byte_list}    -8
    Log To console    The extracted temp ofcamera sensor is: ${temp_list}
    ${length}    Get Length    ${temp_list}

    IF    ${length} == 8
        Log To Console    Camera temperature length is correct (8 bytes)
    ELSE
        Fail    Expected 8 bytes but received ${length}
    END
EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_CameraSensorTemperature(0x0348)(NRC)
    [Documentation]    To check the NRCs for Camera sensor Temperature 0x0348
    [Tags]    CustomerDiagnostic    TCID-558069    FID-5184688

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    2s
    # Incorrect length NRC 13
    prj.sut.can.diag.send    ${sut.diag.CameraTemp_InvalidLongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.CameraTemp_InvalidShorthortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    2s

    # Service not supported in current session NRC 12
    # prj.sut.can.diag.send    ${sut.diag.CameraTemp_IncorrectService_req}
    # prj.sut.diag.compare    ${sut.diag.ServiceNotSupported_Resp}
    # Sleep    2s

    # Service out of Range NRC 31
    prj.sut.can.diag.ProgrammingSession.Enter
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.CameraTemp_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit
    Sleep    2s

    # Executing NRCs in Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Incorrect length NRC 13
    prj.sut.can.diag.send    ${sut.diag.CameraTemp_InvalidLongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.CameraTemp_InvalidShorthortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    2s

    # Service not supported in current session NRC 12
    # prj.sut.can.diag.send    ${sut.diag.CameraTemp_IncorrectService_req}
    # prj.sut.diag.compare    ${sut.diag.ServiceNotSupported_Resp}
    # Sleep    2s

    # Service out of Range NRC 31
    prj.sut.can.diag.ProgrammingSession.Enter
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.CameraTemp_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_RoutineCtrlReadQcomLicense (0xFD01)(Start Routine)
    [Documentation]    This DID(0xFD01) shall deal with routine control  to Read Qcom License.The DID shall be supported
    ...    in theExtended Session.The DID shall require no security level.
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-534793    FULLTEST	FID-4492575,4492576

    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RoutineCtrlReadQcomLicense_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineCtrlReadQcomLicense_Resp}


EnvD_SysQual_Diagnostics_RoutineCtrlReadQcomLicense (0xFD01)(Negative Response)
    [Documentation]    This DID(0xFD01) shall deal with routine control  to Read Qcom License.The DID shall be supported
    ...    in theExtended Session.The DID shall require no security level.
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-534791    FULLTEST	FID-4492579

    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RoutineCtrlReadQcomLicense_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.RoutineCtrlReadQcomLicense_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_ConditionsNotCorrect_Resp}

EnvD_SysQual_Diagnostics_RoutineCtrlGenerateQcomAttestationReport (0xFD02)_PositiveResponse
    [Documentation]    Test the positive response for the DID request 31 01 FD 02 xx in Production session
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-534778    FULLTEST	FID-4492559,4492560,4492561,4492563,4492564

    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RoutineCtrlGenerateQcomAttestationReport_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineCtrlGenerateQcomAttestationReport_Res}


EnvD_SysQual_Diagnostics_RoutineCtrlGenerateQcomAttestationReport (0xFD02)(Negative Response)
    [Documentation]    This DID(0xFD01) shall deal with routine control  to Read Qcom License.The DID shall be supported
    ...    in theExtended Session.The DID shall require no security level.
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-534791    FULLTEST	FID-4492579

    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RoutineCtrlGenerateQcomAttestationReport_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.RoutineCtrlGenerateQcomAttestationReport_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_ConditionsNotCorrect_Resp}

EnvD_SysQual_Diagnostics_ReadDataByIdentifier($22)_BoosterAudioBusProtocolVersion(NRC)
    [Documentation]    To read and verify the NRCs for Booster Audio Bus Protocol Version
    [Tags]    CustomerDiagnostic    FULLTEST    TCID-579774    FID-5447088
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterAudio_BusProtocolVersion_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterAudio_BusProtocolVersion_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterAudio_BusProtocolVersion_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterAudio_BusProtocolVersion_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.BoosterAudio_BusProtocolVersion_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_ReadDataByIdentifier($22)_A2bBoosterErrorstateReason(0x0307)(NRC)
    [Documentation]    To verify the NRC for A2b Booster Error State Reason
    [Tags]    CustomerDiagnostic    TCID-580578    FID-5447007
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterErrorstateReason_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterErrorstateReason_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterErrorstateReason_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterErrorstateReason_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterErrorstateReason_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_ReadDataByIdentifier($22)_A2bBoosterIdentification(0x030A)(NRC)
    [Documentation]    To verify the NRC for A2b Booster Error State Reason
    [Tags]    CustomerDiagnostic    TCID-579771    FID-5447034
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterIdentification_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterIdentification_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterIdentification_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterIdentification_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.A2bBoosterIdentification_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_Diagnostics_IPVLANNetworkTable(NRC)
    [Documentation]    To check the NRCs for IP_VLAN_Network_Table_NRC_NegativeResponse
    [Tags]    CustomerDiagnostic    TCID-548083    FID-4182267
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VLANnetworkTable_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VLANnetworkTable_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VLANnetworkTable_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VLANnetworkTable_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.VLANnetworkTable_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_ExternalDiagnostics_OperationCycleCounterOfBlade_Positive response
    [Documentation]    To check the updated cycle count of the OperationCycleCounter
    [Tags]    CustomerDiagnostic    TCID-547836    FULLTEST    FID-3666441,3666439,3666438,3666437

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_req}
    prj.sut.diag.checkbyte    ${sut.diag.OperationCycleCounterOfBlade_resp}
    ${OperationCycleCountByte_beforePowerCycle}    prj.sut.can.diag.get
    Log To Console    The Operation cyle counter byte is ${OperationCycleCountByte_beforePowerCycle}
    Sleep    2s
    @{all_bytes}    Split String    ${OperationCycleCountByte_beforePowerCycle}    ${SPACE}
    @{beforePowerCycle_bytes}    Get Slice From List    ${all_bytes}    -4
    ${beforePowerCycle_int}    Evaluate    int(''.join(reversed($beforePowerCycle_bytes)), 16)
    Log To Console    ${beforePowerCycle_int}
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    5s
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    1min
    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.simulation.PowerBladeON
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_req}
    ${OperationCycleCountByte_afterPowerCycle}    prj.sut.can.diag.get
    Log To Console    The Operation cyle counter byte is ${OperationCycleCountByte_afterPowerCycle}
    @{all_bytes1}    Split String    ${OperationCycleCountByte_afterPowerCycle}    ${SPACE}
    @{afterPowerCycle_bytes}    Get Slice From List    ${all_bytes1}    -4
    ${afterPowerCycle_int}    Evaluate    int(''.join(reversed($afterPowerCycle_bytes)), 16)
    Log To Console    ${afterPowerCycle_int}
    ${expected}    Evaluate    ${beforePowerCycle_int} + 1
    IF    ${afterPowerCycle_int} == ${expected}
        Log To Console    TEST CASE PASS
    ELSE
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_SupplyVoltageOfBladePositiveResponse_Default&ExtendedSession
    [Documentation]    The DID 22 19 06 will give supply voltage of the blade
    [Tags]    CustomerDiagnostic    TCID-540229    FID-3666425
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    # Positive response expected: 62 19 06
    prj.sut.diag.checkbyte    ${sut.diag.VoltageTerminal30_118V_Resp}
    ${response}    prj.sut.can.diag.get
    Log To Console    Complete Response: ${response}
    @{bytes}    Split String    ${response}

    # voltage bytes after removing positive response
    @{voltage_bytes}    Get Slice From List    ${bytes}    3    5

    ${msb}    Set Variable    ${voltage_bytes}[0]
    ${lsb}    Set Variable    ${voltage_bytes}[1]

    Log To Console    Voltage MSB: ${msb}
    Log To Console    Voltage LSB: ${lsb}

    # Convert 04 9C = 1180
    ${raw_voltage}    Evaluate    (int('${msb}',16) * 256) + int('${lsb}',16)
    Log To Console    Raw Voltage Value: ${raw_voltage}
    # scaling factor 0.01 (Raw value to scalable value)
    ${voltage}    Evaluate    ${raw_voltage} * 0.01
    Log To Console    Supply Voltage Terminal 30 = ${voltage} V
    IF    ${raw_voltage} <= 0
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text=Invalid voltage value received from ECU
    END

    # Executing 22 19 06 in Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    # Positive response expected: 62 19 06
    prj.sut.diag.checkbyte    ${sut.diag.VoltageTerminal30_118V_Resp}
    ${response}    prj.sut.can.diag.get
    Log To Console    Complete Response: ${response}
    @{bytes}    Split String    ${response}

    # voltage bytes after removing positive response
    @{voltage_bytes}    Get Slice From List    ${bytes}    3    5

    ${msb}    Set Variable    ${voltage_bytes}[0]
    ${lsb}    Set Variable    ${voltage_bytes}[1]

    Log To Console    Voltage MSB: ${msb}
    Log To Console    Voltage LSB: ${lsb}

    # Convert 04 9C = 1180
    ${raw_voltage}    Evaluate    (int('${msb}',16) * 256) + int('${lsb}',16)
    Log To Console    Raw Voltage Value: ${raw_voltage}
    # scaling factor 0.01 (Raw value to scalable value)
    ${voltage}    Evaluate    ${raw_voltage} * 0.01
    Log To Console    Supply Voltage Terminal 30 = ${voltage} V
    IF    ${raw_voltage} <= 0
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text=Invalid voltage value received from ECU
    END

EnvD_SysQual_Diagnostics_FailureManagement_OperationCycleCounterOfTheBlade(SnapshotData)
    [Documentation]    To observe updated value of Operation Cycle Counter of the Blade in the snapshot data after triggering DTC
    [Tags]    TCID-548172    FID-1826347

    # Clear DTCs
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    #Operation Cycle Counter before power cycle
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_req}
    prj.sut.diag.checkbyte    ${sut.diag.OperationCycleCounterOfBlade_resp}
    ${response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${response}
    @{counter_bytes_before}    Get Slice From List    ${bytes}    -4
    ${counter_before}    Evaluate    int(''.join(reversed($counter_bytes_before)),16)
    Log To Console    Operation Cycle Counter before power cycle: ${counter_before}

    # Sleep/Wakeup cycle
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    1min
    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.simulation.PowerBladeON
    Sleep    10s

    #updated Operation Cycle Counter
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_req}
    prj.sut.diag.checkbyte    ${sut.diag.OperationCycleCounterOfBlade_resp}
    ${response}    prj.sut.can.diag.get
    @{bytes}    Split String    ${response}
    @{counter_bytes_after}    Get Slice From List    ${bytes}    -4
    ${counter_after}    Evaluate    int(''.join(reversed($counter_bytes_after)),16)
    ${counter_hex_after}    Evaluate    ' '.join($counter_bytes_after)
    Log To Console    Operation Cycle Counter after power cycle: ${counter_after}

    IF    ${counter_after} <= ${counter_before}
        Set Test Status To Fail
        ...    error_type=Failure
        ...    info_text=Operation Cycle Counter was not incremented
    END

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    10s

    # Read Snapshot
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    ${snapshot_response}    prj.sut.can.diag.get
    Log To Console    Snapshot Response: ${snapshot_response}

    # Verify updated counter value present in snapshot
    Should Contain    ${snapshot_response}    ${counter_hex_after}

EnvD_SysQual_Diagnostics_FailureManagement_CoolantTempPositiveResponse
    [Documentation]    The triggered DTC will show the value of Coolant Temp eTM_Tempeeratur_1
    [Tags]    CustomerDiagnostic    TCID-540244    FID-3784653,3784654
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    2s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    83    45        # setting the value to 2D
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Coolant_temperature_external_RespPositive}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.DTC_Snapshot_By_DTC_Number_Overvoltage_CoolantTemp_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_OperationCycleCounterOfBlade_NegativeResponse
    [Documentation]    To capture the NRC for Operation cycle counter of the blade
    [Tags]    CustomerDiagnostic    TCID-548036    FID-3666443
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.OperationCycleCounterOfBlade_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_ReadHWIdent(NegativeResponse)
    [Documentation]    To capture the NRCs for Read HWIDENT service 22 03 5E
    [Tags]    CustomerDiagnostic    TCID-540232    FID-5100787,5184679
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ReadHWIdent_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ReadHWIdent_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ReadHWIdent_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ReadHWIdent_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.ReadHWIdent_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_CoolantTemperature_NegativeResponse
    [Documentation]    To capture the NRCs for Coolant temp 22 06 A0
    [Tags]    CustomerDiagnostic    TCID-540241    FID-4112869
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.CoolantTemperature_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.CoolantTemperature_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.CoolantTemperature_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.CoolantTemperature_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.CoolantTemperature_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SWCOListNumber(0x0441)_NRCs
    [Documentation]    To capture the NRCs for SWCO List Number 0x0441
    [Tags]    CustomerDiagnostic    TCID-558840    FID-2480946
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SWCOListNumber_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SWCOListNumber_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SWCOListNumber_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SWCOListNumber_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.SWCOListNumber_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_BoosterSupplyVoltage(0x0350)NRCValidation
    [Documentation]    To capture the NRCs for Booster Supply Voltage 0x0350
    [Tags]    CustomerDiagnostic    TCID-579773    FID-5447070
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterSupplyVoltage_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterSupplyVoltage_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterSupplyVoltage_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterSupplyVoltage_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.BoosterSupplyVoltage_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_FAZITID(0xF17C)NRCs
    [Documentation]    To capture the NRCs for FAZITID 0xF17C
    [Tags]    CustomerDiagnostic    TCID-<xxx>    FID-4812201
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SWCOListSparePartNumber(0x011F)(NRCs)
    [Documentation]    To capture the NRCs for SWCO List Spare Part Number 0x011F
    [Tags]    CustomerDiagnostic    TCID-559511    FID-5514716
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SWCO_list_spare_part_number_ShortLengthResponse_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SWCOListSparePartNumber_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SWCO_list_spare_part_number_ShortLengthResponse_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.SWCOListSparePartNumber_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.SWCO_list_spare_part_number_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_TrafficLoad(0x0362)(NRCs)
    [Documentation]    To capture the NRCs for Traffic Load 0x0362
    [Tags]    CustomerDiagnostic    TCID-577085    FID-5847914
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.TrafficLoad_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.TrafficLoad_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.TrafficLoad_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.TrafficLoad_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.TrafficLoad_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_A2BProtocolVersions(0x030E)NRCValidation
    [Documentation]    To capture the NRCs for A2B Protocol Versions 0x030E
    [Tags]    CustomerDiagnostic    TCID-579779    FID-5447403
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2BProtocolVersions_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2BProtocolVersions_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2BProtocolVersions_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.A2BProtocolVersions_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.A2BProtocolVersions_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_BoosterTemperatureState(0x0351)(NRCValidation)
    [Documentation]    To capture the NRCs for Booster Temperature State 0x0352
    [Tags]    CustomerDiagnostic    TCID-579776    FID-5447079
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterTemperatureState_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterTemperatureState_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterTemperatureState_ShortLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.BoosterTemperatureState_LongLength_req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.BoosterTemperatureState_req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit

EnvD_SysQual_Diagnostics_RemainingLifetime(0x8000)_DefaultSession
    [Documentation]    To observe the value for 22 80 00 and get remaining lifetime information of the blade
    [Tags]    CustomerDiagnostic    TCID-592683    FID-6423165, 6423166,6423167,6423194,6423195
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.RemainingLifetime_Req}
    ${response}    prj.sut.can.diag.get
    Log To Console    Full Response: ${response}

    # Split the response into individual bytes
    @{all_bytes}    Split String    ${response}    ${SPACE}

    # Normalized percentage->bytes index 3    (00)
    # Raw_value           -> bytes index 4-5  (88 F7)
    # Defect_level_raw    -> bytes index 6-7  (88 F8)
    # Warning_level_raw   -> bytes index 8-9  (80 6A)

    @{Normalized}    Get Slice From List    ${all_bytes}    3    4
    @{raw_bytes}    Get Slice From List    ${all_bytes}    4    6
    @{defect_bytes}    Get Slice From List    ${all_bytes}    6    8
    @{warning_bytes}    Get Slice From List    ${all_bytes}    8    10

    ${Normalized_bytes}    Evaluate    int(''.join($Normalized),16)
    ${raw_value}    Evaluate    int(''.join($raw_bytes), 16)
    ${defect_level}    Evaluate    int(''.join($defect_bytes), 16)
    ${warning_level}    Evaluate    int(''.join($warning_bytes), 16)

    Log To Console    Normalized percentage is ${Normalized_bytes} [%]
    Log To Console    Raw_value is ${raw_value} [h]
    Log To Console    Defect_level_raw is ${defect_level} [h]
    Log To Console    Warning_level_raw is ${warning_level} [h]

EnvD_SysQual_Diagnostics_RemainingLifetime(0x8000)_ExtendedSession
    [Documentation]    To observe the value for 22 80 00 and get remaining lifetime information of the blade
    [Tags]    CustomerDiagnostic    TCID-592712    FID-6423165, 6423166,6423167,6423194,6423195
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.RemainingLifetime_Req}
    ${response}    prj.sut.can.diag.get
    Log To Console    Full Response: ${response}

    # Split the response into individual bytes
    @{all_bytes}    Split String    ${response}    ${SPACE}

    # Normalized percentage->bytes index 3    (00)
    # Raw_value           -> bytes index 4-5  (88 F7)
    # Defect_level_raw    -> bytes index 6-7  (88 F8)
    # Warning_level_raw   -> bytes index 8-9  (80 6A)

    @{Normalized}    Get Slice From List    ${all_bytes}    3    4
    @{raw_bytes}    Get Slice From List    ${all_bytes}    4    6
    @{defect_bytes}    Get Slice From List    ${all_bytes}    6    8
    @{warning_bytes}    Get Slice From List    ${all_bytes}    8    10

    ${Normalized_bytes}    Evaluate    int(''.join($Normalized),16)
    ${raw_value}    Evaluate    int(''.join($raw_bytes), 16)
    ${defect_level}    Evaluate    int(''.join($defect_bytes), 16)
    ${warning_level}    Evaluate    int(''.join($warning_bytes), 16)

    Log To Console    Normalized percentage is ${Normalized_bytes} [%]
    Log To Console    Raw_value is ${raw_value} [h]
    Log To Console    Defect_level_raw is ${defect_level} [h]
    Log To Console    Warning_level_raw is ${warning_level} [h]

EnvD_SysQual_Diagnostics_RemainingLifetime(0x8000)_NegativeResponse
    [Documentation]    To verify NRC for Remaining Lifetime 22 80 00
    [Tags]    CustomerDiagnostic    TCID-592722    FID-    6423196
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.RemainingLifetime_ShortLength_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.RemainingLifetime_LongLength_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.RemainingLifetime_ShortLength_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.RemainingLifetime_LongLength_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.RemainingLifetime_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.programmingSession.Exit
