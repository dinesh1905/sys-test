*** Settings ***
Documentation    Project specific software download keywords
Resource    ${TAF_PATH}/import.resource


*** Keywords ***
prj.sut.can.simulation.PowerBladeON
    [Documentation]    Turn On Power Blade

    ${ack}    bits_platform.Rbs Set Variable Value    1    SYSTEM    PowerBlade::OpStateSignal    1

prj.sut.can.simulation.PowerBladeOFF
    [Documentation]    Turn Off Power Blade

    ${ack}    bits_platform.Rbs Set Variable Value    1    SYSTEM    PowerBlade::OpStateSignal    0

prj.sut.can.simulation.Stop
    [Documentation]    Stop the Canoe simulation
    ${b_ack}    bits_platform.rbs stop measurement    1
    Log To Console    Canoe Simulation is turned OFF
    Sleep    8s

prj.sut.can.simulation.Start
    [Documentation]    Start the Canoe simulation
    ${b_ack}    bits_platform.rbs start measurement    1
    Log To Console    Canoe Simulation is turned On
    Sleep    8s

prj.sut.can.simulation.restart
    [Documentation]    Restarting Canoe simulation
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    Sleep    20s
    prj.sut.can.simulation.PowerBladeON

prj.sut.can.initandloadconfiguration
    [Documentation]    initiate CAN Simulation and load configuration.
    bits_platform.Rbs Close Application    1
    Sleep    20s
    bits_platform.Rbs Initialize Application    1
    Sleep    20s
    bits_platform.Rbs Load Configuration    1    ${sut.can.driveD}:${sut.can.simulationpath1}
    Sleep    20s

prj.sut.can.ShouldContain
    [Documentation]    This function is to compare the actual result with the obtained result
    [Arguments]    ${resp_actual}    ${resp_result}
    ${status}    Run Keyword And Return Status    Should Contain    ${resp_actual}    ${resp_result}
    IF    ${status}
        Log To Console    Comparison is OK
    ELSE
        Log To Console    Comparison is NOT OK.Test Case FAIL!
        framework.Set Test Status To Fail
    END

prj.sut.can.ShouldNotContain
    [Documentation]    This function is to compare the actual result with the obtained result
    [Arguments]    ${resp_actual}    ${resp_result}
    ${status}    Run Keyword And Return Status    Should Contain    ${resp_actual}    ${resp_result}
    IF    Not ${status}
        Log To Console    Comparison is OK
    ELSE
        Log To Console    Comparison is NOT OK.Test Case FAIL!
        framework.Set Test Status To Fail    error_type=POWER
    ...    info_text=Expected ${resp_actual} in the Canoe log file is not the same as ${resp_result} obtained
    END

prj.sut.can.initandloadconfigurationbusload
    [Documentation]    initiate CAN Simulation and load configuration.
    bits_platform.Rbs Close Application    1
    Sleep    20s
    bits_platform.Rbs Initialize Application    1
    Sleep    20s
    bits_platform.Rbs Load Configuration    1    ${sut.can.driveD}:${sut.can.simulationpathbusload}
    Sleep    20s

prj.sut.can.PrintWriteConsole
    [Documentation]    To print text in Write console to a file
    ${logs}    customCanoeLib.Get Write Window Logging
    Create File    D:\\tmp\\CAN_Trace\\Trace1.txt    ${logs}
