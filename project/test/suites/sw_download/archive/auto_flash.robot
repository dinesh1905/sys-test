*** Settings ***
Documentation    Example script to set and get voltage
Metadata    testtype            functional test
Metadata    testarea            sw_flashing
Metadata    requirements        no requirements
Metadata    preconditions       no preconditions
Metadata    actions             flashing SOC sail and Main
Metadata    expectedresults     sw flashing should pass with return value

Library    OperatingSystem
Library    Process
Library    String
Library    AppiumLibrary
Library    subprocess
Resource   ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/sw_download/archive/auto_flash.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library    ${TAF_PATH}/project/test/suites/sw_download/artifactory.py

# Test Automation Framework
Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Variables ***
${SUTSERIALNUMBER}    ${sut.auto_flash.hardware_info.pg1ut078c.SUT1.pcat_serialnumber}


*** Test Cases ***
Auto Flashing
    [Documentation]    Flashing on SOC and Aurix

    # copy files from artifactory
    Set Log Level    DEBUG
    Log To Console    HI

    Set Global Variable    ${cacert}    ${sut.auto_flash.artifactory.bosch_pem1}:${sut.auto_flash.artifactory.bosch_pem3}
    Log To Console    ${cacert}
    Set Global Variable    ${save_as_filename_aurix}    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.aurix_saveasfile}
    Log To Console    ${save_as_filename_aurix}
    Set Global Variable    ${save_as_filename_soc}    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.soc_saveasfile}
    Log To Console    ${save_as_filename_soc}
    Set Global Variable    ${save_as_filename_cdt}    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.cdt_saveasfile}
    Log To Console    ${save_as_filename_cdt}
    Set Global Variable    ${url_aurix}    ${sut.auto_flash.artifactory.url1}:${sut.auto_flash.artifactory.url_aurix}
    Log To Console    ${url_aurix}
    Set Global Variable    ${url_soc}    ${sut.auto_flash.artifactory.url1}:${sut.auto_flash.artifactory.url_soc}
    Log To Console    ${url_soc}
    Set Global Variable    ${url_cdt}    ${sut.auto_flash.artifactory.url1}:${sut.auto_flash.artifactory.url_cdt}
    Log To Console    ${url_cdt}

    # Empty the directory before download
    Empty Directory    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.saveasfile}//soc//
    Empty Directory    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.saveasfile}//aurix//
    Empty Directory    ${sut.auto_flash.drive}:${sut.auto_flash.artifactory.saveasfile}//cdt//

    artifactory.set credentials    ${sut.auto_flash.artifactory.host1},${sut.auto_flash.artifactory.host2},${sut.auto_flash.artifactory.host3}
    ...    ${sut.auto_flash.artifactory.username},${sut.auto_flash.artifactory.username},${sut.auto_flash.artifactory.username}
    ...    ${sut.auto_flash.artifactory.password1},${sut.auto_flash.artifactory.password2},${sut.auto_flash.artifactory.password3}    ${cacert},${cacert},${cacert}
    artifactory.download file    ${url_aurix}    ${save_as_filename_aurix}
    artifactory.download file    ${url_soc}    ${save_as_filename_soc}
    artifactory.download file    ${url_cdt}    ${save_as_filename_cdt}
    Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}aurix    ${save_as_filename_aurix}

    Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}cdt    ${save_as_filename_cdt}

    Run Process    7z    x    -y    -oD:${sut.auto_flash.artifactory.saveasfile}soc    ${save_as_filename_soc}
    ${path}    Get Binary Path    D:${sut.auto_flash.artifactory.saveasfile}soc
    Run Process    7z    x    -y    -o${path}    ${path}${sut.auto_flash.artifactory.LIBMaas_saveasfile}

    # Start flashing
    # log to console    Auric version :${AURIX_VERSION} and SOC version: ${SOC_VERSION}
    Sleep    5s
    Log To Console    HI! Flashing is Starting. Going to boot mode

    # Checking if CDT flashing is needed.
    IF    ${sut.auto_flash.hardware_info.pg9c0012p.SUT2.CDT} == ${True}
        prj.sut.power cycle
        prj.sut.boot mode on    ${SUTSERIALNUMBER}
        Log To Console    *****Start CDT flashing******
        ${status}    ${str}    auto_flash.pcat flash CDT
        ...    ${SUTSERIALNUMBER}
        ...    ${sut.auto_flash.hardware_info.pg9c0012p.SUT2.memory_type_ufs}
        ...    ${sut.auto_flash.hardware_info.pg9c0012p.SUT2.memory_flavorCDT}
    ELSE
        Log To Console    CDT flashing is not needed. Skipping it!.
    END

    # Checking if UFS provisioning flashing is needed.
    IF    ${sut.auto_flash.hardware_info.pg9c0012p.SUT2.Provisioning} == ${True}
        prj.sut.power cycle
        prj.sut.boot mode on    ${SUTSERIALNUMBER}
        Log To Console    ******Start UFS Provinsioning flashing.********
        ${status}    ${str}    auto_flash.pcat flash UFS provinsioning
        ...    ${SUTSERIALNUMBER}
        ...    ${sut.auto_flash.hardware_info.pg9c0012p.SUT2.memory_type_ufs}
    ELSE
        Log To Console    UFS Provinsioning flashing is not needed. Skipping it!.
    END

    # flashing SOC Sail.
    prj.sut.power cycle
    prj.sut.boot mode on    ${SUTSERIALNUMBER}
    Log To Console    ******Start flashing SOC SAIL******
    ${status}    ${str}    auto_flash.pcat flash SOC Sail
    Log To Console    ${status} and ${str}
    IF    ${status} == ${True}
        Log To Console    SOC SAIL flashing was susccesfull . start to flash SOC MAIN
    ELSE
        framework.set test status to fail    Failure in soc sail software flash
    END

    # Power cycling to start SOC Main flashing
    prj.sut.power cycle
    prj.sut.boot mode on    ${SUTSERIALNUMBER}
    Log To Console    *******Start flashing SOC MAIN*******
    ${status}    ${str}    auto_flash.pcat flash SOC Main
    IF    ${status} == ${True}
        Log To Console    SOC Main flashing was susccesfull . Flashing completed
    ELSE
        framework.set test status to fail    Failure in soc Main software flash
    END

    # switch off debug board and power cycle before aurix flashing
    prj.sut.usb toggle debug board switch Off
    sleep    10s
    prj.sut.power cycle
    sleep    10s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_EXIT
    Log To Console    *******Start AURIX Flashing*******
    ${status}    auto_flash_flashgui.flash gui flash    update    ${sut.auto_flash.flashgui.flashgui_COMport}
    ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
    ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}

    IF    ${status} == ${True}
        Log To Console    MCU flashing was susccesfull . Flashing completed
    ELSE
        framework.set test status to fail    Failure in MCU flash.
    END


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
