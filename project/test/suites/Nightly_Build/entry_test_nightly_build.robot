*** Settings ***
Documentation       Example script to set and get voltage
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource            ${TAF_PATH}/import.resource
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         setups.Set Up Test Suite
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case


*** Test Cases ***
# UPDATED TEST CASE IS BELOW WITH DIFFERENT VERIFICATION METHOD
# EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorSoCPowerSequenceOnQNXConsole
#    [Documentation]    SOC should follow proper startup sequence and shutdown sequence based on traces from QNX console.
#    [Tags]    fid-1406834,1406850,1406853,1408489,1408490    1408499,1408500,1408501,1408502,1756875    tcid-195839    ENTRY
#    Log To Console    Entry Test is starting
#    prj.sut.can.initandloadconfiguration
#    prj.sut.can.simulation.Start
#    prj.sut.can.simulation.PowerBladeON

#    prj.sut.can.simulation.PowerBladeOFF
#    prj.sut.connect.QNX
#    prj.sut.power cycle

#    ${res}=    Verify    conn_name=${CONNECTION_NAME_QNX}
#    ...    search_pattern=Startup done
#    ...    timeout=60

#    # Sleep    10s
#    ${res}=    Verify    conn_name=${CONNECTION_NAME_QNX}
#    ...    send_cmd=cat mnt/Buildinfo.txt
#    ...    search_pattern=VERSION=
#    ...    timeout=20
#    Log To Console    ${res}[0]

#    prj.sut.can.simulation.PowerBladeOFF
#    Sleep    60s

#    ${ack}    ${sResult}=    bits_platform.Rbs Get Signal Value    1    CAN    1
#    ...    OPMM_MAAS    OperatingModeResponse_MaaSBlade
#    IF    ${sResult} == 0
#         prj.sut.toellner off
#         Log to Console    Maas Blade Shutdown Successfully
#    ELSE
#         Log to Console    Maas Blade FAIL to Shutdown Successfully
#         Set Test Status To Fail
#    END

#    ${Status}=    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME_QNX}
#    ...    send_cmd=cat /mnt/Buildinfo.txt
#    ...    search_pattern=.*
#    ...    timeout=10

#    Log To Console    The status of verified step is "${Status}"
#    IF    ${Status} == False
#         Log To Console    QNX Shutdown Successfully.Test Case PASS
#    ELSE
#         Log To Console    QNX Shutdown Sequence Failed
#         framework.Set Test Status To Fail    power    QNX Shutdown Sequence Failed
#    END

# EnvD_SysQual_PowerManagementSubsystem_OperatingStateHandling_MonitorSoCPowerSequenceOnQNXConsole
#     [Documentation]    SOC should follow proper startup sequence and shutdown sequence based on traces from QNX console.
#     [Tags]
#     ...    FID-1406834,1406850,1406853,1408489,1408490,1408499,1408500,1408501,1408502,1756875
#     ...    TCID-195839
#     ...    ENTRY

#     prj.sut.can.initandloadconfiguration
#     prj.sut.toellner off
#     prj.sut.connect.QNX
#     prj.sut.can.simulation.Start
#     prj.sut.toellner on
#     prj.sut.can.simulation.PowerBladeON

#     ${res}    Verify    conn_name=${CONNECTION_NAME_QNX}
#     ...    search_pattern=Startup done
#     ...    timeout=60

#     Sleep    60s
#     ${res}    Verify    conn_name=${CONNECTION_NAME_QNX}
#     ...    send_cmd=cat mnt/Buildinfo.txt
#     ...    search_pattern=VERSION=
#     ...    timeout=20
#     Log To Console    ${res}[0]
#     prj.sut.disconnect.QNX
#     prj.sut.connect.dlt
#     prj.sut.can.simulation.PowerBladeOFF

#     Verify DLT keyword    \\[PowerM] Set PWR_HOLD pin to INACTIVE
#     prj.sut.toellner off
#     Log to Console    Maas Blade Shutdown Successfully
#     Sleep    2s
#     ${Status}=    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME_QNX}
#     ...    send_cmd=cat /mnt/Buildinfo.txt
#     ...    search_pattern=.*
#     ...    timeout=10

#     Log To Console    The status of verified step is "${Status}"
#     IF    ${Status} == False
#         Log To Console    QNX Shutdown Successfully.Test Case PASS
#     ELSE
#         Log To Console    QNX Shutdown Sequence Failed
#         framework.Set Test Status To Fail    power    QNX Shutdown Sequence Failed
#     END

EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeNotWokenByCANSupportPOR
    [Documentation]    MaaS Blade should no wake up by CAN. MaaS Blade support POR.
    ...    Only Power Blade can enable individial blades to be powered up.
    [Tags]    FID-1039453    TCID-195833    ENTRY
    Log To Console    Entry test start
    prj.sut.power cycle

    # Shut down Maas Blade
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    2s
    ${b_ack}    ${s_result}=    bits_platform.Input Get Signal Value    Battery_Current
    Log To Console    Current consumption is ${s_result}
    IF    ${s_result} == 0
        Log To Console    Current shown ${s_result}. Device has been shut down.
    ELSE
        Set Test Status To Fail    Device did not shut down.
    END

    # Sending a CAN Message to check if DUT wakes up.
    ${Status}=    Run Keyword And Return Status
    ...    bits_platform.Rbs Set Variable Value
    ...    1
    ...    SYSTEM
    ...    PowerBlade::OpStateSignal
    ...    1
    Log To Console    ${Status}*******
    IF    ${Status} == True
        ${b_ack}    ${s_result}=    bits_platform.Input Get Signal Value    Battery_Current
        IF    ${s_result} == 0
            Log    The current ${s_result} .Device did not wake up.Test Case PASS    console=yes
            ${b_ack}=    bits_platform.Output Set Analog Signal Value    Battery    12
        ELSE
            Log    FAIL!! Device current is ${s_result} and not 0    console=yes
            framework.Set Test Status To Fail
        END
    ELSE
        Log To Console    FAIL!!! Unable to send CAN Message
        framework.Set Test Status To Fail    power    FAIL!!! Unable to send CAN Message
    END
