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
Auto Flashing
    [Documentation]    Test Send DLT
    prj.sut.disconnect.safety
    prj.sut.connect.dlt.safety
    Sleep    10s
    QConnectBase.ConnectionManager.Send Command    ${CONNECTION_NAME_SAFETY}    DLT_CALL_SW_INJECTION 1002 KSSC UTFC 04 00 00 00 02 02 00 01
    QConnectBase.ConnectionManager.Verify    ${CONNECTION_NAME_SAFETY}    Injection Call executed
    prj.sut.disconnect.safety
    Sleep    10s
