*** Settings ***
Documentation       Test suite containing test cases for SOC General of the MaaS Blade.
Metadata            testtype    FULLTEST
Metadata            testarea    MaaS_SoCDomains
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults
Resource            ${TAF_PATH}/import.resource
Library             Screenshot
Library             SSHLibrary
Library             String
Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         setups.Set Up Test Suite
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Test Cases ***
EnvD_SysQual_SoCGeneral_ClientLibrary_CameraEcosystemManagerClientCommunication
    [Documentation]    Verify CesMgr client library communication on QNX target by
    ...    executing Cesmgr_ClientlibTestApp and validating the CESMGR_RESULT counters.
    [Tags]    SOC    socgeneral    FID-6095313    TCID-    FULLTEST
    Close All Connections
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}

    Write    cd /mnt/usr/bin
    Write    on -u 0:10004 ./Cesmgr_ClientlibTestApp
    ${output}=    Read Until Prompt
    Should Contain    ${output}    ASW PASS: CesMgr integration probe succeeded

    ${result_line}=    Extract Result Line    ${output}    CESMGR_RESULT
    Validate Status And Connection    ${result_line}    CesMgr

    # --- Validate cycles ---
    Validate Counter Pair    ${result_line}    cycles_req    cycles_done    Cycle

    # --- Validate request vs callback counts ---
    Validate Counter Pair    ${result_line}    req_set_config    cb_set_config    SetCamConfig
    Validate Counter Pair    ${result_line}    req_get_config    cb_get_config    GetCamConfig

    # --- Validate that no config validation failures occurred ---
    Should Contain    ${result_line}    validation_fail=0

    Close All Connections

*** Keywords ***
Extract Result Line
    [Documentation]    Extract the line containing the given marker from the output.
    [Arguments]    ${output}    ${marker}
    ${lines}=    Split To Lines    ${output}
    FOR    ${line}    IN    @{lines}
        ${found}=    Run Keyword And Return Status    Should Contain    ${line}    ${marker}
        IF    ${found}
            RETURN    ${line}
        END
    END
    Fail    No line containing '${marker}' found in output

Validate Status And Connection
    [Documentation]    Validate status=PASS and connected=1 in the result line.
    [Arguments]    ${result_line}    ${client_name}
    Should Contain    ${result_line}    status=PASS
    ...    msg=${client_name} result status is not PASS: ${result_line}
    Should Contain    ${result_line}    failure_reason=none
    ...    msg=${client_name} failure_reason is not 'none': ${result_line}
    Should Contain    ${result_line}    connected=1
    ...    msg=${client_name} connection was not established: ${result_line}

Validate Counter Pair
    [Documentation]    Validate that two counters in the result line are equal and greater than zero.
    [Arguments]    ${result_line}    ${counter_req}    ${counter_done}    ${counter_name}
    ${req_value}=    Extract Counter Value    ${result_line}    ${counter_req}
    ${done_value}=    Extract Counter Value    ${result_line}    ${counter_done}
    Should Be Equal As Integers    ${req_value}    ${done_value}
    ...    msg=${counter_name} counters mismatch: ${counter_req}=${req_value} vs ${counter_done}=${done_value}
    Should Be True    ${req_value} > 0
    ...    msg=${counter_name} counter ${counter_req} should be greater than 0, got ${req_value}

Extract Counter Value
    [Documentation]    Extract the numeric value of a key=value pair from the result line.
    [Arguments]    ${result_line}    ${counter_name}
    ${matches}=    Get Regexp Matches    ${result_line}    ${counter_name}=(\\d+)    1
    Should Not Be Empty    ${matches}
    ...    msg=Counter '${counter_name}' not found in result line: ${result_line}
    ${value}=    Convert To Integer    ${matches}[0]
    RETURN    ${value}
