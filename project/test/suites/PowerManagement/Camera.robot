*** Settings ***
Documentation       Example script to set and get voltage
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults
Library    OperatingSystem

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_ActivateIndividualPowerSupplyIfRespectiveCameraVariantIsCoded
   [Documentation]    Click ""Startup/shutdown"" on CAN simulation to trigger startup on MaaS Blade. 
   ...    [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
   ...    Make sure cameras were plugged into correct socket. 
   ...    [Expected Result] Cameras are plugged into front connector of MaaS Blade.
   ...    Measure voltage on each camera with digital multimeter. 
   ...    [Expected result] Obtained reasonable voltage reading which is matched to camera specification.

   [Tags]    POWER    FID-039481,1039474,1039475,1039476,1039477,1039478,
   ...    1039479,1039480,1039483,1039484,1039485    TCID-353557    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Log To Console    camera is connected
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.start_up_Camera_Phantom_enabled}
    #Camera Test point voltage has to be checked
    Check Test point voltage    equalto    camera_VDC

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_DeactivateIndividualPowerSupplyIfRespectiveCameraVariantIsNotCoded
    [Documentation]    1. Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade. 
    ...    [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Measure voltage on each camera with digital multimeter. 
    ...    [Expected result] Obtained 0.0V (means power supply disabled).

   [Tags]    POWER    FID-1053030    TCID-353558    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Log To Console    camera is connected
    Verify DLT keyword offline  ${sut.power.DTL_log.start_up_Camera_Phantom_enabled}
    #Camera Test point voltage has to be checked
    Check Test point voltage    equalto    camera_VDC
    prj.sut.power inital preconditions    powercurve_battery    0
    Sleep    10s
    Check Test point voltage    zero    camera_VDC

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_UndervoltageHandling
    [Documentation]    Set UBAT voltage to 8.0V. [Expected Result] MaaS Blade enter undervoltage state.
    ...    Verify SCC trace. [Expected Result] Observed trace for camera phantom disabled.
    ...    Set UBAT voltage to 12.0V. [Expected Result] MaaS Blade enter normal voltage state.
    ...    Verify SCC trace. [Expected Result] Observed trace for camera phantom enabled.
   [Tags]    POWER    FID-1039498   TCID-408345    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    8
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.undervoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Camera_Phantom_disabled}
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_CriticalUndervoltageHandling
    [Documentation]    When power management subsystem detect critical low voltage condition at the MaaS blade,
    ...     power management shall carry out ciritical low voltage handling on power supply to camera that 
    ...    switch off power supply to camera.

   [Tags]    POWER    FID-1039499    TCID-408346    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    5.9
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.critical_undervoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Camera_Phantom_disabled}
    Sleep    10s
    prj.sut.dlt.disconnect.clear.connect dlt
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    12.0    
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_enabled}


EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_BoostedNorminalVoltage
    [Documentation]    The power supply provided from the MaaS blade to the cameras shall be 
    ...    boosted and shall ensure the nominal voltage for less than 30ms after the occurrence 
    ...    of undervoltage at the power blade.

    [Tags]    POWER    FID-1039497    TCID-410497    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    8.0    
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.undervoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Camera_Phantom_disabled}
    Sleep    10s
    prj.sut.dlt.disconnect.clear.connect dlt
    prj.sut.power.add.voltage.to.dictionary.check   powercurve_battery    12.0
    Sleep    50s
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DLT.undervoltage_2}
    prj.sut.connect.dlt.Verify DLT keyword not present in log     ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline    ${sut.power.DTL_log.Camera_Phantom_enabled}

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_LineFaultDetection
    [Documentation]    
    [Tags]    POWER    FID-1053044,1039494,1039501,1039504    TCID-353556    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.start_up_Camera_Phantom_enabled}
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    ON
    Sleep    20s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.sut.diag.ReportDTCByStatusMask_CameraShortToGnd4}
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF
    Sleep    20s

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_CameraPowerFaultDetection(OpenCircuit)
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade. 
    ...    [Expected result] MaaS Blade power up and observed MCU startup sequence in SCC console. 
    ...    Corresponding error code in Fault Memory should obtained.d200b4
   [Tags]    POWER    FID-1039502    TCID-411859    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraOpen4}

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_CameraPowerFaultDetection(ShortToBattery)
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade. 
    ...    [Expected result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Short Vcc of camera to its battery anode terminal (positive terminal) and look for error code in Fault memory. 
    ...    [Expected result] Obtained corresponding error code in Fault Memory.d200b4
   [Tags]    POWER    FID-1039503    TCID-411858    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.start_up_Camera_Phantom_enabled}
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    bits_platform.Output Set Digital Signal Value    Camera_Short_Battery    ON
    Sleep    20s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    Sleep    5
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_CameraShortTobat4}
    bits_platform.Output Set Digital Signal Value    Camera_Short_Battery    OFF
    Sleep    20s

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_VmaxVminForCameras
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected Result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Set KL30 voltage to 9.0V, 14.0V and 16.0V. Monitor voltage to camera. 
    ...    [Expected Result] Voltage for camera phantom should not exit range of 7.0V to 10.0V.

   [Tags]    POWER    FID-1039486,1039487    TCID-432756    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.start_up_Camera_Phantom_enabled}
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    9.0    
    Sleep    30s
    Check Test point voltage    equalto    camera_VDC
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    14.0    
    Sleep    30s
    Check Test point voltage    equalto    camera_VDC
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    16
    Sleep    30s
    Check Test point voltage    equalto    camera_VDC

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForExternalCameras_CameraPowerFaultDetection(OverCurrent)
    [Documentation]    Click ""Startup/shutdown"" on CAN simulation to trigger startup on MaaS Blade.
    ...     [Expected result] MaaS Blade power up and observed MCU startup sequence in SCC console.
    ...    Use ELoad to trigger current load to more than 300mA and look for error code in Fault memory.
    ...     [Expected result] Obtained corresponding error code in Fault Memory."

   [Tags]    POWER    FID-1039505    TCID-432755    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.start_up_Camera_Phantom_enabled}
    Log    Use ELoad to trigger current load to more than 300mA
    Configure Eload and set overcurrent    0.3
    Sleep    30
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    Sleep    5
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.sut.diag.ReportDTCByStatusMask_CameraShortToGnd4}
    Reset Eload device    0
    Sleep    30
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    Sleep    5
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte_not_present    ${sut.diag.sut.diag.ReportDTCByStatusMask_CameraShortToGnd4}