*** Settings ***
Documentation    __init__.robot file from the root folder is executed.
...    This file is executed once at the beginning and at the end of every test run.

# ## Import the Bosch testing library for Robot Framework. ## #
Library           RobotFramework_TestsuitesManagement    AS    testsuites
Library           ${TAF_PATH}/generic/framework/framework.py  AS  framework

Suite Setup       Initialize The Test Run
Suite Teardown    Finalize The Test Run


*** Variables ***
# Initialize global configuration dictionaries
# Content is loaded below (load configuration)
${SETUP}   ${EMPTY}
${SUT}   ${EMPTY}
${TESTBENCH}   ${EMPTY}
${FRAMEWORK}   ${EMPTY}
${TEST}   ${EMPTY}



*** Keywords ***
Initialize The Test Run
    [Documentation]    This keyword is executed once at the beginning of every test run.

    # load test bench configuration
    Set local variable  ${config_file}  ${TAF_PATH}/project/testbench/config.jsonp
    framework.load configuration    ${config_file}  ${testbench_configuration}

    # load sut configuration
    Set local variable  ${config_file}  ${TAF_PATH}/project/sut/config.jsonp
    framework.load configuration    ${config_file}  ${sut_configuration}

    # load setup configuration
    Set local variable  ${config_file}  ${TAF_PATH}/project/setup/config.jsonp
    framework.load configuration    ${config_file}  ${setup_configuration}

    # load test configuration
    Set local variable  ${config_file}  ${TAF_PATH}/project/test/config.jsonp
    framework.load configuration    ${config_file}  ${test_configuration}

    # load framework configuration
    Set local variable  ${config_file}  ${TAF_PATH}/project/framework/config.jsonp
    framework.load configuration    ${config_file}  ${framework_configuration}

Finalize The Test Run
    [Documentation]    This keyword is executed once at the end of every test run.

    testsuites.Testsuite Teardown
