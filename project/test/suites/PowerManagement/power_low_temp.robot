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
EnvD_SysQual_PowerManagementSubsystem_Temperature_EnterLowTemperatureFromNormal Temperature
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temperature of the chamber to -10°C and observe SCC trace.
    ...     [Expected Result] MaaS Blade shall enter Low Temperature state at -2.5°C with its behavior.
    [Tags]    POWER    FID-462078.3480810,462078.3481043,462078.3480622,462078.3481039,462078.3481042    TCID-506937    FULLTEST
    Set Temperature and wait for the target temp to reach    1    25    OFF    1
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    -10    OFF    1
    Verify DLT keyword offline    ${sut.power.DTL_log.Low_Temperature_state}
    Verify DLT keyword offline    ${sut.power.DTL_log.CUP_Reduced}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline    ${sut.power.DTL_log.SLEEP_state}
    Verify DLT keyword offline    ${sut.power.DTL_log.CAN_ETH_trace_status}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence4}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence2}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer}
    prj.sut.Power.Validate the DLT log temperature    -10

EnvD_SysQual_PowerManagementSubsystem_Temperature_ExitLowTemperatureToNormal Temperature
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temperature of the chamber to 25°C and observe SCC trace.
    ...    [Expected Result] MaaS Blade shall enter Normal Temperature state at 0.0°C with its behavior.
    [Tags]    POWER    FID-462078.3480622,462078.3480809,462078.3481042,462078.3481043,462078.3481039,462078.3480810    TCID-506935    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    -2.5    OFF    1
    Sleep    10s
    Verify DLT keyword offline    ${sut.power.DTL_log.Low_Temperature_state}
    Set Temperature and wait for the target temp to reach    1    0    OFF    1
    Sleep    10s
    Verify DLT keyword offline    ${sut.power.DTL_log.Normal_Temperature_state}
    Log To Console    MaaS Blade shall exit Low Temperature and enter Normal Temperature state at 0.0°C with its behavior.
    Sleep    10s
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence1}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence2}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence3}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence4}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence5}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence6}
    Verify DLT keyword offline    ${sut.power.DTL_log.CAN_ETH_trace_status}

EnvD_SysQual_PowerManagementSubsystem_Temperature_ExitCriticalLowTemperatureToLowTemperature
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temperature of the chamber to 25°C and observe SCC trace.
    ...     [Expected Result] MaaS Blade shall exit Critical Low Temperature state at -37.5°C to Low Temperature State with its behavior.
    [Tags]    POWER    FID-462078.3480810,462078.3481074,462078.3481072,462078.3481073    TCID-506934    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    -40    OFF    1
    Sleep    900s
    Log To Console    MaaS Blade shall enter Critical Low Temperature state at -40°C with its behavior.
    Verify DLT keyword offline    ${sut.power.DTL_log.Critical_Low_Temperature_state}
    prj.sut.Power.Validate the DLT log temperature    -40
    Log To Console    SoC CPU throttling by reducing CPU and GPU execution load in SoC.
    Set Temperature and wait for the target temp to reach    1    0    OFF    1
    Sleep    10s
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence1}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence2}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence3}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence4}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence5}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence6}
    Verify DLT keyword offline    ${sut.power.DTL_log.CAN_ETH_trace_status}

EnvD_SysQual_PowerManagementSubsystem_Temperature_EnterCriticalLowTemperature
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temperature of the chamber to -45°C and observe SCC trace.
    ...     [Expected Result] MaaS Blade shall enter Critical Low Temperature state at -40°C with its behavior.
    [Tags]    POWER    FID-462078.3480810,462078.3481072,462078.3481073,462078.3481074    TCID-506936    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    -40    OFF    1
    Sleep    10s
    Log To Console    MaaS Blade shall enter Critical Low Temperature state at -40°C with its behavior.
    Verify DLT keyword offline    ${sut.power.DTL_log.Critical_Low_Temperature_state}
    prj.sut.Power.Validate the DLT log temperature    -40

    Log To Console    SoC CPU throttling by reducing CPU and GPU execution load in SoC.
    Verify DLT keyword offline    ${sut.power.DTL_log.CUP_Reduced}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline    ${sut.power.DTL_log.SLEEP_state}
    Verify DLT keyword offline    ${sut.power.DTL_log.CAN_ETH_trace_status}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence4}
    Verify DLT keyword offline    ${sut.power.DTL_log.MCURestart.MCURestart_sequence2}
    Verify DLT keyword offline    ${sut.power.DTL_log.Serializer_DeSerializer}

EnvD_SysQual_PowerManagementSubsystem_General_TemperatureMonitoring-(low)
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
    [Tags]    POWER    FID-462078.3478048,462078.3478051,462078.3478040    TCID-195841    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    -40    OFF    1
    prj.sut.Power.check DLT log after setting setting target temperature    -40
    Verify DLT keyword offline    [SystemManager] Send system temperature to soc [TM_OVER_TEMPERATURE]
    prj.sut.Power.check DLT log after setting setting target temperature    -40

EnvD_SysQual_PowerManagementSubsystem_Temperature_DetectTemperatureForMicrocontrollerSoCVideoMemoryETHSwitch
    [Documentation]     Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temeprature of the chamber up or down and observe SCC trace.
    ...     [Expected Result] Temperature traces in SCC contain correspondent sensors reading.
    [Tags]    POWER    FID-462078.506941    TCID-506941    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    27    OFF    1
    prj.sut.Power.check DLT log after setting setting target temperature    27

EnvD_SysQual_PowerManagementSubsystem_Temperature_DetectExternalSensorTemperatureChangePeriodicallyEvery50ms(normal)
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Adjust ambient temeprature of the chamber up or down and observe SCC trace.
    ...     [Expected Result] Temperature traces in SCC contain internal sensors and external sensors.
    ...     Temperature traces shall update every 50ms when temperature change
    [Tags]    POWER    FID-462078.3478248    TCID-506938    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    13.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Set Temperature and wait for the target temp to reach    1    27    OFF    1
    prj.sut.validate overall temperature interval

#### cant execute from here as they need power curve toelners
EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-02-Transient-overvoltage-T2
    [Documentation]    Load and playback E-02-T2 power curve (3 cycles).
    ...     [Expected Result] MaaS Blade remain functional state A during the test.
    ...     MaaS Blade remain functional state A after the test. Power supply to cameras
    ...     and A2B should remain around 8.80V during the test.
    [Tags]    POWER    FID-462078.1039463,462078.1039500,462078.1275442    TCID-431808    FULLTEST

    # Set Temperature and wait for the target temp to reach    1    -40    OFF    1
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E_02_T2_power_curve.
    FOR    ${Count}    IN RANGE    0   3
        Load and check Power Curve    ${sut.power.PowerCurve.E_02_T2_power_curve}
        Sleep    1s
        Verify DLT keyword offline    OnEnterRunMode
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Microphone_Phantom_disabled}
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-03a-Transient-undervoltage-T2
    [Documentation]    Load and playback E-03a power curve (1 cycles).
    ...     [Expected Result] MaaS Blade remain functional state A during the test.
    ...     MaaS Blade remain functional state A after the test. Power supply to cameras
    ...     and A2B should remain around 8.80V during the test.
    [Tags]    POWER    FID-462078.1039463,462078.1039500,462078.1275442    TCID-431809    FULLTEST

    # Set Temperature and wait for the target temp to reach    1    -40    OFF    1
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E_03a_power_curve.
    Load and check Power Curve    ${sut.power.PowerCurve.E_03a_power_curve}
    Sleep    1s
    Verify DLT keyword offline    OnEnterRunMode
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Microphone_Phantom_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
    

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-03b-Transient-undervoltage-T2
    [Documentation]    Load and playback E-03b power curve (1 cycles).
...     [Expected Result] MaaS Blade may not remain functional state A during the test.
...     MaaS Blade is in functional state A after the test. Power supply to cameras and
...     A2B may not remain around 8.80V during the test.
    [Tags]    POWER    FID-462078.1039463,462078.1039500,462078.1275442    TCID-431799    FULLTEST

    # Set Temperature and wait for the target temp to reach    1    -40    OFF    1
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E_03b_power_curve.
    Load and check Power Curve    ${sut.power.PowerCurve.E_03b_power_curve}
    Sleep    80s
    # Verify DLT keyword offline    ${sut.power.DLT.Funcational_state.C}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Microphone_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}