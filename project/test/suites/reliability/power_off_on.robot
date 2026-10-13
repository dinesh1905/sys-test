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


*** Variables ***
@{Failed__SOCstartup}
@{Failed__SOCsendcommand}


*** Test Cases ***
PowerOffOn
    [Documentation]    PowerOffOn
    testcase_iterator.Add Test Cases    Teststeps    100


*** Keywords ***
Teststeps
    [Documentation]    The test steps are executed for Power off on test
    Log To Console    Hi Starting the test for poweroffon.

    Set Log Level    Debug
    ${bAck}    ${sIteration}    prj.sut.reliability: Randomize parameters
    prj.sut.connect.dlt
    prj.sut.can.simulation.PowerBladeOFF
    ${b_ack}=    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.QNX
    ${b_ack}=    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.simulation.PowerBladeON

    # prj.sut.power cycle
    # Sleep    30s
    ${Status}=    Run Keyword And Return Status    Verify   conn_name=${CONNECTION_NAME}
    ...                                                     search_pattern=Startup done
    ...                                                     timeout=60

    IF    ${Status} == True
        Log to console    Test round had the keyword startup done.Now wait ${sut.reliability.poweroffon.runtimecommand}s
        Sleep    ${sut.reliability.poweroffon.runtimecommand}s

        ${Status}=    Run Keyword And Return Status     Verify        conn_name=${CONNECTION_NAME}
        ...                                                           send_cmd=date
        ...                                                           search_pattern=GMT
        ...                                                           timeout=60
        IF    ${Status} == True
            Log To Console    SOC is still up
        ELSE
            Append To List    ${Failed__SOCsendcommand}    ${sIteration}
            ${countersocstartup}=    Get Length    ${Failed__SOCsendcommand}
            Log To Console    Number of failed command send : ${countersocstartup}
            Log To Console    The failed test case is test case number : ${Failed__SOCsendcommand}
            framework.Set Test Status To Fail    error_type=RESET    info_text=No Response from SOC when sending a command
        END

    ELSE
        Append To List    ${Failed__SOCstartup}    ${sIteration}
        ${counter}=    Get Length    ${Failed__SOCstartup}
        Log To Console    Number of failed startup : ${counter}
        Log To Console    The failed test case is test case number : ${Failed__SOCstartup}
        framework.Set Test Status To Fail    error_type=command    info_text=SOC did not finish bootup.
    END

    # #prj.sut.can.simulation.Start

    # # ${command_list}=      Create List      'date'      'uname'      'date'      'uname'      'date'
    # # ${pattern_list}=      Create List      GMT      QNX      GMT      QNX      GMT

    # # ${pattern_length}=    Get Length    ${pattern_list}

    # # FOR    ${index}    IN RANGE    0    ${pattern_length}
    # #     ${res}=     Verify        conn_name=${CONNECTION_NAME}
    # #     ...                       send_cmd=${command_list[${index}]}
    # #     ...                       search_pattern=${pattern_list[${index}]}
    # #     Log To Console    ${res}
    # # END

    # prj.sut.can.simulation.PowerBladeOFF
    # sleep    30s
    # prj.sut.connect.dlt
    # prj.sut.power cycle
    # Sleep    30s
    # ${Status}=    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME}
    # ...                                                      search_pattern=Startup done
    # ...                                                      timeout=10

    # Log To Console    The status of verified step is "${Status}"
    # IF    ${Status} == True
    #     Log To Console    SOC Startup done

    # ELSE
    #     Log To Console    SOC startup did not happen
    #     # append count
    #     ${sut.reliability.soc_nonbootup_count}    Set Global Variable    ${sut.reliability.soc_nonbootup_count} + 1
    #     Log To Console    ${sut.reliability.soc_nonbootup_count}

    # END

    # Sleep    600s

    # ${Status}=    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME}
    # ...                                                      send_cmd=date
    # ...                                                      search_pattern=GMT
    # ...                                                      timeout=10

    # Log To Console    The status of verified step is "${Status}"
    # IF    ${Status} == True
    #     Log To Console    SOC is still up

    # ELSE
    #     Log To Console    SOC is not responding.Check for reset.

    # END
    # Log To Console    ${sut.reliability.soc_nonbootup_count}
    # ${sut.reliability.soc_nonbootup_count}    Convert To Integer    ${sut.reliability.soc_nonbootup_count}
    # Log To Console    ${sut.reliability.soc_nonbootup_count}
    # ${sut.reliability.soc_nonbootup_count}    Set Global Variable    ${sut.reliability.soc_nonbootup_count} + ${1}
    # Log To Console    ${sut.reliability.soc_nonbootup_count}
