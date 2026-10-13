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
EnvD_SysQual_PowerManagementSubsystem_VW80000_ StaticOperatingVoltageRange
    [Documentation]    Adjust UBAT voltage from 16.0V to 9.8V with step of 0.1V every 5 seconds.
    ...    MaaS Blade in Functional State A. MaaS Blade remain in normal operating voltage range. All component up and running.
    ...    2. Adjust UBAT voltage from 9.8V to 0.0V with step of 0.1V every 5 seconds.
    ...    MaaS Blade transition from voltage operating voltage state to undervoltage state -> critical undervoltage state -> OFF state.
    ...    MaaS Blade in Functional State C when leaving normal operating voltage state.
    ...    Some components will fall into standby/disable/off state when MaaS Blade not in normal operating state.

    [Tags]    POWER    FID-1456801,1456804    TCID-431807
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    UBAT voltage from 16.0V to 0.0 V    powercurve_battery

EnvD_SysQual_PowerManagementSubsystem_VW80000_E-02-Transient-overvoltage-T3
    [Documentation]    Load and playback E-02-T3 power curve (100 cycles).
    ...    MaaS Blade remain functional state A during the test. MaaS Blade remain functional state A after the test. Power
    ...    supply to cameras and A2B should remain around 8.80V during the test.

    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431811
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E_02_T3_power_curve.
    FOR    ${Count}    IN RANGE    0   101
        Load and check Power Curve    ${sut.power.PowerCurve.E_02_T3_power_curve}
        Sleep    1s
        Verify DLT keyword offline    OnEnterRunMode
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
        prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-04-JumpStart
    [Documentation]    Load and playback E-04 power curve.
    ...    MaaS Blade fall into functional state C during the test. MaaS Blade is in functional state A after the test.
    ...    Power supply to cameras and A2B may not remain around 8.80V during the test.

    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431798
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E-04 power curve.
    Load and check Power Curve    ${sut.power.PowerCurve.E_04_power_curve}
    Log To Console    MaaS Blade is in functional state C and A2B Volatge is not in 8.8V
    Sleep    30s
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
    Log To Console    MaaS Blade remain functional state A and A2B Volatge is around 8.8V
    Check Power Curve is completed    60
    prj.sut.dlt.disconnect.clear.connect dlt
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}

EnvD_SysQual_PowerManagementSubsystem_VW80000_E-05-LoadDump
    [Documentation]    Load and playback E-05 power curve (10 cycles with 1 minute break between cycle).
    ...    MaaS Blade remain in functional state A during the test. MaaS Blade is in functional state A after the test.
    ...    Power supply to cameras and A2B remain around 8.80V during the test.

    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431797
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    FOR    ${Count}    IN RANGE    0    11
      Log To Console    Load and playback E-05 power curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_05_power_curve}
      Log To Console    MaaS Blade remain functional state A and A2B Volatge is around 8.8V
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
      Check Power Curve is completed    60
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-09-ResetBehavior-T1
    [Documentation]    Load and playback E-09-T1 power curve (1 cycle).
    ...    MaaS Blade fall into functional state C during the test.
    ...    MaaS Blade return to functional state A after the test.
    ...    Power supply to cameras and A2B may not remain around 8.80V during the test.
    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431801
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Log To Console    Load and playback E_09_T1_power_curve.
    Load and check Power Curve    ${sut.power.PowerCurve.E_09_T1_power_curve}
    Log To Console    MaaS Blade fall into functional state C
    Check Power Curve is completed    250
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
    Log To Console    MaaS Blade may not remain around 8.80V
    prj.sut.dlt.disconnect.clear.connect dlt
    Log To Console    MaaS Blade fall into functional state A
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-09-ResetBehavior-T2
    [Documentation]    Load and playback E-09-T2 power curve (1 cycle).
    ...    MaaS Blade fall into functional state C during the test.
    ...    MaaS Blade return to functional state A after the test.
    ...    Power supply to cameras and A2B may not remain around 8.80V during the test.
    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431822
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    FOR    ${Count}    IN RANGE    0    1
      Log To Console    Load and playback E_09_T2_power_curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_09_T2_power_curve}
      Log To Console    MaaS Blade fall into functional state C
      Check Power Curve is completed    250
      Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
      Log To Console    MaaS Blade may not remain around 8.80V
      prj.sut.dlt.disconnect.clear.connect dlt
      Log To Console    MaaS Blade fall into functional state A
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-12-VoltageCurveWithVehicleElectricalSystemControl-T1
    [Documentation]    Load and playback E-12-T1 power curve.
    ...    MaaS Blade remain functional state A during the test. MaaS Blade remain functional state A after the test.
    ...    Power supply to cameras and A2B remain around 8.80V during the test.

    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431823
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
   FOR    ${i}    IN RANGE    0    1
      Log To Console    Load and playback E_12_T1_power_curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_12_T1_power_curve}
      Log To Console    MaaS Blade remain functional state A and A2B Volatge is around 8.8V
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
      Log To Console    MaaS Blade remain functional state A and A2B Volatge is around 8.8V
      Sleep    10s
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
   END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-12-VoltageCurveWithVehicleElectricalSystemControl-T2
    [Documentation]    Load and playback E-12-T2 power curve
    ...    MaaS Blade remain functional state A during the test. MaaS Blade remain functional state A after the test.
    ...    Power supply to cameras and A2B remain around 8.80V during the test.

    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431826

    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    FOR    ${Count}    IN RANGE    1    10
      Log To Console    Load and playback E_12_T2_power_curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_12_T2_power_curve}
      Sleep    1s
      Log To Console    MaaS Blade remain functional state A and A2B Volatge is around 8.8V
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
      Log To Console    MaaS Blade remain functional state A and A2B Volatge is around 8.8V
      Sleep    2s
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-12-VoltageCurveWithVehicleElectricalSystemControl-T3
    [Documentation]    Load and playback E-12-T3 power curve
    ...     MaaS Blade remain functional state A during the test. MaaS Blade remain functional state A after the test.
    ...    Power supply to cameras and A2B remain around 8.80V during the test.

    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431825

    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    FOR    ${Count}    IN RANGE    1    2
      Log To Console    Load and playback E_12_T3_power_curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_12_T3_power_curve}
      Sleep    1s
      Log To Console    MaaS Blade remain functional state A and A2B Volatge is around 8.8V
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.Funcational_state.C}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
      Log To Console    MaaS Blade remain functional state A and A2B Volatge is around 8.8V
      Sleep    10s
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
   END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-15-ReversePolarity-T1
    [Documentation]    Load and playback E-15-T1 power curve (1 cycle).
    ...     [Expected Result] Correspondent module in funtional state C during the test.
    ...     Correspondent module in functional state A when test is over.
    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431813
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    FOR    ${Count}    IN RANGE    0    1
      Log To Console    Load and playback E-15-T2 power curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_15_T1_power_curve}
      Sleep    100s
      Log To Console    MaaS Blade fall into functional state C
      Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
      Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
      Log To Console    MaaS Blade may not remain around 8.80V
      Log To Console    MaaS Blade fall into functional state A
      prj.sut.dlt.disconnect.clear.connect dlt
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-15-ReversePolarity-T2
    [Documentation]    Load and playback E-15-T2 power curve (3 cycle). 
    ...    [Expected Result] Correspondent module in funtional state C during the test. 
    ...    Correspondent module in functional state A when test is over.
    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431812
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    FOR    ${Count}    IN RANGE    0    3
      Log To Console    Load and playback E-15-T2 power curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_15_T2_power_curve}
      Sleep    100s
      Log To Console    MaaS Blade fall into functional state C
      Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
      Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_disabled}
      Log To Console    MaaS Blade may not remain around 8.80V
      Log To Console    MaaS Blade fall into functional state A
      prj.sut.dlt.disconnect.clear.connect dlt
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_E-07-SlowDecreaseIncreaseOfTheSupplyVoltage
    [Documentation]    Load and playback E-07 power curve (1 cycle).
    ...    MaaS Blade fall into functional state C during the test.
    ...    MaaS Blade return to functional state A after the test.
    ...    Power supply to cameras and A2B may not remain around 8.80V during the test.
    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431803
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    Verify DLT keyword offline    OnEnterRunMode
    FOR    ${Count}    IN RANGE    0    1
      Log To Console    Load and playback E-07 power curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_07_power_curve}
      Log To Console    MaaS Blade fall into functional state C
      Check Power Curve is completed    3600
      Verify DLT keyword offline  ${sut.power.DTL_log.A2B_disabled}
      Log To Console    MaaS Blade may not remain around 8.80V
      prj.sut.dlt.disconnect.clear.connect dlt
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    END

EnvD_SysQual_PowerManagementSubsystem_VW80000_ E-08-SlowDecreaseQuickIncreaseOfTheSupplyVoltage
    [Documentation]    Load and playback E-08 power curve (1 cycle).
    ...    MaaS Blade fall into functional state C during the test.
    ...    MaaS Blade return to functional state A after the test.
    ...    Power supply to cameras and A2B may not remain around 8.80V during the test.
    [Tags]    POWER    FID-1039463,1039500,1275442    TCID-431802
    prj.sut.power inital preconditions    sSignal=powercurve_battery    voltage=12
    FOR    ${Count}    IN RANGE    0    1
      Log To Console    Load and playback E-08 power curve.
      Load and check Power Curve    ${sut.power.PowerCurve.E_08_power_curve}
      Check Power Curve is completed    2000
      Log To Console    MaaS Blade fall into functional state C
      Verify DLT keyword offline    ${sut.power.DTL_log.A2B_disabled}
      Log To Console    MaaS Blade may not remain around 8.80V
      Log To Console    MaaS Blade fall into functional state A
      prj.sut.dlt.disconnect.clear.connect dlt
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
      prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.Camera_Phantom_disabled}
    END
