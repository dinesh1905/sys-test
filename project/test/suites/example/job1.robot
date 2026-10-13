*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource
# Library    ${TAF_PATH}/project/framework/log2rqm.py

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
EnvD_SysQual_Video_InputCamera_4camera-HSVLsupport
    [Documentation]    Flashing on SOC and Aurix
    [Tags]    ENTRY    POWER    TCID-246029
    Log To Console    HI JOb1
