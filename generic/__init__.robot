*** Settings ***
Documentation    __init__.robot file from generic level is executed.
...    This file is executed once at the beginning and at the end of every test run if a generic test suite is executed.

# ## Import the TA-Framework setup & teardown .py fiies for Robot Framework. ## #
Library           ${TAF_PATH}/generic/test/setups.py
Library           ${TAF_PATH}/generic/test/teardowns.py
Resource          ${TAF_PATH}/project/test/setups.resource
Resource          ${TAF_PATH}/project/test/teardowns.resource

Suite Setup       Initialize The Test Suite
Suite Teardown    Finalize The Test Suite


*** Keywords ***
Initialize The Test Suite
    [Documentation]    This keyword is executed once at the beginning of
    ...                every test run if a generic test suite is executed.

    Log    __init__.robot file from generic level is executed.
    setups.Set Up Initial Test Suite

Finalize The Test Suite
    [Documentation]    This keyword is executed once at the end of every
    ...                test run if a generic test suite is executed

    Log    __init__.robot file from generic level is executed.
    teardowns.Tear Down Final Test Suite
