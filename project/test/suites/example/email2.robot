*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library    ${TAF_PATH}/project/framework/log2rqm.py
Library    AppiumLibrary


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
${RANGE}    0.1

*** Test Cases ***
# EmailTest_4
#     [Documentation]    Flashing on SOC and Aurix
#     [Tags]    ENTRY    POWER
#     Log To Console    HI EmailTest_1

# EmailTest_5
#     [Documentation]    Flashing on SOC and Aurix
#     [Tags]    AUTO_FLASHING    Critical    DIAGNOSTIC
#     Log To Console    HI EmailTest_2
#     framework.Set Test Status To Fail    HMI    Email 2 failed

# EmailTest_6
#     [Documentation]    Flashing on SOC and Aurix
#     [Tags]    FULLTEST    Critical    DIAGNOSTIC
#     Log To Console    EmailTest_3

# EmailTest_7
#     [Documentation]    Flashing on SOC and Aurix
#     [Tags]    FULLTEST    Critical    SWDOWLOAD
#     Log To Console    EmailTest_
#     Sleep    5s

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_VoltageRangeMonitoring
    [Documentation]    To set and get the power voltage
    [Tags]    POWER    fid-1275380,1275382,1275400,1275417    tcid-195842    FULLTEST

    prj.sut.disconnect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    # prj.sut.can.initandloadconfiguration
    # prj.sut.can.simulation.Start
    # prj.sut.can.simulation.PowerBladeON
    prj.sut.power.add.voltage.to.dictionary.check    Battery    ${15}    


EnvD_SysQual_PowerManagementSubsystem_PowerHandling_VoltageRangeMonitoring_float
    [Documentation]    To set and get the power voltage
    [Tags]    POWER    fid-1275380,1275382,1275400,1275417    tcid-195844    FULLTEST

    prj.sut.disconnect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    # prj.sut.can.initandloadconfiguration
    # prj.sut.can.simulation.Start
    # prj.sut.can.simulation.PowerBladeON
    prj.sut.power.add.voltage.to.dictionary.check    Battery    ${12.9}    

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_VoltageRangeMonitoring_0value
    [Documentation]    To set and get the power voltage
    [Tags]    POWER    fid-1275380,1275382,1275400,1275417    tcid-195844    FULLTEST

    prj.sut.disconnect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    # prj.sut.can.initandloadconfiguration
    # prj.sut.can.simulation.Start
    # prj.sut.can.simulation.PowerBladeON
    prj.sut.power.add.voltage.to.dictionary.check    Battery    ${6}    

EnvD_SysQual_PowerManagementSubsystem_PowerHandling_Tempearture Checking

    [Documentation]    To set and get the power voltage
    [Tags]    POWER    fid-1275380,1275382,1275400,1275417    tcid-195844    FULLTEST

    bits_platform.climate set temperature and start    1    30    ON

    Sleep    30s
    bits_platform.climate read current temperature    1


Testing on keywords
    ${status}    Run Keyword and return status    Test    b
    Log To Console    The status is  : ${status}
    IF    ${status} == True
        Log To Console    Test pass
    ELSE
        Log To Console    fail
        framework.Set Test Status To Fail        diag    not same
    END

*** Keywords ***
Test
    [Arguments]    ${a}
    IF    $a == "a"
        Log To Console    ${a}
    ELSE
        Log To Console    fail
        framework.Set Test Status To Fail        diag    not same
    END
