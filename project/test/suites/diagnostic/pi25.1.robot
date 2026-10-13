*** Settings ***
Documentation    This is test suite for demo
Resource    ${TAF_PATH}/import.resource
Library     QConnectBase.ConnectionManager
Library    AppiumLibrary
Library    ${TAF_PATH}/project/test/suites/diagnostic/HextoASCII.py

Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Test Cases ***
EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCSWVersion(0xFEF1)(Default Session)
    [Documentation]    The DID  SoCSWVersion shall give the information about the SW Version
    ...     of diagnostics process under QNX.
    [Tags]    CustomerDiagnostic    TCID-404431    FULLTEST    FID-2845882,2845883,2845884,2845886,2845887,1592416     # 1592416 is SYS req

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_Req}
    prj.sut.diag.compare    ${sut.diag.SoC_SWVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCSWVersion(0xFEF1)(Extended Session)
    [Documentation]    The DID  SoCSWVersion shall give the information about the SW Version
    ...     of diagnostics process under QNX.
    [Tags]    CustomerDiagnostic    TCID-404432    FULLTEST    FID-2845882,2845883,2845884,2845886,2845887

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_Req}
    prj.sut.diag.compare    ${sut.diag.SoC_SWVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCSWVersion(0xFEF1)(Programming Session)
    [Documentation]    The DID  SoCSWVersion shall give the information about the SW Version
    ...     of diagnostics process under QNX.
    [Tags]    CustomerDiagnostic    TCID-404433    FULLTEST    FID-2845882,2845883,2845884,2845886,2845887

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_Req}
    prj.sut.diag.compare    ${sut.diag.SoC_SWVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCSWVersion(0xFEF1)(NegativeResponse)
    [Documentation]    To test negative response for SoCSWVersion(0xFEF1)
    [Tags]    CustomerDiagnostic    TCID-404428    FULLTEST    FID-2845888

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SoC_SWVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus1(0xFEFD)(Default Session)
    [Documentation]    The DID  DisplayLinkStatus1 shall give the information about the
    ...      Status of link to Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404429    FULLTEST    FID-2845893,2845894,2845895,2845897,2845898

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus1(0xFEFD)(Extended Session)
    [Documentation]    The DID  DisplayLinkStatus1 shall give the information about the
    ...      Status of link to Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404430    FULLTEST    FID-2845893,2845894,2845895,2845897,2845898

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus1(0xFEFD)(Programming Session)
    [Documentation]    The DID  DisplayLinkStatus1 shall give the information about the
    ...      Status of link to Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404437    FULLTEST    FID-2845893,2845894,2845895,2845897,2845898

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus1(0xFEFD)(NegativeResponse)
    [Documentation]    To test negative response for DisplayLinkStatus1(0xFEFD)
    [Tags]    CustomerDiagnostic    TCID-404438    FULLTEST    FID-2845899

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus2(0xFEF6)(Default Session)
    [Documentation]    The DID  DisplayLinkStatus2 shall give the information about the
    ...     Status of link to Display#1 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404439    FULLTEST    FID-2845902,2845903,2845904,2845906,2845907

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus2_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus2(0xFEF6)(Extended Session)
    [Documentation]    The DID  DisplayLinkStatus2 shall give the information about the
    ...     Status of link to Display#1 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404434    FULLTEST    FID-2845902,2845903,2845904,2845906,2845907

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus2_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus2(0xFEF6)(Programming Session)
    [Documentation]    The DID  DisplayLinkStatus2 shall give the information about the
    ...     Status of link to Display#1 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404435    FULLTEST    FID-2845902,2845903,2845904,2845906,2845907

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus2_Req}
    prj.sut.diag.compare    ${sut.diag.DisplayLinkStatus2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_DisplayLinkStatus2(0xFEF6)(NegativeResponse)
    [Documentation]    To test negative response for DisplayLinkStatus2(0xFEF6)
    [Tags]    CustomerDiagnostic    TCID-404436    FULLTEST    FID-2845908

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.DisplayLinkStatus1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails1(0xFEF3)(Default Session)
    [Documentation]    The DID  SerializerDetails1 shall give the information about the
    ...     Serializer Details for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404419    FULLTEST    FID-2845911,2845912,2845913,2845915,2845916

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails1(0xFEF3)(Extended Session)
    [Documentation]    The DID  SerializerDetails1 shall give the information about the
    ...     Serializer Details for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404420    FULLTEST    FID-2845911,2845912,2845913,2845915,2845916

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails1(0xFEF3)(Programming Session)
    [Documentation]    The DID  SerializerDetails1 shall give the information about the
    ...     Serializer Details for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404421    FULLTEST    FID-2845911,2845912,2845913,2845915,2845916

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails1(0xFEF3)(NegativeResponse)
    [Documentation]    To test negative response for SerializerDetails1(0xFEF3)
    [Tags]    CustomerDiagnostic    TCID-404416    FULLTEST    FID-2845917

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails2(0xFEF7)(Default Session)
    [Documentation]    The DID  SerializerDetails2 shall give the information about the
    ...     Serializer Details for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404417    FULLTEST    FID-2845920,2845921,2845922,2845924,2845925

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails2(0xFEF7)(Extended Session)
    [Documentation]    The DID  SerializerDetails2 shall give the information about the
    ...     Serializer Details for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404418    FULLTEST    FID-2845920,2845921,2845922,2845924,2845925

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails2(0xFEF7)(Programming Session)
    [Documentation]    The DID  SerializerDetails2 shall give the information about the
    ...     Serializer Details for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404425    FULLTEST    FID-2845920,2845921,2845922,2845924,2845925

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerDetails2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerDetails2(0xFEF7)(NegativeResponse)
    [Documentation]    To test negative response for SerializerDetails2(0xFEF7)
    [Tags]    CustomerDiagnostic    TCID-404426    FULLTEST    FID-2845926

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerDetails2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters1(0xFEF4)(Default Session)
    [Documentation]    The DID  SelectedCounters1 shall give the information about the
    ...     Selected counters for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404427    FULLTEST    FID-2845929,2845930,2845931,2845933,2845934

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters1(0xFEF4)(Extended Session)
    [Documentation]    The DID  SelectedCounters1 shall give the information about the
    ...     Selected counters for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404422    FULLTEST    FID-2845929,2845930,2845931,2845933,2845934

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters1(0xFEF4)(Programming Session)
    [Documentation]    The DID  SelectedCounters1 shall give the information about the
    ...     Selected counters for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404423    FULLTEST    FID-2845929,2845930,2845931,2845933,2845934

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters1(0xFEF4)(NegativeResponse)
    [Documentation]    To test negative response for SelectedCounters1(0xFEF4)
    [Tags]    CustomerDiagnostic    TCID-404424    FULLTEST    FID-2845935

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters2(0xFEF8)(Default Session)
    [Documentation]    The DID  SelectedCounters2 shall give the information about
    ...     Selected counters for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404455    FULLTEST    FID-2845938,2845939,2845940,2845942,2845943

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters2(0xFEF8)(Extended Session)
    [Documentation]    The DID  SelectedCounters2 shall give the information about
    ...     Selected counters for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404456    FULLTEST    FID-2845938,2845939,2845940,2845942,2845943

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters2(0xFEF8)(Programming Session)
    [Documentation]    The DID  SelectedCounters2 shall give the information about
    ...     Selected counters for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404457    FULLTEST    FID-2845938,2845939,2845940,2845942,2845943

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_Req}
    prj.sut.diag.compare    ${sut.diag.SelectedCounters2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SelectedCounters2(0xFEF8)(NegativeResponse)
    [Documentation]    To test negative response for SelectedCounters2(0xFEF8)
    [Tags]    CustomerDiagnostic    TCID-404452    FULLTEST    FID-2845944

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SelectedCounters2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature1(0xFEF5)(Default Session)
    [Documentation]    The DID  SerializerTemperature1 shall give the Serializer Temperature
    ...     for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404453    FULLTEST    FID-2845947,2845948,2845949,2845951,2845952

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature1(0xFEF5)(Extended Session)
    [Documentation]    The DID  SerializerTemperature1 shall give the Serializer Temperature
    ...     for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404454    FULLTEST    FID-2845947,2845948,2845949,2845951,2845952

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature1(0xFEF5)(Programming Session)
    [Documentation]    The DID  SerializerTemperature1 shall give the Serializer Temperature
    ...     for Display#1 (ABT Center Display)
    [Tags]    CustomerDiagnostic    TCID-404461    FULLTEST    FID-2845947,2845948,2845949,2845951,2845952

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature1_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature1(0xFEF5)(NegativeResponse)
    [Documentation]    To test negative response for SerializerTemperature1(0xFEF5)
    [Tags]    CustomerDiagnostic    TCID-404462    FULLTEST    FID-2845953

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature1_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature2(0xFEF9)(Default Session)
    [Documentation]    The DID  SerializerTemperature2 shall give the Serializer Temperature
    ...     for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404463    FULLTEST    FID-2845957,2845958,2845959,2845961,2845962

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature2(0xFEF9)(Extended Session)
    [Documentation]    The DID  SerializerTemperature2 shall give the Serializer Temperature
    ...     for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404458    FULLTEST    FID-2845957,2845958,2845959,2845961,2845962

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature2(0xFEF9)(Programming Session)
    [Documentation]    The DID  SerializerTemperature2 shall give the Serializer Temperature
    ...     for Display#2 (Passengers Display)
    [Tags]    CustomerDiagnostic    TCID-404459    FULLTEST    FID-2845957,2845958,2845959,2845961,2845962

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_Req}
    prj.sut.diag.compare    ${sut.diag.SerializerTemperature2_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SerializerTemperature2(0xFEF9)(NegativeResponse)
    [Documentation]    To test negative response for SerializerTemperature2(0xFEF9)
    [Tags]    CustomerDiagnostic    TCID-404460    FULLTEST    FID-2845963

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SerializerTemperature2_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0xFEFA)(Default Session)
    [Documentation]    The DID  GVM_Status shall give the information about the  Status of Guest Virtual Machines (GVM) .
    [Tags]    CustomerDiagnostic    TCID-404443    FULLTEST    FID-2845966,2845967,2845968,2845970,2845971

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.GVMStatus_Req}
    prj.sut.diag.compare    ${sut.diag.GVMStatus_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0xFEFA)(Extended Session)
    [Documentation]    The DID  GVM_Status shall give the information about the  Status of Guest Virtual Machines (GVM) .
    [Tags]    CustomerDiagnostic    TCID-404444    FULLTEST    FID-2845966,2845967,2845968,2845970,2845971

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.GVMStatus_Req}
    prj.sut.diag.compare    ${sut.diag.GVMStatus_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0xFEFA)(Programming Session)
    [Documentation]    The DID  GVM_Status shall give the information about the  Status of Guest Virtual Machines (GVM) .
    [Tags]    CustomerDiagnostic    TCID-404445    FULLTEST    FID-2845966,2845967,2845968,2845970,2845971

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.GVMStatus_Req}
    prj.sut.diag.compare    ${sut.diag.GVMStatus_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_GVMStatus(0xFEFA)(NegativeResponse)
    [Documentation]    To test negative response for GVMStatus(0xFEFA)
    [Tags]    CustomerDiagnostic    TCID-404440    FULLTEST    FID-2845972

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.GVMStatus_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.GVMStatus_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCTemperatures(0xFEFB)(Programming Session)
    [Documentation]    The DID SoC_Temperatures shall give the information about the Temperatures from 63 Sensors on the SoC.
    [Tags]    CustomerDiagnostic    TCID-404449    FULLTEST    FID-2870531,2870532,2870533,2870535,2870536

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_SoCTemperatures(0xFEFB)(NegativeResponse)
    [Documentation]    To test negative response for SoCTemperatures(0xFEFB)
    [Tags]    CustomerDiagnostic    TCID-404450    FULLTEST    FID-2870537

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.SoCTemperatures_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_OSVersion(0xFEFC)(Programming Session)
    [Documentation]    The DID  OSVersion shall give the information about OS Versions on the MCU.
    [Tags]    CustomerDiagnostic    TCID-404447    FULLTEST    FID-2856756,2856757,2856758,2856760,2856761

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_OSVersion(0xFEFC)(NegativeResponse)
    [Documentation]    To test negative response for OSVersion(0xFEFC)
    [Tags]    CustomerDiagnostic    TCID-404448    FULLTEST    FID-2856762

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.OSVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.OSVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VWLogicalSoftwareBlockVersion(F1AB)(Default Session)
    [Documentation]    The DID VWLogicalSoftwareBlockVersion shall give the information about the SW Block version number.
    [Tags]    CustomerDiagnostic    TCID-404398    FULLTEST    FID-2844632,2844634,2844635,2844637,2844638

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VWLogicalSoftwareBlockVersion(F1AB)(Extended Session)
    [Documentation]    The DID VWLogicalSoftwareBlockVersion shall give the information about the SW Block version number.
    [Tags]    CustomerDiagnostic    TCID-404400    FULLTEST    FID-2844632,2844634,2844635,2844637,2844638

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VWLogicalSoftwareBlockVersion(F1AB)(Programming Session)
    [Documentation]    The DID VWLogicalSoftwareBlockVersion shall give the information about the SW Block version number.
    [Tags]    CustomerDiagnostic    TCID-404399    FULLTEST    FID-2844632,2844634,2844635,2844637,2844638

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_Req}
    prj.sut.diag.compare    ${sut.diag.VWLogicalSoftwareBlockVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VWLogicalSoftwareBlockVersion(F1AB)(NegativeResponse)
    [Documentation]    To test negative response for VWLogicalSoftwareBlockVersion(F1AB)
    [Tags]    CustomerDiagnostic    TCID-404401    FULLTEST    FID-2844639

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VWLogicalSoftwareBlockVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileIdentifier(0xF19E)(Default Session)
    [Documentation]    The DID  ASAMODXFileIdentifier shall give the information about the ASAM ODX File Identifier.
    [Tags]    CustomerDiagnostic    TCID-404409    FULLTEST    FID-2850080,2850081,2850082,2850084,2850085

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileIdentifier_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileIdentifier(0xF19E)(Extended Session)
    [Documentation]    The DID  ASAMODXFileIdentifier shall give the information about the ASAM ODX File Identifier.
    [Tags]    CustomerDiagnostic    TCID-404415    FULLTEST    FID-2850080,2850081,2850082,2850084,2850085

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileIdentifier_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileIdentifier(0xF19E)(Programming Session)
    [Documentation]    The DID  ASAMODXFileIdentifier shall give the information about the ASAM ODX File Identifier.
    [Tags]    CustomerDiagnostic    TCID-404404    FULLTEST    FID-2850080,2850081,2850082,2850084,2850085

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileIdentifier_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileIdentifier(0xF19E)(NegativeResponse)
    [Documentation]    To test negative response for ASAMODXFileIdentifier(0xF19E)
    [Tags]    CustomerDiagnostic    TCID-404405    FULLTEST    FID-2850086

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileIdentifier_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileVersion(0xF1A2)(Default Session)
    [Documentation]    The DID  ASAMODXFileVersion shall give the information about the ASAM ODX File Version.
    [Tags]    CustomerDiagnostic    TCID-404406    FULLTEST    FID-2845975,2845976,2845977,2845979,2845980

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileVersion(0xF1A2)(Extended Session)
    [Documentation]    The DID  ASAMODXFileVersion shall give the information about the ASAM ODX File Version.
    [Tags]    CustomerDiagnostic    TCID-404408    FULLTEST    FID-2845975,2845976,2845977,2845979,2845980

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileVersion(0xF1A2)(Programming Session)
    [Documentation]    The DID  ASAMODXFileVersion shall give the information about the ASAM ODX File Version.
    [Tags]    CustomerDiagnostic    TCID-404413    FULLTEST    FID-2845975,2845976,2845977,2845979,2845980

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_Req}
    prj.sut.diag.compare    ${sut.diag.ASAMODXFileVersion_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_ASAMODXFileVersion(0xF1A2)(NegativeResponse)
    [Documentation]    To test negative response for ASAMODXFileVersion(0xF1A2)
    [Tags]    CustomerDiagnostic    TCID-404411    FULLTEST    FID-2845981

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.ASAMODXFileVersion_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_BladeComputeInternalTemperature(0x0320)(Default Session)
    [Documentation]    The DID  BladeComputeInternalTemperature shall give the information about temperatures of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404397    FULLTEST    FID-2872923,2872924,2872925,2872927,2872928

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    prj.sut.connect.dlt
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.BladeComputeInternalTemperature_Resp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_BladeComputeInternalTemperature(0x0320)(Extended Session)
    [Documentation]    The DID  BladeComputeInternalTemperature shall give the information about temperatures of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404395    FULLTEST    FID-2872923,2872924,2872925,2872927,2872928

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.connect.dlt
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.BladeComputeInternalTemperature_Resp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_BladeComputeInternalTemperature(0x0320)(Programming Session)
    [Documentation]    The DID  BladeComputeInternalTemperature shall give the information about temperatures of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404393    FULLTEST    FID-2872923,2872924,2872925,2872927,2872928
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.connect.dlt
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.BladeComputeInternalTemperature_Resp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_BladeComputeInternalTemperature(0x0320)(NegativeResponse)
    [Documentation]    To test negative response for BladeComputeInternalTemperature(0x0320)
    [Tags]    CustomerDiagnostic    TCID-404412    FULLTEST    FID-2872929

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.BladeComputeInternalTemperature_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VoltageTerminal30(0x1906)(Default Session)
    [Documentation]    The DID  VoltageTerminal30 shall give the information about the volage level for KL30.
    [Tags]    CustomerDiagnostic    TCID-404402    FULLTEST    FID-2872971,2872972,2872973,2872975,2872976

    bits_platform.Output Set Analog Signal Value    Battery    10
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.VoltageTerminal30_12V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 12V. Comparing with 11.9V
        prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_119V_Resp}
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_119V_Resp}
    ELSE
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_12V_Resp}
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VoltageTerminal30(0x1906)(Extended Session)
    [Documentation]    The DID  VoltageTerminal30 shall give the information about the volage level for KL30.
    [Tags]    CustomerDiagnostic    TCID-404407    FULLTEST    FID-2872971,2872972,2872973,2872975,2872976

    bits_platform.Output Set Analog Signal Value    Battery    10
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.VoltageTerminal30_12V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 12V. Comparing with 11.9V
        prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_119V_Resp}
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_119V_Resp}
    ELSE
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_12V_Resp}
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VoltageTerminal30(0x1906)(Programming Session)
    [Documentation]    The DID  VoltageTerminal30 shall give the information about the volage level for KL30.
    [Tags]    CustomerDiagnostic    TCID-404403    FULLTEST    FID-2872971,2872972,2872973,2872975,2872976

    bits_platform.Output Set Analog Signal Value    Battery    10
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    2s
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.VoltageTerminal30_12V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 12V. Comparing with 11.9V
        prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_119V_Resp}
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_119V_Resp}
    ELSE
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_12V_Resp}
    END

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_VoltageTerminal30(0x1906)(NegativeResponse)
    [Documentation]    To test negative response for VoltageTerminal30(0x1906)
    [Tags]    CustomerDiagnostic    TCID-404414    FULLTEST    FID-2872977

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_MaaSBladeInternalTemperature(0xFA01)(Default Session)
    [Documentation]    The DID  MaaSBladeInternalTemperature shall give the MaaS Blade specific temperature of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404410    FULLTEST    FID-2872984,2872985,2872986,2872988,2872989
    prj.sut.connect.dlt
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.MaaSBladeInternalTemperature_Resp}

    ${VideoTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${VideoTemp}    Convert To Integer    0x${VideoTemp}
    Log To Console    Video Display Temp is ${VideoTemp}
    ${CameraTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${CameraTemp}    Convert To Integer    0x${CameraTemp}
    Log To Console    Camera Display Temp is ${CameraTemp}
    ${UFSTopTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${UFSTopTemp}    Convert To Integer    0x${UFSTopTemp}
    ${UFSTopTemp}    Set Variable    ${UFSTopTemp}
    Log To Console    UFS Top PCB Temp is ${UFSTopTemp}
    ${BottomPCBTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${BottomPCBTemp}    Convert To Integer    0x${BottomPCBTemp}
    Log To Console    Bottom PCB Temp is ${BottomPCBTemp}
    Sleep    5s
    prj.sut.disconnect.dlt
    Sleep    3s
    @{pattern_list}    Create List    [Temperature] DID request [Video Display Temperature] = ${VideoTemp}
    ...    [Temperature] DID request [Camera Display Temperature] = ${CameraTemp}
    ...    [Temperature] DID request [UFS TOP PCB Temperature] = ${UFSTopTemp}
    ...    [Temperature] DID request [BOTTOM PCB Temperature] = ${BottomPCBTemp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_MaaSBladeInternalTemperature(0xFA01)(Extended Session)
    [Documentation]    The DID  MaaSBladeInternalTemperature shall give the MaaS Blade specific temperature of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404392    FULLTEST    FID-2872984,2872985,2872986,2872988,2872989
    prj.sut.connect.dlt
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.MaaSBladeInternalTemperature_Resp}

    ${VideoTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${VideoTemp}    Convert To Integer    0x${VideoTemp}
    Log To Console    Video Display Temp is ${VideoTemp}
    ${CameraTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${CameraTemp}    Convert To Integer    0x${CameraTemp}
    Log To Console    Camera Display Temp is ${CameraTemp}
    ${UFSTopTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${UFSTopTemp}    Convert To Integer    0x${UFSTopTemp}
    ${UFSTopTemp}    Set Variable    ${UFSTopTemp}
    Log To Console    UFS Top PCB Temp is ${UFSTopTemp}
    ${BottomPCBTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${BottomPCBTemp}    Convert To Integer    0x${BottomPCBTemp}
    Log To Console    Bottom PCB Temp is ${BottomPCBTemp}
    Sleep    5s
    prj.sut.disconnect.dlt
    Sleep    3s
    @{pattern_list}    Create List    [Temperature] DID request [Video Display Temperature] = ${VideoTemp}
    ...    [Temperature] DID request [Camera Display Temperature] = ${CameraTemp}
    ...    [Temperature] DID request [UFS TOP PCB Temperature] = ${UFSTopTemp}
    ...    [Temperature] DID request [BOTTOM PCB Temperature] = ${BottomPCBTemp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_MaaSBladeInternalTemperature(0xFA01)(Programming Session)
    [Documentation]    The DID  MaaSBladeInternalTemperature shall give the MaaS Blade specific temperature of various sensors.
    [Tags]    CustomerDiagnostic    TCID-404394    FULLTEST    FID-2872984,2872985,2872986,2872988,2872989

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_Req}
    prj.sut.diag.checkbyte    ${sut.diag.MaaSBladeInternalTemperature_Resp}

    ${VideoTemp}    prj.sut.can.diag.get.byte.range    9    11
    ${VideoTemp}    Convert To Integer    0x${VideoTemp}
    Log To Console    Video Display Temp is ${VideoTemp}
    ${CameraTemp}    prj.sut.can.diag.get.byte.range    12    14
    ${CameraTemp}    Convert To Integer    0x${CameraTemp}
    Log To Console    Camera Display Temp is ${CameraTemp}
    ${UFSTopTemp}    prj.sut.can.diag.get.byte.range    15    17
    ${UFSTopTemp}    Convert To Integer    0x${UFSTopTemp}
    ${UFSTopTemp}    Set Variable    ${UFSTopTemp}
    Log To Console    UFS Top PCB Temp is ${UFSTopTemp}
    ${BottomPCBTemp}    prj.sut.can.diag.get.byte.range    18    20
    ${BottomPCBTemp}    Convert To Integer    0x${BottomPCBTemp}
    Log To Console    Bottom PCB Temp is ${BottomPCBTemp}
    Sleep    5s
    prj.sut.disconnect.dlt
    Sleep    3s
    @{pattern_list}    Create List    [Temperature] DID request [Video Display Temperature] = ${VideoTemp}
    ...    [Temperature] DID request [Camera Display Temperature] = ${CameraTemp}
    ...    [Temperature] DID request [UFS TOP PCB Temperature] = ${UFSTopTemp}
    ...    [Temperature] DID request [BOTTOM PCB Temperature] = ${BottomPCBTemp}

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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_MaaSBladeInternalTemperature(0xFA01)(NegativeResponse)
    [Documentation]    To test negative response for MaaSBladeInternalTemperature(0xFA01)
    [Tags]    CustomerDiagnostic    TCID-404396    FULLTEST    FID-2872990

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command with incorrect less message length
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_IncorrectMessageLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Send command with incorrect extra message length
    prj.sut.can.diag.send    ${sut.diag.MaaSBladeInternalTemperature_IncorrectMessageLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_SystemSupplierECUSoftwareVersionNumber(0xF195)(Programming Session)
    [Documentation]    The DID SystemSupplierECUSoftwareVersionNumber identifies
    ...    the versions of the different Software elements
    [Tags]    CustomerDiagnostic    TCID-406495    FULLTEST    FID-1151146,1151148,1151149,1151151,1151152,2872998,2872999,2873000,2873002,2873003

    # Go to extended session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # Go to programming session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    # Send command of system supplier ECU software version number
    prj.sut.can.diag.send    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Req}
    prj.sut.diag.compare    ${sut.diag.SystemSupplierECUSoftwareVersionNumber_Resp}

EnvD_SysQual_Diagnostics_TesterPresenceService($3E)_TesterPresent(NegativeResponse)
    [Documentation]    To test negative response for Tester Present ($3E)

    [Tags]    CustomerDiagnostic    TCID-414739    FULLTEST    FID-1069455,1151322    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.Tester_Present_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.TesterPresent_IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.Tester_Present_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.TesterPresent_IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.Tester_Present_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.TesterPresent_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_SpecificDiagnosticServices
    [Documentation]    A diagnostic session shall enables a specific set of diagnostic services and/or functionality in the server

    [Tags]    CustomerDiagnostic    TCID-414741    FULLTEST    FID-1069704

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    # Send the request to write the RollerTestMode 2E 04 FB 01 in extended session
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Write_Resp}

    # Go to Extended Mode
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    # write to rollerteststand mode
    prj.sut.can.diag.send    ${sut.diag.RollerTestStandModeWrite_Req}
    prj.sut.diag.compare    ${sut.diag.RollerTestStandModeWrite_Resp}

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_DefaultSessionReinitialize/Setting/ControlReset
    [Documentation]    Default Session: When the server is in the default Session and the client requests to start the default Session then
    ...    the server shall re-initialize the default Session completely. The server shall reset all activated/initiated/changed
    ...    settings/controls during the activated session.

    [Tags]    CustomerDiagnostic    TCID-414734    FULLTEST    FID-1069754

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

    # return to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep     3s
    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}    0    20

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_SessionExitCriteriaS3Timeout
    [Documentation]    S3 Timeout -Timeout for Non-Default Session
    ...    Note:S3 value shall be 5s
    [Tags]    CustomerDiagnostic    TCID-414752    FULLTEST    FID-1069767

    prj.sut.can.diag.tester.present.deactive
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    4.5s
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    4.6s
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}
    [Teardown]    prj.sut.can.diag.tester.present.active

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_SessionExitCriteriaDefaultSession
    [Documentation]    Default Session -Timeout for Non-Default Session
    [Tags]    CustomerDiagnostic    TCID-414756    FULLTEST    FID-1069768

    prj.sut.can.diag.tester.present.deactive
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}
    [Teardown]    prj.sut.can.diag.tester.present.active

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_SessionExitCriteriaServerReset
    [Documentation]    Server Reset -Timeout for Non-Default Session
    [Tags]    CustomerDiagnostic    TCID-414745    FULLTEST    FID-1069769

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}
    # perform ECU reset
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    12

    Sleep    5s
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

EnvD_SysQual_Diagnostics_DiagnosticsSessionControlService($10)_NegativeResponse
    [Documentation]    To test negative response for Diagnostic Session Control ($22)

    [Tags]    CustomerDiagnostic    TCID-414749    FULLTEST    FID-1069765,1151322    NegativeTest
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

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_EthernetLinkQuality(0x010D)(Default Session)
    [Documentation]    The "Ethernet signal quality" shall return the signal quality of all Ethernet interfaces of the ECU.

    [Tags]    CustomerDiagnostic    TCID-414750    FULLTEST    FID-2840362,2840363,2840364,2840366,2840367

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_Req}
    prj.sut.diag.compare    ${sut.diag.EthernetLinkQuality_Good_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_EthernetLinkQuality(0x010D)(Extended Session)
    [Documentation]    The "Ethernet signal quality" shall return the signal quality of all Ethernet interfaces of the ECU.

    [Tags]    CustomerDiagnostic    TCID-414751    FULLTEST    FID-2840362,2840363,2840364,2840366,2840367

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_Req}
    prj.sut.diag.compare    ${sut.diag.EthernetLinkQuality_Good_Resp}

EnvD_SysQual_Diagnostics_ReadDatabyIdentifier($22)_EthernetLinkQuality(0x010D)(Negative Response)
    [Documentation]    The "Ethernet signal quality" shall return the signal quality of all Ethernet interfaces of the ECU.

    [Tags]    CustomerDiagnostic    TCID-414746    FULLTEST    FID-2840368    NegativeTest
    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectDID_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

    # Extended Session
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.IncorrectMessageLengthOrInvalidFormat_Resp}

    # Programming Session
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EthernetLinkQuality_Req}
    prj.sut.diag.compare    ${sut.diag.RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_ClearDiagnosticsService($14)_ClearDiagnosticsService(Negative Response)
    [Documentation]    To test negative response for Clear Diagnostics Service ($14)

    [Tags]    CustomerDiagnostic    TCID-414747    FULLTEST    FID-1287767,1151322    NegativeTest
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_ControlDTCSetting($85)_ExistingDTC
    [Documentation]    This service is used to deactivate and reactivate the update of
    ...    the StatusOfDTC bits of events and notices in the event memory
    [Tags]    CustomerDiagnostic    TCID-414757    FULLTEST    FID-1286047

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

    # Set DTC setting to OFF
    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}

    # Qualify Undervoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    7
    Sleep     3s
    # Check DTC should not be logged
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_Resp}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_UndervoltageDTC_Resp}
    IF    ${Status} == ${False}
        Log to Console    No Undervoltage DTC is seen. OK!
    ELSE
        Log To Console    Undervoltage DTC is seen. NOK!!
        Set test status to Fail    error_type=Diagnostic    info_text=DTC is logged when DTC setting is turned to OFF
    END

EnvD_SysQual_Diagnostics_ControlDTCSetting($85)_ControlDTCSetting(Negative Response)
    [Documentation]    To test negative response for Control DTC Setting ($85)

    [Tags]    CustomerDiagnostic    TCID-414759    FULLTEST    FID-1287774,1151322    NegativeTest
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_ServiceNotSupportedInActiveSession_Resp}

    # Default Session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_ServiceNotSupportedInActiveSession_Resp}

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportDTCSnapshotRecordByDTCNumber(0x04)
    [Documentation]    The typical usage of DTC Snapshots is to store data upon detection of a system malfunction. The DTC Snapshots
    ...    will act as a snapshot of data values from the time of the system malfunction occurrence.
    [Tags]    CustomerDiagnostic    TCID-414754    FULLTEST    FID-2811062,2811063

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    0    50
    prj.sut.diag.SetETHSignal    1    12345
    prj.sut.diag.SetETHSignal    2    2024    # set Year to 2024
    prj.sut.diag.SetETHSignal    3    5    # set Month to 5
    prj.sut.diag.SetETHSignal    4    4    # set Day to 4
    prj.sut.diag.SetETHSignal    5    3    # set Hour to 3
    prj.sut.diag.SetETHSignal    6    2    # set Minute to 2
    prj.sut.diag.SetETHSignal    7    1    # set Seconds to 1
    prj.sut.diag.SetETHSignal    8    1
    prj.sut.diag.SetETHSignal    9    1
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}

    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleSpeed_50_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleMileage_12345_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VehicleTimeStamp_Variation2_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_IgnitionStatus_1_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_EngineStatus_1_Resp}

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportNumberOfDTCByStatusMask(0x01)(Negative Response)
    [Documentation]    To test negative response for Read Diagnostics Trouble Code Service ($19)

    [Tags]    CustomerDiagnostic    TCID-414755    FULLTEST    FID-1443758    NegativeTest

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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportDTCByStatusMask(0x02)(Negative Response)
    [Documentation]    To test negative response for Read Diagnostics Trouble Code Service ($19)

    [Tags]    CustomerDiagnostic    TCID-414736    FULLTEST    FID-1443758    NegativeTest
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportDTCExtDataRecordByDTCNumber(0x06)(Negative Response)
    [Documentation]    To test negative response for Read Diagnostics Trouble Code Service ($19)

    [Tags]    CustomerDiagnostic    TCID-414735    FULLTEST    FID-1443758    NegativeTest
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtDataRecordByDTCNumber_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_ReadDiagnosticsTroubleCodeService($19)_ReportDTCSnapshotRecordByDTCNumber(0x04)(Negative Response)
    [Documentation]    To test negative response for Read Diagnostics Trouble Code Service ($19)

    [Tags]    CustomerDiagnostic    TCID-414742    FULLTEST    FID-1443758    NegativeTest
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_IncorrectFormat_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_RequestOutOfRange_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCSnapshotRecordByDTCNumber_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_CommunicationControl($28)_EnableRxAndDisableTxControl(Negative Response)
    [Documentation]    To test negative response for Communication Control ($28)

    [Tags]    CustomerDiagnostic    TCID-414737    FULLTEST    FID-1367305    NegativeTest
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_Req}
    prj.sut.diag.compare    ${sut.diag.EnableRxAndDisableTxControl_Resp}

EnvD_SysQual_Diagnostics_CommunicationControl($28)_EnableRxAndTxControl(Negative Response)
    [Documentation]    To test negative response for Communication Control ($28)

    [Tags]    CustomerDiagnostic    TCID-414740    FULLTEST    FID-1367305,1151322    NegativeTest
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.EnableRxAndTxControl_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_RoutineControl($31)_CheckPreconditions(0x0203)(Negative Response)
    [Documentation]    To test negative response for Check Preconditions (0x0203)

    [Tags]    CustomerDiagnostic    TCID-414744    FULLTEST    FID-1381300,1151322    NegativeTest
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
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Check_Programming_Preconditions_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}

EnvD_SysQual_Diagnostics_RoutineControl($31)_RoutineControl(Negative Response)
    [Documentation]    To test negative response for Routine Control ($31)

    [Tags]    CustomerDiagnostic    TCID-428381    FULLTEST    FID-1338686,1338715,1338718,1338721    NegativeTest

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

    prj.sut.can.diag.send    ${sut.diag.Check_Programming_Preconditions_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_RequestOutOfRange_Resp}

    # To test NRC12
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.CheckPreconditions_IncorrectSubfunction_Req}
    prj.sut.diag.compare    ${sut.diag.RoutineControl_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_ECUReset($11)_ECUReset(Negative Response)
    [Documentation]    To test negative response for ECU Reset ($11)

    [Tags]    CustomerDiagnostic    TCID-428386    FULLTEST    FID-1316995,1151322    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectMsgLengthLess_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectMsgLengthExtra_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_IncorrectMessageLength_Resp}

    prj.sut.can.diag.send    ${sut.diag.ECUReset_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Hard_Reset_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_ServiceNotSupportedInActiveSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Key_Off_On_Reset_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_ServiceNotSupportedInActiveSession_Resp}

EnvD_SysQual_Diagnostics_SuppressPositiveResponse_VerifySession
    [Documentation]    If the MSB of the Sub-Function is set, then the positive response shall be suppressed for that perticular request

    [Tags]    CustomerDiagnostic    TCID-428383    FULLTEST    FID-1348229,1348230

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.ExtendedSession_Suppress_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.can.diag.get
    IF    ${Status} == ${True}
        Set Test Status To Fail    error_type=Diagnostic    info_text=.Able to get a response.Positive Response is NOT suppressed
    END
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_ExtendedSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.DefaultSession_Suppress_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.can.diag.get
    IF    ${Status} == ${True}
        Set Test Status To Fail    error_type=Diagnostic    info_text=.Able to get a response.Positive Response is NOT suppressed
    END
    prj.sut.can.diag.send    ${sut.diag.ActiveDiagnosticSession_Req}
    prj.sut.diag.compare    ${sut.diag.ActiveDiagnosticSession_DefaultSession_Resp}

EnvD_SysQual_Diagnostics_SuppressPositiveResponse_VerifySession(NegativeResponse)
    [Documentation]    To test negative response handling for suppress positive response

    [Tags]    CustomerDiagnostic    TCID-428385    FULLTEST    FID-1348229,1348230    NegativeTest

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

EnvD_SysQual_Diagnostics_ProgrammingSessionPreCondition_SupplyVoltageLow($NRC93)
    [Documentation]    The reprogramming shall be rejected with NRC 93 , If the supply voltage is <9Volts

    [Tags]    CustomerDiagnostic    TCID-428384    FULLTEST    FID-2674365    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    8
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_SupplyVoltageLow_Resp}

    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

EnvD_SysQual_Diagnostics_ProgrammingSessionPreCondition_VehicleSpeedNotZero($NRC88)
    [Documentation]    The requestshall be rejected with NRC 88 , If the vehicle speed is more than or equal to 5kmph
    [Tags]    CustomerDiagnostic    TCID-428388    FULLTEST    FID-1954901    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.diag.SetETHSignal    0    6
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_SupplyVoltageLow_Resp}

    prj.sut.diag.SetETHSignal    0    4
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponse_NotSupportedSID
    [Documentation]    To test negative response of NRC 11

    [Tags]    CustomerDiagnostic    TCID-428387    FULLTEST    FID-1151329,1151335    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.NotSupportedSID_Req}
    prj.sut.diag.compare    ${sut.diag.ServiceNotSupported50_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponse_NotSupportedSIDinActiveSession
    [Documentation]    To test negative response of NRC 7F

    [Tags]    CustomerDiagnostic    TCID-428382    FULLTEST    FID-1151329,1151336    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Hard_Reset_Req}
    prj.sut.diag.compare    ${sut.diag.ECUReset_ServiceNotSupportedInActiveSession_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    prj.sut.diag.compare    ${sut.diag.ControlDTCSetting_ServiceNotSupportedInActiveSession_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponseWithSubfunction_IncorrectMessageLength
    [Documentation]    To test negative response of NRC 13
    [Tags]    CustomerDiagnostic    TCID-428379    FULLTEST    FID-1151339,1151333    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.DefaultSessionSID_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_IncorrectMessageLengthOrInvalidFormat_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponseWithSubfunction_SubFunctionNotSupported
    [Documentation]    To test negative response of NRC 12

    [Tags]    CustomerDiagnostic    TCID-428380    FULLTEST    FID-1151340,1151333    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.EnableRxAndDisableTxControl_IncorrectSubFunction_Req}
    prj.sut.diag.compare    ${sut.diag.CommunicationControl_SubFunctionNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.DiagnosticSession_IncorrectSubfunction_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ServiceNotSupported_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportNumberOfDTCByStatusMask_SubFunctionNotSupported_Req}
    prj.sut.diag.compare    ${sut.diag.ReadDiagnosticsTroubleCodeService_SubFunctionNotSupported_Resp}

EnvD_SysQual_Diagnostics_GenericBehaviorResponseWithSubfunction_SubFunctionNotSupportedInActiveSession
    [Documentation]    To test negative response of NRC 12

    [Tags]    CustomerDiagnostic    TCID-428378    FULLTEST    FID-1151341,1151333    NegativeTest

    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ServiceNotSupportedInActiveSession_Resp}

EnvD_SysQual_Diagnostics_ExtendedRecord1_Priority
    [Documentation]    For each fault record, the ECU shall support a Priority indicating the Priority of that event/DTC

    [Tags]    CustomerDiagnostic    TCID-434194    FULLTEST    FID-2930862
    # Trigger Overvoltage
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_OvervoltageDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.Report_DTC_Ext_Data_Record_By_DTC_Number_Priority1_Resp}    21    23

EnvD_SysQual_Diagnostics_ExtendedRecord3_EngineCoolantTemperature
    [Documentation]    The engine coolant temparature shall be 1 byte in size and captured with the message OBD_Eng_Cool_Temp

    [Tags]    CustomerDiagnostic    TCID-434193    FULLTEST    FID-1447019
    # Set Engine Coolant to xx
    prj.sut.diag.SetETHSignal    0    50    # to create ETH signal for engine coolant

    # Trigger Overvoltage
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s

    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtendedDataRecordByDTCNumber_OvervoltageDTC_EngineCoolant_Req}
    Set test status to fail    info_text=Engine Coolant Failed (KIV)
    prj.sut.diag.compare    ${sut.diag.ReportDTCExtendedDataRecordByDTCNumber_OvervoltageDTC_EngineCoolant_Resp}    # Pending reply from hakim

EnvD_SysQual_Diagnostics_ExtendedRecord0F_MonitoringData
    [Documentation]    The debug data of each DTC shall be captured in this Extended record of size 8 Byte

    [Tags]    CustomerDiagnostic    TCID-434192    FULLTEST    FID-1818192

    # Trigger Overvoltage
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep     3s
    Set test status to fail    info_text=Monitoring Data Failed (KIV)
    prj.sut.can.diag.send    ${sut.diag.ReportDTCExtendedDataRecordByDTCNumber_OvervoltageDTC_MonitoringData_Req}
    ${sResult}    prj.sut.can.diag.get
    # Checking byte length
    ${MonitoringData_Length}    Get Length    ${sResult}
    Log To Console    Byte length is ${MonitoringData_Length}
    IF    ${MonitoringData_Length} == ${sut.diag.MonitoringData_Length}
        Log To Console    Byte Length check is OK
    ELSE
        Log To Console    Byte Length check is NOK!
        ${MonitoringData_Length}    Set Variable    ${MonitoringData_Length}
        Set Test Status To Fail    error_type=Diagnostic    info_text=Response does not contain 8 bytes Monitoring Data
    END

EnvD_SysQual_Diagnostics_SnapshotData_MPCIRackStatus
    [Documentation]    This DID(0x031E) shall give the MPCI Rack status when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-434197    FULLTEST	FID-1826300,1826325

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    9    0  # Pending Hakim to give out info which signal it will take from
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.MPCIRackStatus_Req}
    Set test status to fail    info_text=MPCIRackStatus Failed (KIV)
    prj.sut.diag.compare    ${sut.diag.MPCIRackStatus_Resp}  # So far only FF FF FF FF FF FF FF FF result is implemented. Ticket created

    prj.sut.diag.SetETHSignal    9    1    # Pending Hakim to give out info which signal it will take from
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_MPCIRackStatus_Resp}

    prj.sut.can.diag.send    ${sut.diag.MPCIRackStatus_Req}
    prj.sut.diag.compare    ${sut.diag.MPCIRackStatus_Resp}   # So far only FF FF FF FF FF FF FF FF result is implemented. Ticket created

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_MPCIRackStatus(NegativeTest)
    [Documentation]    To test MPCI Rack Status negative handling
    [Tags]    CustomerDiagnostic    TCID-434196    FULLTEST	FID-1826300,1826325    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    9    0  # Pending Hakim to give out info which signal it will take from
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.MPCIRackStatus_Req}
    Set test status to fail    info_text=MPCIRackStatus Failed (KIV)
    prj.sut.diag.compare    ${sut.diag.MPCIRackStatus_Resp}  # So far only FF FF FF FF FF FF FF FF result is implemented. Ticket created

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.diag.SetETHSignal    9    1  # Pending Hakim to give out info which signal it will take from
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_EngineStatus_0_Resp}

    prj.sut.can.diag.send    ${sut.diag.MPCIRackStatus_Req}
    prj.sut.diag.compare    ${sut.diag.MPCIRackStatus_Resp}  # So far only FF FF FF FF FF FF FF FF result is implemented. Ticket created

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_SupplyVoltageOfTheBlade(Negative Test)
    [Documentation]    To test Supply Voltage Of The Blade Negative handling
    [Tags]    CustomerDiagnostic    TCID-434195    FULLTEST	FID-1826342,1826343    NegativeTest

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
        prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_119V_Resp}
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_119V_Resp}
    ELSE
        prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_12V_Resp}
    END

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    20
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_19V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 19V. Comparing with 18.9V
        prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_VoltageTerminal30_189V_Resp}
    ELSE
        Set Test Status To Fail    error_type=diagnostic    info_text=Voltage Snapshot data is not 19V or 18.9V
    END
    prj.sut.can.diag.send    ${sut.diag.VoltageTerminal30_Req}
    ${Status}    Run Keyword And Return Status    prj.sut.diag.compare   ${sut.diag.VoltageTerminal30_20V_Resp}
    IF    ${Status} == False
        Log To Console    Supply value is not 20V. Comparing with 19.9V
        prj.sut.diag.compare    ${sut.diag.VoltageTerminal30_199V_Resp}
    END
    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_OPMMStatusOfTheBlade(0x030B)
    [Documentation]    This DID(0x031E) shall give the MPCI Rack status when the DTC was qualified for the blade
    [Tags]    CustomerDiagnostic    TCID-434191    FULLTEST	FID-1826348,1826349

    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    9    0  # Pending Hakim to give out info which signal it will take from
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    Set test status to fail    info_text=OPMM Status of the Blade Failed (KIV)
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBlade_Resp}  # So far only FF result is implemented. Ticket created

    prj.sut.diag.SetETHSignal    9    1    # Pending Hakim to give out info which signal it will take from
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s

    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_OPMMStatusOfTheBlade_Resp}

    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBlade_Req}   # So far only FF result is implemented. Ticket created

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_SnapshotData_OPMMStatusOfTheBlade(NegativeTest)
    [Documentation]    To test OPMM Status Of The Blade negative handling
    [Tags]    CustomerDiagnostic    TCID-434190    FULLTEST	FID-1826348,1826349    NegativeTest
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.diag.SetETHSignal    9    0  # Pending Hakim to give out info which signal it will take from
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.compare    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Passive_Resp}

    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    Set test status to fail    info_text=OPMM Status of the Blade Failed (KIV)
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBlade_Resp}  # So far only FF result is implemented. Ticket created

    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.diag.SetETHSignal    9    1  # Pending Hakim to give out info which signal it will take from
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_Overvoltage_Req}
    prj.sut.diag.checkbyte    ${sut.diag.Read_DTC_Snapshot_By_DTC_Number_OPMMStatusOfTheBlade_Resp}

    prj.sut.can.diag.send    ${sut.diag.OPMMStatusOfTheBlade_Req}
    prj.sut.diag.compare    ${sut.diag.OPMMStatusOfTheBlade_Resp}  # So far only FF result is implemented. Ticket created

    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_ClearingFailureMemoryPostFlashing_FailureMemoryAfterFlashing
    [Documentation]    Once the reprogramming is done successfully, the failure memory shall be erased
    [Tags]    CustomerDiagnostic    TCID-434188    FULLTEST	FID-2655054
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    3s
    # Clear all DTC
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}
    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}

    # powercycle and check DTC
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    5s
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_NonVolatileMemory_Req}
    Sleep    5s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_NonVolatileMemory_Resp}
    Sleep    3s

    # Flash newer SW
    Set test status to fail    info_text=UDS Programming Failed (KIV)
    # Flash sw via UDS Programming  # to wait for implementation. ticket created
    # Power cycle after sw flash and check DTC
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    10s
    # DTC shall be erased after flashing
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}

EnvD_SysQual_Diagnostics_ClearingFailureMemoryPostFlashing_FailureMemoryAfterFlashingOldSoftware
    [Documentation]    The Failure Memory shall be cleared only if the older SW version and the newer SW version are different
    [Tags]    CustomerDiagnostic    TCID-434189    FULLTEST	FID-2655055
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    3s
    # Clear all DTC
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_None_Resp}
    # Qualify Overvoltage DTC
    bits_platform.Output Set Analog Signal Value    Battery    19
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_D200B5_Resp}

    # powercycle and check DTC
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    5s
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    10s
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_NonVolatileMemory_Req}
    Sleep    5s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_NonVolatileMemory_Resp}
    Sleep    3s

    # Flash same SW
    Set test status to fail    info_text=UDS Programming Failed (KIV)
    # Flash sw via UDS Programming  # to wait for implementation. ticket created
    # Power cycle after sw flash and check DTC
    bits_platform.Output Set Analog Signal Value    Battery    0
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    12
    Sleep    10s
    # DTC shall be erased after flashing
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_NonVolatileMemory_Req}
    Sleep    5s
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_Resp}
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_OvervoltageDTC_NonVolatileMemory_Resp}

EnvD_SysQual_Diagnostics_PreConditionEnteringProgrammingSession_MaximumSecurityAttempts
    [Documentation]    In Application Locking time of 10min shall be triggered if Max_Sec_Attempt_Reached condition is enable
    ...    NOTE: The 10min Locking time in application and the 10min Locking time in FBL are different
    [Tags]    CustomerDiagnostic    TCID-435018    FULLTEST    FID-1651950,1653107,1653108
    Set Test Status To Fail    Info_text=Max security attempt Precondition failed (KIV)
    # 1.Make the invalid security attempt as 2 in FBL
    # 2. Jump to application when 10min timer is enabled from FBL
    # 3.Enter Extended session and see the positive response
    # 4.Enter to programming session and observe the NRC 22

    # Until the Security access with proper seed and Key mechanism is implemented to verify this requirement the below steps can be followed.
    # 1.Write the value 2 for the NVM Block "RamMirror_ProgBlocking_Count "
    # 2.Enter Extended session and observe the positive response
    # 3.Enter the programming session and observe the NRC22

EnvD_SysQual_Diagnostics_PreConditionEnteringProgrammingSession_10MinLockingTime
    [Documentation]    After the Locking time is finished, the request to enter programming session shall be accepted
    [Tags]    CustomerDiagnostic    TCID-435019    FULLTEST    FID-1653109
    Set Test Status To Fail    Info_text=Max security attempt Precondition failed (KIV)
    # 1.Make the invalid security attempt as 2 in FBL
    # 2. Jump to application when 10min timer is enabled from FBL
    # 3.Enter Extended session and see the positive response
    # 4.Enter to programming session within 10min and observe the NRC 22
    # 5.After 10min timer expired send programming session request
    # 6.Observe the jump to FBL

    # Until the Security access with proper seed and Key mechanism is implemented to verify this requirement the below steps can be followed.
    # 1.Write the value 2 for the NVM Block "RamMirror_ProgBlocking_Count "
    # 2.Enter Extended session and observe the positive response
    # 3.Enter the programming session within 10min and observe the NRC22
    # 4.After 10min timer expired send programming session request
    # 5.Observe the jump to FBL

EnvD_SysQual_Diagnostics_PreConditionEnteringProgrammingSession_10MinLockingTimeReset
    [Documentation]    Locking time of 10min shall be restarted again in application if there is any reset in between before completing the locking time
    [Tags]    CustomerDiagnostic    TCID-435017    FULLTEST    FID-1653110
    Set Test Status To Fail    Info_text=Max security attempt Precondition failed (KIV)
    # 1.Make the invalid security attempt as 2 in FBL
    # 2. Jump to application when 10min timer is enabled from FBL
    # 3.Enter Extended session and see the positive response
    # 4.Enter to programming session within 10min and observe the NRC 22
    # 5.After 10min timer expired send programming session request
    # 6.Observe the jump to FBL

    # Until the Security access with proper seed and Key mechanism is implemented to verify this requirement the below steps can be followed.
    # 1.Write the value 2 for the NVM Block "RamMirror_ProgBlocking_Count "
    # 2.Enter Extended session and observe the positive response
    # 3.Enter the programming session within 10min and observe the NRC22
    # 4.After 10min timer expired send programming session request
    # 5.Observe the jump to FBL

EnvD_SysQual_Diagnostics_PreConditionEnteringProgrammingSession_ReprogrammingAttempt1000
    [Documentation]    If the Re-programming attempt value is 1000 and the request to reprogramming is made then the request shall be rejected with NRC 22
    [Tags]    CustomerDiagnostic    TCID-435016    FULLTEST    FID-1659685
    prj.sut.diag.SetETHSignal    0    500
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    FOR    ${i}    IN RANGE    1000
        Log to Console    Sending Programming Session Request ${i + 1} of 1000
        prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
        prj.sut.diag.compare    ${sut.diag.SessionControl_VehicleSpeedTooHigh_Resp}
    END
    Log to Console    Invalid Programming Session Request has been sent 1000 times
    prj.sut.diag.SetETHSignal    0    0
    prj.sut.can.diag.send    ${sut.diag.Programming_Session_Req}
    prj.sut.diag.compare    ${sut.diag.SessionControl_ConditionNotCorrect_Resp}
