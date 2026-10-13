*** Settings ***
Documentation    Example script to set and get voltage

Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/framework/log2rqm.py

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


*** Test Cases ***
EnvD_SysQual_Video_InputCamera_4camera-HSVLsupport
    [Documentation]    Flashing on SOC and Aurix
    [Tags]    ENTRY    POWER    TCID-246029
    Log To Console    HI EmailTest_1 ${testbench.process.simulationpath}
    Sleep    5s

EmailTest_2
    [Documentation]    Flashing on SOC and Aurix
    [Tags]    AUTO_FLASHING    Critical    DIAGNOSTIC
    Log To Console    HI EmailTest_2
    framework.Set Test Status To Fail    HMI    Email 2 failed

EmailTest_3
    [Documentation]    Flashing on SOC and Aurix
    [Tags]    FULLTEST    Critical    DIAGNOSTIC
    Log To Console    EmailTest_3


Canoe test
    [Documentation]    check canoe time
    prj.sut.can.simulation.Stop
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0

    bits_platform.Output Set Analog Signal Value    Battery    12

    bits_platform.rbs start measurement    1
    bits_platform.Output Set Analog Signal Value    Ignition    12
    Sleep    2s
    ${Canoe_txt}    Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    ${matches}    String.Get Lines Containing String    ${Canoe_txt}    Signal first received at time
    ${time_2}    String.Get Regexp Matches    ${matches}    \\d+\\.\\d+

    FOR    ${index}    IN    ${time_2}
        ${floatvalue}     Convert To Number    ${index}[0]
        IF    $floatvalue <= 0.5
            Log    The signal Authenticat_MaaS was detected less then 500ms
        ELSE
            framework.Set Test Status To Fail    CAN    The signal Authenticat_MaaS was NOT detected less then 500ms
        END
    END

EnvD_SysQual_Diagnostics_DTC_BOSCH_DISPLAY_NOT_REACHABLE_VO01DTC

    # Send Check DTC command
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_BOSCH_DISPLAY_NOT_REACHABLE_VO01DTC_Resp}


EnvD_SysQual_Diagnostics_DTC_A2B_Connection

    # Send Check DTC command
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_BOSCH_DISPLAY_NOT_REACHABLE_VO01DTC_Resp}