
*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library     ${TAF_PATH}/generic/framework/testcase_iterator.py
Library     QConnectBase.ConnectionManager

Metadata    testtype            functional test
Metadata    testarea            sw_flashing
Metadata    requirements        no requirements
Metadata    preconditions       no preconditions
Metadata    actions             flashing SOC sail and Main
Metadata    expectedresults     sw flashing should pass with return value

# Test Automation Framework
Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_PowerHandling_VoltageRangeMonitoring_0value
    [Documentation]    To set and get the power voltage
    [Tags]    TCID-195844    POWER    FID-1275380,1275382,1275400,1275417    FULLTEST

    Log To Console    hey reqid and tcid

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_VoltageRangeMonitoring_0value_2
    [Documentation]    To set and get the power voltage
    [Tags]    TCID-5345421    POWER    FID-1275380,1275382,1275401,1275417    FULLTEST

    Log To Console    hey reqid and tcid

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_VoltageRangeMonitoring_0value_8
    [Documentation]    To set and get the power voltage
    [Tags]    TCID-195    POWER    FID-1275380,1275382,1275400,1275417    FULLTEST

    Set Test Status To Fail    error_type=DIAGNOSIS
    ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
