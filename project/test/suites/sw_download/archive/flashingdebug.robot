*** Settings ***
Documentation    Running Weekly Build for auto flashing and entry test.

Resource    ${TAF_PATH}/import.resource
Library    OperatingSystem
Library    Process
Library    String
Library    AppiumLibrary
Library    subprocess
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library    ${TAF_PATH}/project/test/suites/sw_download/artifactory.py

Metadata    testtype            example
Metadata    testarea            power
Metadata    requirements        no requirements
Metadata    preconditions       no preconditions
Metadata    actions             no actions
Metadata    expectedresults     no expectedresults

# Test Automation Framework
Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Variables ***
${AURIXDEBUG_VERSION}    ${AURIXDEBUG_VERSION}
${AURIXDEBUG_URL}    ${AURIXDEBUG_URL}


*** Test Cases ***
Debug Aurix Flashing
    [Documentation]    Flashing Aurix Debug Version
    [Tags]    AUTO_FLASHING    SWDOWNLOAD
    # copy files from artifactory
    Set Log Level    DEBUG
    # Setting Global variable for saving download file and cacert
    Set Global Variable    ${cacert}    ${sut.auto_flash.artifactory.bosch_pem1}:${sut.auto_flash.artifactory.bosch_pem3}
    Log To Console    ${cacert}
    Set Global Variable    ${save_as_filename_aurixdebug}    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.aurixdebug_saveasfile}
    Log To Console    Saving file into ${save_as_filename_aurixdebug}

    # Empty the directory before download
    Empty Directory    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.saveasfile}//aurixdebug//
    # Empty Directory    ${sut.auto_flash.driveC}:${sut.auto_flash.artifactory.pcat_cachefilepath_1}
    # Empty Directory    ${sut.auto_flash.driveC}:${sut.auto_flash.artifactory.pcat_cachefilepath_2}

    # Logging into artifactory and downloading files to local pc location
    artifactory.set credentials    ${sut.auto_flash.artifactory.host1},${sut.auto_flash.artifactory.host2},${sut.auto_flash.artifactory.host3}
    ...    ${sut.auto_flash.artifactory.username},${sut.auto_flash.artifactory.username},${sut.auto_flash.artifactory.username}
    ...    ${sut.auto_flash.artifactory.password1},${sut.auto_flash.artifactory.password2},${sut.auto_flash.artifactory.password3}    ${cacert},${cacert},${cacert}
    artifactory.download file    ${AURIXDEBUG_URL}    ${save_as_filename_aurixdebug}

    # Unzip the zipped files
    # Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}aurixdebug    ${save_as_filename_aurixdebug}
    Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}aurixdebug/HEX_FILES    ${save_as_filename_aurixdebug}

    #  Start flashing
    log to console    Flashing Aurix version :${AURIXDEBUG_VERSION} for Safety Test
    Sleep    5s
    Log To Console    Hi! Flashing is Starting. Going to boot mode
    IF    "${KDS_FLASH}" == "true"
               ${status}    auto_flash_flashgui.flash gui flash    virgin    ${sut.auto_flash.flashgui.flashgui_COMport}
        ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
        ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}
        ...    ${sut.auto_flash.flashgui.flashgui_program_ucb}
    ELSE
               ${status}    auto_flash_flashgui.flash gui flash    update    ${sut.auto_flash.flashgui.flashgui_COMport}
        ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
        ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}
        ...    ${sut.auto_flash.flashgui.flashgui_program_ucb}
    END

    IF    ${status} == ${True}
        Log To Console    MCU flashing was successful . Flashing completed
    ELSE
        framework.set test status to fail    Failure in MCU flash
    END
    Log To Console    Flashing process ends


*** Keywords ***
Get Binary Path
    [Documentation]    Getting the binary part
    [Arguments]    ${base_path}
    ${listing_path}    OperatingSystem.List Directory    ${base_path}
    IF    len(${listing_path}) == 2
        ${target_path}    Set Variable    ${base_path}/${listing_path[0]}
    ELSE
        ${target_path}    Set Variable    ${base_path}
    END
    RETURN  ${target_path}
