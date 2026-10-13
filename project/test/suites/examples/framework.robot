*** Settings ***
Documentation    Example script to check the complete TA-Framework test flow

Resource    ${TAF_PATH}/import.resource

Metadata    testtype            example
Metadata    testarea            framework.testflow
Metadata    requirements        no requirements
Metadata    preconditions       no preconditions
Metadata    actions             no actions
Metadata    expectedresults     no expectedresults
Metadata    additionalinfo      no additionalinfo

# Test Automation Framework
Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Test Cases ***
Test Framework Test Flow 1
    [Documentation]    Test Flow Test 1: test status is PASS, all test steps are executed.

    ${ack} =  testbench.tuner.fm.Set Parameter    NDR2    frequency    ${100.8}

    Log    Ack: ${ack}    console=yes

Test Framework Test Flow 2
    [Documentation]    Test Flow Test 2: test status is FAIL, all test steps are executed.

    framework.Set Test Status To Fail And Continue     error_type=AUDIO    info_text=Audio error.

    ${ack} =  testbench.tuner.fm.Set Parameter    NDR2    frequency    ${100.8}

    Log    Ack: ${ack}    console=yes

Test Framework Test Flow 3
    [Documentation]    Test Flow Test 3: test status is FAIL, only first test step is executed.

    framework.Set Test Status To Fail    error_type=AUDIO    info_text=Audio error.

    ${ack} =  testbench.tuner.fm.Set Parameter    NDR2    frequency    ${100.8}

    Log    Ack: ${ack}    console=yes

Test Framework Test Flow 4
    [Documentation]    Test Flow Test 4: test status is UNKNOWN, only first test step is executed.

    framework.Set Test Status To Unknown    info_text=Unknown error.

    ${ack} =  testbench.tuner.fm.Set Parameter    NDR2    frequency    ${100.8}

    Log    Ack: ${ack}    console=yes

Test Framework Test Flow 5
    [Documentation]    Test Flow Test 5: test status is PASS, all test steps are executed.

    ${ack}    ${result} =    Test Keyword 1

    IF    ${ack} == ${False}
        framework.Set Test Status To Unknown    info_text=Unknown error.
    END

    IF    ${result} == ${False}
        framework.Set Test Status To Fail    error_type=AUDIO    info_text=Audio error.
    END

    Log    Result: ${result}    console=yes

Test Framework Test Flow 6
    [Documentation]    Test Flow Test 6: test status is FAIL, all test steps are executed.

    ${ack}    ${result} =    Test Keyword 2

    IF    ${ack} == ${False}
        framework.Set Test Status To Unknown    info_text=Unknown error.
    END

    IF    ${result} == ${False}
        framework.Set Test Status To Fail And Continue    error_type=AUDIO    info_text=Audio error.
    END

    Log    Result: ${result}    console=yes

Test Framework Test Flow 7
    [Documentation]    Test Flow Test 7: test status is FAIL, test case execution stops after second IF statement.

    ${ack}    ${result} =    Test Keyword 2

    IF    ${ack} == ${False}
        framework.Set Test Status To Unknown    info_text=Unknown error.
    END

    IF    ${result} == ${False}
        framework.Set Test Status To Fail    error_type=AUDIO    info_text=Audio error.
    END

    Log    Result: ${result}    console=yes

Test Framework Test Flow 8
    [Documentation]    Test Flow Test 8: test status is UNKNOWN, test case execution stops after first IF statement.

    ${ack}    ${result} =    Test Keyword 3

    IF    ${ack} == ${False}
        framework.Set Test Status To Unknown    info_text=Unknown error.
    END

    IF    ${result} == ${False}
        framework.Set Test Status To Fail    error_type=AUDIO    info_text=Audio error.
    END

    Log    Result: ${result}    console=yes

Test Framework Test Flow 9
    [Documentation]    Test Flow Test 9: test status is FAIL, test run is aborted after first IF statement.

    ${ack} =    Test Keyword 4

    IF    ${ack} == ${False}
        framework.Abort Test Run   info_text=Fatal error.
    END

    Log    Ack: ${ack}    console=yes

Test Framework Test Flow 10
    [Documentation]    Test Flow Test 10:test status is UNKNOWN, dummy test case after abort.

    Log    This comment should not be displayed.    console=yes


*** Keywords ***
Test Keyword 1
    [Documentation]  Returns a positive acknowledgement and a positive result value.

    Set Local Variable    ${ack}    True
    Set Local Variable    ${result}    True

    RETURN    ${ack}    ${result}

Test Keyword 2
    [Documentation]  Returns a positive acknowledgement and a negative result value.

    Set Local Variable    ${ack}    True
    Set Local Variable    ${result}    False

    RETURN    ${ack}    ${result}

Test Keyword 3
    [Documentation]  Returns a negative acknowledgement and a negative result value.

    Set Local Variable    ${ack}    False
    Set Local Variable    ${result}    False

    RETURN    ${ack}    ${result}

Test Keyword 4
    [Documentation]  Returns a negative acknowledgement.

    Set Local Variable    ${ack}    False

    RETURN    ${ack}
