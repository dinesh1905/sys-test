*** Settings ***
Documentation    Test case for power onOff non functional test.
Resource    ${TAF_PATH}/import.resource
Library     ${TAF_PATH}/generic/framework/testcase_iterator.py
Library     QConnectBase.ConnectionManager
Metadata    testtype            reliability
Metadata    testarea            sut.shutdown.startup
Metadata    requirements        High-Speed Power Supply
Metadata    preconditions       SuT is running.
Metadata    actions             1. Set ignition off. 2. Play power curve and set ignition on.
Metadata    expectedresults     1. SuT is shutdown. 2. SuT is running.

# Test Automation Framework
# Test Automation Framework
Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup     setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Variables ***
@{Failed__SOCstartup}    @{EMPTY}
@{Failed__SOCsendcommand}    @{EMPTY}
${AURIX_VERSION}    MAAS_AURIX_PI25.4.0_RC4
${COUNTERPLUS1}    1

*** Test Cases ***
Reliability_EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeNotWokenByCANSupportPOR
    testcase_iterator.Add Test Cases    EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeNotWokenByCANSupportPOR    50

Reliability_EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoringWithInterbladeSignal
    testcase_iterator.Add Test Cases    EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoringWithInterbladeSignal    50

Reliability_EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoring
    testcase_iterator.Add Test Cases    EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoring    50

Reliability_EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Default Session)
    prj.sut.diag.SetVehicleSpeedToZero
    testcase_iterator.Add Test Cases    EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Default Session)    50

Reliability_EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)(Extended Session)
    prj.sut.diag.SetVehicleSpeedToZero
    testcase_iterator.Add Test Cases    EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)(Extended Session)    50

Reliability_EnvD_SysQual_Diagnostics_ECUExtractAR-CVersionNumber(0xFD07)(Extended Session)
    prj.sut.diag.SetVehicleSpeedToZero
    testcase_iterator.Add Test Cases    EnvD_SysQual_Diagnostics_ECUExtractAR-CVersionNumber(0xFD07)(Extended Session)    50

Reliability_EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)(Default Session)
    prj.sut.diag.SetVehicleSpeedToZero
    testcase_iterator.Add Test Cases    EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)(Default Session)    50

Reliability_EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0x0322)(Extended Session)
    prj.sut.diag.SetVehicleSpeedToZero
    testcase_iterator.Add Test Cases    EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0x0322)(Extended Session)    50

Reliability_EnvD_SysQual_Diagnostics_CurrentConsumption_value
    prj.sut.diag.SetVehicleSpeedToZero
    testcase_iterator.Add Test Cases    EnvD_SysQual_Diagnostics_CurrentConsumption_value    50

Reliability_EnvD_SysQual_Communication_CANSubsystem_vehicle_data
    testcase_iterator.Add Test Cases    EnvD_SysQual_Communication_CANSubsystem_vehicle_data    50


*** Keywords ***
Teststeps
    [Documentation]    The test steps are executed for Power off on test
    Log To Console    Hi Starting the test for clear DTC
    # Clear DTC command
    prj.sut.power cycle
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    2s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

EnvD_SysQual_PowerManagementSubsystem_General_MaaSBladeNotWokenByCANSupportPOR
    [Documentation]    MaaS Blade should no wake up by CAN. MaaS Blade support POR.
    ...    Only Power Blade can enable individial blades to be powered up.
    [Tags]    POWER    FID-1039453    TCID-195833    FULLTEST

    prj.sut.power cycle

    # Shut down Maas Blade
    prj.sut.can.simulation.PowerBladeOFF
    bits_platform.Output Set Analog Signal Value    Battery    0
    ${b_ack}    ${s_result}    bits_platform.Input Get Signal Value    Battery_Current
    Log To Console    Current consumption is ${s_result}
    IF    ${s_result} == 0
        Log To Console    Current shown ${s_result}. Device has been shut down.
    ELSE
        Set Test Status To Fail    Device did not shut down.
    END

    # Sending a CAN Message to check if DUT wakes up.
    ${Status}    Run Keyword And Return Status
    ...    bits_platform.Rbs Set Variable Value
    ...    1
    ...    SYSTEM
    ...    PowerBlade::OpStateSignal
    ...    1

    IF    ${Status} == True
        ${b_ack}    ${s_result}    bits_platform.Input Get Signal Value    Battery_Current
        IF    ${s_result} == 0
            Log    The current ${s_result} .Device did not wake up.Test Case PASS    console=yes
            ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    12
        ELSE
            Log    FAIL!! Device current is ${s_result} and not 0    console=yes
            framework.Set Test Status To Fail
        END
    ELSE
        Log To Console    FAIL!!! Unable to send CAN Message
        framework.Set Test Status To Fail    power    FAIL!!! Unable to send CAN Message
    END

EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoringWithInterbladeSignal
    [Documentation]    Check on general voltage reading
    [Tags]    POWER    FID-1275341,2655699    TCID-195840    FULLTEST
    Log To Console    Hi

    prj.sut.disconnect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.connect.dlt
    prj.sut.can.initandloadconfiguration
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON

    prj.sut.power.add.voltage.to.dictionary.check    Battery    16.4    

EnvD_SysQual_PowerManagementSubsystem_General_VoltageMonitoring
    [Documentation]    MaaS Blade should produces traces with voltage value in SCC console.
    [Tags]    POWER    FID-1275341    TCID-195837    FULLTEST
    prj.sut.connect.dlt
    prj.sut.power cycle

    bits_platform.Output Set Analog Signal Value    Battery    0
    prj.sut.power.add.voltage.to.dictionary.check    Battery    12    

    Log To Console    Voltage reading is reflected correctly in SCC console

EnvD_SysQual_Diagnostics_RollerTestStandMode(0x04FB)(Default Session)
    [Documentation]    The DID RollerTestStandMode shall be used to Activate/Deactivate
    ...    the Roller test stand mode for the ECU in default mode.
    [Tags]    CustomerDiagnostic    TCID-272514    FULLTEST	FID-1132910,1132911,1132912,1132914,1132915,1069815,1069829

    # precondition
    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_00_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of RollerTestStandMode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandMode_Resp}

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Check is what is written is reflected.
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWriteUpdate_Resp}

EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)(Extended Session)
    [Documentation]    This Data Identifier identifies all current IPv6 addresses of the
    ...    control unit which are not IPv6 multicast addresses.
    [Tags]    CustomerDiagnostic    TCID-272578    FULLTEST	FID-1691409,1691410,1691411,1691413,1691414

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6AddressesList_Resp}

EnvD_SysQual_Diagnostics_NRC$13_RequestLengthExceeded_Write
    [Documentation]    This NRC shall be sent if the length of the message is wrong (max. length check)
    [Tags]    CustomerDiagnostic    TCID-272496    FULLTEST	FID-1151441,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Write_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

EnvD_SysQual_Diagnostics_IpCounterWrongIpv6Addresses(0x0A2C)(Extended Session)
    [Documentation]    This Data Identifier identifies counter messages with invalid IPv6
    ...    addresses.
    [Tags]    CustomerDiagnostic    TCID-272558    FULLTEST    FID-1858015,1858016,1858017,1858019,1858020

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongIpv6Addresses_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongIpv6Addresses_0x0A2C_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongIpv6Addresses_Resp}    0    8

    # take the new last Byte
    ${Counter2}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter2_Int_new}    Convert To Integer    0x${Counter2}
    Log To Console    The latest Counter is ${Counter2_Int_new}. Before it was ${Counter_Int}

    # compare with the 1st variable +1
    IF    ${Counter_Int_new} == ${Counter2_Int_new}
        Log To Console    The Counter increased from ${Counter_Int} to ${Counter2_Int_new}.
        Log To Console    Test Case PASS!!
    ELSE
        Log To Console    The new counter ${Counter2_Int_new} is not the same as the expected counter ${Counter_Int_new}
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_SnapshotData_VehicleSpeed
    [Documentation]    This DID(0x2B16) shall give the Vehicle Speed when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371294    FULLTEST	FID-1818668,1826246
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    0    20
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_20_Resp}

    prj.sut.diag.SetETHSignal    0    50
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleSpeed_50_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_50_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)(Default Session)
    [Documentation]    This Data Identifier indicates the date of the event recorder deletion.The Timestamp shall be read from the message Diagnose_01
    [Tags]    FID-1665051,1665050,1665049,1665054,1665053    TCID-272559    CustomerDiagnostic    FULLTEST
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.diag.SetETHSignal    2    24    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Req}
    prj.sut.diag.compare    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Variation1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0x0322)(Extended Session)
    [Documentation]    The DID  GVM_Status shall give the information about the  Status of Guest Virtual Machines (GVM) .
    [Tags]    CustomerDiagnostic    TCID-404444    FULLTEST    FID-2845966,2845967,2845968,2845970,2845971

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.GVMStatus_Req}
    prj.sut.diag.compare    ${sut.diag.GVMStatus_Resp}

EnvD_SysQual_Diagnostics_CurrentConsumption_value
       [Documentation]    the function will give value of current consumed
       [Tags]    Customer_Diagnostic    TCID-518828    FID-3666429

       ${bAck}    ${sCuurent}    bits_platform.input get signal value    Battery_Current
       Log To Console    ${bAck}, amp is ${sCuurent}

EnvD_SysQual_Communication_CANSubsystem_vehicle_data
    [Documentation]    The CAN subsystem shall provide access to vehicle data only to authorized applications.
    ...    The CAN subsystem shall support to get data from the vehicle communication network.
    ...    The data shall be available for all devices.
    ...    Authorization shall be required to grant arbitrary access, depending on project requirements.
    [Tags]    COMMUNICATION    FID-1340699,1340734,1340700    TCID-437643    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.can.diag.tester.present.active
    prj.sut.com.Countdown Timer    5
    # configuring the baud rate
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.Countdown Timer    3
    prj.sut.com.set Message ID Logging Active
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    prj.sut.com.set Message ID Logging Deactive
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}
    END
    prj.sut.can.diag.tester.present.active
    #  prj.sut.com.Countdown Timer    5
    # # Send command VWECUHardwareNumber
    # prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Req}
    # prj.sut.diag.compare    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Resp}
    # # Go to extended session
    # prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    # prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # # Send command VWECUHardwareNumber
    # prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Req}
    # prj.sut.diag.compare    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Resp}
    Log To Console    Vehicle CAN data is seen

EnvD_SysQual_MCUSubsystem_General_FutureUpdatenotRestrictedByLowComputingPower
    [Documentation]    Check Aurix version and startup time
    [Tags]    Mcu    FULLTEST    FID-1275466    TCID-431593
    ${expected_ms}    Set Variable    500
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    prj.sut.can.simulation.Stop
    Sleep    3s
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    ${Time_Stamp1}    prj.sut.get current Timedata
    Sleep    3s
    ${Time_Stamp2}    prj.sut.get time log from dlt    SwitchOnPowerRail
    Log To Console    Voltage time start     ${Time_Stamp1}
    Log To Console    Expected keyword time     ${Time_Stamp2}
    ${actual_total_ms}    subtract date from date    ${Time_Stamp2}    ${Time_Stamp1}    Number    False    %Y-%m-%d %H:%M:%S.%f    %Y-%m-%d %H:%M:%S.%f
    IF     ${actual_total_ms} <= ${expected_ms}
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
    ELSE
        Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_total_ms} s
        Set Test Status To Fail    error_type=Power time    info_text=Expected timing be to less than ${expected_ms}±5 ms, but got ${actual_total_ms} s
    END
    Log To Console    Traces in SCC console(DTL)
    Verify DLT keyword offline    ${AURIX_VERSION}
    prj.sut.disconnect.dlt

EnvD_SysQual_Diagnostics_ECUExtractAR-CVersionNumber(0xFD07)(Extended Session)
    [Documentation]    also known as ECUExtractVersionInformation(0xFD07) in requirement.
    ...    The DID ECUExtractVersionInformation shall give the information about
    ...     the ECU Extract Information integrated for that particular PI
    [Tags]    CustomerDiagnostic    TCID-272569    FULLTEST	FID-1435087,1435088,1435089,1435091,1435092

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUExtractAR_CVersionNumber_Resp}

EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Default Session)
    [Documentation]    The DID ECUSerialNumber shall give the Serial Number of each of the Blade
    [Tags]    CustomerDiagnostic    TCID-272614    FULLTEST	FID-1150970,1150971,1150972,1150974,1150975

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUSerialNumber_Resp}

