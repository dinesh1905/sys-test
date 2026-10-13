*** Settings ***
Documentation    Project specific software download keywords
Resource    ${TAF_PATH}/import.resource
Library    sequencer.py
Library     QConnectBase.ConnectionManager


*** Variables ***
${CONNECTION_NAME}     TEST_CONN


*** Keywords ***
prj.sut.reliability: Randomize parameters
    [Documentation]    The Wuw Random preconditions are executed at the beginning of the test.

    Log   poweroffon Random preconditions.    console=yes

    # init variable
    Set Local Variable    ${bAck}    ${True}
    Set Local Variable    ${sInfoText}    Found unknown error while executing Wuw Preconditions.

    # Splitting and getting the iteration value to go into sequence.py and getting the current command and respond id.
    ${iteration_string}    Evaluate   '#' in '${TEST_NAME}'
    IF    ${iteration_string}== True
        ${nCount}    Split String    ${TEST_NAME}    separator=#
        Set local variable    ${sIteration}    ${nCount}[1]
        ${iIteration}     Evaluate    int(${sIteration})
        ${scommand}     select current powerofftime    ${iIteration}
        Log To Console    ${scommand}
        IF    ${bAck}
            Set Test Variable     ${sut.reliability.poweroffon.runtimecommand}    ${scommand}
            Log To Console    The power off on wait time is  ${sut.reliability.poweroffon.runtimecommand}s
        END

        # test flow handling
        IF    ${bAck} == False
            framework.Set Test Status To Unknown    InfoText=${sInfoText}
        ELSE
            Log    OK: Poweroffon Random preconditions.    console=yes
        END
    ELSE
        Log To Console    ITERATION NOT STARTED
    END

    RETURN    ${bAck}    ${sIteration}
