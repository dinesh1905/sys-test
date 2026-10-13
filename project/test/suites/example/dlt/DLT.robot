*** Settings ***
Documentation       Example script to set and get voltage
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource    ${TAF_PATH}/import.resource
Library     QConnectBase.ConnectionManager

Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Variables ***
${CONNECTION_NAME}     TEST_CONN


*** Test Cases ***
Test DLT Connection

    [Documentation]    Test Case 1
    [Tags]    PowerModule
    # prj.sut.can.simulation.PowerBladeON
    prj.sut.connect.dlt
    prj.sut.power cycle

    # ${res}=     verify    conn_name=${CONNECTION_NAME}
    # ...                   timeout=30
    # ...                   search_pattern=PRE_RUN

    ${pattern_list}=      Create List      ECU current operational mode ID: 4      OnDriveUp
    ...    PowerM_CssPowerUp_InitFusaWdg      PowerM_CssPowerUp_SwitchOnMainSupplies
    ...    POWERM_SM_DRIVE_POWER_UP_COMRDY_STATE    OnDriveUpComReady    PowerM_CssPowerUp_MiscSupplies

    ${pattern_length}=    Get Length    ${pattern_list}

    FOR    ${index}    IN RANGE    0    ${pattern_length}
        Log To Console    ${pattern_list[${index}]}
        ${res}=     Verify        conn_name=${CONNECTION_NAME}
        ...                       search_pattern=${pattern_list[${index}]}
        ...                       timeout=20
        Log To Console    ${res}
    END

    # log to console     ${res}
    # Disconnect.
    prj.sut.disconnect.dlt

Testdebug
    [Documentation]    avail
    # Close Remote Debug Board program for FlashGUI to start
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_EXIT
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_CLOSE
    # ${ack}    ${result}    bits_platform.System Get Connect State Device    Gen5_DebugBoard_1
    # Log To Console    The Debug board is : ${result}

    bits_platform.System Connect Device    Gen5_DebugBoard_1
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
    Sleep    1s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC Control
    Sleep    1s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=DSP/AVB-C Control
    Sleep    1s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=CPU Control

Set voltage to power supply
    [Documentation]    Set voltage to power supply
    ${b_ack}=    bits_platform.Output Set Analog Signal Value    Battery    12
    Log To Console    ${b_ack}
