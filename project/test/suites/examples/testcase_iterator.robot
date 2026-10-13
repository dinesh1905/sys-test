*** Settings ***
Documentation    Example script to show how to dynamically create test cases.
...              E.g. to create test cases (iterations) for reliabilty tests.

Resource    ${TAF_PATH}/import.resource
Library     ${TAF_PATH}/generic/framework/testcase_iterator.py

Metadata    testtype            example
Metadata    testarea            framework.dynamic_tests
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
Dynamic_Tests
    [Documentation]    Create 10 identical test cases (iterations)
    ...                - using the same 'Test Setup'
    ...                - using the same 'Test Teardown'
    ...                - using the same 'Teststeps'

    testcase_iterator.Add Test Cases    Teststeps    ${11}


*** Keywords ***
Teststeps
    [Documentation]    Define the teststeps used for every test case

    Log To Console    put your code for the first test step here

    Log To Console    put your code for the second test step here

    Log To Console    put your code for the thrid test step herev

    Log To Console    put your code for the fourth test step here
