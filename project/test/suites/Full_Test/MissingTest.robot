*** Settings ***
Documentation       Full Test for all Modules SysTest
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
Test Setup          run keywords    setups.Set Up Test Case    prj.sut.diag.SetVehicleSpeedToZero
Test Teardown       run keywords    teardowns.Tear Down Test Case    prj.sut.diag.SetVehicleSpeedToZero


*** Variables ***
${COUNTERPLUS1}        1
${AURIXDEBUG_VERSION}    ${AURIXDEBUG_VERSION}
${AURIXDEBUG_URL}    ${AURIXDEBUG_URL}
${KDS_FLASH}    ${KDS_FLASH}
${AURIX_VERSION}    ${AURIX_VERSION}
${SOC_VERSION}    ${SOC_VERSION}
${SAIL_VERSION}    ${SAIL_VERSION}


*** Test Cases ***
EnvD_SysQual_Diagnostics_SnapshotData_SupplyVoltageOfTheBlade(Negative Test)
    [Documentation]    To test Supply Voltage Of The Blade Negative handling
    [Tags]    CustomerDiagnostic    TCID-434195    FULLTEST    FID-1826342,1826343    NegativeTest
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.VoltageTerminal30_12V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 12V. Comparing with 11.9V
        ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.VoltageTerminal30_119V_Resp}
            IF    ${Status} == False
                Log To Console    Supply value is not 11.9V. Comparing with 11.8V
                prj.sut.diag.checkbyte    ${sut.diag.VoltageTerminal30_118V_Resp}
                Log to Console    Supply value is 11.8V
            ELSE
                Log to Console    Supply value is 11.9V
            END
    ELSE
        Log to Console    Supply value is 12V
    END
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_21V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 21V. Comparing with 20.9V
        ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_209V_Resp}
    ELSE IF    ${Status} == False
        Log To Console    Supply value is not 20.9V. Comparing with 20.8V
        ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_208V_Resp}
    ELSE
        Set Test Status To Fail    error_type=diagnostic    info_text=Voltage Snapshot data is not 21V or 20.9V
    END
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.compare   ${sut.diag.VoltageTerminal30_21V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 21V. Comparing with 20.9V
        ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_209V_Resp}
        IF    ${Status} == False
            Log To Console    Supply value is not 20.9V. Comparing with 20.8V
            prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_208V_Resp}
        END
    END
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SuppressPositiveResponse_VerifySession(NegativeResponse)
    [Documentation]    To test negative response handling for suppress positive response

    [Tags]    CustomerDiagnostic    TCID-428385    FULLTEST    FID-1348229,1348230    NegativeTest    ProgrammingSession

    # NRC13
    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_Suppress_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_Suppress_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_IncorrectMessageLengthOrInvalidFormat_Resp}

    # NRC 12
    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_Suppress_IncorrectSubfunction_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ServiceNotSupported_Resp}

    # NRC7E
    prj.sut.can.diag.send    ${sut.diag.DefaultSession_Suppress_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.can.diag.get
    IF    ${Status} == ${True}
        Set Test Status To Fail    error_type=Diagnostic    info_text=.Able to get a response.Positive Response is NOT suppressed
    END
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingSession_Suppress_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ServiceNotSupportedInActiveSession_Resp}

EnvD_SysQual_Diagnostics_ECUProgrammingInformation(0xF1DF)(Default Session)
    [Documentation]    This DataIdentifier indicates the programmability and program
    ...    consistency of the server. This refers to the consistency with regard
    ...    to software and software and hardware.
    [Tags]    CustomerDiagnostic    TCID-272498    FULLTEST	FID-1287691,1287693,1287744,1287745,1287764,1287765

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_Req}
    prj.sut.diag.compare    ${sut.diag.ECUProgrammingInformation_Programmable_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCTemperatures(0xFEFB)(Default Session)
    [Documentation]    The DID SoC_Temperatures shall give the information about the Temperatures from 63 Sensors on the SoC.
    [Tags]    CustomerDiagnostic    TCID-404441    FULLTEST    FID-2870531,2870532,2870533,2870535,2870536

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_Req}

    ${sResult}    prj.sut.diag.checkbyte    ${sut.diag.SoCTemperatures_Resp}
    ${SOCTemp_Length}    Get Length    ${sResult}
    Log To Console    Byte length is ${SOCTemp_Length}
    IF    ${SOCTemp_Length} == ${sut.diag.SoCTemperatures_Length}
        Log To Console    All 54 sensors is accounted for.OK
    ELSE
        Log To Console    All 54 sensors is NOT accounted for. NOK!!
        Set Test Status To Fail    error_type=Diagnostic    info_text=Response does not contain all 54 sensors
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_OSVersion(0xFEFC)(Default Session)
    [Documentation]    The DID  OSVersion shall give the information about OS Versions on the MCU.
    [Tags]    CustomerDiagnostic    TCID-404451    FULLTEST    FID-2856756,2856757,2856758,2856760,2856761

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.OSVersion_Req}
    ${sResult}    prj.sut.diag.checkbyte    ${sut.diag.OSVersion_Resp}
    # Checking byte length
    ${OSVersion_Length}    Get Length    ${sResult}
    Log To Console    Byte length is ${OSVersion_Length}
    IF    ${OSVersion_Length} == ${sut.diag.OSVersion_Length}
        Log To Console    Byte Length check is OK
    ELSE
        Log To Console    Byte Length check is NOK!
        Set Test Status To Fail    error_type=Diagnostic    info_text=Response does not contain all the bytes
    END

EnvD_SysQual_Diagnostics_SnapshotData_MPCIRackStatus
    [Documentation]    This DID(0x031E) shall give the MPCI Rack status when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-434197    FULLTEST	FID-1826300,1826325
    prj.sut.power cycle.and.wait
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.MPCIRackStatus_Req}
    prj.sut.diag.compare    ${sut.diag.MPCIRackStatus_INPREPARESHUTDOWN_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_MPCIRackStatus_INPREPARESHUTDOWN_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    [Teardown]    prj.sut.power cycle.and.wait

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_OSVersion(0xFEFC)(Programming Session)
    [Documentation]    The DID  OSVersion shall give the information about OS Versions on the MCU.
    [Tags]    CustomerDiagnostic    TCID-404447    FULLTEST    FID-2856756,2856757,2856758,2856760,2856761    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.OSVersion_Req}
    # ${sResult}    prj.sut.diag.checkbyte    ${sut.diag.OSVersion_Resp}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

    # ${OSVersion_Length}    Get Length    ${sResult}
    # Log To Console    Byte length is ${OSVersion_Length}
    # IF    ${OSVersion_Length} == ${sut.diag.OSVersion_Length}
    #     Log To Console    Byte Length check is OK
    # ELSE
    #     Log To Console    Byte Length check is NOK!
    #     Set Test Status To Fail    error_type=Diagnostic    info_text=Response does not contain all the bytes
    # END

    prj.sut.can.diag.ProgrammingSession.Exit

    # # Checking QNX Linux and Android version in ASCII
    # prj.sut.can.diag.send    ${sut.diag.OSVersion_Req}
    # prj.sut.diag.checkbyte    ${sut.diag.OSVersion_Resp}

    # ${QNX_Hex}    prj.sut.can.diag.get.byte.range    9    159
    # ${Linux_Hex}    prj.sut.can.diag.get.byte.range    159    309
    # ${Android_Hex}    prj.sut.can.diag.get.byte.range    309    459
    # ${QNX_ASCII}    HexConvertToASCII    ${QNX_Hex}
    # ${QNX_ASCII}    Set Variable    ${QNX_ASCII}
    # Log To Console    The QNX version obtained is ${QNX_ASCII}
    # ${Linux_ASCII}    HexConvertToASCII    ${Linux_Hex}
    # ${Linux_ASCII}    Set Variable    ${Linux_ASCII}
    # Log To Console    The Linux version obtained is ${Linux_ASCII}
    # ${Android_ASCII}    HexConvertToASCII    ${Android_Hex}
    # ${Android_ASCII}    Set Variable    ${Android_ASCII}
    # Log To Console    The Android version obtained is ${Android_ASCII}
    # IF    $QNX_ASCII == $sut.diag.OSVersion_QNX_ASCII
    #     Log to Console    QNX Version is Correct
    # ELSE
    #     Set Test Status To Fail    error_type=Diagnostic    info_text=QNX Version is not correct. ->${QNX_ASCII}
    # END
    # IF    $Linux_ASCII == $sut.diag.OSVersion_Linux_ASCII
    #     Log to Console    Linux Version is Correct
    # ELSE
    #     Set Test Status To Fail    error_type=Diagnostic    info_text=Linux Version is not correct ->${Linux_ASCII}
    # END
    # IF    $Android_ASCII == $sut.diag.OSVersion_Android_ASCII
    #     Log to Console    Linux Version is Correct
    # ELSE
    #     ${Android_ASCII}    Set Variable    ${Android_ASCII}
    #     Set Test Status To Fail    error_type=Diagnostic    info_text=Android Version is not correct ->${Android_ASCII}
    # END

EnvD_SysQual_Diagnostics_SnapshotData_OPMMStatusOfTheBlade(NegativeTest)
    [Documentation]    To test OPMM Status Of The Blade negative handling
    [Tags]    CustomerDiagnostic    TCID-434190    FULLTEST	FID-1826348,1826349    NegativeTest
    prj.sut.power cycle.and.wait
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBlade_INRUN_Resp}
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    7s
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_MPCIRackStatus_INRUN_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    [Teardown]    prj.sut.power cycle.and.wait

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_OSVersion(0xFEFC)(Extended Session)
    [Documentation]    The DID  OSVersion shall give the information about OS Versions on the MCU.
    [Tags]    CustomerDiagnostic    TCID-404446    FULLTEST    FID-2856756,2856757,2856758,2856760,2856761

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.OSVersion_Req}
    ${sResult}    prj.sut.diag.checkbyte    ${sut.diag.OSVersion_Resp}

    ${OSVersion_Length}    Get Length    ${sResult}
    Log To Console    Byte length is ${OSVersion_Length}
    IF    ${OSVersion_Length} == ${sut.diag.OSVersion_Length}
        Log To Console    Byte Length check is OK
    ELSE
        Log To Console    Byte Length check is NOK!
        Set Test Status To Fail    error_type=Diagnostic    info_text=Response does not contain all the bytes
    END

    # Checking QNX Linux and Android version in ASCII
    prj.sut.can.diag.send    ${sut.diag.OSVersion_Req}
    prj.sut.diag.checkbyte    ${sut.diag.OSVersion_Resp}

    ${QNX_Hex}    prj.sut.can.diag.get.byte.range    9    159
    ${Linux_Hex}    prj.sut.can.diag.get.byte.range    159    309
    ${Android_Hex}    prj.sut.can.diag.get.byte.range    309    459
    ${QNX_ASCII}    HexConvertToASCII    ${QNX_Hex}
    ${QNX_ASCII}    Set Variable    ${QNX_ASCII}
    Log To Console    The QNX version obtained is ${QNX_ASCII}
    ${Linux_ASCII}    HexConvertToASCII    ${Linux_Hex}
    ${Linux_ASCII}    Set Variable    ${Linux_ASCII}
    Log To Console    The Linux version obtained is ${Linux_ASCII}
    ${Android_ASCII}    HexConvertToASCII    ${Android_Hex}
    ${Android_ASCII}    Set Variable    ${Android_ASCII}
    Log To Console    The Android version obtained is ${Android_ASCII}
    IF    $QNX_ASCII == $sut.diag.OSVersion_QNX_ASCII
        Log to Console    QNX Version is Correct
    ELSE
        Set Test Status To Fail    error_type=Diagnostic    info_text=QNX Version is not correct. ->${QNX_ASCII}
    END
    IF    $Linux_ASCII == $sut.diag.OSVersion_Linux_ASCII
        Log to Console    Linux Version is Correct
    ELSE
        Set Test Status To Fail    error_type=Diagnostic    info_text=Linux Version is not correct ->${Linux_ASCII}
    END
    IF    $Android_ASCII == $sut.diag.OSVersion_Android_ASCII
        Log to Console    Linux Version is Correct
    ELSE
        ${Android_ASCII}    Set Variable    ${Android_ASCII}
        Set Test Status To Fail    error_type=Diagnostic    info_text=Android Version is not correct ->${Android_ASCII}
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCTemperatures(0xFEFB)(Programming Session)
    [Documentation]    The DID SoC_Temperatures shall give the information about the Temperatures from 63 Sensors on the SoC.
    [Tags]    CustomerDiagnostic    TCID-404449    FULLTEST    FID-2870531,2870532,2870533,2870535,2870536    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

    prj.sut.can.diag.ProgrammingSession.Exit

    # ${sResult}    prj.sut.diag.checkbyte    ${sut.diag.SoCTemperatures_Resp}
    # ${SOCTemp_Length}    Get Length    ${sResult}
    # Log To Console    Byte length is ${SOCTemp_Length}
    # IF    ${SOCTemp_Length} == ${sut.diag.SoCTemperatures_Length}
    #     Log To Console    All 54 sensors is accounted for.OK
    # ELSE
    #     Log To Console    All 54 sensors is NOT accounted for. NOK!!
    #     Set Test Status To Fail    error_type=Diagnostic    info_text=Response does not contain all 54 sensors
    # END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCTemperatures(0xFEFB)(NegativeResponse)
    [Documentation]    To test negative response for SoCTemperatures(0xFEFB)
    [Tags]    CustomerDiagnostic    TCID-404450    FULLTEST    FID-2870537    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ECUProgrammingInformation(0xF1DF)(Extended Session)
    [Documentation]    This DataIdentifier indicates the programmability and program
    ...    consistency of the server. This refers to the consistency with regard
    ...    to software and software and hardware.
    [Tags]    CustomerDiagnostic    TCID-272497    FULLTEST	FID-1440104,1440106,1440107,1440109,1440110

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_Req}
    prj.sut.diag.compare    ${sut.diag.ECUProgrammingInformation_Programmable_Resp}

EnvD_SysQual_Diagnostics_SnapshotData_OPMMStatusOfTheBlade(0x030B)
    [Documentation]    This DID(0x031E) shall give the MPCI Rack status when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-434191    FULLTEST    FID-1826348,1826349
 
    prj.sut.power cycle.and.wait
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
 
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}
 
    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBlade_INRUN_Resp}
 
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBlade_INPREPARESHUTDOWN_Resp}
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    3s
 
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_MPCIRackStatus_INPREPARESHUTDOWN_Resp}
 
    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBlade_INPREPARESHUTDOWN_Resp}
 
    bits_platform.Output Set Analog Signal Value    Battery    12
    [Teardown]    prj.sut.power cycle.and.wait

EnvD_SysQual_Diagnostics_SnapshotData_MPCIRackStatus(NegativeTest)

    [Documentation]    To test MPCI Rack Status negative handling
    [Tags]    CustomerDiagnostic    TCID-434196    FULLTEST    FID-1826300,1826325    NegativeTest
    prj.sut.power cycle
    Sleep    60s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.MPCIRackStatus_Req}
    prj.sut.diag.compare    ${sut.diag.MPCIRackStatus_INRUN_Resp}
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    10s
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_MPCIRackStatus_INRUN_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    12
    #[Teardown]    prj.sut.power cycle.and.wait

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCTemperatures(0xFEFB)(Extended Session)
    [Documentation]    The DID SoC_Temperatures shall give the information about the Temperatures from 63 Sensors on the SoC.
    [Tags]    CustomerDiagnostic    TCID-404442    FULLTEST    FID-2870531,2870532,2870533,2870535,2870536

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_Req}

    ${sResult}    prj.sut.diag.checkbyte    ${sut.diag.SoCTemperatures_Resp}
    ${SOCTemp_Length}    Get Length    ${sResult}
    Log To Console    Byte length is ${SOCTemp_Length}
    IF    ${SOCTemp_Length} == ${sut.diag.SoCTemperatures_Length}
        Log To Console    All 54 sensors is accounted for.OK
    ELSE
        Log To Console    All 54 sensors is NOT accounted for. NOK!!
        Set Test Status To Fail    error_type=Diagnostic    info_text=Response does not contain all 54 sensors
    END

EnvD_SysQual_Diagnostics_Write_SoftSKU_Universal_Token (0xFD03)(Production Session)
    [Documentation]    This DID(0xFD03) shall create a file in the temporary directory and saves the entered data to the /tmp/MAAS_key.bin file.
    [Tags]    CustomerDiagnostic    TCID-540493    FULLTEST	FID-5080765,5080766,5080767,5080769,5080770
    Set Test Status To Fail    info_text=Write SOFTSKU failed.
    #    Go to Production session
    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    #    Go to Write 1 Byte data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req1}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    Sleep    5s

    #    Go to Write 2500 Bytes data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req2}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

EnvD_SysQual_Diagnostics_Write_SoftSKU_Universal_Token (0xFD03)(NegativeResponse)
    [Documentation]    	To test negative response for WriteSoftSKUUniversalToken(0xFD03)
    [Tags]    CustomerDiagnostic    TCID-540494    FULLTEST	FID-5080771    ProgrammingSession
    Set Test Status To Fail    info_text=Write SOFTSKU failed.
    #    Go to Production session
    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    # # Go to programming session
    # prj.sut.can.diag.ProgrammingSession.Enter

    # prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    # prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

    # # Send command with incorrect extra message length
    # prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    # prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

    # prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Read_SoftSKU_Universal_Token (0xFD03)(Production Session)
    [Documentation]    This DID(0xFD03) shall read a file in the temporary directory; the /tmp/MAAS_key.bin file
    [Tags]    CustomerDiagnostic    TCID-540497    FULLTEST    FID-5080774,5080775,5080776,5080778,5080779
    Set Test Status To Fail    info_text=Read SOFTSKU failed.
    # Pre Condition
    bits_platform.Output Set Analog Signal Value    Battery    12

    #    Go to Production session
    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    #    Go to Write 1 Byte data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req1}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    #    Read and check 1 Byte data is available
    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_Req}
    prj.sut.diag.compare    ${sut.diag.ReadSOFTSKUUniversalToken_Resp1}

    #    Go to Production session
    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    #    Go to Write 2500 Bytes data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req2}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    #    Read and check 2500 Byte data is available
    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_Req}
    prj.sut.diag.compare    ${sut.diag.ReadSOFTSKUUniversalToken_Resp2}

EnvD_SysQual_Diagnostics_Read_SoftSKU_Universal_Token (0xFD03)(NegativeResponse)
    [Documentation]    	To test negative response for ReadSoftSKUUniversalToken(0xFD03)
    [Tags]    CustomerDiagnostic    TCID-540496    FULLTEST	FID-5080780    ProgrammingSession

    # Production Session
    prj.sut.can.diag.send    ${sut.diag.Production_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Production_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # # Programming Session
    # prj.sut.can.diag.ProgrammingSession.Enter

    # prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    # prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    # prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_TracingDLT_ActivationDeactivationTraces
   [Documentation]   The tracing subsystem shall provide a mechanism to allow the activation and deactivation of the traces of multiple SW components independently.
   [Tags]    FULLTEST    CustomerDiagnostic    TCID-541076   FID-2510875
   Close All Connections
 
   prj.sut.connect.QNX
   prj.sut.power cycle
   Sleep    60s  # new change
   Verify QNX keyword offline    Startup done  # new change
   Sleep    10s
 
   Open Connection    ${sut.com.QNX_HOST}
   Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
   Log To Console    Connection is successful
   Get Connection
 
   # Step 1: Remount /mnt as writable
   Write    mount -uw /mnt
 
   # Step 2: Navigate to the directory of config file
   Write    cd /mnt/etc
 
   # Step 3: List files to confirm file existence
   Write    ls
   ${output}    Read
   Should Contain    ${output}    dlt_message_filter.conf
   Log To Console    dlt_message_filter.conf file exists!
 
 
   # Step 4: Sync changes to disk
   Write    sync
 
   Open Connection    ${sut.com.QNX_HOST}
   Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
   Log To Console    Connection is successful
   Get Connection
 
   # Step 5: Remount and navigate again (IMPORTANT)
   Write    cd /mnt/etc
 
   # Step 5: Confirm the change
   Write    grep DefaultLevel dlt_message_filter.conf
   ${new_output_1}    Read
   Log To Console    The Default value: ${new_output_1}
 
   Should Contain    ${new_output_1}    DefaultLevel = 100

EnvD_SysQual_Diagnostics_TracingDLT_Config_MultipleLevels
   [Documentation]   The tracing subsystem shall provide ability to configure multiple levels of details.
   [Tags]    FULLTEST    CustomerDiagnostic    TCID-541077   FID-2519096
   Close All Connections

   prj.sut.connect.QNX
   prj.sut.power cycle
   Sleep    60s  # new change
   Verify QNX keyword offline    Startup done  # new change
   Sleep    10s

   Open Connection    ${sut.com.QNX_HOST}
   Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
   Log To Console    Connection is successful
   Get Connection

   # Step 1: Remount /mnt as writable
   Write    mount -uw /mnt

   # Step 2: Navigate to the directory of config file
   Write    cd /mnt/etc

   # Step 3: List files to confirm file existence
   Write    ls
   ${output}    Read
   Should Contain    ${output}    dlt.conf
   Log To Console    dlt.conf file exists!

   # Step 4: Change ContextLogLevel  to 0
   Write    sed -i 's/^ContextLogLevel *= *4/ContextLogLevel = 0/' dlt.conf

   # Step 5: Sync changes to disk
   Write    sync

   # Step 6: Power cycle
   prj.sut.power cycle
   Sleep    10s

   Open Connection    ${sut.com.QNX_HOST}
   Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
   Log To Console    Connection is successful
   Get Connection

   # Step 7: Remount and navigate again (IMPORTANT)
   Write    cd /mnt/etc

   # Step 8: Confirm the change
   Write    grep ContextLogLevel dlt.conf
   ${new_output_1}    Read
   Log To Console    The ContextLogLevel value: ${new_output_1}

   Should Contain    ${new_output_1}    ContextLogLevel = 0

   prj.sut.clear.logs.qnx
   prj.sut.connect.QNX
   prj.sut.power cycle
   Sleep    60s  # new change
   Set Test Status To Fail    error_type=DIAGNOSIS    info_text=Trace found
   Verify QNX keyword offline    Startup done  # new change
   Sleep    10s

EnvD_SysQual_Diagnostics_VehicleIdentificationNumber_Chassisnumber(0xF190)(Default Session)
    [Documentation]    The data shall be obtained from the Message "VIN_01_MUX".
    ...    The DID VehicleIdentificationNumber shall give the chassis number.

    [Tags]    CustomerDiagnostic    ExternalDiagnostic    FID-1132964,1132965,1132967,1132968    TCID-518813    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.power cycle
    Sleep    40s
    prj.sut.can.diag.tester.present.active
    Sleep    5s
    # Set the New VIN value to the VIN_01 message
    prj.sut.com.set VIN Value    23456789123456781
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send the VIN request
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Modified_Default_Resp_New}
    sleep    3s
    prj.sut.power cycle
    sleep    5s
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Modified_Default_Resp_New}
    # Set the VIN value to the Default value
    prj.sut.com.set VIN Value    12345678912345678
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Default_Resp_New}

EnvD_SysQual_Diagnostics_VehicleIdentificationNumber_Chassisnumber(0xF190)(Extended Session)
    [Documentation]    The DID VehicleIdentificationNumber shall give the chassis number in extended mode
    [Tags]    CustomerDiagnostic    TCID-518811    FULLTEST    FID-1132964,1132965,1132967,1132968
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.power cycle
    Sleep    40s
    prj.sut.can.diag.tester.present.active
    Sleep    5s
    # Set the New VIN value to the VIN_01 message
    prj.sut.com.set VIN Value    23456789123456781
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send the VIN request
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Modified_Default_Resp_New}
    sleep    3s
    prj.sut.power cycle
    sleep    5s
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Modified_Default_Resp_New}
    # Set the VIN value to the Default value
    prj.sut.com.set VIN Value    12345678912345678
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Default_Resp_New}

EnvD_SysQual_Diagnostics_Service_Identification_Extended(0x01D8)
    [Documentation]    Make sure that DUT is communicating and the handshaking with the tester is established and Update
    ...    Ignition status (ZAS_Kl_15) with the value. Send the request 22 03 0D and see the response as 62 03 0D
    [Tags]    CustomerDiagnostic    TCID-518891    FID-3701921,3701920,3701922,3701924    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.Service_Identification_Req}
    Sleep    500ms
    prj.sut.diag.compare.byte.range    ${sut.diag.Service_Identification_Resp}    0    8
    Sleep    500ms
    prj.sut.diag.DID.Length.Validation    ${sut.diag.Service_Identification_Req}    ${sut.diag.Service_Identification_Resp}
    ...    ${sut.diag.DID.Lenght_70}

EnvD_SysQual_Diagnostics_Service_Identification_Extended(0x01D8)_NRC12_NRC13_NRC31
    [Documentation]    Test Negative Response for DID(0x 01 D8)
    [Tags]    CustomerDiagnostic    TCID-518892    FID-3666411    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Service_Identification_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Service_Identification_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.send    ${sut.diag.Service_Identification_IncorrectMessageLengthMore_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostic_ResetIpCounterWrongTcpPorts_(0x05E5)_(Default_Session)_(Extended_session)
    [Documentation]    In Default Session
    ...    Request 31 01 05 EB 00 00 00 and see the Response as 71 01 05 EB 24
    ...    In Extended Session
    ...    Request 31 01 05 EB 00 00 00 and see the Response as 71 01 05 EB 24
    [Tags]    CustomerDiagnostic    TCID-518831    FID-3672806,3672805    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongTcpPorts_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    500ms
    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongTcpPorts_Resp}

EnvD_SysQual_Diagnostics_UFSHealthData(0x0360)(Extended Session)
    [Documentation]    This DID(0xFEFE) shall give the UFS Health Data
    [Tags]    CustomerDiagnostic    ExternalDiagnostic    FID-3569017,3569014,3569018,3569013,3569015    TCID-518826    FULLTEST
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.UFS_Health_Data_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.UFS_Health_Data_Resp}

EnvD_SysQual_Diagnostics_UFSHealthData(0x0360)(Negative Response)
    [Documentation]    This DID(0x0360) shall give the UFS Health Data
    [Tags]    CustomerDiagnostic    ExternalDiagnostic    FID-3569019    TCID-518832    FULLTEST    ProgrammingSession
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.UFS_Health_Data_IncorrectMessageLengthExtra_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.UFS_Health_Data_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.UFS_Health_Data_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SlaveComponentList(0x061A)(Negative Response)
    [Documentation]    This DID(0x0360) shall give the UFS Health Data
    [Tags]    CustomerDiagnostic    ExternalDiagnostic    FID-5447139,3574719    TCID-518824    FULLTEST    ProgrammingSession
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.WriteSlaveComponentList_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.UFS_Health_Data_IncorrectMessageLengthLess_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.UFS_Health_Data_IncorrectMessageLengthExtra_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.WriteSlaveComponentList_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Security_Access_Denied}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.WriteSlaveComponentList_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

EnvD_SysQual_ExternalDiagnostics_CoolantTempExternal_DIDResponse
    [Documentation]    Checking positive response for External Coolant temperature
    [Tags]    CustomerDiagnostic    ExternalDiagnostics    TCID-539841    FID-4112868
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    prj.sut.can.simulation.Stop
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.can.diag.send    ${sut.diag.ExternalCoolantTemp_Req}
    ${resp}    prj.sut.can.diag.get

    ${hexlist}    Evaluate    [x for x in "${resp}".split() if len(x)==2 and all(c in "0123456789ABCDEFabcdef" for c in x)]

    ${raw_hex}    Set Variable    ${hexlist[-1]}

    ${raw_dec}    Convert To Integer    0x${raw_hex}

    ${temp}    Evaluate    (${raw_dec} * 0.75) - 40

    Log To Console    Raw Hex: ${raw_hex}
    Log To Console    Raw Decimal: ${raw_dec}
    Log To Console    Temperature: ${temp} °C

EnvD_SysQual_FailureManagement_RainIntensity_SnapshotData_PositiveResponse
    [Documentation]    To check the Rain Intensity RS_Regenmenge signal, trigger a DTC and observe the changed signal value
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-539840    FID-3800708,3800709
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.diag.SetETHSignal    234    11    # setting the value to 0B
    # prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    # prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Raw_Resp}

    prj.sut.can.diag.send    ${sut.diag.RainIntensity_req}
    prj.sut.diag.compare    ${sut.diag.RainIntensity_resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    10s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Raw2_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_CustomerDiagnostic_FailureManagement_AmbientBrightness_PositiveResponse
    [Documentation]    To change the ambient brightness and trigger a DTC to comapre the snapshot record value
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-539842    FID-3784657,3784658
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    126    200        # setting the value to C8
    prj.sut.can.diag.send    ${sut.diag.AmbientBrightness_req}
    prj.sut.diag.compare    ${sut.diag.AmbientBrightness_resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Raw3_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_FailureManagement_HumiditySensorOutside_positiveResponse
    [Documentation]    To change the humidity sensor value and trigger a DTC to compare the snapshot record value
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-539844    FID-3784655,3784656
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    97    10        # setting the value to 0A
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_req}
    prj.sut.diag.compare    ${sut.diag.Humidity_Sensor_Outside_resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Raw4_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostic_FailureManagement_DMAD_ConnectivityState_positiveResponse
    [Documentation]    To check the value of DMAD_Connectivity_State in the snapshot data record using DTC trigger
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-539837    FID-4113378,4113377        # 3784640,3784639

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    53    1        # setting the value to 01
    prj.sut.can.diag.send    ${sut.diag.RainIntensity_req_DMAD}
    prj.sut.diag.compare    ${sut.diag.RainIntensity_resp_DMAD}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Raw5_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_FailureManagement_DriverModeDetectionBlade_positiveResponse
    [Documentation]    To change the Driving Mode detection value and trigger a DTC to compare the snapshot record value
    [Tags]    CustomerDiagnostic    FailureManagement    TCID-539839    FID-378639,3784640

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    90    0A        # setting the value to 0A
    prj.sut.can.diag.send    ${sut.diag.FahrModEr_StatMod_req}
    prj.sut.diag.compare    ${sut.diag.FahrModEr_StatMod_resp}

    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_FahrModEr_StatMod_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ExternalDiagnostics_Operation_Lifetime_Operating_Time_of_the_Blade
    [Documentation]    Read Operating Time DID and convert bytes 4–7 into minutes
    [Tags]    CustomerDiagnostic    Diagnostics    OperatingTime    TCID-548044    FID-366458,366457

    # Send diagnostic request
    prj.sut.can.diag.send    ${sut.diag.OperatingTime_Req}
    ${resp}    prj.sut.can.diag.get
    Should Not Be Empty    ${resp}
    Log To Console    Full diagnostic response: ${resp}
    ${time_bytes}    prj.sut.can.diag.get.byte.range    9    21
    Log To Console    Operating time raw bytes: ${time_bytes}

    # Split returned bytes into list
    ${byte_list}    Split String    ${time_bytes}    ${SPACE}

    ${minutes}    Evaluate    int("${byte_list[3]}${byte_list[2]}${byte_list[1]}${byte_list[0]}", 16)

    Log To Console    Operating Time (minutes): ${minutes}
