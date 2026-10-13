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
# ${AURIXDEBUG_VERSION}    ${AURIXDEBUG_VERSION}
# ${AURIXDEBUG_URL}    ${AURIXDEBUG_URL}
# ${KDS_FLASH}    ${KDS_FLASH}
# ${AURIX_VERSION}    ${AURIX_VERSION}
# ${SOC_VERSION}    ${SOC_VERSION}
# ${SAIL_VERSION}    ${SAIL_VERSION}


*** Test Cases ***

# #  Diagnostic Start Here ########################################################
EnvD_SysQual_Diagnostics_ActiveDiagnosticSession(0xF186)_NegativeResponse
    [Documentation]    	To test negative response for ActiveDiagnosticSession(0xF186)
    [Tags]    CustomerDiagnostic    TCID-272508    FULLTEST	FID-1132893    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_AUTOSARStandardApplicationSoftwareIdentification(0xF1AF)_NegativeResponse
    [Documentation]    To test negative response for AUTOSARStandardApplicationSoftwareIdentification (0xF1AF)
    [Tags]    CustomerDiagnostic    TCID-272512    FULLTEST	FID-1132982    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send
    ...    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send
    ...    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send
    ...    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send
    ...    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send
    ...    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send
    ...    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_BasicSettingStatus(0x0102)_NegativeResponse
    [Documentation]    To test negative response for BasicSettingStatus(0x0102)
    [Tags]    CustomerDiagnostic    TCID-272505    FULLTEST	FID-1132902    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_IncorrectMsgLengthLess_Req}}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ECUExtractVersionInformation(0xFD07)_NegativeResponse
    [Documentation]    To test negative response for ECUExtractVersionInformation(0xFD07)
    [Tags]    CustomerDiagnostic    TCID-272516    FULLTEST	FID-1435093    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ECUProgrammingInformation(0xF1DF)_NegativeResponse
    [Documentation]    To test negative response for ECUProgrammingInformation(0xF1DF)
    [Tags]    CustomerDiagnostic    TCID-272542    FULLTEST	FID-1440111    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ECUProgrammingInformation(0xF1DF)(Programming Session)
    [Documentation]    This DataIdentifier indicates the programmability and program
    ...    consistency of the server. This refers to the consistency with regard
    ...    to software and software and hardware.
    [Tags]    CustomerDiagnostic    TCID-272504    FULLTEST	FID-1440104,1440106,1440107,1440109,1440110    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_Req}
    prj.sut.diag.compare    ${sut.diag.ECUProgrammingInformation_Programmable_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit


EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)_NegativeResponse
    [Documentation]    To test negative response for ECUSerialNumber(0xF18C)
    [Tags]    CustomerDiagnostic    TCID-272538    FULLTEST	FID-1150976    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Programming Session)
    [Documentation]    The DID ECUSerialNumber shall give the Serial Number of each of the Blade
    [Tags]    CustomerDiagnostic    TCID-272620    FULLTEST	FID-1150970,1150971,1150972,1150974,1150975    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUSerialNumber_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_CommunicationControl($28)_EnableRxAndDisableTxControl(Programming Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-491570    FULLTEST    FID-1453617,1453618,1367233,1367234,4600905    ProgrammingSession
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    prj.sut.diag.compare    ${sut.diag.EnableRxAndDisableTxControl_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_CommunicationControl($28)_EnableRxAndTxControl(Programming Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-491572    FULLTEST    FID-1453617,1453618,1367233,1367234,4600905    ProgrammingSession
    prj.sut.diag.SetETHSignal    0    0
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_Req}
    prj.sut.diag.compare    ${sut.diag.EnableRxAndTxControl_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit


EnvD_SysQual_Diagnostics_VWSystemNameOrEngineType(0xF197)_NegativeResponse
    [Documentation]    The DID SystemNameOrEngineType shall give the information
    ...    about the system name of the Blade
    [Tags]    CustomerDiagnostic    TCID-272555    FULLTEST	FID-1383253    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWSystemFirmwareVersion(0xF1B8)_NegativeResponse
    [Documentation]    To test negative response for VWSystemFirmwareVersion(0xF1B8)
    [Tags]    CustomerDiagnostic    TCID-272549    FULLTEST	FID-1453710    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWSystemFirmwareVersion(0xF1B8)(Programming Session)
    [Documentation]    This DataIdentifier identifies the hardware-related software versions of the Blade
    [Tags]    CustomerDiagnostic    TCID-272575    FULLTEST	FID-1453704,1453705,1453706,1453708,1453709    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemFirmwareVersion_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VW Spare Part Number(0xF187)_NegativeResponse
    [Documentation]    To test negative response for VW Spare Part Number(0xF187)
    [Tags]    CustomerDiagnostic    TCID-272544    FULLTEST	FID-1440275    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VW_Spare_Part_Number(0xF187)(Programming Session)
    [Documentation]    This DataIdentifier identifies the Blade specific part number of a control unit.
    [Tags]    CustomerDiagnostic    TCID-272588    FULLTEST	FID-1440269,1440270,1440271,1440273,1440274    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWSparePartNumber_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit


EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockLockValue(0x040F)_NegativeResponse
    [Documentation]    To test negative response for VWLogicalSoftwareBlockLockValue(0x040F)
    [Tags]    CustomerDiagnostic    TCID-272541    FULLTEST	FID-1691100    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockLockValue(0x040F)(Programming Session)
    [Documentation]    This Data Identifier identifies blocking values for the counters of
    ...     the programming attempts (lock value) of the corresponding logical software block #1-#n
    [Tags]    CustomerDiagnostic    TCID-272637    FULLTEST	FID-1691094,1691095,1691096,1691098,1691099    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockLockValue_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

# EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockCounterOfProgrammingAttempts(0x0407)(Default Session)
#     [Documentation]    The DID VWLogicalSoftwareBlockCounterOfProgrammingAttempts Identifies
#     ...     the counter for the programming attempts (counter value) of a logical software block (1 to n).
#     [Tags]    CustomerDiagnostic    TCID-272581    FULLTEST	FID-1383418,1383419,1383420,1383422,1383423    ProgrammingSession

#     # depends on how much is the counter. to check how to set the counter back to zero
#     # need to use vflash/ODIS to increase counter
#     Set Test Status to fail    error_type=Diagnostic    info_text=UDS Programming Failed (KIV) -ODIS

#     prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

#     # send command
#     prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

#     # compare the positive response
#     prj.sut.diag.compare.byte.range    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Resp}    0    8

#     # verify & take the last Byte
#     ${lastbyte}    prj.sut.can.diag.get.byte.range    9    14
#     Log To Console    The current Counter is ${lastbyte}

#     # put into new Variable
#     ${currentinteger}    Convert To Integer    0x${lastbyte}

#     # make variable +1
#     ${expectedcounter}    evaluate    ${currentinteger} + ${COUNTERPLUS1}

#     # send programming state but make it Fail
#     prj.sut.diag.SetETHSignal    0    500
#     prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

#     prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.SessionControl_VehicleSpeedTooHigh_Resp}

#     # send command again
#     prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

#     prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

#     # take the last Byte
#     ${newlastbyte}    prj.sut.can.diag.get.byte.range    9    14
#     ${latestinteger}    Convert To Integer    0x${newlastbyte}
#     Log To Console    The latest Counter is ${latestinteger}. Before it was ${currentinteger}

#     # compare with the 1st variable +1
#     IF    ${latestinteger} == ${expectedcounter}
#         Log To Console    The Counter increased from ${currentinteger} to ${latestinteger}.
#         Log To Console    Test Case PASS!!
#     ELSE
#         Log    ${latestinteger} is not the same as ${expectedcounter}    console=True
#         Set Test Status To Fail    error_type=DIAGNOSIS
#     END

# EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockCounterOfProgrammingAttempts(0x0407)(Extended Session)
#     [Documentation]    The DID VWLogicalSoftwareBlockCounterOfProgrammingAttempts Identifies
#     ...     the counter for the programming attempts (counter value) of a logical software block (1 to n).
#     [Tags]    CustomerDiagnostic    TCID-272587    FULLTEST	FID-1383418,1383419,1383420,1383422,1383423    ProgrammingSession

#     # depends on how much is the counter. to check how to set the counter back to zero
#     # need to use vflash/ODIS to increase counter
#     Set Test Status to fail    error_type=Diagnostic    info_text=UDS Programming Failed (KIV) -ODIS
#     prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

#     # send command
#     prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

#     # compare the positive response
#     prj.sut.diag.compare.byte.range    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Resp}    0    8

#     # verify & take the last Byte
#     ${lastbyte}    prj.sut.can.diag.get.byte.range    9    14
#     Log To Console    The current Counter is ${lastbyte}

#     # put into new Variable
#     ${currentinteger}    Convert To Integer    0x${lastbyte}

#     # make variable +1
#     ${expectedcounter}    evaluate    ${currentinteger} + ${COUNTERPLUS1}

#     # send programming state but make it Fail
#     prj.sut.diag.SetETHSignal    0    500
#     Sleep    3s
#     prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.SessionControl_VehicleSpeedTooHigh_Resp}

#     # send command again
#     prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

#     prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

#     # take the last Byte
#     ${newlastbyte}    prj.sut.can.diag.get.byte.range    9    14
#     ${latestinteger}    Convert To Integer    0x${newlastbyte}
#     Log To Console    The latest Counter is ${latestinteger}. Before it was ${currentinteger}

#     # compare with the 1st variable +1
#     IF    ${latestinteger} == ${expectedcounter}
#         Log To Console    The Counter increased from ${currentinteger} to ${latestinteger}.
#         Log To Console    Test Case PASS!!
#     ELSE
#         Log    ${latestinteger} is not the same as ${expectedcounter}    console=True
#         Set Test Status To Fail    error_type=DIAGNOSIS
#     END

# EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockCounterOfProgrammingAttempts(0x0407)(Programming Session)
#     [Documentation]    The DID VWLogicalSoftwareBlockCounterOfProgrammingAttempts Identifies
#     ...     the counter for the programming attempts (counter value) of a logical software block (1 to n).
#     [Tags]    CustomerDiagnostic    TCID-272584    FULLTEST	FID-1383418,1383419,1383420,1383422,1383423    ProgrammingSession

#     # send programming state but make it Fail
#     Set Test Status to fail    error_type=Diagnostic    info_text=UDS Programming Failed (KIV) -ODIS
#     prj.sut.diag.SetETHSignal    0    600
#     Sleep    3s
#     prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.SessionControl_VehicleSpeedTooHigh_Resp}

#     prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}
#     prj.sut.diag.checkbyte    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Resp}
#     ${Result}    Run keyword and return status    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_00_Resp}
#     IF    not ${False}
#       Log to console    Counter is not zero
#     ELSE
#       Set test Status to Fail    error_type=Diagnostic    info_text=SoftwareBlockCounterOfProgrammingAttempts Counter should not be zero
#     END

#     prj.sut.can.diag.ProgrammingSession.Enter
#     prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}
#     prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_00_Resp}
#     prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockCounterOfProgrammingAttempts(0x0407)_NegativeResponse
    [Documentation]    The DID VWLogicalSoftwareBlockCounterOfProgrammingAttempts Identifies
    ...     the counter for the programming attempts (counter value) of a logical software block (1 to n).
    [Tags]    CustomerDiagnostic    TCID-272494    FULLTEST	FID-1383424    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_RollerTestStandMode(0x04FB)_NegativeResponse
    [Documentation]    To test negative response for RollerTestStandMode(0x04FB)
    [Tags]    CustomerDiagnostic    TCID-272500    FULLTEST	FID-1132916    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_RollerTestStandMode(0x04FB)_NegativeResponse_Write
    [Documentation]    To test negative response for RollerTestStandMode(0x04FB) $2E write command
    [Tags]    CustomerDiagnostic    TCID-272528    FULLTEST	FID-1151274,1151322,1151323    ProgrammingSession

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length NRC13
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Write_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    # Send command with incorrect extra message length NRC13
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Write_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    # Send command with wrong value NRC31
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWriteWrongValue_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of system supplier ECU software version number NRC7F
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

    # # Go to programming session
    # prj.sut.can.diag.ProgrammingSession.Enter

    # # Send command of system supplier ECU software version number NRC31
    # prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    # prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}
    # prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareNumber(0xF192)(Programming Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW number
    [Tags]    CustomerDiagnostic    TCID-272601    FULLTEST	FID-1150982,1150983,1150984,1150986,1150987    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    # send command for SystemSupplierECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareNumber_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareNumber(0xF192)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierECUHardwareVersionNumber(0xF193)
    [Tags]    CustomerDiagnostic    TCID-272546    FULLTEST	FID-1150988    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareVersionNumber(0xF193)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierECUHardwareVersionNumber(0xF193)
    [Tags]    CustomerDiagnostic    TCID-272523    FULLTEST	FID-1150999    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareVersionNumber(0xF193)(Programming Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW version number in programming mode

    [Tags]    CustomerDiagnostic    TCID-272635    FULLTEST	FID-1150992,1150994,1150995,1150997,1150998    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    # send command for ECU hardware version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SystemSupplierECUSoftwareVersionNumber(0xF195)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierECUSoftwareVersionNumber(0xF195)

    [Tags]    CustomerDiagnostic    TCID-272532    FULLTEST	FID-1151153,2873004    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SystemSupplierECUSWNumber(0xF194)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierECUSWNumber(0xF194)

    [Tags]    CustomerDiagnostic    TCID-272519    FULLTEST	FID-1150965    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command of system supplier supplier ECUSW number
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SystemSupplierIdentification(0xF18A)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierIdentification(0xF18A)

    [Tags]    CustomerDiagnostic    TCID-272531    FULLTEST	FID-1150955    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command in programming session
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit


EnvD_SysQual_Diagnostics_TechnicalSpecificationsVersion(0xF1B4)_NegativeResponse
    [Documentation]    To test negative response for TechnicalSpecificationsVersion(0xF1B4)

    [Tags]    CustomerDiagnostic    TCID-272535    FULLTEST	FID-1132927    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.tester.present.active
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command in programming session
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Tester_Present(Programming Session)
    [Documentation]    This service shall be used to keep the server in a diagnostic session other than the default Session.
    ...    This service is used to indicate to a server (or servers)
    ...    that a client is still connected to the vehicle and that
    ...    certain diagnostic services and/or communication that
    ...    have been previously activated are to remain active.

    [Tags]    CustomerDiagnostic    TCID-272518    FULLTEST	FID-1069374,1069377,1069379    ProgrammingSession

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send tester present
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}

    # Wait for 4.5s
    Sleep    4.5s

    # Check active session
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ProgrammingSession_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VehicleIdentificationNumber(0xF190)_NegativeResponse
    [Documentation]    To test negative response for VehicleIdentificationNumber(0xF190)
    [Tags]    CustomerDiagnostic    TCID-272493    FULLTEST	FID-1132969    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command in programming session
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VW_FAZIT_Identification(0xF17C)(Programming Session)
    [Documentation]    This Data Identifier identifies the FAZIT identification number of a blade in programming mode.
    [Tags]    CustomerDiagnostic    TCID-272612    FULLTEST	FID-1692043,1692044,1692045,1692047,1692048    ProgrammingSession

    # Go to Programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # send VW spare part number
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_Req}
    prj.sut.diag.compare    ${sut.diag.VW_FAZIT_Identification_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VW_FAZIT_Identification(0xF17C)_NegativeResponse
    [Documentation]    To test negative response for VW_FAZIT_Identification(0xF17C)
    [Tags]    CustomerDiagnostic    TCID-272552    FULLTEST	FID-1692049    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Fingerprint(0xF15A)
    [Documentation]    This DataIdentifier is used to transfer the workshop code and date of
    ...    the currently connected client to the server. During programming, it is transferred
    ...    to the server in the boot loader and stored in the RAM. The data is then stored
    ...    internally in the EEPROM for each logical block (application, boot loader, data)
    ...    that has been programmed. The Data Identifier "0xF15B-Fingerprint And Programmin
    ...     Date Of Logical Software Blocks" is used for output.
    [Tags]    CustomerDiagnostic    TCID-272636    FULLTEST	FID-1802998,1802999,1803000,1803002,1803003    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Req}
    prj.sut.diag.compare    ${sut.diag.Fingerprint_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Fingerprint(0xF15A)_NegativeResponse
    [Documentation]    To test negative response for Fingerprint(0xF15A)
    [Tags]    CustomerDiagnostic    TCID-272539    FULLTEST	FID-1803004    ProgrammingSession

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Fingerprint_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_Fingerprint(0xF15A)_NegativeResponse_Write
    [Documentation]    To test negative response for Fingerprint(0xF15A) $2E write command
    [Tags]    CustomerDiagnostic    TCID-272550    FULLTEST	FID-1803937    ProgrammingSession

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.Seed_Req}
    ${SeedData}    prj.sut.can.diag.get.byte.range    0    18
    Log To Console    ${SeedData}
 
    ${result}=    Run Process    python    ${TAF_PATH}/project/testbench/config/Partnumber_code/seedkey2712.py
...    --response
...    ${SeedData}
...    stdout=PIPE
...    stderr=PIPE
 
    ${matches}=    Get Regexp Matches    ${result.stdout}    key_bytes:\\s*([0-9A-F]{2}\\s+[0-9A-F]{2}\\s+[0-9A-F]{2}\\s+[0-9A-F]{2})
    ${key_bytes}=    Set Variable    ${matches}[0]
 
    Log To Console    Key Bytes = ${key_bytes}
 
    ${key_bytes}=    Evaluate    re.search(r'key_bytes:\s*([0-9A-F ]+)', '''${result.stdout}''').group(1)    re
 
    ${SecurityAccessReq}=    Set Variable    27 12 ${key_bytes}
 
    Log To Console    Sending: ${SecurityAccessReq}
 
    prj.sut.can.diag.send    ${SecurityAccessReq}
    prj.sut.diag.compare     ${sut.diag.SecurityLevel_Resp}
    
    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

EnvD_SysQual_Diagnostics_FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)(Default Session)
    [Documentation]    This DID FingerprintAndProgrammingDateOfLogicalSoftwareBlocks is used to read out the list
    ...     of all fingerprint, date and status information of the logical software
    ...     blocks (application, boot loader, data) of the server.
    [Tags]    CustomerDiagnostic    TCID-272605    FULLTEST	FID-1383302,1383303,1383304,1383306,1383307    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    prj.sut.diag.checkbyte    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Resp}
    # ${Resul}    prj.sut.can.diag.get
    # IF    "${Resul}" == "${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_NoFlash_Resp}"
    #         Log To Console    Blade has NOT been flashed before
    #         prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    #         prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #         prj.sut.can.diag.ProgrammingSession.Enter

    #         prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    #         prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Resp}
    #         prj.sut.can.diag.ProgrammingSession.Exit

    #         prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    #         prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    #         prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    #         prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Resp}
    # ELSE
    #         Log To Console    Blade has been flashed before
    #         prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    #         prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #         prj.sut.can.diag.ProgrammingSession.Enter
    #         prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    #         prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Resp}
    #         prj.sut.can.diag.ProgrammingSession.Exit
    #         prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    #         prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    #         prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    #         prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Variation2_Resp}
    # END

EnvD_SysQual_Diagnostics_FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)(Extended Session)
    [Documentation]    This DID FingerprintAndProgrammingDateOfLogicalSoftwareBlocks is used to read out the list
    ...     of all fingerprint, date and status information of the logical software
    ...     blocks (application, boot loader, data) of the server.
    [Tags]    CustomerDiagnostic    TCID-272609    FULLTEST	FID-1383302,1383303,1383304,1383306,1383307    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    prj.sut.diag.checkbyte    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Resp}
    # ${Resul}    prj.sut.can.diag.get
    # IF    "${Resul}" == "${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_NoFlash_Resp}"
    #         Log To Console    Blade has NOT been flashed before
    #         prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    #         prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #         prj.sut.can.diag.ProgrammingSession.Enter

    #         prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
    #         prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}
    #         prj.sut.can.diag.ProgrammingSession.Exit

    #         prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    #         prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #         prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    #         prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Resp}
    # ELSE
    #         Log To Console    Blade has been flashed before
    #         prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    #         prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #         prj.sut.can.diag.ProgrammingSession.Enter

    #         prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Variation2_Req}
    #         prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}
    #         prj.sut.can.diag.ProgrammingSession.Exit

    #         prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    #         prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #         prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    #         prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Variation2_Resp}
    # END

EnvD_SysQual_Diagnostics_FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)(Programming Session)
    [Documentation]    This DID FingerprintAndProgrammingDateOfLogicalSoftwareBlocks is used to read out the list
    ...     of all fingerprint, date and status information of the logical software
    ...     blocks (application, boot loader, data) of the server.
    [Tags]    CustomerDiagnostic    TCID-272608    FULLTEST	FID-1383302,1383303,1383304,1383306,1383307    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    prj.sut.diag.checkbyte    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Resp}
    # ${Resul}    prj.sut.can.diag.get
    # IF    "${Resul}" == "${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_NoFlash_Resp}"
    #         Log To Console    Blade has NOT been flashed before

    #         prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
    #         prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

    #         prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    #         prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Resp}
    # ELSE
    #         Log To Console    Blade has been flashed before

    #         prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Variation2_Req}
    #         prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

    #         prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    #         prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Variation2_Resp}
    # END
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)_NegativeResponse
    [Documentation]    To test negative response for FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)
    [Tags]    CustomerDiagnostic    TCID-272524    FULLTEST	FID-1383308    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Fingerprint_Write(0xF15A)
    [Documentation]    This Data Identifier is used to transfer the workshop code
    ...    and date of the currently connected client to the server during programming.
    [Tags]    CustomerDiagnostic    TCID-272606    FULLTEST	FID-1803931,1803932,1803933,1803935,1803936    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Req}
    prj.sut.diag.compare    ${sut.diag.Fingerprint_Resp}

    prj.sut.can.diag.send    ${sut.diag.Seed_Req}
    ${SeedData}    prj.sut.can.diag.get.byte.range    0    18
    Log To Console    ${SeedData}
 
    ${result}=    Run Process    python    ${TAF_PATH}/project/testbench/config/Partnumber_code/seedkey2712.py
...    --response
...    ${SeedData}
...    stdout=PIPE
...    stderr=PIPE
 
    ${matches}=    Get Regexp Matches    ${result.stdout}    key_bytes:\\s*([0-9A-F]{2}\\s+[0-9A-F]{2}\\s+[0-9A-F]{2}\\s+[0-9A-F]{2})
    ${key_bytes}=    Set Variable    ${matches}[0]
 
    Log To Console    Key Bytes = ${key_bytes}
 
    ${key_bytes}=    Evaluate    re.search(r'key_bytes:\s*([0-9A-F ]+)', '''${result.stdout}''').group(1)    re
 
    ${SecurityAccessReq}=    Set Variable    27 12 ${key_bytes}
 
    Log To Console    Sending: ${SecurityAccessReq}
 
    prj.sut.can.diag.send    ${SecurityAccessReq}
    prj.sut.diag.compare     ${sut.diag.SecurityLevel_Resp}
 
    #    Write Fingerprint F15A
    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
    prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}
 
    #    Read Fingerprint F15A
    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Req}
    prj.sut.diag.compare     ${sut.diag.Fingerprint_Resp1}
 
    prj.sut.can.diag.ProgrammingSession.Exit

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Req}
    prj.sut.diag.compare    ${sut.diag.Fingerprint_Resp}

    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_IpCounterDroppedIpv6PacketsLayer3(0x01A0)_NegativeResponse
    [Documentation]    To test negative response for IpCounterDroppedIpv6PacketsLayer3(0x01A0)
    [Tags]    CustomerDiagnostic    TCID-272492    FULLTEST	FID-1383442    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_IpCounterDroppedUdpTcpPacketsLayer4(0x01A1)_NegativeResponse
    [Documentation]    To test negative response for IpCounterDroppedUdpTcpPacketsLayer4(0x01A1)
    [Tags]    CustomerDiagnostic    TCID-272536    FULLTEST	FID-1692039    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_IpCounterWrongIpv6Addresses(0x0A2C)_NegativeResponse
    [Documentation]    To test negative response for IpCounterWrongIpv6Addresses(0x0A2C)
    [Tags]    CustomerDiagnostic    TCID-272495    FULLTEST	FID-1665045    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_IpCounterWrongUdpPorts(0x0A2F)_NegativeResponse
    [Documentation]    To test negative response for IpCounterWrongUdpPorts(0x0A2F)
    [Tags]    CustomerDiagnostic    TCID-272547    FULLTEST	FID-1394237    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)_NegativeResponse
    [Documentation]    To test negative response for IpIpv6AddressesList(0x013D)
    [Tags]    CustomerDiagnostic    TCID-272520    FULLTEST	FID-1691415    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_IpIpv6MultiCastAddressesList(0x013E)_NegativeResponse
    [Documentation]    To test negative response for IpIpv6MultiCastAddressesList(0x013E)
    [Tags]    CustomerDiagnostic    TCID-272517    FULLTEST	FID-1691424    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Programming Preconditions(0x0448)_NegativeResponse
    [Documentation]    To test negative response for Programming Preconditions(0x0448)
    [Tags]    CustomerDiagnostic    TCID-272545    FULLTEST	FID-1665045    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Programming_Preconditions(0x0448)(Programming Session)
    [Documentation]    This DataIdentifier identifies the programming pre-requisites of the Blade
    [Tags]    CustomerDiagnostic    TCID-272616    FULLTEST	FID-1665039,1665040,1665041,1665043,1665044    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_Req}
    prj.sut.diag.compare    ${sut.diag.ProgrammingPreconditions_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWApplicationSoftwareVersionNumber(0xF189)(Programming Session)
    [Documentation]    The DID VWApplicationSoftwareVersionNumber shall give the
    ...    information about the overall SW(ASW+BSW) version number of
    ...    the Blade in programming mode.
    [Tags]    CustomerDiagnostic    TCID-272557    FULLTEST	FID-1151031,1151033,1151034,1151036,1151037    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command VWApplicationSoftwareVersionNumber
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWApplicationSoftwareVersionNumber_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWApplicationSoftwareVersionNumber(0xF189)_NegativeResponse
    [Documentation]    To test negative response for VVWApplicationSoftwareVersionNumber(0xF189)
    [Tags]    CustomerDiagnostic    TCID-272534    FULLTEST	FID-1151038    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)_NegativeResponse
    [Documentation]    To test negative response for VWClearDiagnosticInformationDateFunctional(0xF1B0)

    [Tags]    CustomerDiagnostic    TCID-272553    FULLTEST	FID-1665055    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VVWClearDiagnosticInformationDateFunctional_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VVWClearDiagnosticInformationDateFunctional_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command in programming session
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWECUHardwareNumber(0xF191)(Programming Session)
    [Documentation]    The DID VWECUHardwareNumber shall give the information about the VW HW version number of each blade in programming mode.
    [Tags]    CustomerDiagnostic    TCID-272594    FULLTEST	FID-1151010,1151012,1151013,1151015,1151016    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter
    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareNumber_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWECUHardwareNumber(0xF191)_NegativeResponse
    [Documentation]    To test negative response for VWECUHardwareNumber(0xF191)
    [Tags]    CustomerDiagnostic    TCID-272526    FULLTEST	FID-1151017    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWECUHardwareVersionNumber(0xF1A3)(Programming Session)
    [Documentation]    The DID SystemSupplierECUHardwareVersionNumber shall give
    ...    the information about VW ECU HW version number in programming mode.
    [Tags]    CustomerDiagnostic    TCID-272589    FULLTEST	FID-1151021,1151023,1151024,1151026,1151027    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareVersionNumber_Resp}

    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_VWECUHardwareVersionNumber(0xF1A3)_NegativeResponse
    [Documentation]    To test negative response for VWECUHardwareVersionNumber(0xF1A3)
    [Tags]    CustomerDiagnostic    TCID-272509    FULLTEST	FID-1151028    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.can.diag.ProgrammingSession.Exit

    # 24.3 new test case starts here

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterDroppedIpv6PacketsLayer(0x068C)(NegativeResponse)
    [Documentation]    To test negative response for ResetIpCounterDroppedIpv6PacketsLayer(0x068C)
    [Tags]    CustomerDiagnostic    TCID-353729    FULLTEST    FID-1381301,1381302    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterDroppedUdpTcpPacketsLayer4(0x068D)(NegativeResponse)
    [Documentation]    To test negative response for ResetIpCounterDroppedUdpTcpPacketsLayer4(0x068D)
    [Tags]    CustomerDiagnostic    TCID-353730    FULLTEST    FID-1381301,1805370    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterWrongUdpPorts(0x05EB)(NegativeResponse)
    [Documentation]    To test negative response for ResetIpCounterWrongUdpPorts(0x05EB)
    [Tags]    CustomerDiagnostic    TCID-353733    FULLTEST    FID-1381309,1381301    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ResetIpCounterWrongTcpPorts(0x05E5)(NegativeResponse)
    [Documentation]    To test negative response for ResetIpCounterWrongTcpPorts(0x05E5)
    [Tags]    CustomerDiagnostic    TCID-353731    FULLTEST    FID-1805359,1381301    ProgrammingSession

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Ip_counter_dropped_ethernet_frames_layer_2(0x019f)_NegativeResponse
    [Documentation]    To test negative response for Ip_counter_dropped_ethernet_frames_layer_2
    [Tags]    CustomerDiagnostic    TCID-518852    FID-2845412    FULLTEST        ProgrammingSession
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_dropped_ethernet_frames_layer_2_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

# 24.4RC1

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCSWVersion(0x031F)(Programming Session)
    [Documentation]    The DID  SoCSWVersion shall give the information about the SW Version
    ...     of diagnostics process under QNX.
    [Tags]    CustomerDiagnostic    TCID-404433    FULLTEST    FID-2845882,2845883,2845884,2845886,2845887    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCSWVersion(0x031F)(NegativeResponse)
    [Documentation]    To test negative response for SoCSWVersion(0x031F)
    [Tags]    CustomerDiagnostic    TCID-404428    FULLTEST    FID-2845888    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus1(0x0313)(Programming Session)
    [Documentation]    The DID  DisplayLinkStatus1 shall give the information about the
    ...      Status of link to Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404437    FULLTEST    FID-2845893,2845894,2845895,2845897,2845898    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus1(0x0313)(NegativeResponse)
    [Documentation]    To test negative response for DisplayLinkStatus1(0xFEFD)
    [Tags]    CustomerDiagnostic    TCID-404438    FULLTEST    FID-2845899    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus2(0x0314)(Programming Session)
    [Documentation]    The DID  DisplayLinkStatus2 shall give the information about the
    ...     Status of link to Display#1 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404435    FULLTEST    FID-2845902,2845903,2845904,2845906,2845907    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus2_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus2(0x0314)(NegativeResponse)
    [Documentation]    To test negative response for DisplayLinkStatus2(0x0314)
    [Tags]    CustomerDiagnostic    TCID-404436    FULLTEST    FID-2845908    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit


EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails1(0x031A)(Programming Session)
    [Documentation]    The DID  SerializerDetails1 shall give the information about the
    ...     Serializer Details for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404421    FULLTEST    FID-2845911,2845912,2845913,2845915,2845916    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails1(0x031A)(NegativeResponse)
    [Documentation]    To test negative response for SerializerDetails1(0x031A)
    [Tags]    CustomerDiagnostic    TCID-404416    FULLTEST    FID-2845917    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails2(0x031B)(Programming Session)
    [Documentation]    The DID  SerializerDetails2 shall give the information about the
    ...     Serializer Details for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404425    FULLTEST    FID-2845920,2845921,2845922,2845924,2845925    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails2(0x031B)(NegativeResponse)
    [Documentation]    To test negative response for SerializerDetails2(0x031B)
    [Tags]    CustomerDiagnostic    TCID-404426    FULLTEST    FID-2845926    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters1(0x0318)(Programming Session)
    [Documentation]    The DID  SelectedCounters1 shall give the information about the
    ...     Selected counters for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404423    FULLTEST    FID-2845929,2845930,2845931,2845933,2845934    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters1(0x0318)(NegativeResponse)
    [Documentation]    To test negative response for SelectedCounters1(0xFEF4)
    [Tags]    CustomerDiagnostic    TCID-404424    FULLTEST    FID-2845935    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters2(0x0319)(Programming Session)
    [Documentation]    The DID  SelectedCounters2 shall give the information about
    ...     Selected counters for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404457    FULLTEST    FID-2845938,2845939,2845940,2845942,2845943    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters2(0x0319)(NegativeResponse)
    [Documentation]    To test negative response for SelectedCounters2(0xFEF8)
    [Tags]    CustomerDiagnostic    TCID-404452    FULLTEST    FID-2845944    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature1(0x0315)(Programming Session)
    [Documentation]    The DID  SerializerTemperature1 shall give the Serializer Temperature
    ...     for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404461    FULLTEST    FID-2845947,2845948,2845949,2845951,2845952    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature1(0x0315)(NegativeResponse)
    [Documentation]    To test negative response for SerializerTemperature1(0x0315)
    [Tags]    CustomerDiagnostic    TCID-404462    FULLTEST    FID-2845953    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature2(0x0316)(Programming Session)
    [Documentation]    The DID  SerializerTemperature2 shall give the Serializer Temperature
    ...     for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404459    FULLTEST    FID-2845957,2845958,2845959,2845961,2845962    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature2(0x0316)(NegativeResponse)
    [Documentation]    To test negative response for SerializerTemperature2(0x0316)
    [Tags]    CustomerDiagnostic    TCID-404460    FULLTEST    FID-2845963    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0x0322)(Programming Session)
    [Documentation]    The DID  GVM_Status shall give the information about the  Status of Guest Virtual Machines (GVM) .
    [Tags]    CustomerDiagnostic    TCID-404445    FULLTEST    FID-2845966,2845967,2845968,2845970,2845971    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.GVMStatus_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0x0322)(NegativeResponse)
    [Documentation]    To test negative response for GVMStatus(0xFEFA)
    [Tags]    CustomerDiagnostic    TCID-404440    FULLTEST    FID-2845972    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.GVMStatus_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.GVMStatus_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.GVMStatus_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.GVMStatus_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.GVMStatus_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.GVMStatus_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_OSVersion(0x031C)(NegativeResponse)
    [Documentation]    To test negative response for OSVersion(0x031C)
    [Tags]    CustomerDiagnostic    TCID-404448    FULLTEST    FID-2856762    ProgrammingSession
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length

    prj.sut.can.diag.send    ${sut.diag.OSVersion_IncorrectMessageLengthLess_Req}

    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length

    prj.sut.can.diag.send    ${sut.diag.OSVersion_IncorrectMessageLengthExtra_Req}

    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}

    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length

    prj.sut.can.diag.send    ${sut.diag.OSVersion_IncorrectMessageLengthLess_Req}

    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length

    prj.sut.can.diag.send    ${sut.diag.OSVersion_IncorrectMessageLengthExtra_Req}

    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session

    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length

    prj.sut.can.diag.send    ${sut.diag.OSVersion_IncorrectMessageLengthLess_Req}

    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length

    prj.sut.can.diag.send    ${sut.diag.OSVersion_IncorrectMessageLengthExtra_Req}

    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VWLogicalSoftwareBlockVersion(F1AB)(Programming Session)
    [Documentation]    The DID VWLogicalSoftwareBlockVersion shall give the information about the SW Block version number.
    [Tags]    CustomerDiagnostic    TCID-404399    FULLTEST    FID-2844632,2844634,2844635,2844637,2844638    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockVersion_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VWLogicalSoftwareBlockVersion(F1AB)(NegativeResponse)
    [Documentation]    To test negative response for VWLogicalSoftwareBlockVersion(F1AB)
    [Tags]    CustomerDiagnostic    TCID-404401    FULLTEST    FID-2844639    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileIdentifier(0xF19E)(Programming Session)
    [Documentation]    The DID  ASAMODXFileIdentifier shall give the information about the ASAM ODX File Identifier.
    [Tags]    CustomerDiagnostic    TCID-404404    FULLTEST    FID-2850080,2850081,2850082,2850084,2850085    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileIdentifier_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileIdentifier(0xF19E)(NegativeResponse)
    [Documentation]    To test negative response for ASAMODXFileIdentifier(0xF19E)
    [Tags]    CustomerDiagnostic    TCID-404405    FULLTEST    FID-2850086    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileVersion(0xF1A2)(Programming Session)
    [Documentation]    The DID  ASAMODXFileVersion shall give the information about the ASAM ODX File Version.
    [Tags]    CustomerDiagnostic    TCID-404413    FULLTEST    FID-2845975,2845976,2845977,2845979,2845980    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileVersion_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileVersion(0xF1A2)(NegativeResponse)
    [Documentation]    To test negative response for ASAMODXFileVersion(0xF1A2)
    [Tags]    CustomerDiagnostic    TCID-404411    FULLTEST    FID-2845981    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_BladeComputeInternalTemperature(0x0320)(Programming Session)
    [Documentation]    The DID  BladeComputeInternalTemperature shall give the information about temperatures of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404393    FULLTEST    FID-2872923,2872924,2872925,2872927,2872928    ProgrammingSession
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_BladeComputeInternalTemperature(0x0320)(NegativeResponse)
    [Documentation]    To test negative response for BladeComputeInternalTemperature(0x0320)
    [Tags]    CustomerDiagnostic    TCID-404412    FULLTEST    FID-2872929    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VoltageTerminal30(0x1906)(Programming Session)
    [Documentation]    The DID  VoltageTerminal30 shall give the information about the volage level for KL30.
    [Tags]    CustomerDiagnostic    TCID-404403    FULLTEST    FID-2872971,2872972,2872973,2872975,2872976    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VoltageTerminal30(0x1906)(NegativeResponse)
    [Documentation]    To test negative response for VoltageTerminal30(0x1906)
    [Tags]    CustomerDiagnostic    TCID-404414    FULLTEST    FID-2872977    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_MaaSBladeInternalTemperature(0xFA01)(Programming Session)
    [Documentation]    The DID  MaaSBladeInternalTemperature shall give the MaaS Blade specific temperature of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404394    FULLTEST    FID-2872984,2872985,2872986,2872988,2872989    ProgrammingSession
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_MaaSBladeInternalTemperature(0xFA01)(NegativeResponse)
    [Documentation]    To test negative response for MaaSBladeInternalTemperature(0xFA01)
    [Tags]    CustomerDiagnostic    TCID-404396    FULLTEST    FID-2872990    ProgrammingSession

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Go to programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_SystemSupplierECUSoftwareVersionNumber(0xF195)(Programming Session)
    [Documentation]    The DID SystemSupplierECUSoftwareVersionNumber identifies
    ...    the versions of the different Software elements
    [Tags]    CustomerDiagnostic    TCID-406495    FULLTEST    FID-1151146,1151148,1151149,1151151,1151152,2872998,2872999,2873000,2873002,2873003    ProgrammingSession

    # Go to extended session
    prj.sut.can.diag.ProgrammingSession.Enter

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_NegativeResponse
    [Documentation]    To test negative response for Diagnostic Session Control ($22)

    [Tags]    CustomerDiagnostic    TCID-414749    FULLTEST    FID-1069765,1151322    NegativeTest    ProgrammingSession
    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_IncorrectSubfunction_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ServiceNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ServiceNotSupportedInActiveSession_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_EthernetLinkQuality(0x010D)(Negative Response)
    [Documentation]    The "Ethernet signal quality" shall return the signal quality of all Ethernet interfaces of the ECU.

    [Tags]    CustomerDiagnostic    TCID-414746    FULLTEST    FID-2840368    NegativeTest    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ClearDiagnosticsService($14)_ClearDiagnosticsService(Negative Response)
    [Documentation]    To test negative response for Clear Diagnostics Service ($14)

    [Tags]    CustomerDiagnostic    TCID-414747    FULLTEST    FID-1287767,1151322,4608342    NegativeTest    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_RequestOutOfRange_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_RequestOutOfRange_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_ServiceNotSupported_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ControlDTCSetting($85)_ControlDTCSetting(Negative Response)
    [Documentation]    To test negative response for Control DTC Setting ($85)

    [Tags]    CustomerDiagnostic    TCID-414759    FULLTEST    FID-1287774,1151322    NegativeTest    ProgrammingSession
    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ControlDTCSetting_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ControlDTCSetting_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ControlDTCSetting_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.ControlDTCSetting_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_SubFunctionNotSupported_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_ServiceNotSupportedInActiveSession_Resp}

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_ServiceNotSupportedInActiveSession_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit


EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportNumberOfDTCByStatusMask(0x01)(Negative Response)
    [Documentation]    To test negative response for Read Diagnostics Trouble Code Service ($19)

    [Tags]    CustomerDiagnostic    TCID-414755    FULLTEST    FID-1443758,4600884    NegativeTest    ProgrammingSession

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_ServiceNotSupported_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportDTCByStatusMask(0x02)(Negative Response)
    [Documentation]    To test negative response for Read Diagnostics Trouble Code Service ($19)

    [Tags]    CustomerDiagnostic    TCID-414736    FULLTEST    FID-1443758,4600884    NegativeTest    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_ServiceNotSupported_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportDTCExtDataRecordByDTCNumber(0x06)(Negative Response)
    [Documentation]    To test negative response for Read Diagnostics Trouble Code Service ($19)

    [Tags]    CustomerDiagnostic    TCID-414735    FULLTEST    FID-1443758,4600884    NegativeTest    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_ServiceNotSupported_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportDTCSnapshotRecordByDTCNumber(0x04)(Negative Response)
    [Documentation]    To test negative response for Read Diagnostics Trouble Code Service ($19)

    [Tags]    CustomerDiagnostic    TCID-414742    FULLTEST    FID-1443758,4600884    NegativeTest    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_ServiceNotSupported_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_CommunicationControl($28)_EnableRxAndDisableTxControl(Negative Response)
    [Documentation]    To test negative response for Communication Control ($28)

    [Tags]    CustomerDiagnostic    TCID-414737    FULLTEST    FID-1367305    NegativeTest    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectCommType_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_RequestOutOfRange_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectCommType_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_RequestOutOfRange_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectCommType_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_CommunicationControl($28)_EnableRxAndTxControl(Negative Response)
    [Documentation]    To test negative response for Communication Control ($28)

    [Tags]    CustomerDiagnostic    TCID-414740    FULLTEST    FID-1367305,1151322    NegativeTest    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectCommType_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_RequestOutOfRange_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectCommType_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_RequestOutOfRange_Resp}

    # Programming Session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_IncorrectCommType_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_RoutineControl($31)_CheckPreconditions(0x0203)(Negative Response)
    [Documentation]    To test negative response for Check Preconditions (0x0203)

    [Tags]    CustomerDiagnostic    TCID-414744    FULLTEST    FID-1381300,1151322    NegativeTest    ProgrammingSession
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectRoutine_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectSubfunction_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_SubFunctionNotSupported_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectRoutine_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectSubfunction_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_SubFunctionNotSupported_Resp}

    # Programming Session
    prj.sut.diag.SetETHSignal    0    60
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.Check_Programming_Preconditions_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_RoutineControl($31)_RoutineControl(Negative Response)
    [Documentation]    To test negative response for Routine Control ($31)

    [Tags]    CustomerDiagnostic    TCID-428381    FULLTEST    FID-1338686,1338715,1338718,1338721    NegativeTest    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # To test NRC13
    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_IncorrectMessageLength_Resp}

    # To test NRC31
    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectRoutine_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}

    # To test NRC12
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectSubfunction_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Check_Programming_Preconditions_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_ECUReset($11)_ECUReset(Negative Response)
    [Documentation]    To test negative response for ECU Reset ($11)

    [Tags]    CustomerDiagnostic    TCID-428386    FULLTEST    FID-1316995,1151322    NegativeTest    ProgrammingSession
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Hard_Reset_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_ServiceNotSupportedInActiveSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Key_Off_On_Reset_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_ServiceNotSupportedInActiveSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_SubFunctionNotSupported_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit


EnvD_SysQual_Diagnostics_ProgrammingSessionPreCondition_SupplyVoltageLow($NRC93)
    [Documentation]    The reprogramming shall be rejected with NRC 93 , If the supply voltage is <9Volts

    [Tags]    CustomerDiagnostic    TCID-428384    FULLTEST    FID-2674365    NegativeTest    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    8
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_SupplyVoltageLow_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    Sleep    7s
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    60s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_ProgrammingSessionPreCondition_VehicleSpeedNotZero($NRC88)
    [Documentation]    The requestshall be rejected with NRC 88 , If the vehicle speed is more than or equal to 5kmph
    [Tags]    CustomerDiagnostic    TCID-428388    FULLTEST    FID-1954901    NegativeTest    ProgrammingSession
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.diag.SetETHSignal    0    600
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_VehicleSpeedTooHigh_Resp}

    prj.sut.diag.SetETHSignal    0   400
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    Sleep    7s
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    60s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponseWithSubfunction_SubFunctionNotSupportedInActiveSession
    [Documentation]    To test negative response of NRC 12

    [Tags]    CustomerDiagnostic    TCID-428378    FULLTEST    FID-1151341,1151333    NegativeTest    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ServiceNotSupportedInActiveSession_Resp}

# EnvD_SysQual_Diagnostics_PreConditionEnteringProgrammingSession_ReprogrammingAttempt1000
#     [Documentation]    If the Re-programming attempt value is 1000 and the request to reprogramming is made then the request shall be rejected with NRC 22
#     [Tags]    CustomerDiagnostic    TCID-435016    FULLTEST    FID-1659685
#     Set Test Status To Fail    info_text=Pending ODIS
    # prj.sut.diag.SetETHSignal    0    500
    # prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    # prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # FOR    ${i}    IN RANGE    1000
    #     Log to Console    Sending Programming Session Request ${i + 1} of 1000
    #     prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    #     prj.sut.diag.compare    ${sut.diag.SessionControl_VehicleSpeedTooHigh_Resp}
    # END
    # Log to Console    Invalid Programming Session Request has been sent 1000 times
    # prj.sut.diag.SetETHSignal    0    0
    # prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    # prj.sut.diag.compare    ${sut.diag.SessionControl_ConditionNotCorrect_Resp}

# ###############################################Diag Tanisha ###########################################

EnvD_SysQual_Diagnostics_CurrentConsumptionOfBlade_NegativeResponse
    [Documentation]    Getting the Negative responses for service(0x0321)
    [Tags]    Customer_Diagnostic    TCID-518837    FID-3666434,3666435    ProgrammingSession

    # Step 1: Switch to Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # step2 Send DID request to check short message length NRC
    prj.sut.can.diag.send    ${sut.diag.CurrentConsumption_IncorrectLength_Resp}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # step3 Send DID request to check long message length NRC
    prj.sut.can.diag.send    ${sut.diag.CurrentConsumptionIncorrectLengthExtra_Resp}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # step 5 switch to programming session
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.CurrentConsumption_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_OPMMStatusOfBlade_NegativeResponse
    [Documentation]    getting negative responses for service. #CHECK TEST CASE NAME  TANISHAAAAAAAAAAAAAAAAAAAAAAAA########
    [Tags]    Customer_Diagnostic    TCID-518833    FID-3666450,3666451    ProgrammingSession

    # Step 1 Switch to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # step2 Send DID request to check short message length NRC
    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBladeCAN_ShortLength_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Step 3 Send DID request to check for long message length NRC
    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBladeCAN_ExtendedLength_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Step4 switch to programming session to send DID for out of range request
    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

############## Naveen ##########################################

EnvD_SysQual_Diagnostics_Ethernet_CRC_error_counter(0x010F)_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of ReadDataByIdentifier
    [Tags]    CustomerDiagnostic    TCID-518851    FID-2870648    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.Ethernet_Counter_Checksum_Error_value_Req}

EnvD_SysQual_Diagnostics_ComputeElementTemperatureOfBlade(0x0320)_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 03 20
    [Tags]    CustomerDiagnostic    TCID-518848    FID-3666215    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.ComputeElementTemperatureOfBlade_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.ComputeElementTemperatureOfBlade_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.ComputeElementTemperatureOfBlade_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.ComputeElementTemperatureOfBlade_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.ComputeElementTemperatureOfBlade_Req}

EnvD_SysQual_Diagnostics_IgnitionStatus(0x030D)_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 03 20
    [Tags]    CustomerDiagnostic    TCID-518867    FID-3666259    FULLTEST    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.IgnitionStatusOfTheBlade_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.IgnitionStatusOfTheBlade_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.IgnitionStatusOfTheBlade_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.IgnitionStatusOfTheBlade_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.IgnitionStatusOfTheBlade_Req}

EnvD_SysQual_Diagnostics_EngineStatus(0x02B7)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 02 B7
    [Tags]    CustomerDiagnostic    TCID-518886    FID-3666352,3666351    FULLTEST    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.EngineStatus_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.EngineStatus_IncorrectMessageLengthLMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.EngineStatus_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.EngineStatus_IncorrectMessageLengthLMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.EngineStatus_Req}

EnvD_SysQual_Diagnostics_VWWorkshopSystemName_(0xF1AA)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 F1 AA
    [Tags]    CustomerDiagnostic    TCID-518883    FID-3786756,3786757     FULLTEST    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.VWWorkshopSystemName_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.VWWorkshopSystemName_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.VWWorkshopSystemName_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.VWWorkshopSystemName_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.VWWorkshopSystemName_Req}

EnvD_SysQual_Diagnostics_Ambient_Brightness(0x25B8)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 25 B8
    [Tags]    CustomerDiagnostic    TCID-518889    FID-4112886    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.Ambient_Brightness_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ambient_Brightness_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.Ambient_Brightness_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ambient_Brightness_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.Ambient_Brightness_Req}

EnvD_SysQual_Diagnostics_Rain_Internsity(0x0343)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 03 43
    [Tags]    CustomerDiagnostic    TCID-518872    FID-4112894    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.Rain_Internsity_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Rain_Internsity_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.Rain_Internsity_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Rain_Internsity_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.Rain_Internsity_Req}

EnvD_SysQual_Diagnostics_LvSupplyVoltages1StatusKd(0x0353)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 35 53
    [Tags]    CustomerDiagnostic    TCID-518869    FID-4112902     FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages1StatusKd_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages1StatusKd_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages1StatusKd_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages1StatusKd_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.LvSupplyVoltages1StatusKd_Req}

EnvD_SysQual_DiagnosticsLvSupplyVoltages2StatusKd(0x0354)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 35 54
    [Tags]    CustomerDiagnostic    TCID-518878    FID-4112964    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_2StatusKd_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_2StatusKd_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_2StatusKd_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_2StatusKd_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.LvSupplyVoltages_2StatusKd_Req}

EnvD_SysQual_DiagnosticsLvSupplyVoltages3StatusKd(0x0355)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 35 55
    [Tags]    CustomerDiagnostic    TCID-518875    FID-4112972    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_3StatusKd_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_3StatusKd_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_3StatusKd_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.LvSupplyVoltages_3StatusKd_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.LvSupplyVoltages_3StatusKd_Req}

EnvD_SysQual_Diagnostics_Connectivity_status(0x0356)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 35 56
    [Tags]    CustomerDiagnostic    TCID-518816    FID-4112980    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.Connectivity_status_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Connectivity_status_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.Connectivity_status_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Connectivity_status_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.Connectivity_status_Req}

EnvD_SysQual_Diagnostics__IP_Network_Max_Correction_SyncClock(0x0173)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 01 73
    [Tags]    CustomerDiagnostic    TCID-518810    FID-3701926    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.IP_Network_Max_Correction_SyncClock_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.IP_Network_Max_Correction_SyncClock_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.IP_Network_Max_Correction_SyncClock_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.IP_Network_Max_Correction_SyncClock_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.IP_Network_Max_Correction_SyncClock_Req}

EnvD_SysQual_Diagnostics_SlaveComponentListECUIdentification_(0x061C)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 06 1C
    [Tags]    CustomerDiagnostic    TCID-518808    FID-3569297    FULLTEST    ProgrammingSession

    prj.sut.DID.Test.case.setups
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListECUIdentification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListECUIdentification_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListECUIdentification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListECUIdentification_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.SlaveComponentListECUIdentification_Req}

EnvD_SysQual_Diagnostics_SlaveComponentListPresent(0x061D)_NRC12_NRC13_NRC31
    [Documentation]    The negative response format shall be as specified in "Negative Response Format" of 22 06 1D
    [Tags]    CustomerDiagnostic    TCID-518817    FID-4282474    FULLTEST    ProgrammingSession

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListPresent_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListPresent_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Log To Console    NRC 13
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListPresent_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    prj.sut.can.diag.send    ${sut.diag.SlaveComponentListPresent_IncorrectMessageLengthMore_Req}
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Log To Console    NRC 31
    DID NRC 31    ${sut.diag.SlaveComponentListPresent_Req}

######################## Yathin ########################################


######################################## RAVI ############################################################

# EnvD_SysQual_Diagnostics_VehicleIdentificationNumber_Chassisnumber(0xF190)_NegativeResponse
#     [Documentation]    To test negative response for VehicleIdentificationNumber(0xF190)
#     [Tags]    CustomerDiagnostic    TCID-    FULLTEST    FID-    ProgrammingSession
#     prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

#     # Send command with incorrect less message length
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_IncorrectMessageLengthLess_Req}
#     prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

#     # Send command with incorrect extra message length
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_IncorrectMessageLengthExtra_Req}
#     prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

#     # Go to extended session
#     prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
#     prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

#     # Send command with incorrect less message length
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_IncorrectMessageLengthLess_Req}
#     prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

#     # Send command with incorrect extra message length
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_IncorrectMessageLengthExtra_Req}
#     prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

#     prj.sut.can.diag.ProgrammingSession.Enter
#     prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
#     prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
#     prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Ip_counter_wrong_vlans(0x0A2B)NegativeResponse
    [Documentation]    To test negative response for Ip_counter_wrong_vlans
    [Tags]    CustomerDiagnostic    TCID-518881    FID-2840979    FULLTEST    ProgrammingSession
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Ip_counter_wrong_vlans_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Ethernet_Link_Lost_Counter(0x010E)NegativeResponse
    [Documentation]    To test negative response for Ethernet_Link_Lost_Counter
    [Tags]    CustomerDiagnostic    TCID-518880    FID-2839639    FULLTEST    ProgrammingSession
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Ethernet_Link_Lost_Counter_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_Ambient_air_temperature_from_CAN(0x3DA9)NegativeResponse
    [Documentation]    To test negative response for Ambient_air_temperature_from_CAN
    [Tags]    CustomerDiagnostic    TCID-518863    FID-4112839    FULLTEST    ProgrammingSession
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Ambient_air_temperature_from_CAN_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_GPS_position(0x2430)NegativeResponse
    [Documentation]    To test negative response for Ambient_air_temperature_from_CAN
    [Tags]    CustomerDiagnostic    TCID-518860    FID-4112860    FULLTEST    ProgrammingSession
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.GPS_position_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.GPS_position_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.GPS_position_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.GPS_position_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.GPS_position_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_Coolant_temperature_external(0x06A0)NegativeResponse
    [Documentation]    To test negative response for Ambient_air_temperature_from_CAN
    [Tags]    CustomerDiagnostic    TCID-518855    FID-4112861    FULLTEST    ProgrammingSession
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Coolant_temperature_external_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_Humidity_Sensor_Outside(0x27C3)NegativeResponse
    [Documentation]    To test negative response for Outside Humidity_Sensor
    [Tags]    CustomerDiagnostic    TCID-518865    FID-4112877    FULLTEST    ProgrammingSession
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Humidity_Sensor_Outside_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_Read_SlaveComponentList(0x061A)NegativeResponse
    [Documentation]    To test negative response for Outside Humidity_Sensor
    [Tags]    CustomerDiagnostic    TCID-518854    FID-3569007    FULLTEST    ProgrammingSession
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentList_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentList_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentList_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentList_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentList_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_Read_SlaveComponentListDatabusIdentification(0x061B)NegativeResponse
    [Documentation]    To test negative response for SlaveComponentListDatabusIdentification
    [Tags]    CustomerDiagnostic    TCID-518842    FID-3569307    FULLTEST    ProgrammingSession
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}
    # Enter Programming session
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.can.diag.send    ${sut.diag.Read_SlaveComponentListDatabusIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

EnvD_SysQual_Diagnostics_PreConditionEnteringProgrammingSession_MaximumSecurityAttempts
    [Documentation]    In Application Locking time of 10min shall be triggered if Max_Sec_Attempt_Reached condition is enable
    ...    NOTE: The 10min Locking time in application and the 10min Locking time in FBL are different
    [Tags]    CustomerDiagnostic    TCID-435018    FULLTEST    FID-1651950,1653107,1653108    ProgrammingSession

    prj.sut.can.diag.ProgrammingSession.Enter
    # Request Seed
    prj.sut.can.diag.send    ${sut.diag.Seed_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Seed_Resp}    0    5
    ${SeedKey}    prj.sut.can.diag.get.byte.range    6    17
    Log to Console    Seed key obtained is ${SeedKey}

    # Request Invalid Seed key 1st try
    prj.sut.can.diag.send    ${sut.diag.SeedKey_Invalid_Req}
    Sleep    1s
    prj.sut.diag.compare    ${sut.diag.SeedKey_Invalid_Resp}

    # Request Seed again
    prj.sut.can.diag.send    ${sut.diag.Seed_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Seed_Resp}    0    5
    ${SeedKey}    prj.sut.can.diag.get.byte.range    6    17
    Log to Console    Seed key obtained is ${SeedKey}

    # Request Invalid Seed key 2nd try
    prj.sut.can.diag.send    ${sut.diag.SeedKey_Invalid_Req}
    Sleep    1s
    prj.sut.diag.compare    ${sut.diag.SeedKey_MaxNumberOfAttempt_Resp}
    Log to Console     Max_Sec_Attempt_Reached condition is enabled.
    Log to COnsole    Locking time of 10min Starts

    prj.sut.can.diag.send    ${sut.diag.Hard_Reset_Req}
    Log to Console    Hard Reset in progress
    Sleep    30s
    prj.sut.diag.compare    ${sut.diag.HardReset_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ConditionNotCorrect_Resp}
    Log to Console    Waiting for 3 minutes......
    Sleep    3 minutes
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ConditionNotCorrect_Resp}
    Log to Console    Waiting for 7 minutes......
    Sleep    7 minutes
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    Sleep    10s
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

EnvD_SysQual_Diagnostics_PreConditionEnteringProgrammingSession_10MinLockingTime
    [Documentation]    After the Locking time is finished, the request to enter programming session shall be accepted
    [Tags]    CustomerDiagnostic    TCID-435019    FULLTEST    FID-1653109    ProgrammingSession
    [Setup]        Aurix.Flashing.Same.Software   true    true
    prj.sut.can.diag.ProgrammingSession.Enter
    # Request Seed
    prj.sut.can.diag.send    ${sut.diag.Seed_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Seed_Resp}    0    5
    ${SeedKey}    prj.sut.can.diag.get.byte.range    6    17
    Log to Console    Seed key obtained is ${SeedKey}

    # Request Invalid Seed key 1st try
    prj.sut.can.diag.send    ${sut.diag.SeedKey_Invalid_Req}
    Sleep    1s
    prj.sut.diag.compare    ${sut.diag.SeedKey_Invalid_Resp}

    # Request Seed again
    prj.sut.can.diag.send    ${sut.diag.Seed_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Seed_Resp}    0    5
    ${SeedKey}    prj.sut.can.diag.get.byte.range    6    17
    Log to Console    Seed key obtained is ${SeedKey}

    # Request Invalid Seed key 2nd try
    prj.sut.can.diag.send    ${sut.diag.SeedKey_Invalid_Req}
    Sleep    1s
    prj.sut.diag.compare    ${sut.diag.SeedKey_MaxNumberOfAttempt_Resp}
    Log to Console     Max_Sec_Attempt_Reached condition is enabled.
    Log to COnsole    Locking time of 10min Starts
    Log to Console    Waiting for 10 minutes......
    Sleep    11 minutes
    prj.sut.can.diag.send    ${sut.diag.Hard_Reset_Req}
    Log to Console    Hard Reset in progress
    Sleep    30s
    prj.sut.diag.compare    ${sut.diag.HardReset_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    Sleep    10s
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

EnvD_SysQual_Diagnostics_PreConditionEnteringProgrammingSession_10MinLockingTimeReset
    [Documentation]    Locking time of 10min shall be restarted again in application if there is any reset in between before completing the locking time
    [Tags]    CustomerDiagnostic    TCID-435017    FULLTEST    FID-1653110    ProgrammingSession
    [Setup]        Aurix.Flashing.Same.Software   true    true
    prj.sut.can.diag.ProgrammingSession.Enter
    # Request Seed
    prj.sut.can.diag.send    ${sut.diag.Seed_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Seed_Resp}    0    5
    ${SeedKey}    prj.sut.can.diag.get.byte.range    6    17
    Log to Console    Seed key obtained is ${SeedKey}

    # Request Invalid Seed key 1st try
    prj.sut.can.diag.send    ${sut.diag.SeedKey_Invalid_Req}
    Sleep    1s
    prj.sut.diag.compare    ${sut.diag.SeedKey_Invalid_Resp}

    # Request Seed again
    prj.sut.can.diag.send    ${sut.diag.Seed_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Seed_Resp}    0    5
    ${SeedKey}    prj.sut.can.diag.get.byte.range    6    17
    Log to Console    Seed key obtained is ${SeedKey}

    # Request Invalid Seed key 2nd try
    prj.sut.can.diag.send    ${sut.diag.SeedKey_Invalid_Req}
    Sleep    1s
    prj.sut.diag.compare    ${sut.diag.SeedKey_MaxNumberOfAttempt_Resp}
    Log to Console     Max_Sec_Attempt_Reached condition is enabled.
    Log to COnsole    Locking time of 10min Starts
    Log to Console    Waiting for 7 minutes......
    Sleep    7 minutes
    prj.sut.can.diag.send    ${sut.diag.Hard_Reset_Req}
    Log to Console    Hard Reset in progress
    Sleep    30s
    prj.sut.diag.compare    ${sut.diag.HardReset_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ConditionNotCorrect_Resp}
    Log to Console    Waiting for 3 minutes......
    Sleep    3 minutes
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ConditionNotCorrect_Resp}
    Log to Console    Waiting for 7 minutes......
    Sleep    7 minutes
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    Sleep    10s
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

EnvD_SysQual_Diagnostics_ActiveDiagnosticSession(0xF186)
    [Documentation]    The DID BasicSettingStatus shall give the information
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-272513    FULLTEST	FID-1132291,1132290,1132292,1131667,1132288,1069809,1069812    ProgrammingSession

    # prj.sut.power cycle
    # Sleep    40s
    # prj.sut.can.diag.tester.present.active
    # Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

    prj.sut.can.diag.ProgrammingSession.Enter

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ProgrammingSession_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit



################### Flashing test cases ###############################################
EnvD_SysQual_Diagnostics_ClearingFailureMemoryPostFlashing_FailureMemoryAfterFlashing
    [Documentation]    Once the reprogramming is done successfully, the failure memory shall be erased
    [Tags]    CustomerDiagnostic    TCID-434188    FULLTEST	FID-2655054

    # Clear all DTC
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    Log to Console    Overvoltage DTC is seen

    # powercycle and check DTC
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    5s
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    Log to Console    Overvoltage DTC is still seen after powercycle

    # Flash to different sw (older)
    Archive.Aurix.flashing    true    true

    # Check DTC after flashing
    Sleep    70s
    # DTC shall be erased after flashing
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    5s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}

    ${Status}    Run keyword and return status    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    IF    ${Status} == False
        Log To Console    DTC is erased after flashing.
    ELSE
        Set Test Status To Fail    error_type=Diagnostic    info_text=DTC is not erased after flashing to different sw version
    END

    [Teardown]    Aurix.Flashing.Same.Software    true    true

EnvD_SysQual_Diagnostics_ClearingFailureMemoryPostFlashing_FailureMemoryAfterFlashingOldSoftware
    [Documentation]    The Failure Memory shall be cleared only if the older SW version and the newer SW version are different
    [Tags]    CustomerDiagnostic    TCID-434189    FULLTEST	FID-2655055
    # Clear all DTC
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    21
    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    Log to Console    Overvoltage DTC is seen

    # powercycle and check DTC
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    5s
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    Log to Console    Overvoltage DTC is still seen after powercycle

    # Flash same SW
    Aurix.Flashing.Same.Software   true    true

    # Check DTC after flashing
    Sleep    70s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    5s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}

    # DTC shall remain after flashing
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    [Teardown]    Run Keyword If Test Failed    prj.sut.power cycle
