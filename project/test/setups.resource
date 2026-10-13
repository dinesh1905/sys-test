*** Settings ***
Documentation    Project specific setups module

Library     BuiltIn
Library    OperatingSystem
Resource    ${TAF_PATH}/import.resource


*** Variables ***
${PROGRAMMING_TAG}    "ProgrammingSession"


*** Keywords ***
prj.test.setups.set up initial test suite
    [Documentation]    Specific Suite Setup executed in case of the robot file is the first robot file
    ...                within a multi file test suite or in case of the robot file is the only one within
    ...                the suite (in opposite to the standard Suite Setup that is executed every time
    ...                (= in every robot file of the suite)).

    Log    ====== [${SUITE NAME}] :: (Initial) :: (Suite Setup) :S: Enter ======    console=yes
    # Closing DLT and Putty before running test
    Close DLT
    Close Putty
    Close FlashGUI
    Empty Directory    D:/tmp/LogFile
    bits_platform.output set digital signal value    ClearAll    0
    Sleep     2s
    bits_platform.output set digital signal value    ClearAll    1
    Sleep     2s
    bits_platform.output set digital signal value    ClearAll    0

    Log    ====== [${SUITE NAME}] :: (Initial) :: (Suite Setup) :S: Exit ======    console=yes

prj.test.setups.set up test suite
    [Documentation]    Standard Suite Setup executed executed every time (= in every robot file of the suite).

    Log    ====== [${SUITE NAME}] :: (Suite Setup) :S: Enter ======    console=yes

    Log    ====== [${SUITE NAME}] :: (Suite Setup) :S: Exit ======    console=yes

prj.test.setups.set up test case
    [Documentation]    Specific standard Test Setup executed in every test.

    Log  ====== [${TEST NAME}] :: (Test Setup) :S: Enter ======
    IF    ${PROGRAMMING_TAG} in ${TEST_TAGS}
            ${Status}    Run Keyword And Return Status    prj.sut.diag.SetVehicleSpeedToZero
            IF    "${Status}" == "True"
                Log To Console    Vehicle Speed set to 0
            ELSE
                Log to Console    Test Case Setups is initializing ...
                prj.sut.power cycle
                Sleep    10s
                prj.sut.diag.SetVehicleSpeedToZero
            END
    END
    Log  ====== [${TEST NAME}] :: (Test Setup) :S: Exit ======
