*** Settings ***
Documentation    Project specific teardowns module

Library     BuiltIn
Library    OperatingSystem
Library    String

Resource    ../sut/all_sut/libraries/sw_flashing/sw_flashing.resource


*** Variables ***
@{AurixRestCount}    @{EMPTY}
${DTC_TAG}    "DTC"
${PROGRAMMING_TAG}    "ProgrammingSession"
${COMMUNICATION_TAG}    "Comunication_tag"


*** Keywords ***
prj.test.teardowns.tear down test case
    [Documentation]    Specific endconditions: Keyword execution for each test case teardown.
    ...                This keyword will be executed for each test case except for the last
    ...                test case in a test suite.

    Log  ====== [${TEST NAME}] :: (Test Teardown) :S: Enter ======    console=yes
    #prj.sut.disconnect.dlt
    #prj.sut.disconnect.safety
    ${test_name_log}        Set Variable        ${TEST_NAME}
    Log To Console    ${test_name_log}
    # Create Directory    D:\\Desktop\\MaaS_SW\\LogFile\\Test_logs\\${test_name_log}
    # Copy File    D:\\tmp\\LogFile\\log.txt    D:\\Desktop\\MaaS_SW\\LogFile\\Test_logs\\${test_name_log}\\log.txt
    # Copy File    D:\\tmp\\LogFile\\log_QNX.txt    D:\\Desktop\\MaaS_SW\\LogFile\\Test_logs\\${test_name_log}\\log_QNX.txt
    # Copy File    D:\\tmp\\LogFile\\log_safety.txt    D:\\Desktop\\MaaS_SW\\LogFile\\Test_logs\\${test_name_log}\\SafetyLog.txt

    # ${reset}    Grep File    D:\\Desktop\\MaaS_SW\\LogFile\\cerberus.txt   CERBERUS APPLICATION STARTED
    # Log To Console    Number of reset is  ${reset}

    # Append To List    ${AurixRestCount}     ${reset}
    # ${counter}    Get Length    ${AurixRestCount}
    # Log To Console    Number of failed startup : ${counter}
    # Log To Console    The failed test case is test case number : ${AurixRestCount}
    # ${content}    Get File    D:\\Desktop\\MaaS_SW\\LogFile\\FailureLog\\${test_name_log}\\log.txt
    # @{AurixRestCount}    Split To Lines    ${content}
    # @{resultKeyValue}    Set Local Variable    @{AurixRestCount}
    # ${total}   Get Lines Containing String    ${content}    CERBERUS APPLICATION STARTED
    # Log To Console    ***********${total}
    Log  ====== [${TEST NAME}] :: (Test Teardown) :S: Exit ======    console=yes

prj.test.teardowns.tear down test case with failure
    [Documentation]    Specific endconditions: Keyword execution if a test case failed.

    Log    ====== [${TEST NAME}] :: {Failure} :: (Test Teardown) :S: Enter ======    console=yes

    ${b_ack}    ${s_result}    bits_platform.Input Get Signal Value    Battery_Voltage
    IF    ${s_result} == 12
        Log To Console    Voltage is in Normal range (12V)
    ELSE
        Log To Console    Battery voltage is not in Normal range. Setting it to 12V
        ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    12
    END

    IF    ${DTC_TAG} in ${TEST_TAGS}
        Log To Console    Starting teardown for testcase with DTC tags
        ${Status}    Run Keyword And Return Status    DTC Setting ON
        IF    "${Status}" == "True"
            Log To Console    DTC setting turned to ON
        ELSE
            Log to Console    DTC tags test teardown is initializing ...
            prj.sut.power cycle
            Sleep    10s
            prj.sut.can.diag.tester.present.active
            Sleep    5s
            DTC Setting ON
        END
    END
    IF    ${PROGRAMMING_TAG} in ${TEST_TAGS}
        Log To Console    Starting teardown for testcase with ProgrammingSession tags
        bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagProgrammingModeEntry    0
        Sleep    10s
        prj.sut.can.simulation.Stop
        prj.sut.disconnect.dlt
        Move File    D:/tmp/CAN_Trace/Logging.blf    D:/tmp/LogFile/${TEST_NAME}/
        prj.sut.power cycle
        prj.sut.can.diag.tester.present.active
        Sleep    60s
    END

    IF    ${COMMUNICATION_TAG} in ${TEST_TAGS}
        Close All Connections
        Log to Console    Teardown for COM is performed.........
    END
    Log    ====== [${TEST NAME}] :: {Failure} :: (Test Teardown) :S: Exit ======    console=yes

prj.test.teardowns.tear down test suite
    [Documentation]    Standard Suite Teardown executed executed every time (= in every robot file
    ...                of the suite).

    Log  ****** [${SUITE NAME}] :: (Suite Teardown) :S: Enter *******

    Log  ****** [${SUITE NAME}] :: (Suite Teardown) :S: Exit *******

prj.test.teardowns.tear down final test suite
    [Documentation]    Specific endconditions: Keyword execution for the last test case in a test suite.

    Log    ====== [${SUITE NAME}] :: (Final) :: (Suite Teardown) :S: Enter ======

    Log    ====== [${SUITE NAME}] :: (Final) :: (Suite Teardown) :S: Exit ======
