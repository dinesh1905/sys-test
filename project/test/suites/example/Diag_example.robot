*** Settings ***
Documentation    This is test suite for demo
Resource    ${TAF_PATH}/import.resource
Library     QConnectBase.ConnectionManager
Library    AppiumLibrary

Suite Setup      setups.Set Up Test Suite
Suite Teardown   teardowns.Tear Down Test Suite
Test Setup       setups.Set Up Test Case
Test Teardown    teardowns.Tear Down Test Case


*** Variables ***
${COUNTERPLUS1}    1

*** Test Cases ***
# 24.3 New DTC test Case #############################################################
Overvoltage_DTC
    [Documentation]    The Operating Mode Subsystem shall set DTC when system voltage enters OVERVOLTAGE state.
    [Tags]    DiagnosticModule    TCID-

    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt

    # Adjust KL30 voltage to Overvoltage 18V
    ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    18
    Verify DLT keyword    Voltage enters OVERVOLTAGE range
    Log To Console    Maas Blade enters Overvoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_BB0010_Resp}    0    20

    # Retun back to normal voltage
    ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    12

EnvD_SysQual_Diagnostics_Undervoltage_DTC
    [Documentation]    The Operating Mode Subsystem shall set DTC when system voltage enters UNDERVOLTAGE state.
    [Tags]    DiagnosticModule    TCID-
    # Clear DTC command
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}

    prj.sut.connect.dlt

    # Adjust KL30 voltage to Overvoltage 18V
    ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    7
    Verify DLT keyword    Voltage enters UNDERVOLTAGE range
    Log To Console    Maas Blade enters Undervoltage
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_BB0008_Resp}    0    20

    # Retun back to normal voltage
    ${b_ack}    bits_platform.Output Set Analog Signal Value    Battery    12

# EnvD_SysQual_Diagnostics_PREPARERUN_NotReceived_DTC
#     [Documentation]    The Operating Mode Subsystem shall trigger "MaaS_Blade_OPM_Blade_Sequencing_Failure(0xD20090)"
#     ...    DTC with debug code PREPARERUN_MODE_REQ_NOTREC if it does not receive PREPARERUN operating mode request from
#     ...    PowerBlade in STARTUP state for 1.5 sec
#     [Tags]    DiagnosticModule    TCID-
#     #  To create a separate simulation for preparerun message not to receive within 1.5s
#     prj.sut.can.initandloadconfiguration.PrepareRunDTC
#     prj.sut.can.simulation.Start
#     prj.sut.can.simulation.PowerBladeON

#     Sleep    30s
#     prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}

#     # to add in json the response code
#     prj.sut.diag.compare    ${sut.diag.ReportDTCByStatusMask_OPM_Blade_Sequencing_Resp}

# 24.2 New added test Case ##########################################################################


EnvD_SysQual_Diagnostics_ResetIpCounterDroppedIpv6PacketsLayer(0x068C)(Extended Session)        # NEW #########################################################
    [Documentation]    This RID shall reset the Count of the Dropped IPV6 packets
    [Tags]    CustomerDiagnostic    TCID-    FULLTEST

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

EnvD_SysQual_Diagnostics_ResetIpCounterWrongUdpPorts(0x05EB)(Extended Session)    # New Test Case ########################
    [Documentation]    The routine "ResetIpCounterWrongUdpPorts" shall reset the
    ...    measured value "counter messages with invalid UDP ports" to the
    ...    value 0
    [Tags]    CustomerDiagnostic    TCID-272626    FULLTEST

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
      #   prj.sut.diag.compare    ${sut.diag.ResetIpCounterWrongUdpPorts_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterWrongUdpPorts_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterWrongUdpPorts_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

# 24.2 New added test Case ##########################################################################

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
    [Tags]    CustomerDiagnostic    TCID-272624    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1381301,1378481,1378482,1378484,1378489,1378490


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
    [Tags]    CustomerDiagnostic    TCID-272639    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1381301,1805364,1805365,1805366,1805368,1805369


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
      #   prj.sut.diag.compare    ${sut.diag.ResetIpCounterDroppedUdpTcpPacketsLayer4_Resp}
        Sleep    2s
        prj.sut.can.diag.send    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_Req}
        prj.sut.diag.compare    ${sut.diag.IpCounterDroppedUdpTcpPacketsLayer4_00_Resp}
    ELSE
        # Counter is zero, Unable to proceed to reset command
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The precondition is not correct. Counter is not ZERO.Unable to verify the Reset command.
    END

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
    ...    measured value "counter messages with invalid UDP ports" to the value 0
    [Tags]    CustomerDiagnostic    TCID-272626    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1381301,1378495,1378496,1378497,1378499,1378500

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

EnvD_SysQual_Diagnostics_ResetIpCounterWrongTcpPorts(0x05E5)
    [Documentation]    The routine "ResetIpCounterWrongTcpPorts" shall reset the
    ...    measured value "counter messages with invalid TCP ports" to the value 0
    [Tags]    CustomerDiagnostic    TCID-272632    FULLTEST    FID-1326078,1336183,1336184,1336186,1336952,1336958,1336959,1381301,1805353,1805354,1805355,1805357,1805358

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
