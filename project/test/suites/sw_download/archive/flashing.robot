*** Settings ***
Documentation    Running Weekly Build for auto flashing and entry test.

Resource    ${TAF_PATH}/import.resource
Library    OperatingSystem
Library    Process
Library    String
Library    AppiumLibrary
Library    subprocess
Library    ${TAF_PATH}/project/test/suites/sw_download/archive/auto_flash.py
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
${AURIX_VERSION}    ${AURIX_VERSION}
${SOC_VERSION}    ${SOC_VERSION}
${AURIX_URL}    ${AURIX_URL}
${SOC_URL}    ${SOC_URL}
# ${CDT_URL}    ${CDT_URL}
${PCSUTSERIALNUMBERJENKINS}   ${PCSUTSERIALNUMBERJENKINS}
${KDS_FLASH}    ${KDS_FLASH}
${HSM_ENABLE}    ${HSM_ENABLE}


*** Test Cases ***
Auto Flashing
    [Documentation]    Flashing on SOC and Aurix
    [Tags]    AUTO_FLASHING    SWDOWNLOAD
    # copy files from artifactory
    Set Log Level    DEBUG
    # Setting Global variable for saving download file and cacert
    Set Global Variable    ${cacert}    ${sut.auto_flash.artifactory.bosch_pem1}:${sut.auto_flash.artifactory.bosch_pem3}
    Log To Console    ${cacert}
    Set Global Variable    ${save_as_filename_aurix}    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.aurix_saveasfile}
    Log To Console    ${save_as_filename_aurix}
    Set Global Variable    ${save_as_filename_soc}    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.soc_saveasfile}
    Log To Console    ${save_as_filename_soc}
    # Set Global Variable    ${save_as_filename_cdt}    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.cdt_saveasfile}
    # Log To Console    ${save_as_filename_cdt}
    ${SUTSERIALNUMBER}    prj.sut.load.pcansutserial    ${PCSUTSERIALNUMBERJENKINS}

    # Empty the directory before download
    Empty Directory    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.saveasfile}//soc//
    Empty Directory    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.saveasfile}//aurix//
    # Empty Directory    ${sut.auto_flash.driveC}:${sut.auto_flash.artifactory.pcat_cachefilepath_1}
    # Empty Directory    ${sut.auto_flash.driveC}:${sut.auto_flash.artifactory.pcat_cachefilepath_2}

    # Logging into artifactory and downloading files to local pc location
    artifactory.set credentials    ${sut.auto_flash.artifactory.host1},${sut.auto_flash.artifactory.host2},${sut.auto_flash.artifactory.host3}
    ...    ${sut.auto_flash.artifactory.username},${sut.auto_flash.artifactory.username},${sut.auto_flash.artifactory.username}
    ...    ${sut.auto_flash.artifactory.password1},${sut.auto_flash.artifactory.password2},${sut.auto_flash.artifactory.password3}    ${cacert},${cacert},${cacert}
    artifactory.download file    ${AURIX_URL}    ${save_as_filename_aurix}
    artifactory.download file    ${SOC_URL}    ${save_as_filename_soc}
    # artifactory.download file    ${CDT_URL}    ${save_as_filename_cdt}

    # Unzip the zipped files
    Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}aurix    ${save_as_filename_aurix}

    # Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}cdt    ${save_as_filename_cdt}

    Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}soc    ${save_as_filename_soc}
    ${path}    Get Binary Path    D:${sut.auto_flash.artifactory.saveasfile}soc
    Run Process    7z    x    -y    -o${path}    ${path}${sut.auto_flash.artifactory.LIBMaas_saveasfile}

    #  Start flashing
    log to console    Aurix version :${AURIX_VERSION} and SOC version: ${SOC_VERSION}
    Sleep    5s
    Log To Console    HI! Flashing is Starting. Going to boot mode

    # flashing SOC Sail.
    prj.sut.power cycle
    prj.sut.boot mode on    ${SUTSERIALNUMBER}
    Log To Console    ******Start flashing SOC SAIL******
    ${status}    ${str}    auto_flash.pcat flash SOC Sail
    Log To Console    ${status} and ${str}
    IF    ${status} == ${True}
        Log To Console    SOC SAIL flashing was successful . Start to flash SOC MAIN
    ELSE
        framework.set test status to fail    Failure in SOC SAIL software flash
    END

    # Checking if UFS provisioning flashing is needed.
    IF    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.Provisioning} == ${True}
        Log To Console    Power cycle before starting provisioning
        prj.sut.power cycle
        prj.sut.boot mode on    ${SUTSERIALNUMBER}
        Log To Console    ******Start UFS Provisioning flashing.********
        ${status}    ${str}    auto_flash.pcat flash UFS provinsioning
        ...    ${SUTSERIALNUMBER}
        ...    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.memory_type_ufs}
    ELSE
        Log To Console    UFS Provinsioning flashing is not needed. Skipping it!.
    END

    # # Checking if CDT flashing is needed.
    # IF    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.CDT} == ${True}
    #     Log To Console    Power cycle before starting CDT
    #     prj.sut.power cycle
    #     prj.sut.boot mode on    ${SUTSERIALNUMBER}
    #     Log To Console    *****Start CDT flashing******
    #     ${status}    ${str}    auto_flash.pcat flash CDT
    #     ...    ${SUTSERIALNUMBER}
    #     ...    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.memory_type_ufs}
    #     ...    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.memory_flavorCDT}
    # ELSE
    #     Log To Console    CDT flashing is not needed. Skipping it!.
    # END

    # Power cycling to start SOC Main flashing
    Log To Console    Power cycle before starting SOC Main
    prj.sut.power cycle
    prj.sut.boot mode on    ${SUTSERIALNUMBER}
    Log To Console    *******Start flashing SOC MAIN*******
    ${status}    ${str}    auto_flash.pcat flash SOC Main
    IF    ${status} == ${True}
        Log To Console    SOC Main flashing was successful . Flashing completed
    ELSE
        framework.set test status to fail    Failure in soc Main software flash
    END

    #  switch off debug board and power cycle before aurix flashing
    prj.sut.usb toggle debug board switch Off

    # Close Remote Debug Board program for FlashGUI to start
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_EXIT
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_CLOSE
    prj.sut.power cycle

    Log To Console    FlashGUI Aurix Flash is starting
    # Set Global variable for HSM_Status
    IF    "${HSM_ENABLE}" == "true"
        Set Global Variable    ${Jenkins_HSM_Status}    ${True}
    ELSE
        Set Global Variable    ${Jenkins_HSM_Status}    ${False}
    END

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
        prj.sut.debug connect and toggle off
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
