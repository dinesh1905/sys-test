*** Settings ***
Documentation    Project specific software download keywords
Resource    ${TAF_PATH}/import.resource
Library    OperatingSystem
Library    Process
Library    String
Library    AppiumLibrary
Library    subprocess
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui_debug.py
Library    ${TAF_PATH}/project/test/suites/sw_download/artifactory.py


*** Keywords ***
prj.sut.safety.precondition
    [Documentation]    Precondition before starting safety test.
    bits_platform.System Connect Device    Gen5_DebugBoard_1
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC Control
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=DSP/AVB-C Control
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=CPU Control
    # Use Gen-5.6 to toggle H1008 to ON
    bits_platform.output set digital signal value    H1008    1
    prj.sut.can.simulation.Stop

prj.sut.safety.postcondition
    [Documentation]    Precondition after finishing safety test.

    # Use Gen-5.6 to toggle H1008 to OFF
    bits_platform.output set digital signal value    H1008    0
    Log To Console    Setting Debug board pin H1008 to OFF
    prj.sut.can.simulation.start
    prj.sut.power cycle

prj.sut.safety.wakeup
    [Documentation]    Precondition before starting injection
    prj.sut.connect.dlt.safety
    ${pattern_list}=    Create List    CERBERUS APPLICATION STARTED
    ${pattern_length}=    Get Length    ${pattern_list}
    Log To Console    ${pattern_length}

    # prj.sut.power cycle
    prj.sut.power off
    prj.sut.power on

    FOR    ${index}    IN RANGE    0    ${pattern_length}
        Log To Console    Now Searching for the keyword : ${pattern_list[${index}]}
        ${res}=    Verify    conn_name=${CONNECTION_NAME_SAFETY}
        ...    search_pattern=${pattern_list[${index}]}
        # ...    timeout=5
        Log To Console    MATCH FOUND for : ${pattern_list[${index}]}
    END
    Sleep    5s
    Log To Console    Maas Blade wakeup successfully.Begin Safety Injection Test

prj.sut.safety.setUTFmode
    [Documentation]    Precondition before sending safety command
    Log To Console    UTF Mode command injection start
    QConnectBase.ConnectionManager.Verify    ${CONNECTION_NAME_SAFETY}    ${sut.safety.SetUTFMode_resp}    send_cmd=${sut.safety.SetUTFMode}
    ...    timeout=7
    Log To Console    UTF Mode command successfully injected
    Sleep    5s

prj.sut.safety.injectandverify.withoutreset
    [Documentation]    to send injection command and verify the injection status
    [Arguments]    ${safety_command}

    ${pattern_list}=    Create List    UTF injection data processed sucessfully!
    ...    FIT_Inject_Fault
    ...    TEST_OK

    ${pattern_length}=    Get Length    ${pattern_list}
    Log To Console    Injecting ${safety_command} command
    ${bAck}=    Set Variable    ${True}

    # Doing a 3 times loops incase there is no reply from DUT
    FOR    ${counter}    IN RANGE    0    3
        QConnectBase.ConnectionManager.Send Command    ${CONNECTION_NAME_SAFETY}    ${safety_command}

        FOR    ${index}    IN RANGE    0    ${pattern_length}
            Log To Console    Now Searching for the keyword : ${pattern_list[${index}]}
            ${Match_result}=    Run Keyword And Return Status        Verify    conn_name=${CONNECTION_NAME_SAFETY}
            ...    search_pattern=${pattern_list[${index}]}    timeout=7
            IF    "${Match_result}" == "True"
                Log To Console    MATCH FOUND for : ${pattern_list[${index}]}
                ${bAck}=    Set Variable    ${True}
            ELSE
                ${bAck}=    Set Variable    ${False}
                Set Global Variable    ${CURRENT_PATTERN}    ${pattern_list[${index}]}
                BREAK
            END
        END
        IF    ${bAck} == ${False}
            Log To Console    Unable to find ${CURRENT_PATTERN}. Repeating injection again!.
        ELSE
            Log To Console    Test case found the pattern. Now check for reset!.
            Log To Console    Now verify there is NO reset after injection
            # to verify NO reset happens after injection
            ${Result}=    Run Keyword And Return Status    Verify    ${CONNECTION_NAME_SAFETY}    ${sut.safety.Cerberus}
            ...    timeout=7
            Log To Console    The reset status is ${Result}
            IF    "${Result}" == "False"
              # Cerberus keyword is NOT found. Reset does not happen after injection
              Log To Console    NO Reset occured after injection.OK!
              ${Status}=    Set Variable    ${True}
              BREAK
            ELSE
              Log To Console    Reset occurs after injection. Try Again!!
              ${Status}=    Set Variable    ${False}
              Set Global Variable    ${CURRENT_PATTERN}    ${sut.safety.Cerberus}
            END
        END
    END
    IF    ${bAck} == ${False}
          framework.Set Test Status To Fail    error_type=Safety    info_text=Fail due to ${CURRENT_PATTERN} could not be found after injecting reset safety command
    ELSE IF    ${Status} == ${False}
          framework.Set Test Status To Fail    error_type=Safety    info_text=Fail due to ${CURRENT_PATTERN} is found after injecting reset safety command
    ELSE
          Log To Console    Test case Pass!.
    END


prj.sut.safety.injectandverify.withreset.withresponse
    [Documentation]    to send injection command and verify the injection status
    [Arguments]    ${safety_command}

    ${pattern_list}=    Create List    UTF injection data processed sucessfully!
    ...    FIT_Inject_Fault
    ...    TEST_OK

    ${pattern_length}=    Get Length    ${pattern_list}
    Log To Console    Injecting ${safety_command} command
    ${bAck}=    Set Variable    ${True}

    # Doing a 3 times loops incase there is no reply from DUT
    FOR    ${counter}    IN RANGE    0    3
        QConnectBase.ConnectionManager.Send Command    ${CONNECTION_NAME_SAFETY}    ${safety_command}

        FOR    ${index}    IN RANGE    0    ${pattern_length}
            Log To Console    Now Searching for the keyword : ${pattern_list[${index}]}
            ${Match_result}=    Run Keyword And Return Status        Verify    conn_name=${CONNECTION_NAME_SAFETY}
            ...    search_pattern=${pattern_list[${index}]}    timeout=7
            Set Global Variable    ${CURRENT_PATTERN}    ${pattern_list[${index}]}
            IF    "${Match_result}" == "True"
                Log To Console    MATCH FOUND for : ${pattern_list[${index}]}
                ${bAck}=    Set Variable    ${True}
            ELSE
                ${bAck}=    Set Variable    ${False}
                BREAK
            END
        END
        IF    ${bAck} == ${False}
            Log To Console    Unable to find the pattern. Repeating injection again!.
        ELSE
            Log To Console    Test case found the pattern. Now check for reset!.
            Log To Console    Now verify there is reset after injection
            # to verify reset happens after injection
            ${Result}=    Run Keyword And Return Status    Verify    ${CONNECTION_NAME_SAFETY}    ${sut.safety.Cerberus}
            ...    timeout=7
            Log To Console    The reset status is ${Result}
            IF    "${Result}" == "True"
              # Cerberus keyword is found. Reset happened after injection
              Log To Console    Reset occured after injection.OK!
              ${bAck}=    Set Variable    ${True}
              BREAK
            ELSE
              Log To Console    No reset occurs after injection. Try Again!!
              ${bAck}=    Set Variable    ${False}
            END
        END
    END
    IF    ${bAck} == ${False}
          framework.Set Test Status To Fail    error_type=Safety    info_text=Fail due to NO reset detected after injecting reset safety command
    ELSE
          Log To Console    Test case Pass!.
    END

prj.sut.safety.injectandverify.withreset.withoutresponse
    [Documentation]    to send injection command and verify the injection status
    [Arguments]    ${safety_command}

    Log To Console    Injecting ${safety_command} command and verify reset happens
    ${bAck}=    Set Variable    ${True}
    # Doing a 2 times loops incase there is no reply from DUT
    FOR    ${counter}    IN RANGE    0    3
        QConnectBase.ConnectionManager.Send Command    ${CONNECTION_NAME_SAFETY}    ${safety_command}

        # to verify reset happens after injection
        ${Result}=    Run Keyword And Return Status    Verify    ${CONNECTION_NAME_SAFETY}    ${sut.safety.Cerberus}
        ...    timeout=7
        Log To Console    The reset status is ${Result}
        IF    "${Result}" == "True"
          # Cerberus keyword is found. Reset happened after injection
          Log To Console    Reset occured after injection.OK!
          ${bAck}=    Set Variable    ${True}
          BREAK
        ELSE
          Log To Console    No reset occurs after injection!!
          ${bAck}=    Set Variable    ${False}
        END
    END
    IF    ${bAck} == ${False}
        framework.Set Test Status To Fail    error_type=Safety    info_text=Fail due to NO reset detected after injecting reset safety command
    ELSE
        Log To Console    Test case Pass!.
    END

Debug.Aurix.Flashing
    [Documentation]    Flashing Aurix Debug Version
    [Tags]    AUTO_FLASHING    SWDOWNLOAD
    [Arguments]    ${AURIXDEBUG_VERSION}    ${AURIXDEBUG_URL}    ${KDS_FLASH}    ${FOLDER_NAME}
    # copy files from artifactory
    Set Log Level    DEBUG
    # Setting Global variable for saving download file and cacert
    Set Global Variable    ${cacert}    ${sut.auto_flash.artifactory.bosch_pem1}:${sut.auto_flash.artifactory.bosch_pem3}
    Log To Console    ${cacert}
    Set Global Variable    ${save_as_filename_aurixdebug}    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.aurixdebug_saveasfile}
    Log To Console    Saving file into ${save_as_filename_aurixdebug}

    # Empty the directory before download
    Empty Directory    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.saveasfile}//aurixdebug//

    # Logging into artifactory and downloading files to local pc location
    artifactory.set credentials    ${sut.auto_flash.artifactory.host1},${sut.auto_flash.artifactory.host2},${sut.auto_flash.artifactory.host3}
    ...    ${sut.auto_flash.artifactory.username},${sut.auto_flash.artifactory.username},${sut.auto_flash.artifactory.username}
    ...    ${sut.auto_flash.artifactory.password1},${sut.auto_flash.artifactory.password2},${sut.auto_flash.artifactory.password3}    ${cacert},${cacert},${cacert}
    artifactory.download file    ${AURIXDEBUG_URL}    ${save_as_filename_aurixdebug}

    # Unzip the zipped files
    Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}aurixdebug    ${save_as_filename_aurixdebug}

    #  Start flashing
    log to console    Flashing Aurix version :${AURIXDEBUG_VERSION} for Safety Test
    Sleep    5s
    Log To Console    Hi! Flashing Aurix Debug is Starting.
    IF    "${KDS_FLASH}" == "true"
               ${status}    auto_flash_flashgui_debug.Flash Gui Flash Debug    virgin    ${sut.auto_flash.flashgui.flashgui_COMport}
        ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
        ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}
        ...    ${FOLDER_NAME}    ${sut.auto_flash.flashgui.flashgui_program_ucb}
    ELSE
               ${status}    auto_flash_flashgui_debug.Flash Gui Flash Debug   update    ${sut.auto_flash.flashgui.flashgui_COMport}
        ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
        ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}
        ...    ${FOLDER_NAME}    ${sut.auto_flash.flashgui.flashgui_program_ucb}
    END

    IF    ${status}
        Log To Console    MCU flashing was successful . Flashing completed.Now Power cycle to apply changes
        bits_platform.Output Set Analog Signal Value    Battery    0
        Sleep    2s
        bits_platform.Output Set Analog Signal Value    Battery    12
    ELSE
        framework.set test status to fail    Failure in MCU flash
    END
    Log To Console    Flashing process ends

Sleep.10s
    [Documentation]    Pause for 10s
    Sleep    10s

prj.sut.safety.injectandverify.withreset.withoutresponse(continousreset)
    [Documentation]    to send injection command and verify the injection status
    [Arguments]    ${safety_command}

    Log To Console    Injecting ${safety_command} command and verify reset happens
    # Doing a 10 times loops to check continous reset
    FOR    ${counter}    IN RANGE    0    10
        Log to Console     Attempt ${counter}
        QConnectBase.ConnectionManager.Send Command    ${CONNECTION_NAME_SAFETY}    ${safety_command}

        # to verify reset happens after injection
        ${Result}=    Run Keyword And Return Status    Verify    ${CONNECTION_NAME_SAFETY}    ${sut.safety.Cerberus}
        ...    timeout=7
        Log To Console    The reset status is ${Result}
        IF    "${Result}" == "True"
          # Cerberus keyword is found. Reset happened after injection
          Log To Console    Reset no ${counter} occured after injection.OK!
        ELSE
          framework.Set Test Status To Fail    error_type=Safety    info_text=Fail due to NO reset detected after injecting reset safety command
        END
    END
