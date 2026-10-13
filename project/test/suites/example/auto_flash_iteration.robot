*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library     ${TAF_PATH}/generic/framework/testcase_iterator.py

Metadata    testtype            functional test
Metadata    testarea            sw_flashing
Metadata    requirements        no requirements
Metadata    preconditions       no preconditions
Metadata    actions             flashing SOC sail and Main
Metadata    expectedresults     sw flashing should pass with return value

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
${CDT_URL}    ${CDT_URL}
${PCSUTSERIALNUMBER}   ${PCSUTSERIALNUMBER}


*** Test Cases ***
Auto Flashing
    [Documentation]    Flashing on SOC and Aurix

    testcase_iterator.Add Test Cases    Teststeps    ${sut.auto_flash.iteration}


*** Keywords ***
Teststeps
    [Documentation]    Flashing on SOC and Aurix multiple times.
    bits_platform.System Connect Device    Gen5_DebugBoard_1
    Sleep    5s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC

    ${SUTSERIALNUMBER}    prj.sut.load.pcansutserial    ${PCSUTSERIALNUMBER}
    prj.sut.usb toggle debug board switch On
    prj.sut.boot mode on    ${SUTSERIALNUMBER}

    # Start flashing
    log to console    Auric version :${AURIX_VERSION} and SOC version: ${SOC_VERSION}
    Sleep    5s
    Log To Console    HI! Flashing is Starting. Going to boot mode

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

    # Checking if UFS provisioning flashing is needed.
    IF    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.Provisioning} == ${True}
        prj.sut.power cycle
        prj.sut.boot mode on    ${SUTSERIALNUMBER}
        Log To Console    ******Start UFS Provinsioning flashing.********
        ${status}    ${str}    auto_flash.pcat flash UFS provinsioning
        ...    ${SUTSERIALNUMBER}
        ...    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.memory_type_ufs}
    ELSE
        Log To Console    UFS Provinsioning flashing is not needed. Skipping it!.
    END

    # Checking if CDT flashing is needed.
    IF    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.CDT} == ${True}
        prj.sut.power cycle
        prj.sut.boot mode on    ${SUTSERIALNUMBER}
        Log To Console    *****Start CDT flashing******
        ${status}    ${str}    auto_flash.pcat flash CDT
        ...    ${SUTSERIALNUMBER}
        ...    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.memory_type_ufs}
        ...    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.memory_flavorCDT}
    ELSE
        Log To Console    CDT flashing is not needed. Skipping it!.
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
        framework.set test status to fail    Failure in MCU flash
    END
