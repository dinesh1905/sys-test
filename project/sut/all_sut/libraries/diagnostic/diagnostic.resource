*** Settings ***
Documentation    Project specific software download keywords
Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/diagnostic/HextoASCII.py


*** Keywords ***
prj.sut.can.diag.clear
    [Documentation]    Clear the data in the Diagnostic Console
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagClear    1
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagClear    0

prj.sut.can.diag.send
    [Documentation]    Send Diagnostic Command through the Diagnostic Console
    [Arguments]    ${arg}

    prj.sut.can.diag.clear

    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagReq    ${arg}
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagSendReq    1
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagSendReq    0
    Log To Console    Sending ${arg} command

prj.sut.can.diag.get
    [Documentation]    Get Diagnostic Command through the Diagnostic Console
    FOR    ${counter}    IN RANGE    0    4
        Sleep    0.5s
        ${ack}    Run keyword And Return Status    bits_platform.Rbs Get Variable Value    1    SYSTEM    diag::diagResp
        IF    "${ack}" == "True"
            ${ack}    ${sResult}    bits_platform.Rbs Get Variable Value    1    SYSTEM    diag::diagResp
            IF    "${sResult}" == "${None}"
                Log To Console    No response is received.Retrying
                ${bAck}    Set Variable    ${False}
                Sleep    5s
            ELSE
                Log To Console    The response is ${sResult}
                ${bAck}    Set Variable    ${True}
                RETURN    ${sResult}
            END
        ELSE
            Log To Console    Unable to get diagnostic command.Retrying again.
            ${bAck}    Set Variable    ${False}
            Sleep    5s
        END
    END
    IF    ${bAck} == ${False}
            Log to Console    Reached max attempts
            Set Test Status To Fail    error_type=RBS    info_text=Reached max attempts.No Response from Diag Module.
    END

prj.sut.can.diag.get.byte.specific
    [Documentation]    This function is to get the specific bytes of the response
    [Arguments]    ${byte}

    Sleep    1s
    ${value}    prj.sut.can.diag.get
    ${newvar}    Set Variable    ${value}
    Log To Console     the variable is ${newvar}
    @{splitstring}    Split String    ${newvar}
    ${getlength}    Get Length    ${splitstring}
    log to console    ${getlength}
    ${byteresult}    Set Variable    ${splitstring}[${byte}]
    Log To Console    ${byteresult}
    IF    "${byteresult}" == ""
        Log To Console    The byte does not exist. Test Case FAIL!
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: The byte selected is empty.
    ELSE
        Log To Console    Byte no ${byte} is ${splitstring}[${byte}]
        RETURN    ${byteresult}
    END

prj.sut.can.diag.get.byte.range
    [Documentation]    This function is to get the range in bytes of the response
    [Arguments]    ${startbyte}    ${endbyte}
    ${response}    prj.sut.can.diag.get
    ${byterange}    Get Substring    ${response}    ${startbyte}    ${endbyte}
    IF    "${byterange}" == ""
        Log To Console    The byte does not exist. Test Case FAIL!
        Set Test Status To Fail    error_type=Diagnostic    info_text=The byte does not exist.Test Case FAIL!
    ELSE
        Log To Console     the byte is ${byterange}
        RETURN    ${byterange}
    END

prj.sut.can.diag.tester.present.active
    [Documentation]    This function is to enable Tester Present
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagTesterPresent    1

prj.sut.can.diag.tester.present.deactive
    [Documentation]    This function is to disable Tester Present
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagTesterPresent    0

prj.sut.diag.log.display
    [Documentation]    This function is to display the expected and obtained result on the console
    [Arguments]    ${message1}    ${message2}
    Log To Console    Expected Result == Obtained Result
    Log To Console    ${message1} = ${message2}

prj.sut.diag.compare
    [Documentation]    This function is to compare the actual result with the obtained result
    [Arguments]    ${resp_actual}
    ${resp_result}    prj.sut.can.diag.get
    IF    "${resp_result}" == "${resp_actual}"
        prj.sut.diag.log.display    ${resp_actual}    ${resp_result}
        Log To Console    Expected result is the same as actual result.OK!
    ELSE IF    "${resp_result}" == ""
        Log To Console    No response  is obtained (EMPTY)
    ELSE
        Log To Console    ${resp_actual} is not the same as ${resp_result}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${resp_actual} but we are getting: ${resp_result} from DUT!
    END

prj.sut.diag.compare.byte.range
    [Documentation]    This function is get the byte range of the response
    [Arguments]    ${resp_actual}    ${startbyte}    ${endbyte}
    ${resp_result}    prj.sut.can.diag.get
    ${byterange}    Get Substring    ${resp_result}    ${startbyte}    ${endbyte}
    IF    "${byterange}" == "${resp_actual}"
        prj.sut.diag.log.display    ${resp_actual}    ${byterange}
        Log To Console    Test Case PASS!
    ELSE
        Log To Console    ${resp_actual} is not the same as ${byterange}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${resp_actual} but we are getting: ${byterange} from DUT!
    END

prj.sut.diag.Nocheckbyte
    [Documentation]    This function is to check byte in not the line
    [Arguments]    ${byte}
    ${sResult}    prj.sut.can.diag.get
    ${sResult}    Set Variable    ${sResult}
    IF    "${byte}" not in "${sResult}"
        Log To Console    Byte is not seen in the response. OK!
        RETURN    ${sResult}
    ELSE
        Log To Console    Byte is seen in the response. NOK!
        ${byte}    Set Variable    ${byte}
        Set Test Status To Fail    error_type=Diagnostic    info_text=${byte} is seen in DUT ${sResult}.NOK!
    END

DTC Setting OFF
    [Documentation]    This function is to set the DTC setting to OFF
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_OFF_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_OFF_Resp}

DTC Setting ON
    [Documentation]    This function is to set the DTC setting to ON
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

    prj.sut.can.diag.send    ${sut.diag.Control_DTC_Setting_ON_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Control_DTC_Setting_ON_Resp}

prj.sut.diag.IpDrop
    [Documentation]    This function is to simulate IP drop
    [Arguments]    ${IPDrop}
    bits_platform.Rbs Set Variable Value    1    SYSTEM    IPDrop::signalname    ${IPDrop}
    bits_platform.Rbs Set Variable Value    1    SYSTEM    IPDrop::send    1
    bits_platform.Rbs Set Variable Value    1    SYSTEM    IPDrop::send    0

prj.sut.diag.checkbyte
    [Documentation]    This function is to check byte in a line
    [Arguments]    ${byte}
    ${sResult}    prj.sut.can.diag.get
    ${sResult}    Set Variable    ${sResult}
    IF    "${byte}" in "${sResult}"
        Log To Console    Byte is seen in the response. OK!
        RETURN    ${sResult}
    ELSE
        Log To Console    Byte is NOT seen in the response. NOK!
        ${byte}    Set Variable    ${byte}
        Set Test Status To Fail    error_type=Diagnostic    info_text=${byte} is not seen in DUT ${sResult}.NOK!
    END

prj.sut.diag.checkbyte_not_present
    [Documentation]    This function checks that a byte/string is NOT present in response
    [Arguments]    ${byte}
    ${sResult}    prj.sut.can.diag.get

    IF    "${byte}" not in "${sResult}"
        Log To Console    Byte is NOT seen in the response. OK!
        RETURN    ${sResult}
    ELSE
        Log To Console    Byte is seen in the response. NOK!
        Set Test Status To Fail    error_type=Diagnostic    info_text=${byte} is present in DUT ${sResult}. NOK!
    END

prj.sut.diag.SetETHSignal
    [Documentation]    This function is to control the Ethernet Signal and input values
    [Arguments]    ${ETH_Signal}    ${Signal_Value}
    bits_platform.Rbs Set Variable Value    1    SYSTEM    EthSignal::EthSignalName    ${ETH_Signal}
    prj.sut.diag.ClearETHSignalValue
    bits_platform.Rbs Set Variable Value    1    SYSTEM    EthSignal::EthSignalValue    ${Signal_Value}
    bits_platform.Rbs Set Variable Value    1    SYSTEM    EthSignal::EthSignalSend    1
    bits_platform.Rbs Set Variable Value    1    SYSTEM    EthSignal::EthSignalSend    0
    Sleep    2s

prj.sut.diag.ClearETHSignalValue
    [Documentation]    Clear the data in the Diagnostic Console
    bits_platform.Rbs Set Variable Value    1    SYSTEM    EthSignal::EthSignalValue    1
    bits_platform.Rbs Set Variable Value    1    SYSTEM    EthSignal::EthSignalValue    0

HexConvertToASCII
    [Documentation]    Converts Hex value to ASCII
    [Arguments]    ${Hex_Value}
    ${ASCII_Value}    HextoASCII.Convert Hex to ASCII    ${Hex_Value}
    Log to Console    The ASCII value converted from Hex is ${ASCII_Value}
    RETURN    ${ASCII_Value}

prj.sut.diag.GetETHSignalValue
    [Documentation]    Read and print Ethernet signal value
    [Arguments]    ${ETH_Signal}

    # Set signal name
    bits_platform.Rbs Set Variable Value    1    SYSTEM    EthSignal::EthSignalName    ${ETH_Signal}
    ${ack}    ${value}    bits_platform.Rbs Get Variable Value    1    SYSTEM    EthSignal::EthSignalName
    Log To Console    ETH Signal [${ETH_Signal}] Value: ${value}
    RETURN    ${ack}
    RETURN    ${value}

prj.sut.diag.SetVehicleSpeedToZero
    [Documentation]    Sets Vehicle Speed to 0
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.ESP_v_Signal_XIX_ESP_21_XIX_E3V_VLAN_MPCI}    0
    Sleep    3s

prj.sut.can.diag.ProgrammingSession.Enter
    [Documentation]    This function is to enter Programming Session/FBL
    Log To Console    Entering Programming Session.....
    prj.sut.connect.dlt
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagProgrammingModeEntry    0
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagProgrammingModeEntry    1
    Sleep    6.45s
    FOR    ${counter}    IN RANGE    0    2
        Log To Console    Attempt ${counter} of 2
        Sleep    1s
        ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.Programming_Session_Resp}
        Log To Console    status is ${Status}
        IF    $Status
          Log To Console    Entering Programming session is successful
          ${bAck}    Set Variable    ${True}
          BREAK
        ELSE
          Log To Console    Entering Programming Session failed.Retrying
          ${bAck}    Set Variable    ${False}
        END
    END
    Sleep    3s
    prj.sut.disconnect.dlt
    IF    ${bAck} == ${False}
       ${Return}    prj.sut.can.diag.get
       Set Test Status To Fail    error_type=ProgrammingSession    info_text=Failed to Enter ProgrammingSession ${Return}

    END

prj.sut.can.diag.ProgrammingSession.Exit
    [Documentation]    This function is to exit Programming Session/FBL
    Log To Console    Exiting Programming Session.....
    prj.sut.connect.dlt
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagProgrammingModeExit    0
    bits_platform.Rbs Set Variable Value    1    SYSTEM    diag::diagProgrammingModeExit    1
    FOR    ${counter}    IN RANGE    0    4
        Sleep    15s
        Log To Console    Attempt ${counter} of 4
        Sleep    2s
        ${Status}    Run Keyword And Return Status    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
        IF    ${Status}
          Log To Console    Exiting Programming session is successful
          ${bAck}    Set Variable    ${True}
          Verify DLT keyword    OnEnterGssRun
          BREAK
        ELSE
          Log To Console    Exiting Programming Session failed.Retrying
          ${bAck}    Set Variable    ${False}
        END
    END
    prj.sut.disconnect.dlt
    IF    ${bAck} == ${False}
      ${Result}    prj.sut.can.diag.get
      Set Test Status To Fail    error_type=ProgrammingSession    info_text=Failed to Exit ProgrammingSession ${Result}
    END

prj.sut.diag.compare.byte.range.flexible
    [Documentation]    Compare byte range allowing multiple valid values
    [Arguments]    ${valid_values_list}    ${startbyte}    ${endbyte}    ${field_name}=Field

    ${resp_result}    prj.sut.can.diag.get
    ${byterange}    Get Substring    ${resp_result}    ${startbyte}    ${endbyte}

    # Convert list to string for safe logging
    ${valid_list_str}    Evaluate    str(${valid_values_list})

    # Display Given vs Observed safely
    Log To Console    \n${field_name} Validation:
    Log To Console    Given ${field_name}: ${valid_list_str}
    Log To Console    Observed ${field_name}: ${byterange}

    # Check if observed value matches any valid value
    ${match_found}    Set Variable    ${False}
    ${matched_value}    Set Variable    ${EMPTY}

    FOR    ${valid_value}    IN    @{valid_values_list}
        # Ensure both are strings and normalized
        ${valid_clean}    Strip String    ${valid_value}
        ${observed_clean}    Strip String    ${byterange}

        IF    '${observed_clean}' == '${valid_clean}'
            ${match_found}    Set Variable    ${True}
            ${matched_value}    Set Variable    ${valid_value}
            BREAK
        END
    END

    IF    ${match_found}
        prj.sut.diag.log.display    ${matched_value}    ${byterange}
        Log To Console    ✓ ${field_name} Test Case PASS! (Matched: ${matched_value})
    ELSE
        Log To Console    ✗ ${field_name} Test Case FAIL!
        Log To Console    Observed: ${byterange}
        Log To Console    Valid options: ${valid_list_str}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=${field_name} mismatch! Got: ${byterange}, Expected one of: ${valid_list_str}
    END

prj.sut.can.diag.VIN
    [Documentation]    This function is set VIN Number fot F1 90 Diagnostic command
    [Arguments]    ${VINNumber}
    Log To Console    Setting VIN Number to ${VINNumber}
    bits_platform.Rbs Set Variable Value    1    SYSTEM    vehicle::VIN    ${VINNumber}

prj.sut.diag.compare.list
    [Documentation]    This function compares the actual result with a list of expected results.
    [Arguments]        ${resp_actual}
    ${resp_result}    prj.sut.can.diag.get

    ${match_found}    Run Keyword And Return Status
    ...                List Should Contain Value    ${resp_actual}    ${resp_result}

    IF    ${match_found}
        Log To Console    Expected result matches actual result. OK!
        Log To Console    Matched value: ${resp_result} from possible values: @{resp_actual}
    ELSE IF    "${resp_result}" == "${EMPTY}"
        Log To Console    No response is obtained (EMPTY)
    ELSE
        Fail    Expected one of: @{resp_actual} but we are getting: ${resp_result} from DUT!
    END

prj.sut.diag.DID.Length.Validation
    [Documentation]    Check the DID Response Lenght
    [Arguments]    ${diag_Req}    ${diag_Resp}    ${Lenght}
    prj.sut.can.diag.send    ${diag_Req}
    Sleep    500ms
    ${resp_result}    prj.sut.can.diag.get
    ${byterange}    Get Substring    ${resp_result}    0    8
    IF    "${byterange}" == "${diag_Resp}"
        ${Resp_Lenght}    Get Length    ${resp_result}
        IF    ${Resp_Lenght} != ${Lenght}
            Set Test Status To Fail    error_type=DIAGNOSIS
            ...    info_text=The expected DID lenght is: ${Lenght} but we are getting: ${Resp_Lenght} from DUT!
        END
    ELSE
        Log To Console    ${diag_Resp} is not the same as ${byterange}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${diag_Resp} but we are getting: ${byterange} from DUT!
    END

prj.sut.diag.vinStringExtract
    [Documentation]    Extracts only the VIN bytes (17) from a DID F190 positive response by removing 62 F1 90
    [Arguments]    ${resp}

    # Split the full response into a list of bytes
    @{resp_list}    Split String    ${resp}

    # Slice out VIN bytes (skip first 3 bytes: 62 F1 90)
    @{vin_data}     Get Slice From List    ${resp_list}    3    20

    # Join the VIN bytes into one string (hex format)
    ${vin_string}   Catenate    SEPARATOR=    @{vin_data}

    # Log raw VIN bytes
    Log To Console    VIN Data Bytes: ${vin_string}

    RETURN    ${vin_string}

prj.sut.diag.HexToASCIIExtraction
    [Documentation]    Extracting & converting  HEX number to ASCII
    [Arguments]    ${hex_resp}
    Log To Console    HEX to ASCII
    ${ascii_resp}    Evaluate    bytes.fromhex("${hex_resp}").decode("ascii")
    Log To Console    we are getting: ${ascii_resp}
    RETURN    ${ascii_resp}

prj.sut.diag.Get.DID.Data.for.Validation
    [Documentation]    Get DID Data for Validation
    [Arguments]    ${resp_actual}    ${startbyte}    ${endbyte}
    ${byte_Data}    set variable    0
    ${resp_result}    prj.sut.can.diag.get
    ${byterange}    Get Substring    ${resp_result}    0    8
    IF    "${resp_result}" == ""
        Log To Console    No response  is obtained (EMPTY)
    ELSE IF    "${byterange}" == "${resp_actual}"
        ${byte_Data}    Get Substring    ${resp_result}    ${startbyte}    ${endbyte}
    ELSE
        Log To Console    ${resp_actual} is not the same as ${resp_result}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${resp_actual} but we are getting: ${resp_result} from DUT!
    END
    ${Byte_integer}   Convert To Integer    ${byte_Data}
    RETURN    ${Byte_integer}

prj.sut.diag.DID.Data.Validation
    [Documentation]    Data Validation
    [Arguments]    ${CAN_sigVal}    ${DID}    ${Value}    ${Lenght}
    IF    "${Value}" == "Raw_value"
        ${Result}    prj.sut.diag.Get.DID.Data.for.Validation    ${DID}    9    ${Lenght}
        IF    ${Result} == ${CAN_sigVal}
            Log To Console    we are getting: ${Result} from ${DID}
        ELSE
            Log To Console    The expected data is: ${CAN_sigVal} but we are getting: ${Result} from ${DID}
            Set Test Status To Fail    error_type=DID Data Validation
            ...    info_text=The expected data is: ${CAN_sigVal} but we are getting: ${Result} from ${DID}
        END
    ELSE IF    "${Value}" == "Phy_value"
        ${resp_result}    prj.sut.can.diag.get
        ${byte_Data}    Get Substring    ${resp_result}    9    ${Lenght}
        ${Byte_integer}   prj.sut.diag.Hex.to.Int.Conversion    ${byte_Data}
        IF    ${Byte_integer} == ${CAN_sigVal}
            Log To Console    we are getting: ${Byte_integer} from ${DID}
        ELSE
            Log To Console    The expected data is: ${CAN_sigVal} but we are getting: ${Byte_integer} from ${DID}
            Set Test Status To Fail    error_type=DID Data Validation
            ...    info_text=The expected data is: ${CAN_sigVal} but we are getting: ${Byte_integer} from ${DID}
        END
    ELSE
        Log To Console    The expected data is: ${CAN_sigVal} but we are getting: ${Byte_integer} from ${DID}
        Set Test Status To Fail    error_type=DID Data Validation
        ...    info_text=The expected data is: ${CAN_sigVal} but we are getting: ${Byte_integer} from ${DID}
    END

prj.sut.diag.DID.Data.Validation.non.zero.data
    [Documentation]    validate data in the DID is non zero
    [Arguments]    ${DID_Req}    ${DID_Reps}    ${Check}
    ${byte_Data}    set variable    0
    prj.sut.can.diag.send    ${DID_Req}
    Sleep    500ms
    ${resp_result}    prj.sut.can.diag.get
    ${byterange}    Get Substring    ${resp_result}    0    8
    IF    "${resp_result}" == ""
        Log To Console    No response  is obtained (EMPTY)
    ELSE IF    "${byterange}" == "${DID_Reps}"
        ${byte_Data}    Get Substring    ${resp_result}    9    23
    ELSE
        Log To Console    ${DID_Reps} is not the same as ${resp_result}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${DID_Reps} but we are getting: ${resp_result} from DUT!
    END
    ${Byte_integer}   prj.sut.diag.Hex.to.Int.Conversion    ${byte_Data}
    IF    "${Check}" == "Non Zero"
        IF    ${Byte_integer} != ${0}
            Log To Console    ${DID_Req} , Received DID value ${resp_result} is a non-zero value
        ELSE
            Log To Console    ${DID_Req} , Received DID value ${resp_result} is not a non-zero value
            Set Test Status To Fail    error_type=DIAGNOSIS
            ...    info_text= ${DID_Req} , Received DID value ${resp_result} is not a non-zero value
        END
    ELSE IF    "${Check}" == "Zero"
        IF    ${Byte_integer} >= ${0}
            Log To Console    ${DID_Req} , Received DID value ${resp_result} is a non-zero value
        ELSE
            Log To Console    ${DID_Req} , Received DID value ${resp_result} is not a non-zero value
            Set Test Status To Fail    error_type=DIAGNOSIS
            ...    info_text= ${DID_Req} , Received DID value ${resp_result} is not a non-zero value
        END
    END

prj.sut.diag.VWWorkshopSystemName.DID.Data.Validation
    [Documentation]    Data Validation
    [Arguments]    ${DID}
    ${byte_Data}    set variable    0
    ${resp_result}    prj.sut.can.diag.get
    ${byterange}    Get Substring    ${resp_result}    0    8
    IF    "${resp_result}" == ""
        Log To Console    No response  is obtained (EMPTY)
    ELSE IF    "${byterange}" == "${sut.diag.VWWorkshopSystemName_Resp}"
        ${byte_Data}    Get Substring    ${resp_result}    9    23
    ELSE
        Log To Console    ${sut.diag.VWWorkshopSystemName_Resp_Data} is not the same as ${resp_result}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${sut.diag.VWWorkshopSystemName_Resp_Data} but we are getting: ${resp_result} from DUT!
    END
    Log To Console    HEX to ASCII
    ${ascii_data}    Evaluate    bytes.fromhex("${byte_Data}").decode("ascii")
    IF    "${ascii_data}" == "${sut.diag.VWWorkshopSystemName_Resp_Data}"
        Log To Console    we are getting: ${ascii_data} from ${sut.diag.VWWorkshopSystemName_Req}
    ELSE
        Log To Console    The expected data is: ${sut.diag.VWWorkshopSystemName_Resp_Data} but we are getting: ${ascii_data} from ${DID}
        Set Test Status To Fail    error_type=DID Data Validation
        ...    info_text=The expected data is: ${sut.diag.VWWorkshopSystemName_Resp_Data} but we are getting: ${ascii_data} from ${DID}
    END

DID NRC 12
    [Documentation]    Create the request for NRC 12 in $22 and check response
    [Arguments]   ${DID_Req}
    ${prefix}    Evaluate    "${DID_Req}"[:-2]
    ${merged}   Catenate    SEPARATOR=    ${prefix}    ${sut.diag.DID.Lenghtbig_Resp}
    log    ${merged}
    prj.sut.can.diag.send    ${merged}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.DID.incorrectDID_Resp}
    Sleep    500ms

DID NRC 13
    [Documentation]    Create the request for NRC 13 in $22 and check response
    [Arguments]   ${DID_Req}
    ${DID_Short_Req}    Evaluate    "${DID_Req}"[:-2]
    prj.sut.can.diag.send    ${DID_Short_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
    Sleep    500ms
    ${DID_long_Req}   Catenate    SEPARATOR=    ${DID_Req}    ${sut.diag.DID.Lenghtbig_Resp}
    prj.sut.can.diag.send    ${DID_long_Req}
    Sleep    500ms
    prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}

DID NRC 31
    [Documentation]    Create the request for NRC 31 for $22 in programming session and check response
    [Arguments]   ${DID_Req}
    prj.sut.can.diag.ProgrammingSession.Enter
    prj.sut.diag.SetVehicleSpeedToZero
    prj.sut.can.diag.send    ${DID_Req}
    Sleep    500ms
    prj.sut.diag.compare and Continue    ${sut.diag.RequestOutOfRange_Resp}
    prj.sut.can.diag.ProgrammingSession.Exit

prj.sut.diag.NRCCheck
    [Documentation]    Create the request and check response is NRC 12
    [Arguments]   ${Req}    ${Reps}    ${NRC}
    IF    "${NRC}" == "NRC12"
        ${prefix}    Evaluate    "${Req}"[:-2]
        ${merged}   Catenate    SEPARATOR=    ${prefix}    ${sut.diag.DID.Lenghtbig_Resp}
        log    ${merged}
        prj.sut.can.diag.send    ${merged}
        Sleep    500ms
        prj.sut.diag.compare    ${Reps}
        Sleep    500ms
    ELSE IF    "${NRC}" == "NRC13"
        ${DID_Short_Req}    Evaluate    "${Req}"[:-2]
        prj.sut.can.diag.send    ${DID_Short_Req}
        Sleep    500ms
        prj.sut.diag.compare    ${sut.diag.DID.IncorrectMessageLength_Resp}
        Sleep    500ms
        ${DID_long_Req}   Catenate    SEPARATOR=    ${Req}    ${sut.diag.DID.Lenghtbig_Resp}
        prj.sut.can.diag.send    ${DID_long_Req}
        Sleep    500ms
        prj.sut.diag.compare    ${Reps}
    ELSE IF    "${NRC}" == "NRC31"
        prj.sut.can.diag.ProgrammingSession.Enter
        prj.sut.diag.SetVehicleSpeedToZero
        prj.sut.can.diag.send    ${Req}
        Sleep    500ms
        prj.sut.diag.compare and Continue    ${Reps}
        prj.sut.can.diag.ProgrammingSession.Exit
    ELSE IF    "${NRC}" == "NRC31_Default"
        prj.sut.diag.SetVehicleSpeedToZero
        prj.sut.can.diag.send    ${Req}
        Sleep    500ms
        prj.sut.diag.compare and Continue    ${Reps}
    END

prj.sut.diag.compare and Continue
    [Documentation]    This function is to compare the actual result with the obtained result
    [Arguments]    ${resp_actual}
    ${resp_result}    prj.sut.can.diag.get
    IF    "${resp_result}" == "${resp_actual}"
        prj.sut.diag.log.display    ${resp_actual}    ${resp_result}
        Log To Console    Expected result is the same as actual result.OK!
    ELSE
        Log To Console    ${resp_actual} is not the same as ${resp_result}
        Set Test Status To Fail And Continue    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${resp_actual} but we are getting: ${resp_result} from DUT!
    END

prj.sut.diag.Hex.to.Int.Conversion
    [Documentation]    convert Hex (more 2 byte with space in between) into an integer
    [Arguments]    ${Hex_Data}
    ${clean_data}    Replace String    ${hex_data}    ${SPACE}    ${EMPTY}
    ${number}    Evaluate    int("${clean_data}", 16)
    Log To Console    ${number}
    RETURN     ${number}

prj.sut.diag.Convert.Raw.To.Physical
    [Documentation]    Convert Raw To Physical
    [Arguments]    ${raw_value}    ${resolution}    ${offset}
    ${physical_value}    Evaluate    (${raw_value} * ${resolution}) + ${offset}
    RETURN    ${physical_value}

prj.sut.diag.DID.Data.Validation.With.Data.Convert
    [Documentation]    DID Data Validation With Data Convert
    [Arguments]    ${CAN_Msg_sgl}    ${DID_Reps}    ${Lenght}    ${resolution}    ${offset}
    ${resp_result}    prj.sut.can.diag.get
    ${byterange}    Get Substring    ${resp_result}    0    8
    IF    "${resp_result}" == ""
        Log To Console    No response  is obtained (EMPTY)
    ELSE IF    "${byterange}" == "${DID_Reps}"
        ${byte_Data}    Get Substring    ${resp_result}    9    ${Lenght}
    ELSE
        Log To Console    ${DID_Reps} is not the same as ${resp_result}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${DID_Reps} but we are getting: ${resp_result} from DUT!
    END
    ${raw_value}    prj.sut.diag.Hex.to.Int.Conversion    ${byte_Data}
    ${physical_value}    prj.sut.diag.Convert.Raw.To.Physical    ${raw_value}    ${resolution}    ${offset}
    Log To Console     Raw Value from DID ${raw_value}
    IF    ${physical_value} == ${CAN_Msg_sgl}
        Log To Console     Log To Console    we are getting: ${physical_value} from ${resp_result}
    ELSE
        Log To Console    The expected data is: ${CAN_Msg_sgl} but we are getting: ${physical_value} from ${resp_result}
        Set Test Status To Fail    error_type=DID Data Validation
        ...    info_text=The expected data is: ${CAN_Msg_sgl} but we are getting: ${physical_value} from ${resp_result}
    END

prj.sut.diag.SetVehicleSpeed
    [Documentation]    Set Vehicle_Speed
    [Arguments]    ${Speed}
    prj.sut.diag.SetETHSignal    ${sut.can.SysVar.ETNMsg.ESP_v_Signal_XIX_ESP_21_XIX_E3V_VLAN_MPCI}    ${Speed}
    Sleep    3s

prj.sut.DID.Test.case.setups
    [Documentation]    DID Test case setups
    prj.sut.power cycle
    Sleep    20s
    prj.sut.can.diag.tester.present.active
    Sleep    3s

prj.sut.com.set VIN Value
    [Documentation]    To set the VIN value with ASCII to decimal conversion
    [Arguments]    ${vin_input}=12345678912345678
    # Convert VIN input to individual characters and their decimal values
    ${vin_length}    Get Length    ${vin_input}
    # Generate console output and set signals for each VIN position
    FOR    ${index}    IN RANGE    1    ${vin_length + 1}
        ${char}    Get Substring    ${vin_input}    ${index-1}    ${index}
        # Convert ASCII character to decimal value
        ${decimal_value}    Evaluate    ord('${char}')
        # Calculate Mx value (increments every 5 positions)
        ${mx_number}    Evaluate    (${index} - 1) // 5
        ${mx_value}    Set Variable If    ${mx_number} < 10    Mx0${mx_number}    Mx${mx_number}
        # Format console output with decimal values
        IF    ${index} == 1
            ${console_line}    Set Variable    VIN_${index}_XIX_VIN_01_${mx_value}_XIX_E3V_VLAN_MPCI = ${decimal_value}
        ELSE IF    ${index} == 2
            ${console_line}    Set Variable    VIN_${index}_XIX_VIN_01_${mx_value}_XIX_E3V_VLAN_MPCI = ${decimal_value}
        ELSE
            ${console_line}    Set Variable    VIN_${index}_XIX_VIN_01_${mx_value}_XIX_E3V_VLAN_MPCI = ${decimal_value}
        END
        Log To Console    ${console_line}
    END
    # Set the complete VIN value in the system
    bits_platform.Rbs Set Variable Value    1    SYSTEM     vehicle::VIN    ${vin_input}
    Sleep    5s

prj.sut.com.set ASCII to decimal
    [Documentation]    Helper keyword to convert ASCII string to decimal values
    [Arguments]    ${ascii_string}
    ${decimal_list}    Create List
    ${length}    Get Length    ${ascii_string}
    FOR    ${i}    IN RANGE    ${length}
        ${char}    Get Substring    ${ascii_string}    ${i}    ${i+1}
        ${decimal}    Evaluate    ord('${char}')
        Append To List    ${decimal_list}    ${decimal}
    END
    RETURN    ${decimal_list}

prj.sut.diag.compareSupplyVoltage
    [Documentation]    This function is to compare response of the supply voltage with +-0.1 Tollerance value
    [Arguments]    ${resp_actual1}    ${resp_actual2}    ${resp_actual3}
    ${resp_result}    prj.sut.can.diag.get
    # Simulating switch-case using IF-ELSE structure
    IF    "${resp_result}" == "${resp_actual1}"
        prj.sut.diag.log.display    ${resp_actual1}    ${resp_result}
        Log To Console    Expected result is the same as actual result. OK! with -0.1 Tollerance
    ELSE IF    "${resp_result}" == "${resp_actual2}"
        prj.sut.diag.log.display    ${resp_actual2}    ${resp_result}
        Log To Console    Expected result is the same as actual result. OK! exact value
    ELSE IF    "${resp_result}" == "${resp_actual3}"
        prj.sut.diag.log.display    ${resp_actual3}    ${resp_result}
        Log To Console    Expected result is the same as actual result. OK! with -0.2 Tollerance
    ELSE
        Log To Console    ${resp_actual1} or ${resp_actual2} or ${resp_actual3} is not the same as ${resp_result}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=The expected result is: ${resp_actual1} or ${resp_actual2} or ${resp_actual3} but we are getting: ${resp_result} from DUT!
    END

prj.sut.diag.ConvertDecimalToDegCelcius
    [Documentation]    converting raw decimal temp value to DegreeCelcius
    [Arguments]    ${raw_dec}
    ${temp}    Evaluate    round(${raw_dec} * 0.75 - 40, 2)
    RETURN    ${temp}

prj.sut.diag.slavecompare
    [Documentation]    Compare if response matches ANY of the expected results
    [Arguments]    ${resp_actual}
    ${resp_result}    prj.sut.can.diag.get

    IF    "${resp_result}" == ""
        Log To Console    No response is obtained (EMPTY)
        RETURN
    END

    # Check if response is in the list of expected responses
    ${is_match}    Evaluate    $resp_result in $resp_actual

    IF    ${is_match}
        prj.sut.diag.log.display    ${resp_actual}    ${resp_result}
        Log To Console    Response matches expected result. OK!
    ELSE
        Log To Console    Response does not match any expected result
        Log To Console    Expected one of: ${resp_actual}
        Log To Console    But got: ${resp_result}
        Set Test Status To Fail    error_type=DIAGNOSIS
        ...    info_text=Expected one of: ${resp_actual} but got: ${resp_result} from DUT!
    END

prj.sut.diag.PartNumberUpdate
    [Documentation]    Updates partnumber values from ASCII to hexa
    [Arguments]    ${AURIX_VERSION}    ${Excel_Destination}    ${Jsonp_Path}

    ${result}=    Run Process    python    ${TAF_PATH}\\project\\testbench\\config\\Partnumber_code\\PartNumber_Automation.py    ${AURIX_VERSION}    ${Excel_Destination}    ${Jsonp_Path}    stdout=PIPE    stderr=PIPE

    # Log To Console    STDOUT: ${result.stdout}
    Log To Console    STDERR: ${result.stderr}
    Log To Console    RC: ${result.rc}

prj.sut.diag.CopyFile
    [Documentation]    Copy file from one folder to another folder
    [Arguments]    ${Excel_Source}    ${Excel_Destination}

    ${result}=    Run Process    python    ${TAF_PATH}\\project\\testbench\\config\\Partnumber_code\\File_Copy.py    ${Excel_Source}    ${Excel_Destination}    stdout=PIPE    stderr=PIPE

    Log To Console    STDOUT: ${result.stdout}
    Log To Console    STDERR: ${result.stderr}
    Log To Console    RC: ${result.rc}


