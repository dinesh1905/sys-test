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
Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety    prj.sut.Power.Activate Big Toelner
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_General_PowerSupplyInputFromPowerBladeViaBackPlaneConnector
    [Documentation]    Set something on power blade to trigger start up on MaaS Blade. 
    ...    [Expected Result] MaaS Blade power up with startup traces in SCC console.
    ...    Click ""Startup/shutdown"" on CAN simulation to trigger startup on MaaS Blade. 
    ...    [Expected Result] MaaS Blade power up with startup traces in SCC console.
    [Tags]    POWER    FID-462078.1039449    TCID-283136        FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT

EnvD_SysQual_PowerManagementSubsystem_General_DC/DCConverter
    [Documentation]    Click ""Startup/shutdown"" on CAN simulation to trigger startup on MaaS Blade.
    ...    [Expected Result] MaaS Blade power up with startup traces in SCC console.
    ...    Lower UBAT voltage to 9.3V and 9.2V. [Expected Result] MaaS Blade remain in normal voltage state.
    ...    Lower UBAT voltage to a value between 9.1V and 8.3V. 
    ...    [Expected Result] MaaS Blade enter undervoltage state with its behavior."
    [Tags]    POWER    FID-462078.1275350    TCID-408336        FULLTEST
    prj.sut.power inital preconditions        powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    9.3    
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Verify DLT keyword offline    ${sut.power.DTL_log.A2B_enabled}
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    8.3    
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.undervoltage_2}
    Verify DLT keyword offline  ${sut.power.DTL_log.Camera_Phantom_disabled}
    Verify DLT keyword offline  ${sut.power.DTL_log.Linux_Android_sDisabled_StandbyMode}
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_disabled}
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12    

EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeFullyONFullyOFFPowerModeState
    [Documentation]    Press ""Startup"" on CAN simulation to trigger startup on MaaS Blade. 
    ...    [Expected Result] MaaS Blade wake up with POR message and startup successfully. 
    ...    At 60th second from supply voltage to MaaS Blade, perform: - SSH into QNX.adb into Linux and Android.
    ...    [Expected Result] SoC, Linux and Android boot up in 60 seconds.
    ...    Press ""Shutdown"" on CAN simulation to trigger shutdown on Maas Blade.
    ...    [Expected Result] MaaS Blade can be shutdown with standby current at 0.00A.
    [Tags]    POWER    FID-462078.1039457,462078.1039458,462078.1039455    TCID-369368        FULLTEST
    prj.sut.power inital preconditions        powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  [PowerM] OnInit Set PWR_HOLD pin to ACTIVE
    Verify DLT keyword offline    [PowerM] OnInit LastResetReason
    Log To Console    Click "Shutdown" on CAN simulation to trigger shutdown on Maas Blade
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    0    
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    10s
    Log To Console    Read the Target current less than 20µA
    Read the Target current    BigToelner_Current    0.1    Lessthan
    prj.sut.can.simulation.PowerBladeON
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12

EnvD_SysQual_PowerManagementSubsystem_General_MonitorOverallTemperatureValue
    [Documentation]    Press "Startup" on CAN simulation to trigger startup on MaaS Blade.
    ...    [Expected result] DUT power up.
    ...     Traces for temperature reading should show up in SCC console.
    ...     Highest temperature value being used as overall temperature value.
    [Tags]    POWER    FID-462078.1275340    TCID-195831        FULLTEST
    prj.sut.power inital preconditions        powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline    [Temperature] Overall temperature
    ${output}=    prj.sut.connect.dlt.Search the DLT and return matching patterns    [Temperature] Overall temperature =    D:/tmp/LogFile/${TEST_NAME}/log.txt
    ${temp_value}=    Extract Temperature Number    ${output}[0]
    Log    ${temp_value}
    Validate Temperature Range    ${temp_value}

EnvD_SysQual_PowerManagementSubsystem_General_TemperatureMonitoringWithInterbladeSignal
    [Documentation]    Press "Startup" on CAN simulation to trigger startup on MaaS Blade.
    ...    [Expected result] DUT power up.
    ...    Traces for temperature reading should show up in SCC console.
    ...    Temperature reading should be in -ve +ve 1 degree resolution.
    [Tags]    POWER    FID-462078.1275340    TCID-195832        FULLTEST
   prj.sut.connect.dlt
   prj.sut.power cycle
   prj.sut.can.simulation.PowerBladeOFF
   prj.sut.can.simulation.PowerBladeON
   Verify DLT keyword offline    [PowerM] SendCanSignal Safety Temperature validity = valid
   Sleep    2s
   Verify DLT keyword offline    [PowerM] SendCanSignal Safety Temperature value
   prj.sut.disconnect.dlt

EnvD_SysQual_PowerManagementSubsystem_General_PowerBladeToTriggerStartup-ShutdownToMaaSBlade
    [Documentation]    Set something on power blade to trigger start up on MaaS Blade. 
    ...    [Expected Result] MaaS Blade power up with startup traces in SCC console.
    ...    Set something on power blade to trigger shutdown on Maas Blade.
    ...    [Expected Result] MaaS Blade power down with shutdown traces in SCC console.

    [Tags]    POWER    FID-462078.1039450,462078.1376730,462078.1039462,462078.1039459     TCID-195835        FULLTEST
    prj.sut.power inital preconditions        powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    15s
    Verify DLT keyword offline    [PowerM] KssPowerDown Disable CPU
    Verify DLT keyword offline    [PowerM] KssPowerDown SwitchOffMainSupplies
    Verify DLT keyword offline    [PowerM] BswM_RequestMode [PRJ_OpeMode_SHUTDOWN]
    Verify DLT keyword offline    [PowerM] Set PMIC_PGOOD_BL2 pin to INACTIVE
    Verify DLT keyword offline    [PowerM] Set PWR_HOLD pin to INACTIVE
    prj.sut.can.simulation.PowerBladeON
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12

EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladePowerInputOutputOverview
    [Documentation]    Click "Startup" on CAN simulation to trigger startup on MaaS Blade.
    ...    [Expected Result] MaaS Blade power up with startup traces in SCC console.
    ...    Measure voltage on each camera with digital multimeter. 
    ...    [Expected result] Obtained reasonable voltage reading which is matched to camera specification.
    ...    Measure voltage on A2B with digital multimeter.
    ...     [Expected result] Obtained reasonable voltage reading which is matched to A2B requirement.

    [Tags]    POWER    FID-462078.1275331    TCID-406484    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Log    Measure voltage on A2B with digital multimeter
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    bits_platform.Multimeter Initialize_Device    1
    bits_platform.multimeter get parameter    1    parameter_name
    Verify DLT keyword offline  ${sut.power.DTL_log.Camera_Phantom_enabled}

EnvD_SysQual_PowerManagementSubsystem_General_PhantomPowerToCameraAndA2BBooster
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade. 
    ...    [Expected Result] MaaS Blade power up with startup traces in SCC console.
    ...    Verify keyword of phantom power is showing up in SCC trace. 
    ...    [Expected result] Keyword found.
    ...    Enter command(s) in SoC console to read status of cameras. 
    ...    [Expected Result] Commands return cameras are active.
    ...    Enter command(s) in SoC console to read status of A2B booster. 
    ...    [Expected Result] Commands return A2B booster is active.
    [Tags]    POWER    FID-462078.1275330,462078.3451358     TCID-283137        FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    Verify DLT keyword offline  ${sut.power.DTL_log.Camera_Phantom_enabled}
    Log    Enter command(s) in SoC console to read status of cameras
    prj.sut.Power.screencap the image from camera    Not_Displayed
    Log    Enter command(s) in SoC console to read status of A2B booster
    prj.sut.thread.A2BVoltageCheck

