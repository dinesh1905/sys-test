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


*** Test Cases ***
PowerOffOn
    [Documentation]    PowerOffOn
    testcase_iterator.Add Test Cases    Teststeps    10


*** Keywords ***
Teststeps
    [Documentation]    The test steps are executed for Power off on test
    Log To Console    Hi
    prj.sut.connect.QNX

    # prj.sut.can.simulation.Start
    prj.sut.power cycle

    # ${res}=     Verify        conn_name=${CONNECTION_NAME}
    # ...                       send_cmd=date
    # ...                       search_pattern=GMT
    # ...                       timeout=20

    # ${command_list}=      Create List      'date'      'uname'      'date'      'uname'      'date'
    # ${pattern_list}=      Create List      GMT      QNX      GMT      QNX      GMT

    # ${pattern_length}=    Get Length    ${pattern_list}

    # FOR    ${index}    IN RANGE    0    ${pattern_length}
    #     ${res}=     Verify        conn_name=${CONNECTION_NAME}
    #     ...                       send_cmd=${command_list[${index}]}
    #     ...                       search_pattern=${pattern_list[${index}]}
    #     Log To Console    ${res}
    # END

    ${startup_list}=    Create List
    ...     OnInit
    ...     Set PWR_HOLD pin to ACTIVE
    ...     Enable UART trace supply
    ...     Enable CPU_RESET
    ...     EcuM] OnEnterWakeup
    ...     RecvCanSignal \\[PRE_RUN]
    ...     BswM_RequestMode \\[PRJ_OpeMode_PRE_RUN]
    ...     SendCanSignal \\[PRE_RUN_ACK]
    ...     EcuM] OnEnterPreRun
    ...     OnDriveUp
    ...     KssPowerUp InitFusaWdg
    ...     KssPowerUp Disable CPU_RESET
    ...     GssPowerUp Set PMIC_PGOOD_BL2 pin to ACTIVE
    ...     KssPowerUp SwitchOnMainSupplies
    ...     OnDriveUpComReady
    ...     OnEnterRunMode
    ...     EcuM] OnEnterKssRun
    ...     GssPowerUp Enable MAX20877
    ...     GssPowerUp MiscSupplies
    ...     GssPowerUp Enable CPU
    ...     GssPowerUp CPU Activated
    # wait for YZ comment on the sequence of these 3 signals
    ...     SendCanSignal \\[PRE_RUN_RESPONSE]
    ...     CPF_Test] Simulate SOC startup complete
    ...     BswM_RequestMode \\[PRJ_OpeMode_PRE_RUN_DONE]
    ...     RecvCanSignal \\[RUN]
    ...     BswM_RequestMode \\[PRJ_OpeMode_RUN]
    ...     SendCanSignal \\[RUN_ACK]
    ...     CPF_Test] Simulate SOC RUN complete \\(idle, ready to shutdown\\)
    ...     BswM_RequestMode \\[PRJ_OpeMode_RUN_DONE]
    ...     SendCanSignal \\[RUN_RESPONSE]

    ${pattern_length}=    Get Length    ${startup_list}

    ${shutdown_list}=    Create List
    ...    \\[PowerM] RecvCanSignal \\[PREPARE_SHUTDOWN]
    ...    \\[PowerM] BswM_RequestMode \\[PRJ_OpeMode_PRE_SHUTDOWN]
    ...    \\[PowerM] SendCanSignal \\[PRE_SHUTDOWN_ACK]
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
    ...    \\[PowerM] SendCanSignal \\[PRE_SHUTDOWN_RESPONSE]
    ...    \\[PowerM] RecvCanSignal \\[SHUTDOWN]
    ...    \\[PowerM] BswM_RequestMode \\[PRJ_OpeMode_SHUTDOWN]
    ...    \\[PowerM] SendCanSignal \\[SHUTDOWN_ACK]
    ...    \\[PowerM] SendCanSignal \\[SHUTDOWN_RESPONSE]
    ...    \\[PowerM] Shutdown ComM Channel Completed
    ...    \\[PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE
    ...    \\[PowerM] Set PWR_HOLD pin to INACTIVE

    ${pattern_length2}=    Get Length    ${shutdown_list}

    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    # prj.sut.can.simulation.PowerBladeON

    FOR    ${index}    IN RANGE    0    ${pattern_length}
        Log To Console    ${startup_list[${index}]}
        ${res}=    Verify    conn_name=${CONNECTION_NAME}
        ...    search_pattern=${startup_list[${index}]}
        ...    timeout=20
        Log To Console    ${res} MCU Startup sequence is correct
    END
