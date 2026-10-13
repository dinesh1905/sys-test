*** Settings ***
Documentation       Example script to set and get voltage
Metadata            testtype    example
Metadata            testarea    power
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource            ${TAF_PATH}/import.resource
Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         setups.Set Up Test Suite
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case


*** Variables ***
${COUNTERPLUS1}        1


*** Test Cases ***
EnvD_SysQual_Diagnostics_ActiveDiagnosticSession(0xF186)
    [Documentation]    The DID BasicSettingStatus shall give the information
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-272513    FULLTEST	FID-1132291,1132290,1132292,1131667,1132288,1069809,1069812

    prj.sut.power cycle
    Sleep    40s
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ProgrammingSession_Resp}

EnvD_SysQual_Diagnostics_ActiveDiagnosticSession(0xF186)_NegativeResponse
    [Documentation]    	To test negative response for ActiveDiagnosticSession(0xF186)
    [Tags]    CustomerDiagnostic    TCID-272508    FULLTEST	FID-1132893

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_AUTOSARStandardApplicationSoftwareIdentification(0xF1AF)(Default Session)
    [Documentation]    The DID identifies the standard software component(SSW) that are
    ...    integrated onto the project along with the vendor and component version code
    [Tags]    CustomerDiagnostic    TCID-272507    FULLTEST	FID-1132976,1132977,1132978,1132980,1132981,1133008,1133011

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_Resp}

EnvD_SysQual_Diagnostics_AUTOSARStandardApplicationSoftwareIdentification(0xF1AF)(Extended Session)
    [Documentation]    The DID identifies the standard software component(SSW) that are
    ...    integrated onto the project along with the vendor and component version code
    [Tags]    CustomerDiagnostic    TCID-272506    FULLTEST	FID-1132976,1132977,1132978,1132980,1132981,1133008,1133011

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_Resp}

EnvD_SysQual_Diagnostics_AUTOSARStandardApplicationSoftwareIdentification(0xF1AF)_NegativeResponse
    [Documentation]    To test negative response for AUTOSARStandardApplicationSoftwareIdentification (0xF1AF)
    [Tags]    CustomerDiagnostic    TCID-272512    FULLTEST	FID-1132982

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send
    ...    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send
    ...    ${sut.diag.AUTOSARStandardApplicationSoftwareIdentification_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_BasicSettingStatus(0x0102)(Default Session)
    [Documentation]    The DID BasicSettingStatus shall give the information
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-272583    FULLTEST	FID-1132896,1132897,1132898,1132900,1132901

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_Req}
    prj.sut.diag.compare    ${sut.diag.BasicSettingStatus_NoRoutineActive_Resp}

EnvD_SysQual_Diagnostics_BasicSettingStatus(0x0102)(Extended Session)
    [Documentation]    The DID BasicSettingStatus shall give the information
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-272582    FULLTEST	FID-1132896,1132897,1132898,1132900,1132901

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_Req}
    prj.sut.diag.compare    ${sut.diag.BasicSettingStatus_NoRoutineActive_Resp}

EnvD_SysQual_Diagnostics_BasicSettingStatus(0x0102)_NegativeResponse
    [Documentation]    To test negative response for BasicSettingStatus(0x0102)
    [Tags]    CustomerDiagnostic    TCID-272505    FULLTEST	FID-1132902

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.BasicSettingStatus_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_Check_Programming_Preconditions(0x0203)(Default Session)
    [Documentation]    This RoutineIdentifier allows the client to retrieve the
    ...     state of the programming prerequisites in the server.
    [Tags]    CustomerDiagnostic    TCID-272630    FULLTEST	FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1381301,1337931,1453623,1453624,1337933,1337908

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Check_Programming_Preconditions_Req}
    prj.sut.diag.compare    ${sut.diag.Check_Programming_Preconditions_VehicleSpeedNonZero_Resp}

EnvD_SysQual_Diagnostics_Check_Programming_Preconditions(0x0203)(Extended Session)
    [Documentation]    This RoutineIdentifier allows the client to retrieve the
    ...     state of the programming prerequisites in the server.
    [Tags]    CustomerDiagnostic    TCID-272623    FULLTEST	FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1381301,1337931,1453623,1453624,1337933,1337908

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Check_Programming_Preconditions_Req}
    prj.sut.diag.compare    ${sut.diag.Check_Programming_Preconditions_VehicleSpeedNonZero_Resp}

EnvD_SysQual_Diagnostics_Default_Session(0x01)
    [Documentation]    This service shall be used to enable different diagnostic sessions in the server(s)
    [Tags]    CustomerDiagnostic    TCID-272530    FULLTEST	FID-1069702,1069706,1069761,1069763

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

EnvD_SysQual_Diagnostics_ECUExtractAR-CVersionNumber(0xFD07)(Default Session)
    [Documentation]    also known as ECUExtractVersionInformation(0xFD07) in requirement.
    ...    The DID ECUExtractVersionInformation shall give the information about
    ...     the ECU Extract Information integrated for that particular PI
    [Tags]    CustomerDiagnostic    TCID-272577    FULLTEST	FID-1435087,1435088,1435089,1435091,1435092

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUExtractAR_CVersionNumber_Resp}

EnvD_SysQual_Diagnostics_ECUExtractAR-CVersionNumber(0xFD07)(Extended Session)
    [Documentation]    also known as ECUExtractVersionInformation(0xFD07) in requirement.
    ...    The DID ECUExtractVersionInformation shall give the information about
    ...     the ECU Extract Information integrated for that particular PI
    [Tags]    CustomerDiagnostic    TCID-272569    FULLTEST	FID-1435087,1435088,1435089,1435091,1435092

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUExtractAR_CVersionNumber_Resp}

EnvD_SysQual_Diagnostics_ECUExtractVersionInformation(0xFD07)_NegativeResponse
    [Documentation]    To test negative response for ECUExtractVersionInformation(0xFD07)
    [Tags]    CustomerDiagnostic    TCID-272516    FULLTEST	FID-1435093

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUExtractAR_CVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_ECUProgrammingInformation(0xF1DF)(Default Session)
    [Documentation]    This DataIdentifier indicates the programmability and program
    ...    consistency of the server. This refers to the consistency with regard
    ...    to software and software and hardware.
    [Tags]    CustomerDiagnostic    TCID-272498    FULLTEST	FID-1287691,1287693,1287744,1287745,1287764,1287765

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_Req}
    prj.sut.diag.compare    ${sut.diag.ECUProgrammingInformation_Programmable_Resp}

EnvD_SysQual_Diagnostics_ECUProgrammingInformation(0xF1DF)(Extended Session)
    [Documentation]    This DataIdentifier indicates the programmability and program
    ...    consistency of the server. This refers to the consistency with regard
    ...    to software and software and hardware.
    [Tags]    CustomerDiagnostic    TCID-272497    FULLTEST	FID-1440104,1440106,1440107,1440109,1440110

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_Req}
    prj.sut.diag.compare    ${sut.diag.ECUProgrammingInformation_Programmable_Resp}

EnvD_SysQual_Diagnostics_ECUProgrammingInformation(0xF1DF)_NegativeResponse
    [Documentation]    To test negative response for ECUProgrammingInformation(0xF1DF)
    [Tags]    CustomerDiagnostic    TCID-272542    FULLTEST	FID-1440111

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ECUProgrammingInformation(0xF1DF)(Programming Session)
    [Documentation]    This DataIdentifier indicates the programmability and program
    ...    consistency of the server. This refers to the consistency with regard
    ...    to software and software and hardware.
    [Tags]    CustomerDiagnostic    TCID-272504    FULLTEST	FID-1440104,1440106,1440107,1440109,1440110

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUProgrammingInformation_Req}
    prj.sut.diag.compare    ${sut.diag.ECUProgrammingInformation_Programmable_Resp}

EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Default Session)
    [Documentation]    The DID ECUSerialNumber shall give the Serial Number of each of the Blade
    [Tags]    CustomerDiagnostic    TCID-272614    FULLTEST	FID-1150970,1150971,1150972,1150974,1150975

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUSerialNumber_Resp}

EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Extended Session)
    [Documentation]    The DID ECUSerialNumber shall give the Serial Number of each of the Blade
    [Tags]    CustomerDiagnostic    TCID-272611    FULLTEST	FID-1150970,1150971,1150972,1150974,1150975

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUSerialNumber_Resp}

EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)_NegativeResponse
    [Documentation]    To test negative response for ECUSerialNumber(0xF18C)
    [Tags]    CustomerDiagnostic    TCID-272538    FULLTEST	FID-1150976

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ECUSerialNumber(0xF18C)(Programming Session)
    [Documentation]    The DID ECUSerialNumber shall give the Serial Number of each of the Blade
    [Tags]    CustomerDiagnostic    TCID-272620    FULLTEST	FID-1150970,1150971,1150972,1150974,1150975

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUSerialNumber_Req}
    prj.sut.diag.compare    ${sut.diag.ECUSerialNumber_Resp}

EnvD_SysQual_Diagnostics_Enable_Rx_And_Disable_Tx_Control(0x01)(Default Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-272571    FULLTEST	FID-1453617,1453618,1367233,1367234

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Enable_Rx_And_Disable_Tx_Control_Req}
    prj.sut.diag.compare    ${sut.diag.Enable_Rx_And_Disable_Tx_Control_Resp}

EnvD_SysQual_Diagnostics_Enable_Rx_And_Disable_Tx_Control(0x01)(Extended Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-272627    FULLTEST	FID-1453617,1453618,1367233,1367234

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Enable_Rx_And_Disable_Tx_Control_Req}
    prj.sut.diag.compare    ${sut.diag.Enable_Rx_And_Disable_Tx_Control_Resp}

EnvD_SysQual_Diagnostics_Enable_Rx_And_Tx_Control(0x00)(Default Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-272568    FULLTEST	FID-1453617,1453618,1367233,1367234

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Enable_Rx_And_Tx_Control_Req}
    prj.sut.diag.compare    ${sut.diag.Enable_Rx_And_Tx_Control_Resp}

EnvD_SysQual_Diagnostics_Enable_Rx_And_Tx_Control(0x00)(Extended Session)
    [Documentation]    Communication control service is used to turn on/off of the
    ...    transmission And/Or turn on/off the reception.Setting the
    ...    state CommunicationControl (28hex) with subfunction
    ...    EnableRxDisableTx (0x01) prevents starting of the engine (internal
    ...    combustion engine and e-motor) for the entire ignition cycle.
    [Tags]    CustomerDiagnostic    TCID-272572    FULLTEST	FID-1453617,1453618,1367233,1367234

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Enable_Rx_And_Tx_Control_Req}
    prj.sut.diag.compare    ${sut.diag.Enable_Rx_And_Tx_Control_Resp}

EnvD_SysQual_Diagnostics_Extended_Session(0x03)
    [Documentation]    This service shall be used to enable different diagnostic sessions in the server(s)
    [Tags]    CustomerDiagnostic    TCID-272527    FULLTEST	FID-1069702,1069705,1069718,1069761,1069763

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

EnvD_SysQual_Diagnostics_OFF_Control_DTC_Setting(0x02)
    [Documentation]    This service is used to deactivate and reactivate the update of
    ...    the StatusOfDTC bits of events and notices in the event memory
    [Tags]    CustomerDiagnostic    TCID-272642    FULLTEST    FID-1286027,1286042,1286049,1286050,1287772,1287773    DTC

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}    0    20

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    5s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Check if DTC is cleared
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}
    # Set DTC setting to OFF
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}

    # Qualify Overvoltage DTC again
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s
    # Check DTC should not be logged
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}

    # post condition
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ON_Control_DTC_Setting(0x01)
    [Documentation]    This service is used to deactivate and reactivate the update of
    ...    the StatusOfDTC bits of events and notices in the event memory
    [Tags]    CustomerDiagnostic    TCID-272640    FULLTEST	FID-1286027,1286042,1286049,1286050,1287772,1287773    DTC

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}

    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Check if DTC is cleared
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}
    # Set DTC setting to ON
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON_Resp}

    # Qualify Overvoltage DTC again
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep     3s
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    # Check DTC should be logged
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}    0    20
    # post condition
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Report_DTC_By_Status_Mask(0x02)(Default Session)
    [Documentation]    The client can retrieve a list of DTCs, which satisfy a client defined
    ...     status mask by sending a request with the SubFunction byte set to reportDTCByStatusMask.
    [Tags]    CustomerDiagnostic    TCID-272540    FULLTEST	FID-1287925,1290752,1287925,1290752,1290762,1290764,1290765

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}    0    20

EnvD_SysQual_Diagnostics_VWSystemNameOrEngineType(0xF197)(Default Session)
    [Documentation]    The DID SystemNameOrEngineType shall give the information
    ...    about the system name of the Blade
    [Tags]    CustomerDiagnostic    TCID-272580    FULLTEST	FID-1383247,1383248,1383249,1383251,1383252

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemNameOrEngineType_Resp}

EnvD_SysQual_Diagnostics_VWSystemNameOrEngineType(0xF197)(Extended Session)
    [Documentation]    The DID SystemNameOrEngineType shall give the information
    ...    about the system name of the Blade
    [Tags]    CustomerDiagnostic    TCID-272579    FULLTEST	FID-1383247,1383248,1383249,1383251,1383252

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemNameOrEngineType_Resp}

EnvD_SysQual_Diagnostics_VWSystemNameOrEngineType(0xF197)_NegativeResponse
    [Documentation]    The DID SystemNameOrEngineType shall give the information
    ...    about the system name of the Blade
    [Tags]    CustomerDiagnostic    TCID-272555    FULLTEST	FID-1383253

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemNameOrEngineType_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_VWSystemFirmwareVersion(0xF1B8)(Default Session)
    [Documentation]    This DataIdentifier identifies the hardware-related software versions of the Blade
    [Tags]    CustomerDiagnostic    TCID-272567    FULLTEST	FID-1453704,1453705,1453706,1453708,1453709

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemFirmwareVersion_Resp}

EnvD_SysQual_Diagnostics_VWSystemFirmwareVersion(0xF1B8)(Extended Session)
    [Documentation]    This DataIdentifier identifies the hardware-related software versions of the Blade
    [Tags]    CustomerDiagnostic    TCID-272574    FULLTEST	FID-1453704,1453705,1453706,1453708,1453709

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemFirmwareVersion_Resp}

EnvD_SysQual_Diagnostics_VWSystemFirmwareVersion(0xF1B8)_NegativeResponse
    [Documentation]    To test negative response for VWSystemFirmwareVersion(0xF1B8)
    [Tags]    CustomerDiagnostic    TCID-272549    FULLTEST	FID-1453710

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_VWSystemFirmwareVersion(0xF1B8)(Programming Session)
    [Documentation]    This DataIdentifier identifies the hardware-related software versions of the Blade
    [Tags]    CustomerDiagnostic    TCID-272575    FULLTEST	FID-1453704,1453705,1453706,1453708,1453709

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSystemFirmwareVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWSystemFirmwareVersion_Resp}

EnvD_SysQual_Diagnostics_VW_Spare_Part_Number(0xF187)(Default Session)
    [Documentation]    This DataIdentifier identifies the Blade specific part number of a control unit.
    [Tags]    CustomerDiagnostic    TCID-272585    FULLTEST	FID-1440269,1440270,1440271,1440273,1440274

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWSparePartNumber_Resp}

EnvD_SysQual_Diagnostics_VW_Spare_Part_Number(0xF187)(Extended Session)
    [Documentation]    This DataIdentifier identifies the Blade specific part number of a control unit.
    [Tags]    CustomerDiagnostic    TCID-272586    FULLTEST	FID-1440269,1440270,1440271,1440273,1440274

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWSparePartNumber_Resp}

EnvD_SysQual_Diagnostics_VW Spare Part Number(0xF187)_NegativeResponse
    [Documentation]    To test negative response for VW Spare Part Number(0xF187)
    [Tags]    CustomerDiagnostic    TCID-272544    FULLTEST	FID-1440275

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_VW_Spare_Part_Number(0xF187)(Programming Session)
    [Documentation]    This DataIdentifier identifies the Blade specific part number of a control unit.
    [Tags]    CustomerDiagnostic    TCID-272588    FULLTEST	FID-1440269,1440270,1440271,1440273,1440274

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWSparePartNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWSparePartNumber_Resp}

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockLockValue(0x040F)(Default Session)
    [Documentation]    This Data Identifier identifies blocking values for the counters of
    ...     the programming attempts (lock value) of the corresponding logical software block #1-#n
    [Tags]    CustomerDiagnostic    TCID-272634    FULLTEST	FID-1691094,1691095,1691096,1691098,1691099

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockLockValue_Resp}

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockLockValue(0x040F)(Extended Session)
    [Documentation]    This Data Identifier identifies blocking values for the counters of
    ...     the programming attempts (lock value) of the corresponding logical software block #1-#n
    [Tags]    CustomerDiagnostic    TCID-272633    FULLTEST	FID-1691094,1691095,1691096,1691098,1691099

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockLockValue_Resp}

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockLockValue(0x040F)_NegativeResponse
    [Documentation]    To test negative response for VWLogicalSoftwareBlockLockValue(0x040F)
    [Tags]    CustomerDiagnostic    TCID-272541    FULLTEST	FID-1691100

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockLockValue(0x040F)(Programming Session)
    [Documentation]    This Data Identifier identifies blocking values for the counters of
    ...     the programming attempts (lock value) of the corresponding logical software block #1-#n
    [Tags]    CustomerDiagnostic    TCID-272637    FULLTEST	FID-1691094,1691095,1691096,1691098,1691099

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockLockValue_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockLockValue_Resp}

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockCounterOfProgrammingAttempts(0x0407)(Default Session)
    [Documentation]    The DID VWLogicalSoftwareBlockCounterOfProgrammingAttempts Identifies
    ...     the counter for the programming attempts (counter value) of a logical software block (1 to n).
    [Tags]    CustomerDiagnostic    TCID-272581    FULLTEST	FID-1383418,1383419,1383420,1383422,1383423

    # depends on how much is the counter. to check how to set the counter back to zero

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # send command
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

    # compare the positive response
    prj.sut.diag.compare.byte.range    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Resp}    0    8

    # verify & take the last Byte
    ${lastbyte}    prj.sut.can.diag.get.byte.range    9    14
    Log To Console    The current Counter is ${lastbyte}

    # put into new Variable
    ${currentinteger}    Convert To Integer    0x${lastbyte}

    # make variable +1
    ${expectedcounter}    evaluate    ${currentinteger} + ${COUNTERPLUS1}

    # send programming state but make it Fail
    # in here maybe need to control ETH IG to change speed in the future
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.NegativeResponse_VehicleSpeedTooHigh_Resp}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

    # take the last Byte
    ${newlastbyte}    prj.sut.can.diag.get.byte.range    9    14
    ${latestinteger}    Convert To Integer    0x${newlastbyte}
    Log To Console    The latest Counter is ${latestinteger}. Before it was ${currentinteger}

    # compare with the 1st variable +1
    IF    ${latestinteger} == ${expectedcounter}
        Log To Console    The Counter increased from ${currentinteger} to ${latestinteger}.
        Log To Console    Test Case PASS!!
    ELSE
        Log    ${latestinteger} is not the same as ${expectedcounter}    console=True
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockCounterOfProgrammingAttempts(0x0407)(Extended Session)
    [Documentation]    The DID VWLogicalSoftwareBlockCounterOfProgrammingAttempts Identifies
    ...     the counter for the programming attempts (counter value) of a logical software block (1 to n).
    [Tags]    CustomerDiagnostic    TCID-272587    FULLTEST	FID-1383418,1383419,1383420,1383422,1383423

    # depends on how much is the counter. to check how to set the counter back to zero

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # send command
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

    # compare the positive response
    prj.sut.diag.compare.byte.range    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Resp}    0    8

    # verify & take the last Byte
    ${lastbyte}    prj.sut.can.diag.get.byte.range    9    14
    Log To Console    The current Counter is ${lastbyte}

    # put into new Variable
    ${currentinteger}    Convert To Integer    0x${lastbyte}

    # make variable +1
    ${expectedcounter}    evaluate    ${currentinteger} + ${COUNTERPLUS1}

    # send programming state but make it Fail
    # in here maybe need to control ETH IG to change speed in the future
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.NegativeResponse_VehicleSpeedTooHigh_Resp}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

    # take the last Byte
    ${newlastbyte}    prj.sut.can.diag.get.byte.range    9    14
    ${latestinteger}    Convert To Integer    0x${newlastbyte}
    Log To Console    The latest Counter is ${latestinteger}. Before it was ${currentinteger}

    # compare with the 1st variable +1
    IF    ${latestinteger} == ${expectedcounter}
        Log To Console    The Counter increased from ${currentinteger} to ${latestinteger}.
        Log To Console    Test Case PASS!!
    ELSE
        Log    ${latestinteger} is not the same as ${expectedcounter}    console=True
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockCounterOfProgrammingAttempts(0x0407)(Programming Session)
    [Documentation]    The DID VWLogicalSoftwareBlockCounterOfProgrammingAttempts Identifies
    ...     the counter for the programming attempts (counter value) of a logical software block (1 to n).
    [Tags]    CustomerDiagnostic    TCID-272584    FULLTEST	FID-1383418,1383419,1383420,1383422,1383423

    # depends on how much is the counter. to check how to set the counter back to zero

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # send command
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}
    # compare the positive response
    prj.sut.diag.compare.byte.range    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Resp}    0    8
    # verify & take the last Byte
    ${lastbyte}    prj.sut.can.diag.get.byte.range    9    14
    Log To Console    The current Counter is ${lastbyte}
    # put into new Variable
    ${currentinteger}    Convert To Integer    0x${lastbyte}
    # make variable +1
    ${expectedcounter}    evaluate    ${currentinteger} + ${COUNTERPLUS1}

    # send programming state but make it Fail
    # in here maybe need to control ETH IG to change speed in the future
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.NegativeResponse_VehicleSpeedTooHigh_Resp}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_Req}

    # take the last Byte
    ${newlastbyte}    prj.sut.can.diag.get.byte.range    9    14
    ${latestinteger}    Convert To Integer    0x${newlastbyte}
    Log To Console    The latest Counter is ${latestinteger}. Before it was ${currentinteger}

    # compare with the 1st variable +1
    IF    ${latestinteger} == ${expectedcounter}
        Log To Console    The Counter increased from ${currentinteger} to ${latestinteger}.
        Log To Console    Test Case PASS!!
    ELSE
        Log    ${latestinteger} is not the same as ${expectedcounter}    console=True
        Set Test Status To Fail    error_type=DIAGNOSIS
    END

EnvD_SysQual_Diagnostics_VWLogicalSoftwareBlockCounterOfProgrammingAttempts(0x0407)_NegativeResponse
    [Documentation]    The DID VWLogicalSoftwareBlockCounterOfProgrammingAttempts Identifies
    ...     the counter for the programming attempts (counter value) of a logical software block (1 to n).
    [Tags]    CustomerDiagnostic    TCID-272494    FULLTEST	FID-1383424

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockCounterOfProgrammingAttempts_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

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

EnvD_SysQual_Diagnostics_RollerTestStandMode(0x04FB)(Extended Session)
    [Documentation]    The DID RollerTestStandMode shall be used to Activate/Deactivate
    ...    the Roller test stand mode for the ECU in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272491    FULLTEST	FID-1132910,1132911,1132912,1132914,1132915,1069815,1069829

    # precondition
    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_00_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command of RollerTestStandMode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandMode_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Check is what is written is reflected.
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWriteUpdate_Resp}

EnvD_SysQual_Diagnostics_RollerTestStandMode(0x04FB)_NegativeResponse
    [Documentation]    To test negative response for RollerTestStandMode(0x04FB)
    [Tags]    CustomerDiagnostic    TCID-272500    FULLTEST	FID-1132916

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_RollerTestStandMode(0x04FB)_NegativeResponse_Write
    [Documentation]    To test negative response for RollerTestStandMode(0x04FB) $2E write command
    [Tags]    CustomerDiagnostic    TCID-272528    FULLTEST	FID-1151274

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    # Send command with wrong value
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWriteWrongValue_Req}
    prj.sut.diag.compare    ${sut.diag.ConditionNotCorrect_Write_Resp}

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

EnvD_SysQual_Diagnostics_SendRequest_ReferringCDD
    [Documentation]    To verify that ReadDataByIdentifier($22) service allows
    ...    the client to request data record values from the server
    ...    identified by one or more dataIdentifiers via CDD.
    [Tags]    CustomerDiagnostic    TCID-272529    FULLTEST	FID-1069770

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

EnvD_SysQual_Diagnostics_RollerTestStandMode_Write(0x04FB)
    [Documentation]    The DID RollerTestStandMode shall be used to Activate/Deactivate the Roller test stand mode for the ECU
    [Tags]    CustomerDiagnostic    TCID-272629    FULLTEST	FID-1151240,1151246,1151257,1151277,1151260,1151264,1151267,1151272

    # precondition
    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_00_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Send command of RollerTestStandMode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandMode_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

    # Check is what is written is reflected.
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWriteUpdate_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareNumber(0xF192)(Default Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW number in default mode.
    [Tags]    CustomerDiagnostic    TCID-272617    FULLTEST	FID-1150982,1150983,1150984,1150986,1150987

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # send command for SystemSupplierECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareNumber(0xF192)(Extended Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW number in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272604    FULLTEST	FID-1150982,1150983,1150984,1150986,1150987

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # send command for SystemSupplierECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareNumber(0xF192)(Programming Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW number
    [Tags]    CustomerDiagnostic    TCID-272601    FULLTEST	FID-1150982,1150983,1150984,1150986,1150987

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Go to programming mode
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # send command for SystemSupplierECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareNumber(0xF192)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierECUHardwareVersionNumber(0xF193)
    [Tags]    CustomerDiagnostic    TCID-272546    FULLTEST	FID-1150988

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareVersionNumber(0xF193)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierECUHardwareVersionNumber(0xF193)
    [Tags]    CustomerDiagnostic    TCID-272523    FULLTEST	FID-1150999

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareVersionNumber(0xF193)(Default Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW version number

    [Tags]    CustomerDiagnostic    TCID-272607    FULLTEST	FID-1150992,1150994,1150995,1150997,1150998

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareVersionNumber(0xF193)(Extended Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW version number in extended mode

    [Tags]    CustomerDiagnostic    TCID-272621    FULLTEST	FID-1150992,1150994,1150995,1150997,1150998

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # send command for ECU hardware version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUHardwareVersionNumber(0xF193)(Programming Session)
    [Documentation]    The DID SystemSupplierECUHardwareNumber shall give the
    ...    information about ECU HW version number in programming mode

    [Tags]    CustomerDiagnostic    TCID-272635    FULLTEST	FID-1150992,1150994,1150995,1150997,1150998

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # send command for ECU hardware version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSoftwareVersionNumber(0xF195)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierECUSoftwareVersionNumber(0xF195)

    [Tags]    CustomerDiagnostic    TCID-272532    FULLTEST	FID-1151153

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSoftwareVersionNumber(0xF195)(Default Session)
    [Documentation]    The DID SystemSupplierECUSoftwareVersionNumber identifies
    ...    the versions of the different Software elements

    [Tags]    CustomerDiagnostic    TCID-272625    FULLTEST	FID-1151146,1151148,1151149,1151151,1151152

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Resp}

# tell aizat test case need to modify in manual step

EnvD_SysQual_Diagnostics_SystemSupplierECUSoftwareVersionNumber(0xF195)(Extended Session)
    [Documentation]    The DID SystemSupplierECUSoftwareVersionNumber identifies
    ...    the versions of the different Software elements

    [Tags]    CustomerDiagnostic    TCID-272622    FULLTEST	FID-1151146,1151148,1151149,1151151,1151152

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSWNumber(0xF194)(Default Session)
    [Documentation]    The DID SystemSupplierECUSWNumber shall give the information
    ...    about the SW part Number of the ECU in default mode

    [Tags]    CustomerDiagnostic    TCID-272641    FULLTEST	FID-1150959,1150960,1150961,1150966,1150963

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of system supplier supplier ECUSW number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSWNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSWNumber(0xF194)(Extended Session)
    [Documentation]   The DID SystemSupplierECUSWNumber shall give the information
    ...    about the SW part Number of the ECU in extended mode.

    [Tags]    CustomerDiagnostic    TCID-272638    FULLTEST	FID-1150959,1150960,1150961,1150966,1150963

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command of system supplier supplier ECUSW number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSWNumber_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSWNumber(0xF194)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierECUSWNumber(0xF194)

    [Tags]    CustomerDiagnostic    TCID-272519    FULLTEST	FID-1150965

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command of system supplier supplier ECUSW number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSWNumber_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierIdentification(0xF18A)(Default Session)
    [Documentation]    The DID SystemSupplierIdentification shall give the information
    ...    about the name and address of the Supplier of the Blade

    [Tags]    CustomerDiagnostic    TCID-272631    FULLTEST	FID-1150949,1150950,1150951,1150953,1150954

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command of system supplier identification
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierIdentification_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierIdentification(0xF18A)(Extended Session)
    [Documentation]    The DID SystemSupplierIdentification shall give the information
    ...    about the name and address of the Supplier of the Blade

    [Tags]    CustomerDiagnostic    TCID-272628    FULLTEST	FID-1150949,1150950,1150951,1150953,1150954

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command of system supplier identification
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierIdentification_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierIdentification(0xF18A)_NegativeResponse
    [Documentation]    To test negative response for SystemSupplierIdentification(0xF18A)

    [Tags]    CustomerDiagnostic    TCID-272531    FULLTEST	FID-1150955

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command in programming session
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierIdentification_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_TechnicalSpecificationsVersion(0xF1B4)(Default Session)
    [Documentation]    The DID TechnicalSpecificationVershion shall identified
    ...    the designations and versions of implemented specifications in default session

    [Tags]    CustomerDiagnostic    TCID-272570    FULLTEST	FID-1132921,1132922,1132923,1132925,1132926

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command for TechnicalSpecificationsVersion
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_Req}
    prj.sut.diag.compare    ${sut.diag.TechnicalSpecificationsVersion_Resp}

EnvD_SysQual_Diagnostics_TechnicalSpecificationsVersion(0xF1B4)(Extended Session)
    [Documentation]    The DID TechnicalSpecificationVershion shall identified
    ...    the designations and versions of implemented specifications in extended session

    [Tags]    CustomerDiagnostic    TCID-272576    FULLTEST	FID-1132921,1132922,1132923,1132925,1132926

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command for TechnicalSpecificationsVersion
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_Req}
    prj.sut.diag.compare    ${sut.diag.TechnicalSpecificationsVersion_Resp}

EnvD_SysQual_Diagnostics_TechnicalSpecificationsVersion(0xF1B4)_NegativeResponse
    [Documentation]    To test negative response for TechnicalSpecificationsVersion(0xF1B4)

    [Tags]    CustomerDiagnostic    TCID-272535    FULLTEST	FID-1132927

    # Go to default session
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

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command in programming session
    prj.sut.can.diag.send    ${sut.diag.TechnicalSpecificationsVersion_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_Tester_Present(Extended Session)
    [Documentation]    This service shall be used to keep the server in a diagnostic session other than the default Session.
    ...    This service is used to indicate to a server (or servers)
    ...    that a client is still connected to the vehicle and that
    ...    certain diagnostic services and/or communication that
    ...    have been previously activated are to remain active.

    [Tags]    CustomerDiagnostic    TCID-272533    FULLTEST	FID-1069374,1069377,1069379

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send tester present
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}

    # Wait for 4.5s
    Sleep    4.5s

    # Check active session
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

EnvD_SysQual_Diagnostics_Tester_Present(Programming Session)
    [Documentation]    This service shall be used to keep the server in a diagnostic session other than the default Session.
    ...    This service is used to indicate to a server (or servers)
    ...    that a client is still connected to the vehicle and that
    ...    certain diagnostic services and/or communication that
    ...    have been previously activated are to remain active.

    [Tags]    CustomerDiagnostic    TCID-272518    FULLTEST	FID-1069374,1069377,1069379

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send tester present
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}

    # Wait for 4.5s
    Sleep    4.5s

    # Check active session
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ProgrammingSession_Resp}

EnvD_SysQual_Diagnostics_VehicleIdentificationNumber(0xF190)(Default Session)
    [Documentation]    The DID VehicleIdentificationNumber shall give the chassis number
    [Tags]    CustomerDiagnostic    TCID-272600    FULLTEST	FID-1132964,1132965,1132967,1132968

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send VehicleIdentificationNumber
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Default_Resp}

EnvD_SysQual_Diagnostics_VehicleIdentificationNumber(0xF190)(Extended Session)
    [Documentation]    The DID VehicleIdentificationNumber shall give the chassis number in extended mode
    [Tags]    CustomerDiagnostic    TCID-272602    FULLTEST	FID-1132964,1132965,1132967,1132968

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send VehicleIdentificationNumber
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleIdentificationNumber_Default_Resp}

EnvD_SysQual_Diagnostics_VehicleIdentificationNumber(0xF190)_NegativeResponse
    [Documentation]    To test negative response for VehicleIdentificationNumber(0xF190)
    [Tags]    CustomerDiagnostic    TCID-272493    FULLTEST	FID-1132969

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command in programming session
    prj.sut.can.diag.send    ${sut.diag.VehicleIdentificationNumber_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_VW_FAZIT_Identification(0xF17C)(Default Session)
    [Documentation]    This Data Identifier identifies the FAZIT identification number of a blade in default mode.
    [Tags]    CustomerDiagnostic    TCID-272618    FULLTEST    FID-1692043,1692044,1692045,1692047,1692048

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # send VW spare part number
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_Req}
    prj.sut.diag.compare    ${sut.diag.VW_FAZIT_Identification_Resp}

EnvD_SysQual_Diagnostics_VW_FAZIT_Identification(0xF17C)(Extended Session)
    [Documentation]    This Data Identifier identifies the FAZIT identification number of a blade in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272619    FULLTEST    FID-1692043,1692044,1692045,1692047,1692048

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # send VW spare part number
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_Req}
    prj.sut.diag.compare    ${sut.diag.VW_FAZIT_Identification_Resp}

EnvD_SysQual_Diagnostics_VW_FAZIT_Identification(0xF17C)(Programming Session)
    [Documentation]    This Data Identifier identifies the FAZIT identification number of a blade in programming mode.
    [Tags]    CustomerDiagnostic    TCID-272612    FULLTEST	FID-1692043,1692044,1692045,1692047,1692048

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # send VW spare part number
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_Req}
    prj.sut.diag.compare    ${sut.diag.VW_FAZIT_Identification_Resp}

EnvD_SysQual_Diagnostics_VW_FAZIT_Identification(0xF17C)_NegativeResponse
    [Documentation]    To test negative response for VW_FAZIT_Identification(0xF17C)
    [Tags]    CustomerDiagnostic    TCID-272552    FULLTEST	FID-1692049

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VW_FAZIT_Identification_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_Fingerprint(0xF15A)
    [Documentation]    This DataIdentifier is used to transfer the workshop code and date of
    ...    the currently connected client to the server. During programming, it is transferred
    ...    to the server in the boot loader and stored in the RAM. The data is then stored
    ...    internally in the EEPROM for each logical block (application, boot loader, data)
    ...    that has been programmed. The Data Identifier "0xF15B-Fingerprint And Programmin
    ...     Date Of Logical Software Blocks" is used for output.
    [Tags]    CustomerDiagnostic    TCID-272636    FULLTEST	FID-1802998,1802999,1803000,1803002,1803003

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Req}
    prj.sut.diag.compare    ${sut.diag.Fingerprint_Resp}

EnvD_SysQual_Diagnostics_Fingerprint(0xF15A)_NegativeResponse
    [Documentation]    To test negative response for Fingerprint(0xF15A)
    [Tags]    CustomerDiagnostic    TCID-272539    FULLTEST	FID-1803004

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

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
    [Tags]    CustomerDiagnostic    TCID-272550    FULLTEST	FID-1803937

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

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
    [Tags]    CustomerDiagnostic    TCID-272605    FULLTEST	FID-1383302,1383303,1383304,1383306,1383307

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    ${Resul}    prj.sut.can.diag.get
    IF    "${Resul}" == "${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_NoFlash_Resp}"
            Log To Console    Blade has NOT been flashed before
            prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
            prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

            prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
            prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Resp}
    ELSE
            Log To Console    Blade has been flashed before
            prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Variation2_Req}
            prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

            prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
            prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Variation2_Resp}
    END

EnvD_SysQual_Diagnostics_FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)(Extended Session)
    [Documentation]    This DID FingerprintAndProgrammingDateOfLogicalSoftwareBlocks is used to read out the list
    ...     of all fingerprint, date and status information of the logical software
    ...     blocks (application, boot loader, data) of the server.
    [Tags]    CustomerDiagnostic    TCID-272609    FULLTEST	FID-1383302,1383303,1383304,1383306,1383307

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    ${Resul}    prj.sut.can.diag.get
    IF    "${Resul}" == "${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_NoFlash_Resp}"
            Log To Console    Blade has NOT been flashed before
            prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
            prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

            prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
            prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Resp}
    ELSE
            Log To Console    Blade has been flashed before
            prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Variation2_Req}
            prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

            prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
            prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Variation2_Resp}
    END

EnvD_SysQual_Diagnostics_FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)(Programming Session)
    [Documentation]    This DID FingerprintAndProgrammingDateOfLogicalSoftwareBlocks is used to read out the list
    ...     of all fingerprint, date and status information of the logical software
    ...     blocks (application, boot loader, data) of the server.
    [Tags]    CustomerDiagnostic    TCID-272608    FULLTEST	FID-1383302,1383303,1383304,1383306,1383307

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
    ${Resul}    prj.sut.can.diag.get
    IF    "${Resul}" == "${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_NoFlash_Resp}"
            Log To Console    Blade has NOT been flashed before

            prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
            prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

            prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
            prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Resp}
    ELSE
            Log To Console    Blade has been flashed before
            prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
            prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

            prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Variation2_Req}
            prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

            prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_Req}
            prj.sut.diag.compare    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_FlashDone_Variation2_Resp}
    END

EnvD_SysQual_Diagnostics_FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)_NegativeResponse
    [Documentation]    To test negative response for FingerprintAndProgrammingDateOfLogicalSoftwareBlocks(0xF15B)
    [Tags]    CustomerDiagnostic    TCID-272524    FULLTEST	FID-1383308

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.FingerprintAndProgrammingDateOfLogicalSoftwareBlocks_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_Fingerprint_Write(0xF15A)
    [Documentation]    This Data Identifier is used to transfer the workshop code
    ...    and date of the currently connected client to the server during programming.
    [Tags]    CustomerDiagnostic    TCID-272606    FULLTEST	FID-1803931,1803932,1803933,1803935,1803936

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
    prj.sut.diag.compare    ${sut.diag.Fingerprint_Write_Resp}

EnvD_SysQual_Diagnostics_Group_of_DTC(0xFFFFFF)(Default Session)
    [Documentation]    The Clear Diagnostics Service is used to clear/delete the entries from the Primary memory.
    [Tags]    CustomerDiagnostic    TCID-272522    FULLTEST	FID-1287691,1287693,1287744,1287745,1287764,1287765

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}    0    20

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Group_of_DTC(0xFFFFFF)(Extended Session)
    [Documentation]    The Clear Diagnostics Service is used to clear/delete the entries from the Primary memory.
    [Tags]    CustomerDiagnostic    TCID-272548    FULLTEST	FID-1287691,1287693,1287744,1287745,1287764,1287765

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}    0    20

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_IpCounterDroppedIpv6PacketsLayer3(0x01A0)_NegativeResponse
    [Documentation]    To test negative response for IpCounterDroppedIpv6PacketsLayer3(0x01A0)
    [Tags]    CustomerDiagnostic    TCID-272492    FULLTEST	FID-1383442
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_IpCounterDroppedUdpTcpPacketsLayer4(0x01A1)_NegativeResponse
    [Documentation]    To test negative response for IpCounterDroppedUdpTcpPacketsLayer4(0x01A1)
    [Tags]    CustomerDiagnostic    TCID-272536    FULLTEST	FID-1692039

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_IpCounterWrongIpv6Addresses(0x0A2C)_NegativeResponse
    [Documentation]    To test negative response for IpCounterWrongIpv6Addresses(0x0A2C)
    [Tags]    CustomerDiagnostic    TCID-272495    FULLTEST	FID-1665045

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongIpv6Addresses_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_IpCounterWrongUdpPorts(0x0A2F)_NegativeResponse
    [Documentation]    To test negative response for IpCounterWrongUdpPorts(0x0A2F)
    [Tags]    CustomerDiagnostic    TCID-272547    FULLTEST	FID-1394237

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)(Default Session)
    [Documentation]    This Data Identifier identifies all current IPv6 addresses of the
    ...    control unit which are not IPv6 multicast addresses.
    [Tags]    CustomerDiagnostic    TCID-272593    FULLTEST	FID-1691409,1691410,1691411,1691413,1691414

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6AddressesList_Resp}

EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)(Extended Session)
    [Documentation]    This Data Identifier identifies all current IPv6 addresses of the
    ...    control unit which are not IPv6 multicast addresses.
    [Tags]    CustomerDiagnostic    TCID-272578    FULLTEST	FID-1691409,1691410,1691411,1691413,1691414

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6AddressesList_Resp}

EnvD_SysQual_Diagnostics_IpIpv6AddressesList(0x013D)_NegativeResponse
    [Documentation]    To test negative response for IpIpv6AddressesList(0x013D)
    [Tags]    CustomerDiagnostic    TCID-272520    FULLTEST	FID-1691415

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6AddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_IpIpv6MulticastAddressesList(0x013E)(Default Session)
    [Documentation]    This Data Identifier identifies all current IPv6 multicast addresses
    ...    of the Blade.
    [Tags]    CustomerDiagnostic    TCID-272562    FULLTEST	FID-1691418,1691419,1691420,1691422,1691423

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6MultiCastAddressesList_Resp}

EnvD_SysQual_Diagnostics_IpIpv6MulticastAddressesList(0x013E)(Extended Session)
    [Documentation]    This Data Identifier identifies all current IPv6 multicast addresses
    ...    of the Blade.
    [Tags]    CustomerDiagnostic    TCID-272564    FULLTEST	FID-1691418,1691419,1691420,1691422,1691423

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.IpIpv6MultiCastAddressesList_Resp}

EnvD_SysQual_Diagnostics_IpIpv6MultiCastAddressesList(0x013E)_NegativeResponse
    [Documentation]    To test negative response for IpIpv6MultiCastAddressesList(0x013E)
    [Tags]    CustomerDiagnostic    TCID-272517    FULLTEST	FID-1691424

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpIpv6MultiCastAddressesList_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_NRC$13_IncorrectMessageLengthorInvalidFormat
    [Documentation]    This NRC shall be sent if:
    ...    1) the length of the request message is invalid (minimum length check or modulo 2 division)
    ...    2) the client exceeded the maximum number of dataIdentifiers allowed to be
    ...    requested at a time (max. length check).
    [Tags]    CustomerDiagnostic    TCID-272501    FULLTEST	FID-1151358,1151359,1071149,1069774

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_9DID_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_NRC$13_IncorrectMessageLengthOrInvalidFormat_Write
    [Documentation]    This NRC shall be sent if the length of the message is wrong (min. length check)
    [Tags]    CustomerDiagnostic    TCID-272499    FULLTEST	FID-1151438,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Write_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

EnvD_SysQual_Diagnostics_NRC$13_RequestLengthExceeded_Write
    [Documentation]    This NRC shall be sent if the length of the message is wrong (max. length check)
    [Tags]    CustomerDiagnostic    TCID-272496    FULLTEST	FID-1151441,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.RollerTestStandMode_Write_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

EnvD_SysQual_Diagnostics_Programming_Preconditions(0x0448)(Default Session)
    [Documentation]    This DataIdentifier identifies the programming pre-requisites of the Blade
    [Tags]    CustomerDiagnostic    TCID-272603    FULLTEST	FID-1665039,1665040,1665041,1665043,1665044

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_Req}
    prj.sut.diag.compare    ${sut.diag.ProgrammingPreconditions_Resp}

EnvD_SysQual_Diagnostics_Programming_Preconditions(0x0448)(Extended Session)
    [Documentation]    This DataIdentifier identifies the programming pre-requisites of the Blade
    [Tags]    CustomerDiagnostic    TCID-272610    FULLTEST	FID-1665039,1665040,1665041,1665043,1665044

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_Req}
    prj.sut.diag.compare    ${sut.diag.ProgrammingPreconditions_Resp}

EnvD_SysQual_Diagnostics_Programming Preconditions(0x0448)_NegativeResponse
    [Documentation]    To test negative response for Programming Preconditions(0x0448)
    [Tags]    CustomerDiagnostic    TCID-272545    FULLTEST	FID-1665045

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_Programming_Preconditions(0x0448)(Programming Session)
    [Documentation]    This DataIdentifier identifies the programming pre-requisites of the Blade
    [Tags]    CustomerDiagnostic    TCID-272616    FULLTEST	FID-1665039,1665040,1665041,1665043,1665044

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ProgrammingPreconditions_Req}
    prj.sut.diag.compare    ${sut.diag.ProgrammingPreconditions_Resp}

EnvD_SysQual_Diagnostics_VWApplicationSoftwareVersionNumber(0xF189)(Default Session)
    [Documentation]    The DID VWApplicationSoftwareVersionNumber shall give the
    ...    information about the overall SW(ASW+BSW) version number of
    ...    the Blade.
    [Tags]    CustomerDiagnostic    TCID-272573    FULLTEST	FID-1151031,1151033,1151034,1151036,1151037

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command VWApplicationSoftwareVersionNumber
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWApplicationSoftwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWApplicationSoftwareVersionNumber(0xF189)(Extended Session)
    [Documentation]    The DID VWApplicationSoftwareVersionNumber shall give the
    ...    information about the overall SW(ASW+BSW) version number of
    ...    the Blade in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272560    FULLTEST	FID-1151031,1151033,1151034,1151036,1151037

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command VWApplicationSoftwareVersionNumber
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWApplicationSoftwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWApplicationSoftwareVersionNumber(0xF189)(Programming Session)
    [Documentation]    The DID VWApplicationSoftwareVersionNumber shall give the
    ...    information about the overall SW(ASW+BSW) version number of
    ...    the Blade in programming mode.
    [Tags]    CustomerDiagnostic    TCID-272557    FULLTEST	FID-1151031,1151033,1151034,1151036,1151037

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command VWApplicationSoftwareVersionNumber
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWApplicationSoftwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWApplicationSoftwareVersionNumber(0xF189)_NegativeResponse
    [Documentation]    To test negative response for VVWApplicationSoftwareVersionNumber(0xF189)
    [Tags]    CustomerDiagnostic    TCID-272534    FULLTEST	FID-1151038

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWApplicationSoftwareVersionNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)_NegativeResponse
    [Documentation]    To test negative response for VWClearDiagnosticInformationDateFunctional(0xF1B0)

    [Tags]    CustomerDiagnostic    TCID-272553    FULLTEST	FID-1665055

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command in programming session
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareNumber(0xF191)(Default Session)
    [Documentation]    The DID VWECUHardwareNumber shall give the information about the VW HW version number of each blade
    [Tags]    CustomerDiagnostic    TCID-272566    FULLTEST	FID-1151010,1151012,1151013,1151015,1151016

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareNumber(0xF191)(Extended Session)
    [Documentation]    The DID VWECUHardwareNumber shall give the information about the VW HW version number of each blade in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272563    FULLTEST	FID-1151010,1151012,1151013,1151015,1151016

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareNumber(0xF191)(Programming Session)
    [Documentation]    The DID VWECUHardwareNumber shall give the information about the VW HW version number of each blade in programming mode.
    [Tags]    CustomerDiagnostic    TCID-272594    FULLTEST	FID-1151010,1151012,1151013,1151015,1151016

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareNumber(0xF191)_NegativeResponse
    [Documentation]    To test negative response for VWECUHardwareNumber(0xF191)
    [Tags]    CustomerDiagnostic    TCID-272526    FULLTEST	FID-1151017

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareNumber_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareVersionNumber(0xF1A3)(Default Session)
    [Documentation]    The DID SystemSupplierECUHardwareVersionNumber shall give
    ...    the information about VW ECU HW version number
    [Tags]    CustomerDiagnostic    TCID-272591    FULLTEST	FID-1151021,1151023,1151024,1151026,1151027

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareVersionNumber(0xF1A3)(Extended Session)
    [Documentation]    The DID SystemSupplierECUHardwareVersionNumber shall give
    ...    the information about VW ECU HW version number in extended mode.
    [Tags]    CustomerDiagnostic    TCID-272597    FULLTEST	FID-1151021,1151023,1151024,1151026,1151027

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareVersionNumber(0xF1A3)(Programming Session)
    [Documentation]    The DID SystemSupplierECUHardwareVersionNumber shall give
    ...    the information about VW ECU HW version number in programming mode.
    [Tags]    CustomerDiagnostic    TCID-272589    FULLTEST	FID-1151021,1151023,1151024,1151026,1151027

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command VWECUHardwareNumber
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.VWECUHardwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_VWECUHardwareVersionNumber(0xF1A3)_NegativeResponse
    [Documentation]    To test negative response for VWECUHardwareVersionNumber(0xF1A3)
    [Tags]    CustomerDiagnostic    TCID-272509    FULLTEST	FID-1151028

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWECUHardwareVersionNumber_IncorrectMessageLengthExtra_Req}

# May Cause problem *******************

EnvD_SysQual_Diagnostics_NRC$31_RequestOutOfRange
    [Documentation]    This NRC shall be returned if none of the requested
    ...                dataIdentifier values are supported by the device
    [Tags]    CustomerDiagnostic    TCID-272503    FULLTEST	FID-1151358,1151362,1071149

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.NotSupportedDID_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_NRC$31_RequestOutOfRange_Write
    [Documentation]    This NRC shall be returned if any data transmitted
    ...     in the request message after the dataIdentifier is invalid.
    [Tags]    CustomerDiagnostic    TCID-272511    FULLTEST	FID-1151440,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Write_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

EnvD_SysQual_Diagnostics_NRC$31_RequestOutOfRange_Write_2
    [Documentation]    This NRC shall be returned if the
    ...    dataIdentifier in the request message is not supported in the server
    [Tags]    CustomerDiagnostic    TCID-272510    FULLTEST	FID-1151443,1151389

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Fingerprint_Write_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

EnvD_SysQual_Diagnostics_Multi_DID_Request_check
    [Documentation]    To verify that- Multi DID (Up to 8 DID's) request shall be supported using service 0x22.
    [Tags]    CustomerDiagnostic    TCID-272502    FULLTEST	FID-1069773

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MultiDID_Req}
    prj.sut.diag.compare    ${sut.diag.MultiDID_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MultiDID_Req}
    prj.sut.diag.compare    ${sut.diag.MultiDID_Resp}

EnvD_SysQual_Diagnostics_MultipleTimeNegativeRequest
    [Documentation]    In a multi DID request, the negative response shall be sent only
    ...     when all the DIDs are responded with negative response
    [Tags]    CustomerDiagnostic    TCID-272556    FULLTEST	FID-1069777

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Multi_Negative_DID_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_MultipleTimeNegativeRequest_WithPositiveRequest
    [Documentation]    In a muti DID request, if any DID is reported as negative response,
    ...     then that particular response shall be skipped
    [Tags]    CustomerDiagnostic    TCID-272615    FULLTEST	FID-1069776

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Multi_Negative_with_Positive_DID_Req}
    prj.sut.diag.compare    ${sut.diag.Multi_Negative_with_Positive_DID_Resp}

EnvD_SysQual_Diagnostics_MultipleTimeRequest
    [Documentation]    In a multi DID request, if the same DID is requested multiple times
    ...     then the DID shall be responded multiple times
    [Tags]    CustomerDiagnostic    TCID-272613    FULLTEST	FID-1069775

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Multi_Same_DID_Req}
    prj.sut.diag.compare    ${sut.diag.Multi_Same_DID_Resp}

    # 24.3 new test case starts here

EnvD_SysQual_Diagnostics_DTC_Overvoltage
    [Documentation]    The Operating Mode Subsystem shall set DTC when system voltage enters OVERVOLTAGE state.
    [Tags]    DiagnosticModule    TCID-353659    FID-2889309

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt

    # Adjust KL30 voltage to Overvoltage 18V
    bits_platform.Output Set Analog Signal Value    Battery    19
    Verify DLT keyword    Voltage enters OVERVOLTAGE range
    Log To Console    Maas Blade enters Overvoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}    0    20

    # Return back to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s

EnvD_SysQual_Diagnostics_DTC_Undervoltage
    [Documentation]    The Operating Mode Subsystem shall set DTC when system voltage enters UNDERVOLTAGE state.
    [Tags]    DiagnosticModule    TCID-353660    FID-2881566
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt

    # Adjust KL30 voltage to UnderVoltage 7V
    bits_platform.Output Set Analog Signal Value    Battery    7
    Verify DLT keyword    Voltage enters UNDERVOLTAGE range
    Log To Console    Maas Blade enters Undervoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B6_Resp}    0    20

    # Return back to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    5s

EnvD_SysQual_Diagnostics_IpCounterDroppedIpv6PacketsLayer3(0x01A0)(Default Session)
    [Documentation]    The DID IpCounterDroppedIpv6PacketsLayer3 shall give the count
    ...    about discarded IPv6 packets
    [Tags]    CustomerDiagnostic    TCID-272596    FULLTEST    FID-1383436,1383437,1383438,1383440,1383441
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    Log To Console    counter in hex is ${Counter}
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_0x01A0_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Resp}    0    8

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

EnvD_SysQual_Diagnostics_IpCounterDroppedIpv6PacketsLayer3(0x01A0)(Extended Session)
    [Documentation]    The DID IpCounterDroppedIpv6PacketsLayer3 shall give the count
    ...    about discarded IPv6 packets
    [Tags]    CustomerDiagnostic    TCID-272595    FULLTEST    FID-1383436,1383437,1383438,1383440,1383441

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_0x01A0_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Resp}    0    8

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

EnvD_SysQual_Diagnostics_ResetIpCounterDroppedIpv6PacketsLayer(0x068C)
    [Documentation]    This RID shall reset the Count of the Dropped IPV6 packets
    [Tags]    CustomerDiagnostic    TCID-272624    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1378481,1378482,1378484,1378489,1378490

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Increase the counter
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_0x01A0_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Resp}

        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterDroppedIpv6PacketsLayer(0x068C)(Extended Session)
    [Documentation]    This RID shall reset the Count of the Dropped IPV6 packets
    [Tags]    CustomerDiagnostic    TCID-353707    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1378481,1378482,1378484,1378489,1378490

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Increase the counter
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_0x01A0_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Resp}

        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedIpv6PacketsLayer3_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterDroppedIpv6PacketsLayer(0x068C)(NegativeResponse)
    [Documentation]    To test negative response for ResetIpCounterDroppedIpv6PacketsLayer(0x068C)
    [Tags]    CustomerDiagnostic    TCID-353729    FULLTEST    FID-1381301,1381302

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedIpv6PacketsLayer3_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_RoutineControl_Resp}

EnvD_SysQual_Diagnostics_IpCounterDroppedUdpTcpPacketsLayer4(0x01A1)(Default Session)
    [Documentation]    This Data Identifier identifies counter UDP and TCP messages with
    ...    wrong ports
    [Tags]    CustomerDiagnostic    TCID-272599    FULLTEST    FID-1692033,1692034,1692035,1692037,1692038

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_0x01A1_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Resp}    0    8

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

EnvD_SysQual_Diagnostics_IpCounterDroppedUdpTcpPacketsLayer4(0x01A1)(Extended Session)
    [Documentation]    This Data Identifier identifies counter UDP and TCP messages with
    ...    wrong ports
    [Tags]    CustomerDiagnostic    TCID-272598    FULLTEST    FID-1692033,1692034,1692035,1692037,1692038

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_0x01A1_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Resp}    0    8

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

EnvD_SysQual_Diagnostics_ResetIpCounterDroppedUdpTcpPacketsLayer4(0x068D)
    [Documentation]    The routine "Reset, counter discarded UDP/TCP packets, layer 4"
    ...    must reset the measured value "Counter discarded UDP/TCP packets, layer 4" to the value 0.
    [Tags]    CustomerDiagnostic    TCID-272639    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1805364,1805365,1805366,1805368,1805369

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_0x01A1_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Req}
        # prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterDroppedUdpTcpPacketsLayer4(0x068D)(Extended_Session)
    [Documentation]    The routine "Reset, counter discarded UDP/TCP packets, layer 4"
    ...    must reset the measured value "Counter discarded UDP/TCP packets, layer 4" to the value 0.
    [Tags]    CustomerDiagnostic    TCID-353725    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1805364,1805365,1805366,1805368,1805369

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_0x01A1_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Req}
        # prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterDroppedUdpTcpPacketsLayer4(0x068D)(NegativeResponse)
    [Documentation]    To test negative response for ResetIpCounterDroppedUdpTcpPacketsLayer4(0x068D)
    [Tags]    CustomerDiagnostic    TCID-353730    FULLTEST    FID-1381301,1805370

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_RoutineControl_Resp}

EnvD_SysQual_Diagnostics_IpCounterWrongIpv6Addresses(0x0A2C)(Default Session)
    [Documentation]    This Data Identifier identifies counter messages with invalid IPv6
    ...    addresses.
    [Tags]    CustomerDiagnostic    TCID-272565    FULLTEST    FID-1858015,1858016,1858017,1858019,1858020

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

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
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

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

EnvD_SysQual_Diagnostics_IpCounterWrongUdpPorts(0x0A2F)(Default Session)
    [Documentation]    The DID IpCounterWrongUdpPorts shall give the count about
    ...    wrong UDP ports via which the ethernet packets are sent
    [Tags]    CustomerDiagnostic    TCID-272590    FULLTEST    FID-1394231,1394232,1394233,1394235,1394236

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongUdpPorts_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongUdpPorts_0x0A2F_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongUdpPorts_Resp}    0    8

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

EnvD_SysQual_Diagnostics_IpCounterWrongUdpPorts(0x0A2F)(Extended Session)
    [Documentation]    The DID IpCounterWrongUdpPorts shall give the count about
    ...    wrong UDP ports via which the ethernet packets are sent
    [Tags]    CustomerDiagnostic    TCID-272592    FULLTEST    FID-1394231,1394232,1394233,1394235,1394236

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongUdpPorts_Resp}    0    8

    # Get counter in the last 2 byte and put into new Variable
    ${Counter}    prj.sut.can.diag.get.byte.range    9    14
    ${Counter_Int}    Convert To Integer    0x${Counter}

    # make variable +1
    Log To Console    The counter is currently ${Counter_Int}
    ${Counter_Int_new}    evaluate    ${Counter_Int} + ${COUNTERPLUS1}
    Log To Console    The expected new counter is ${Counter_Int_new}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongUdpPorts_0x0A2F_CounterAdd}

    # send command again
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.IpCounterWrongUdpPorts_Resp}    0    8

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

EnvD_SysQual_Diagnostics_ResetIpCounterWrongUdpPorts(0x05EB)
    [Documentation]    The routine "ResetIpCounterWrongUdpPorts" shall reset the
    ...    measured value "counter messages with invalid UDP ports" to the
    ...    value 0
    [Tags]    CustomerDiagnostic    TCID-272626    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1378495,1378496,1378497,1378499,1378500

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongUdpPorts_0x0A2F_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongUdpPorts_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterWrongUdpPorts(0x05EB)(Extended Session)
    [Documentation]    The routine "ResetIpCounterWrongUdpPorts" shall reset the
    ...    measured value "counter messages with invalid UDP ports" to the
    ...    value 0
    [Tags]    CustomerDiagnostic    TCID-353728    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1378495,1378496,1378497,1378499,1378500

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Increase the counter for the signal
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongUdpPorts_0x0A2F_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_Req}
        # prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongUdpPorts_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_RoutineControl($31)_ResetIpCounterWrongUdpPorts(0x05EB)(NegativeResponse)
    [Documentation]    To test negative response for ResetIpCounterWrongUdpPorts(0x05EB)
    [Tags]    CustomerDiagnostic    TCID-353733    FULLTEST    FID-1381309,1381301

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongUdpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_RoutineControl_Resp}

EnvD_SysQual_Diagnostics_ResetIpCounterWrongTcpPorts(0x05E5)
    [Documentation]    The routine "ResetIpCounterWrongTcpPorts" shall reset the
    ...    measured value "counter messages with invalid TCP ports" to the
    ...    value 0
    [Tags]    CustomerDiagnostic    TCID-272632    FULLTEST
    ...       FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1805353,1805354,1805355,1805357,1805358

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Increase the counter
    prj.sut.diag.IpDrop    ${sut.diag.IpCounterWrongTcpPorts_0x0A2E_CounterAdd}

    prj.sut.can.diag.send    ${sut.diag.IpCounterWrongTcpPorts_Req}
    ${Status}     Run Keyword And Return Status    prj.sut.diag.compare
    ...    ${sut.diag.IpCounterWrongTcpPorts_00_Resp}
    Log To Console    the status is ${Status}
    IF    "${Status}" == "False"
        Log to Console    Counter is not zero, proceed to reset command
        prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongTcpPorts_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongTcpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterWrongTcpPorts_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

EnvD_SysQual_Diagnostics_ResetIpCounterWrongTcpPorts(0x05E5)(NegativeResponse)
    [Documentation]    To test negative response for ResetIpCounterWrongTcpPorts(0x05E5)
    [Tags]    CustomerDiagnostic    TCID-353731    FULLTEST    FID-1805359,1381301

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_RoutineControl_Resp}

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_RoutineControl_Resp}

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ResetIpCounterWrongTcpPorts_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_RoutineControl_Resp}

# 24.4RC1

EnvD_SysQual_Diagnostics_DTC_D20090-PREPARERUNMODEREQNOTREC(Normal Range)
    [Documentation]    Checking Dtc for PREPARERUN_MODE_REQ_NOTREC
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-371277    FULLTEST	FID-2607038

    prj.sut.can.simulation.PowerBladeON
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power off
    prj.sut.power on
    Sleep    1.6s
    prj.sut.can.simulation.PowerBladeON
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    sleep    3s
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_PREPARERUN_MODE_REQ_NOTREC_Resp}

EnvD_SysQual_Diagnostics_DTC_D20090-PREPARERUNMODEREQNOTREC(Lower Limit)
    [Documentation]    Checking Dtc for PREPARERUN_MODE_REQ_NOTREC
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-371275    FULLTEST	FID-2607038

    prj.sut.can.simulation.PowerBladeON
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power off
    prj.sut.power on
    Sleep    1.5s
    prj.sut.can.simulation.PowerBladeON
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    sleep    3s
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_PREPARERUN_MODE_REQ_NOTREC_Resp}

EnvD_SysQual_Diagnostics_DTC_D20090-PREPARERUNMODEREQNOTREC(Upper Limit)
    [Documentation]    Checking Dtc for PREPARERUN_MODE_REQ_NOTREC
    ...    as whether any routine control service is active or not
    [Tags]    CustomerDiagnostic    TCID-371274    FULLTEST	FID-2607038

    prj.sut.can.simulation.PowerBladeON
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power off
    prj.sut.power on
    Sleep    1.4s
    prj.sut.can.simulation.PowerBladeON
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    5s
    ${result}    Run Keyword And Return Status    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_PREPARERUN_MODE_REQ_NOTREC_Resp}
    IF    ${result} == ${True}
        prj.sut.can.simulation.PowerBladeON
        Set Test Status To Fail    error_type=DTCCode    info_text= DTC code is seen.NOK!
    ELSE
        Log To Console    Test case PASS
    END
    prj.sut.can.simulation.PowerBladeON

EnvD_SysQual_Diagnostics_DTC_FrequencyCounter-IncrementalGeneric
    [Documentation]  For each fault record, the ECU shall
    ...    support a Frequency Counter indicating the total number
    ...    of times a a DTC is qulaified and dequalified i.e.
    ...    DTC status bit 0 (TestFailed) has transitioned from FALSE to TRUE.
    [Tags]    CustomerDiagnostic    TCID-371284    FULLTEST	FID-1447001

    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
    ${byte_range}    prj.sut.can.diag.get.byte.range    15    17
    IF    "${byte_range}" != "2B"
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=DTC did not activate!
    ELSE
        ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
        ${byte_value}    Convert To Integer    ${byte_value}
        bits_platform.Output Set Analog Signal Value    Battery    12
        bits_platform.Output Set Analog Signal Value    Battery    7
        Sleep    2s

        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
        ${byte_range}    prj.sut.can.diag.get.byte.range    15    17
        IF    "${byte_range}" != "2B"
            Set Test Status To Fail    error_type=DIAGNOSIS
            ...    info_text=DTC did not activate!
        ELSE
            ${byte_value_2}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
            ${byte_value_2}    Convert To Integer    ${byte_value_2}
            IF    ${byte_value} < ${byte_value_2}
               Log To Console    Counter increased to ${byte_value_2}

            ELSE
               Set Test Status To Fail    error_type=DIAGNOSIS
               ...    info_text=The incrementing did not happen. Current increment is still same with ${byte_value}
            END
        END
    END
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_DTC_FrequencyCounter-FirstOccurance
    [Documentation]  At the first occurence of a DTC the Frequency Counter shall initially be set to 1.
    [Tags]    CustomerDiagnostic    TCID-371282    FULLTEST	FID-1447002

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
    ${byte_range}    prj.sut.can.diag.get.byte.range    15    17
    IF    "${byte_range}" != "2B"
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=DTC did not activate!
    ELSE
        ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
        ${byte_value}    Convert To Integer    ${byte_value}
        IF    ${byte_value} == ${1}
           Log To Console    Counter increased to ${byte_value}

        ELSE
           Set Test Status To Fail    error_type=DIAGNOSIS
           ...    info_text=The expected result is: ${1} but we are getting: ${byte_value} from DUT!
        END
    END
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_DTC_FrequencyCounter-IncrementalCheck
    [Documentation]  Each time the DTC is qualified from not qualified state , the Frequency Counter value shall be incremented by 1.
    [Tags]    CustomerDiagnostic    TCID-371280    FULLTEST	FID-1447003

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    FOR     ${i}     IN RANGE     0    10
        ${j}    Set Variable    ${${i}+${1}}
        bits_platform.Output Set Analog Signal Value    Battery    7
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
        ${byte_range}    prj.sut.can.diag.get.byte.range    15    17
        IF    "${byte_range}" != "2B"
             Set Test Status To Fail    error_type=DIAGNOSIS
             ...    info_text=DTC did not activate!
        ELSE
             ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
             ${byte_value}    Convert To Integer    ${byte_value}
             IF    ${byte_value} == ${j}
               Log To Console    Counter increased to ${byte_value}
               bits_platform.Output Set Analog Signal Value    Battery    12
             ELSE
               Set Test Status To Fail    error_type=DIAGNOSIS
               ...    info_text=The expected result is: ${j} but we are getting: ${byte_value} from DUT!
             END
        END
    END

EnvD_SysQual_Diagnostics_DTC_FrequencyCounter-IncrementalCheck255
     [Documentation]  Each time the DTC is qualified from not qualified state , the Frequency Counter value shall be incremented by 1.
     [Tags]    CustomerDiagnostic    TCID-371281    FULLTEST	FID-1447004

     prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
     prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
     FOR     ${i}     IN RANGE     0    256
        ${j}    Set Variable    ${${i} + ${1}}
        bits_platform.Output Set Analog Signal Value    Battery    7
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}
        ${byte_range}    prj.sut.can.diag.get.byte.range    15    17

        IF    "${byte_range}" != "2B"
            Set Test Status To Fail    error_type=DIAGNOSIS
           ...    info_text=DTC did not activate!
        ELSE
            Log To Console    DTC is activated
            ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
            ${byte_value}    Convert To Integer    ${byte_value}
            IF    ${byte_value} == ${j}
               Log To Console    Counter increased to ${byte_value}
               bits_platform.Output Set Analog Signal Value    Battery    12
            ELSE
               Set Test Status To Fail    error_type=DIAGNOSIS
               ...    info_text=The expected result is: ${j} but we are getting: ${byte_value} from DUT!
            END
        END

     END
     # now check if the 255 is latched at 255

     bits_platform.Output Set Analog Signal Value    Battery    7
     Sleep    2s
     prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_Undervoltage_Req}

     ${byte_range}    prj.sut.can.diag.get.byte.range    15    17

     IF    "${byte_range}" != "2B"
         Set Test Status To Fail    error_type=DIAGNOSIS
         ...    info_text=DTC did not activate!
     ELSE
         ${byte_value}    prj.sut.can.diag.get.byte.specific    ${sut.diag.ReportDTCByStatusMask_DTC_Counter_ByteCheck_Resp}
         ${byte_value}    Convert To Integer    ${byte_value}
         IF    ${byte_value} == ${255}
            Log To Console    Counter latched at ${byte_value}
            bits_platform.Output Set Analog Signal Value    Battery    12
         ELSE
            Set Test Status To Fail    error_type=DIAGNOSIS
            ...    info_text=The expected result is: 255 but we are getting: ${byte_value} from DUT!
         END
     END

# tower 3

# EnvD_SysQual_Diagnostics_DTC_NoETHConnectionToMainBlade
#     [Documentation]    In case no ethernet link is established to Main Blade(Port 9)
#     ...     after 5000ms upon system boot up,DTC shall be logged.
#     [Tags]    FULLTEST    CustomerDiagnostic    TCID-371276    FID-2441939

#     # Shutdown the System and q5050 switchboard
#     prj.sut.can.simulation.PowerBladeOFF
#     ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    0
#     # ${b_ack}    bits_platform.Output Set Analog Signal Value    Ignition    0
#     ${b_ack}    bits_platform.Output Set Analog Signal Value    Q5050    0
#     Sleep    2s
#     # Turn back on the board
#     # ${b_ack}    bits_platform.Output Set Analog Signal Value    Ignition    12
#     ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    12
#     prj.sut.can.simulation.PowerBladeON
#     Sleep    6s

#     # Turn ON Q5050 switch
#     ${b_ack}    bits_platform.Output Set Analog Signal Value    Q5050    12
#     Sleep    8s
#     # Check DTC
#     prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
#     Sleep    3s
#     prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_NoETHConnectionDTC_Resp}

EnvD_SysQual_Diagnostics_DTC_NonVolatileMemory
    [Documentation]    Each blade must have a non-volatile memory (e.g. EEPROM)
    ...    in which the events with the associated ambient data can be stored.
    [Tags]    CustomerDiagnostic    TCID-371297    FULLTEST	FID-1446835

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt

    # Adjust KL30 voltage to Overvoltage 18V
    bits_platform.Output Set Analog Signal Value    Battery    18
    Verify DLT keyword    Voltage enters OVERVOLTAGE range
    Log To Console    Maas Blade enters Overvoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}

    # Return back to normal voltage
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    2s
    # powercycle
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    5s
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_NonVolatileMemory_Req}
    Sleep    5s
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_NonVolatileMemory_Resp}

EnvD_SysQual_Diagnostics_DTC_StatusOfDTC
    [Documentation]    To check DTC status value for DTC symptom
    [Tags]    CustomerDiagnostic    TCID-371295    FULLTEST	FID-1446837,1446838,1446840

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt

    # Adjust KL30 voltage to Overvoltage 18V
    bits_platform.Output Set Analog Signal Value    Battery    18
    Verify DLT keyword    Voltage enters OVERVOLTAGE range
    Log To Console    Maas Blade enters Overvoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    prj.sut.diag.compare.byte.range    ${sut.diag.StatusOfDTC}    -2    ${NONE}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_DTC_CameraPhantomPowerSupply
    [Documentation]    The Operating Mode Subsystem shall set DTC when
    ...    Camera Phantom Power Supply failure occurs.
    [Tags]    CustomerDiagnostic    TCID-371296    FULLTEST	FID-2881581

    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Trigger Short to ground Camera Power Supply
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    ON
    Sleep    10s
    bits_platform.Output Set Digital Signal Value    Camera_Short_Ground    OFF
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkDTC    ${sut.diag.ReportDTCByStatusMask_CameraPhantomPowerFailure_Resp}

    # tower 1

EnvD_SysQual_Diagnostics_ExtendedRecord2_Mileage
    [Documentation]    The Mileage shall be capture with 3bytes of data from the received message
    [Tags]    CustomerDiagnostic    TCID-371279    FULLTEST	FID-1447007,1447011
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    1    999999

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    prj.sut.diag.SetETHSignal    1    12345
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_AgingCounter_Resp}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Mileage12345_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ExtendedRecord2_Mileage(NegativeTest)
    [Documentation]    The Mileage shall be capture with 3bytes of data from the received message
    [Tags]    CustomerDiagnostic    TCID-371283    FULLTEST	FID-1447007,1447011    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    1    10000

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.diag.SetETHSignal    1    12345
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_AgingCounter_Resp}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Mileage10000_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ExtendedRecord2_Timestamp
    [Documentation]    The timestamp shall be captured in 5bytes of data from the received message Diagnose_01
    [Tags]    CustomerDiagnostic    TCID-371278    FULLTEST	FID-1447007,1447015,1447016
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_AgingCounter_Resp}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Timestamp_Variation2_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ExtendedRecord2_Timestamp(NegativeTest)
    [Documentation]    The timestamp shall be captured in 5bytes of data from the received message Diagnose_01
    [Tags]    CustomerDiagnostic    TCID-371285    FULLTEST	FID-1447007,1447015,1447016    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_AgingCounter_Resp}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Timestamp_Variation1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleSpeed
    [Documentation]    This DID(0x2B16) shall give the Vehicle Speed when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371294    FULLTEST	FID-1818668,1826246
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    0    20

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_20_Resp}

    prj.sut.diag.SetETHSignal    0    50
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleSpeed_50_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_50_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleSpeed(NegativeTest)
    [Documentation]    This DID(0x2B16) shall give the Vehicle Speed when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371299    FULLTEST	FID-1818668,1826246    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    0    20

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_20_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s
    prj.sut.diag.SetETHSignal    0    50

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleSpeed_20_Resp}
    prj.sut.can.diag.send    ${sut.diag.VehicleSpeed_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleSpeed_50_Resp}
    Log To Console    Snapshot data is not updated to the latest value. Test case PASS!

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_IgnitionStatus
    [Documentation]    This DID(0x030D) shall give the Ignition status when the DTC was qualified for the blade under test
    [Tags]    CustomerDiagnostic    TCID-371288    FULLTEST	FID-1826286,1826288
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    8    0

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.IgnitionStatus_Req}
    prj.sut.diag.compare    ${sut.diag.IgnitionStatus_0_Resp}

    prj.sut.diag.SetETHSignal    8    1
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_IgnitionStatus_1_Resp}

    prj.sut.can.diag.send    ${sut.diag.IgnitionStatus_Req}
    prj.sut.diag.compare    ${sut.diag.IgnitionStatus_1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_IgnitionStatus(NegativeTest)
    [Documentation]    This DID(0x030D) shall give the Ignition status when the DTC was qualified for the blade under test
    [Tags]    CustomerDiagnostic    TCID-371289    FULLTEST	FID-1826286,1826288    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    8    0

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.IgnitionStatus_Req}
    prj.sut.diag.compare    ${sut.diag.IgnitionStatus_0_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s
    prj.sut.diag.SetETHSignal    8    1

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_IgnitionStatus_0_Resp}

    prj.sut.can.diag.send    ${sut.diag.IgnitionStatus_Req}
    prj.sut.diag.compare    ${sut.diag.IgnitionStatus_1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_EngineStatus
    [Documentation]    This DID(0x02B7) shall give the Engine status when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371290    FULLTEST	FID-1826298,1826299
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    9    0

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    prj.sut.diag.compare    ${sut.diag.EngineStatus_0_Resp}

    prj.sut.diag.SetETHSignal    9    1
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_EngineStatus_1_Resp}

    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    prj.sut.diag.compare    ${sut.diag.EngineStatus_1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_EngineStatus(NegativeTest)
    [Documentation]    This DID(0x02B7) shall give the Engine status when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371291    FULLTEST	FID-1826298,1826299    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    9    0

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    prj.sut.diag.compare    ${sut.diag.EngineStatus_0_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s
    prj.sut.diag.SetETHSignal    9    1

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_EngineStatus_0_Resp}

    prj.sut.can.diag.send    ${sut.diag.EngineStatus_Req}
    prj.sut.diag.compare    ${sut.diag.EngineStatus_1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleTimeStamp
    [Documentation]    This DID(0x2BC1) shall give the Vehicle Time stamp when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371292    FULLTEST	FID-1826336,1826335
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation1_Resp}

    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleTimeStamp_Variation2_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation2_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleTimeStamp(NegativeTest)
    [Documentation]    This DID(0x2BC1) shall give the Vehicle Time stamp when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371286    FULLTEST	FID-1826336,1826335    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation1_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleTimeStamp_Variation1_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleTimeStamp_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleTimeStamp_Variation2_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleMileage
    [Documentation]    This DID(0x295A) shall give the Vehicle Mileage when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371287    FULLTEST	FID-1826339,1826340
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    1    10000

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_10000_Resp}
    Sleep    3s
    prj.sut.diag.SetETHSignal    1    12345

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleMileage_12345_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_12345_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_VehicleMileage(NegativeTest)
    [Documentation]    This DID(0x295A) shall give the Vehicle Mileage when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-371293    FULLTEST	FID-1826339,1826340    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    1    10000

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_10000_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.diag.SetETHSignal    1    12345

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleMileage_10000_Resp}

    prj.sut.can.diag.send    ${sut.diag.VehicleMileage_Req}
    prj.sut.diag.compare    ${sut.diag.VehicleMileage_12345_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_SupplyVoltageOfTheBlade
    [Documentation]    This DID(0x1906) shall give the Supply Voltage when the DTC was qualified for the blade under test
    [Tags]    CustomerDiagnostic    TCID-371298    FULLTEST	FID-11826342,1826343

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.SupplyVoltage_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkDTC    ${sut.diag.SupplyVoltage_12V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 12V. Comapring with 11.9V
        prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_SupplyVoltage_119V_Resp}
        prj.sut.can.diag.send    ${sut.diag.SupplyVoltage_Req}
        prj.sut.diag.compare    ${sut.diag.SupplyVoltage_119V_Resp}
    ELSE
        prj.sut.can.diag.send    ${sut.diag.SupplyVoltage_Req}
        prj.sut.diag.compare    ${sut.diag.SupplyVoltage_12V_Resp}
    END

    bits_platform.Output Set Analog Signal Value    Battery    12
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_SupplyVoltage_19V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 19V. Comapring with 18.9V
        prj.sut.diag.checkDTC    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_SupplyVoltage_189V_Resp}
        prj.sut.can.diag.send    ${sut.diag.SupplyVoltage_Req}
        prj.sut.diag.compare    ${sut.diag.SupplyVoltage_189V_Resp}
    ELSE
        prj.sut.can.diag.send    ${sut.diag.SupplyVoltage_Req}
        prj.sut.diag.compare    ${sut.diag.SupplyVoltage_19V_Resp}
    END

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_ComputeElementTemperatureOfTheBlade
    [Documentation]    This DID(0x1906) shall give the Supply Voltage when the DTC was qualified for the blade under test
    [Tags]    CustomerDiagnostic    TCID-371300    FULLTEST	FID-1826351

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.connect.dlt
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.ComputeElementTemperature_Req}
    prj.sut.diag.checkDTC    ${sut.diag.ComputeElementTemperature_Resp}

    ${McTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${MC}    Convert To Integer    0x${McTemp}
    Log To Console    Microcontroller temp is ${MC}
    ${MpTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${MP}    Convert To Integer    0x${MpTemp}
    Log To Console    Microprocessor temp is ${MP}
    ${PMICTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${PMIC}    Convert To Integer    0x${PMICTemp}
    Log To Console    PMIC temp is ${PMIC}
    ${ETHTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${ETH}    Convert To Integer    0x${ETHTemp}
    Log To Console    PMIC temp is ${ETH}

    prj.sut.disconnect.dlt
    Sleep    2s
    @{pattern_list}    Create List    [Temperature] DID request [MicroController Temperature] = ${MC}
    ...    [Temperature] DID request [MicroProcessor Temperature] = ${MP}
    ...    [Temperature] DID request [PMIC Temperature] = ${PMIC}
    ...    [Temperature] DID request [Ethernet Switch Temperature] = ${ETH}

    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Searching for "${index}"
        ${Status}    Run Keyword And Return Status    Should Contain    ${Temp_Log}    ${index}
        IF    ${Status} == True
            Log To Console    Keyword "${index}" found!
        ELSE
            Log to COnsole    Keyword "${index}" is NOT found
            ${Keyword_var}        Set Variable        ${index}
            Set Test Status To Fail    error_type=DLT    info_text=Keyword "${Keyword_var}" is NOT found
        END
    END

    bits_platform.Output Set Analog Signal Value    Battery    20
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ComputeElementTemperature_Req}
    ${ElementTemp}    prj.sut.can.diag.get.byte.range    3    20

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkDTC    ${ElementTemp}

EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)(Default Session)
    [Documentation]    This Data Identifier indicates the date of the event recorder deletion.The Timestamp shall be read from the message Diagnose_01
    [Tags]    FID-1665051,1665050,1665049,1665054,1665053    TCID-272559    CustomerDiagnostic    FULLTEST
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    1    # set Month to 1
    prj.sut.diag.SetETHSignal    4    2    # set Day to 2
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    4    # set Minute to 4
    prj.sut.diag.SetETHSignal    7    5    # set Seconds to 5
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Req}
    prj.sut.diag.compare    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Variation1_Resp}

EnvD_SysQual_Diagnostics_VWClearDiagnosticInformationDateFunctional(0xF1B0)(Extended Session)
    [Documentation]    This Data Identifier indicates the date of the event recorder deletion.The Timestamp shall be read from the message Diagnose_01
    [Tags]    FID-1665053,1665049,1665050,1665051,1665054    TCID-272561    CustomerDiagnostic    FULLTEST
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Req}
    prj.sut.diag.compare    ${sut.diag.VWClearDiagnosticInformationDateFunctional_Variation2_Resp}

EnvD_SysQual_Diagnostics_Report_Number_of_DTC_by_Status_Mask(0x01)(Default Session)
    [Documentation]    A client can retrieve a count of the number of DTCs matching a client defined status mask
    ...    by sending a request for this service with the SubFunction set to reportNumberOfDTCByStatusMask.
    [Tags]    FID-1290752,1287925,1290755,1290753,1290756    TCID-272554    CustomerDiagnostic    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    prj.sut.diag.compare    ${sut.diag.Report_Number_of_DTC_by_Status_Mask__NoDTC_Resp}

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    prj.sut.diag.compare    ${sut.diag.Report_Number_of_DTC_by_Status_Mask__1DTC_Resp}

    # Trigger Undervoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    prj.sut.diag.compare    ${sut.diag.Report_Number_of_DTC_by_Status_Mask__2DTC_Resp}

    # Post Condition
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Report_Number_of_DTC_by_Status_Mask(0x01)(Extended Session)
    [Documentation]    A client can retrieve a count of the number of DTCs matching a client defined status mask
    ...    by sending a request for this service with the SubFunction set to reportNumberOfDTCByStatusMask.
    [Tags]    FID-1290752,1287925,1290755,1290753,1290756    TCID-272551    CustomerDiagnostic    FULLTEST

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    prj.sut.diag.compare    ${sut.diag.Report_Number_of_DTC_by_Status_Mask__NoDTC_Resp}

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    prj.sut.diag.compare    ${sut.diag.Report_Number_of_DTC_by_Status_Mask__1DTC_Resp}

    # Trigger Undervoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep    2s

    prj.sut.can.diag.send    ${sut.diag.Report_Number_of_DTC_by_Status_Mask_Req}
    prj.sut.diag.compare    ${sut.diag.Report_Number_of_DTC_by_Status_Mask__2DTC_Resp}

    # Post Condition
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Report_DTC_By_Status_Mask(0x02)(Extended Session)
    [Documentation]    The client can retrieve a list of DTCs, which satisfy a client defined
    ...     status mask by sending a request with the SubFunction byte set to reportDTCByStatusMask.
    [Tags]    CustomerDiagnostic    TCID-272537    FULLTEST    FID-1290764,1290752,1287925,1290765,1290762

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    # Trigger Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}    0    20

    # Post Condition
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Report_DTC_Ext_Data_Record_By_DTC_Number(0x06)
    [Documentation]    A client queries extended data (environment data) for a defined DTC
    ...    in conjunction with a DTCExtendedDataRecordNumber by sending a request with the service
    ...     19hex with the subfunction ReportDTCExtendedDataRecordByDTCNumber (0x06).
    [Tags]    CustomerDiagnostic    TCID-272543    FULLTEST    FID-1290752,1287925,1443754,1443757,1443756

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.compare    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Passive_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Req}
    prj.sut.diag.checkDTC    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Overvoltage_ExtendedData2_Resp}

    # Post Condition
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Read_SoftSKU_Universal_Token (0xFD03)(Default Session)
    [Documentation]    This DID(0xFD03) shall read a file in the temporary directory; the /tmp/MAAS_key.bin file
    [Tags]    CustomerDiagnostic    TCID-540497    FULLTEST    FID-5080774,5080775,5080776,5080778, 5080779

    # Pre Condition
    bits_platform.Output Set Analog Signal Value    Battery    12

    #    Go to Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #    Go to Write 1 Byte data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req1}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    #    Go to Default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    #    Read and check 1 Byte data is available
    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_Req}
    prj.sut.diag.compare    ${sut.diag.ReadSOFTSKUUniversalToken_Resp1}

    #    Go to Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #    Go to Write 2000 Bytes data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req2}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    #    Go to Default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    #    Read and check 2000 Byte data is available
    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_Req}
    prj.sut.diag.compare    ${sut.diag.ReadSOFTSKUUniversalToken_Resp2}

    #    Go to Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #    Go to Write 4000 Bytes data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req3}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    #    Go to Default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    #    Read and check 4000 Byte data is available
    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_Req}
    prj.sut.diag.compare    ${sut.diag.ReadSOFTSKUUniversalToken_Resp3}

EnvD_SysQual_Diagnostics_Read_SoftSKU_Universal_Token (0xFD03)(Extended Session)
    [Documentation]    This DID(0xFD03) shall read a file in the temporary directory; the /tmp/MAAS_key.bin file
    [Tags]    CustomerDiagnostic    TCID-540495    FULLTEST    FID-5080774,5080775,5080776,5080778, 5080779

    #    Go to Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #    Go to Write 1 Byte data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req1}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    #    Read and check 1 Byte data is available
    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_Req}
    prj.sut.diag.compare    ${sut.diag.ReadSOFTSKUUniversalToken_Resp1}

    #    Go to Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #    Go to Write 2000 Bytes data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req2}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    #    Read and check 2000 Byte data is available
    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_Req}
    prj.sut.diag.compare    ${sut.diag.ReadSOFTSKUUniversalToken_Resp2}

    #    Go to Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #    Go to Write 4000 Bytes data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req3}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    #    Read and check 4000 Byte data is available
    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_Req}
    prj.sut.diag.compare    ${sut.diag.ReadSOFTSKUUniversalToken_Resp3}

EnvD_SysQual_Diagnostics_Read_SoftSKU_Universal_Token (0xFD03)(NegativeResponse)
    [Documentation]    	To test negative response for ReadSoftSKUUniversalToken(0xFD03)
    [Tags]    CustomerDiagnostic    TCID-540496    FULLTEST	FID-5080780

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReadSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_Write_SoftSKU_Universal_Token (0xFD03)(Extended Session)
    [Documentation]    This DID(0xFD03) shall create a file in the temporary directory and saves the entered data to the /tmp/MAAS_key.bin file.
    [Tags]    CustomerDiagnostic    TCID-540493    FULLTEST	FID-5080765,5080766,5080767,5080769,5080770

    #    Go to Extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    #    Go to Write 1 Byte data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req1}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    Sleep    5s

    #    Go to Write 2000 Bytes data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req2}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

    Sleep    5s

    #    Go to Write 4000 Bytes data
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_Req3}
    prj.sut.diag.compare    ${sut.diag.WriteSOFTSKUUniversalToken_Resp}

EnvD_SysQual_Diagnostics_Write_SoftSKU_Universal_Token (0xFD03)(NegativeResponse)
    [Documentation]    	To test negative response for WriteSoftSKUUniversalToken(0xFD03)
    [Tags]    CustomerDiagnostic    TCID-540494    FULLTEST	FID-5080771

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Write_Resp}

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.WriteSOFTSKUUniversalToken_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.Write_ServiceNotSupportedInActiveSession_Resp}
