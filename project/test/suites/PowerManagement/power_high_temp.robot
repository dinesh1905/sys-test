*** Settings ***
Documentation       Example script to set and get voltage
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_PartiallyHWShutDown_ PartiallyHardwareShutDownWithAbilitySwitchOffSubsystem_HighTemperature
    [Documentation]    Set ambient temperature to > +70C.
    ...     [Expected Result] Traces validation
    ...    Adjust ambient temperature of the chamber to 25°C and observe SCC trace.
    [Tags]    POWER    FID-462078.3451353    TCID-370119    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    71    OFF    1
    Log To Console    check DuT is in High Temperature state
    Verify DLT keyword offline  ${sut.power.DTL_log.High_Temperature_state}
    Verify DLT keyword offline  ${sut.power.DTL_log.High_Temperature_state_COM_Ready}
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_disabled}
    Verify DLT keyword offline  ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer}
    Sleep    10s
    prj.sut.dlt.disconnect.clear.connect dlt
    Set Temperature and wait for the target temp to reach    1    25    OFF    1
    Sleep    20s
    Verify DLT keyword offline    ${sut.power.DTL_log.Normal_Temperature_state}
    Verify DLT keyword offline    ${sut.power.DTL_log.Normal_Temperature_state_COM_Ready}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_enabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_enabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer_ON}

EnvD_SysQual_PowerManagementSubsystem_Temperature_ExitHighTemperatureToNormal Temperature
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temperature of the chamber to 25°C and observe SCC trace.
    ...     [Expected Result] MaaS Blade shall exit High Temperature state at 67.5°C
    ...     to Normal Temperature state with its behavior.
    [Tags]    POWER    FID-462078.3481066,462078.3481068,462078.3481070,462078.3480809,462078.3480810,462078.3451353,462078.3481067,462078.3481069,462078.3480622    TCID-506943    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    67.5    OFF    1
    Sleep    10s
    Log To Console    check DuT is in High Temperature state
    Verify DLT keyword offline  ${sut.power.DTL_log.High_Temperature_state}
    prj.sut.dlt.disconnect.clear.connect dlt
    Set Temperature and wait for the target temp to reach    1    25    OFF    1
    Sleep    10s
    Log To Console    check DuT is in Normal Temperature state
    Verify DLT keyword offline    ${sut.power.DTL_log.Normal_Temperature_state}
    Verify DLT keyword offline    ${sut.power.DLT.MCUStartup.MCUStartup_sequence21}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence1}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence2}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence3}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence4}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence5}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence6}
    Log To Console    Check DTC is Not Logged
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.Nocheckbyte    ${sut.diag.ReportDTCByStatusMask_SoC_OVERTEMP}
    Log To Console    check SendCanSignal Safety Temperature value
    prj.sut.Power.Validate the DLT log temperature    25

EnvD_SysQual_PowerManagementSubsystem_Temperature_ExitCriticalHighTemperatureToHighTemperature
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temperature of the chamber to 25°C and observe SCC trace.
    ...    [Expected Result] MaaS Blade shall exit Critical High Temperature state at 77.5°C with its behavior.
    [Tags]    POWER    FID-462078.3480771,462078.3480622,462078.3480773,462078.3480797,462078.3451353,462078.3480796,462078.3480769,462078.3480810    TCID-506945    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    80.0    OFF    1
    Sleep    10s
    Log To Console    check DuT is in Critical_High_Temperature_state
    Verify DLT keyword offline    ${sut.power.Critical_High_Temperature_state}
    Log To Console    check DuT is in High Temperature state
    Set Temperature and wait for the target temp to reach    1    75    OFF    1
    Sleep    10s
    Verify DLT keyword offline    ${sut.power.DTL_log.High_Temperature_state}
    Log To Console    Check DTC is Logged
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_SoC_OVERTEMP}
    Log To Console    check SendCanSignal Safety Temperature value
    prj.sut.Power.Validate the DLT log temperature    77
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence4}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence2}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence7}

EnvD_SysQual_PowerManagementSubsystem_Temperature_EnterCriticalHighTemperature
    [Documentation]     Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temperature of the chamber to 83°C and observe SCC trace.
    ...     [Expected Result] MaaS Blade shall enter Critical High Temperature state at 80°C with its behavior.
    [Tags]    POWER    FID-462078.3480622,462078.3480771,462078.3480797,462078.3451353,462078.3480810,462078.5029492,462078.3480773,462078.3480796,462078.3480769    TCID-506944    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    83.0    OFF    1
    Sleep    10s
    Log To Console    check DuT is in Critical_High_Temperature_state
    Verify DLT keyword offline    ${sut.power.Critical_High_Temperature_state}
    Log To Console    Check DTC is Logged
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_SoC_OVERTEMP}
    Log To Console    check SendCanSignal Safety Temperature value
    prj.sut.Power.Validate the DLT log temperature    83
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence7}
    Verify DLT keyword offline    ${sut.power.DTL_log.CUP_Reduced}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline    ${sut.power.DTL_log.CAN_ETH_trace_status}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence4}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence2}

EnvD_SysQual_PowerManagementSubsystem_Temperature_EnterHighTemperatureFromNormal Temperature
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temperature of the chamber to 73°C and observe SCC trace.
    ...     [Expected Result] MaaS Blade shall enter High Temperature state at 70°C with its behavior.
    [Tags]    POWER    FID-462078.3481070,462078.3481067,462078.3481069,462078.3481068,462078.3481066,462078.3480622,462078.3480810,462078.2509506    TCID-506942    FULLTEST
    Set Temperature and wait for the target temp to reach    1    25    OFF    1
    Sleep    10s
    Log To Console    check DuT is in Normal Temperature state
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    73    OFF    1
    Sleep    10s
    Verify DLT keyword offline    ${sut.power.DTL_log.High_Temperature_state}
    Log To Console    check SendCanSignal Safety Temperature value
    prj.sut.Power.Validate the DLT log temperature    73
    Verify DLT keyword offline    ${sut.power.DTL_log.CUP_Reduced}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline    ${sut.power.DTL_log.SLEEP_state}
    Verify DLT keyword offline    ${sut.power.DTL_log.CAN_ETH_trace_status}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence4}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence2}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer}
    Log To Console    Check DTC is Logged
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_SoC_OVERTEMP}


EnvD_SysQual_PowerManagementSubsystem_General_TemperatureMonitoring-(high)
    [Documentation]    Press "Startup" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected result] DUT power up. Traces for temperature reading should show up in SCC console.
    ...     Next temperature reading trace only shows up when there is temperature change.
    ...    Adjust ambient temperature to -40C. [Expected result]
    ...    DUT still running. Traces for temperature react accordingly to
    ...    ambient temperature with slightly higher value due to internal heating.
    ...    Adjust ambient temperature to 70C. [Expected result] DUT still running.
    ...     Traces for temperature react accordingly to ambient temperature with slightly higher value due to internal heating.
    ...    Adjust ambient temperature to more than +70°C and read errors in Fault Memory.
    ...     [Expected Result] DUT enter over temperature state. DTC of overtemperature is showing up in Fault Memory.
    ...    Observed temperature value when rising or reducing the ambient temperature.
    ...    [Expected Result] Temperature values show up in SCC trace with minimum resolution of 1°C.
    [Tags]    POWER    FID-3478088,2873327,3478050,3478040,3478052,3478077,1876612,2728317,3478084,3478065    TCID-195841    FULLTEST
    Set Temperature and wait for the target temp to reach    1    25    OFF    1
    Sleep    10s
    Log To Console    check DuT is in Normal Temperature state 
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    70    OFF    1
    prj.sut.Power.check DLT log after setting setting target temperature    70
    Set Temperature and wait for the target temp to reach    1    72    OFF    1
    prj.sut.Power.check DLT log after setting setting target temperature    72
    Verify DLT keyword offline    [SystemManager] Send system temperature to soc [TM_OVER_TEMPERATURE]
    Log To Console    Check DTC is Logged
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_SoC_OVERTEMP}
    prj.sut.Power.check DLT log after setting setting target temperature    72


EnvD_SysQual_PowerManagementSubsystem_Temperature_DetectTemperatureChangePeriodicallyEvery50ms(Normal)
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temeprature of the chamber up or down and observe SCC trace.
    ...     [Expected Result] Temperature traces in SCC contain BLADE_TOP and BLADE_BOT.
    ...     Temperature traces shall update every 50ms when temperature change.
    [Tags]    POWER    FID-462078.3478249    TCID-506940    FULLTEST
    Set Temperature and wait for the target temp to reach    1    25    OFF    1
    Sleep    10s
    Log To Console    check DuT is in Normal Temperature state
    ${SEARCH_STRING}    Set Variable    [Temperature] Sensor temperature (C):  ARX_DTS
    ${expected_ms}    Set Variable    50
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    150s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${Time_Stamp1}    Get the Time log from DTL    ${SEARCH_STRING}
    Log    ${Time_Stamp1}
    prj.sut.Power.Temperature traces check    ${SEARCH_STRING}
    ${Time_Stamp2}    Get the Time log from DTL    ${SEARCH_STRING}
    Log    ${Time_Stamp2}
    ${actual_total_ms}    subtract date from date    ${Time_Stamp2}    ${Time_Stamp1}    Number    False    %Y-%m-%d %H:%M:%S.%f    %Y-%m-%d %H:%M:%S.%f
    Log    ${actual_total_ms}
    IF     ${actual_total_ms} <= ${expected_ms}
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
    ELSE
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
        framework.Set Test Status To Fail    error_type=Power time    info_text=Expected timing be to lees than ${expected_ms}±5 ms, but got ${actual_total_ms} s
    END

EnvD_SysQual_PowerManagementSubsystem_Temperature_TemperatureSensorInputAccuracyRangeof2C
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temeprature of the chamber up or down and observe SCC trace.
    ...     [Expected Result] Temperature sensor in SCC trace produce reading at least +2°C (increment) or -2°C (decrement)
    [Tags]    POWER    FID-462078.3480271    TCID-506939    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    25    OFF    1
    prj.sut.Power.check DLT log after setting setting target temperature    25




#### Cant be executed as it needs power curve toelner to be connected ###
EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-01-Long-term-overvoltage
    [Documentation]    Load and playback E-01 power curve (1 cycle).
    ...     [Expected Result] MaaS Blade remain functional state A during the test.
    ...     MaaS Blade remain functional state A after the test. Power supply to cameras
    ...     and A2B should remain around 8.80V during the test.
    [Tags]    POWER    FID-462078.1039463,462078.1039500,462078.1275442    TCID-431806    FULLTEST

    # Set Temperature and wait for the target temp to reach    1    70    OFF    1
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E-01-Long-term-overvoltage.
    Log    ${sut.power.PowerCurve.E_01_power_curve}
    Load and check Power Curve    ${sut.power.PowerCurve.E_01_power_curve}
    Sleep    1s
    Verify DLT keyword offline    OnEnterRunMode
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Microphone_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-02-Transient-overvoltage-T1
    [Documentation]    Load and playback E-02-T1 power curve (3 cycles).
    ...     [Expected Result] MaaS Blade remain functional state A during the test.
    ...     MaaS Blade remain functional state A after the test. Power supply to cameras and
    ...     A2B should remain around 8.80V during the test.
    [Tags]    POWER    FID-462078.1039463,462078.1039500,462078.1275442    TCID-431805    FULLTEST

    # Set Temperature and wait for the target temp to reach    1    70    OFF    1
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E_02_T1_power_curve.
    FOR    ${Count}    IN RANGE    0   3
        Load and check Power Curve    ${sut.power.PowerCurve.E_02_T2_power_curve}
        Sleep    1s
        Verify DLT keyword offline    OnEnterRunMode
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Microphone_Phantom_disabled}
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-03a-Transient-undervoltage-T1
    [Documentation]    Load and playback E-03a power curve (1 cycles).
    ...     [Expected Result] MaaS Blade remain functional state A during the test.
    ...     MaaS Blade remain functional state A after the test. Power supply to cameras
    ...     and A2B should remain around 8.80V during the test.
    [Tags]    POWER    FID-462078.1039463,462078.1039500,462078.1275442    TCID-431810    FULLTEST

    # Set Temperature and wait for the target temp to reach    1    70    OFF    1
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E_02_T3_power_curve.
    Load and check Power Curve    ${sut.power.PowerCurve.E_03a_power_curve}
    Sleep    1s
    Verify DLT keyword offline    OnEnterRunMode
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Microphone_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-03b-Transient-undervoltage-T1
    [Documentation]    Load and playback E-03b power curve (1 cycles).
    ...     [Expected Result] MaaS Blade may not remain functional state A during the test.
    ...     MaaS Blade is in functional state A after the test. Power supply to cameras and
    ...     A2B may not remain around 8.80V during the test.
    [Tags]    POWER    FID-462078.1039463,462078.1039500,462078.1275442    TCID-431804    FULLTEST

    # Set Temperature and wait for the target temp to reach    1    70    OFF    1
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E_03b_power_curve.
    Load and check Power Curve    ${sut.power.PowerCurve.E_03b_power_curve}
    Sleep    10s
    Verify DLT keyword offline    OnEnterRunMode
    Verify DLT keyword offline    ${sut.power.DLT.Funcational_state.C}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Microphone_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}


