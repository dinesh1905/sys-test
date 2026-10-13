*** Settings ***
Documentation       Example script to set and get voltage

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager
Library    OperatingSystem
Library    String
Library    DateTime
Library        ${TAF_PATH}/project/test/suites/example/Image_read.py

*** Variables ***
${SEARCH_STRING}    error

*** Keywords ***
prj.sut.power inital preconditions
    [Documentation]    inital precondition for power module
    [Arguments]    ${sSignal}    ${voltage}
    Log To Console    MaaS Blade in RUN mode
    prj.sut.disconnect.dlt
    Sleep    1
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    ${sSignal}    0
    Sleep    2s
    prj.sut.can.simulation.Stop
    bits_platform.Output Set Analog Signal Value    ${sSignal}    ${voltage}
    prj.sut.connect.QNX
    prj.sut.power.add.voltage.to.dictionary.check    ${sSignal}    ${voltage}
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON
    Log To Console    Power cycle is done!

prj.sut.thread.A2BVoltageCheck
    [Documentation]    To check A2B network node discovery in the SOC putty
    prj.sut.connect.QNX
    Log To Console    Send the putty command "slog2info -w | grep -e ASC -e"
    ...    Check the putty response
    # Verify console able to send command and receive response
    # Verify QNX keyword    ${sut.power.QNXCommand.Reponse_A2B}    command=${sut.power.QNXCommand.Starts_A2B}
    Verify QNX keyword    A2B    command=${sut.power.QNXCommand.Starts_A2B}

Load and check Power Curve
    [Documentation]    Load Power Curve from specific folder
    [Arguments]    ${Power_curve_Name}
    Load Power Curve    ${Power_curve_Name}
    powercurve control    PLAY

Load Power Curve
    [Documentation]    Load Power Curve by passing the file path
    [Arguments]    ${Power_Curve _Name}
    Log    ${TAF_PATH}${sut.power.PowerCurve.Path}${Power_Curve _Name}
    ${bPower_Curve_Load}    bits_platform.powercurve load single Curve   ${TAF_PATH}${sut.power.PowerCurve.Path}/${Power_Curve _Name}
    # ${bPower_Curve_Load}    bits_platform.powercurve load single Curve   C:\BITSRF\sys_test\project\config\Power_Curve\E-02_Transient_overvoltage_TC1&2
    IF    ${bPower_Curve_Load}
       Log To Console    Power curve is loaded successfully
    ELSE
       Log To Console    Power curve is didnt load successfully
       Set Test Status To Fail    error_type=Power_Curve
        ...    info_text=Power curve is didnt load successfully
    END

Check Power Curve is completed
    [Documentation]    Check Power cruve played
    [Arguments]    ${Timeout}
    FOR    ${count}    IN RANGE    0    10
        Log    Iteration: ${count}
        
        ${bcomplete}    bits_platform.powercurve wait until curve is finished    ${Timeout}
        Sleep    500ms
        IF    ${bcomplete}    BREAK
    END
    IF    ${bcomplete}
       Log To Console    Power curve is loading completed
    ELSE
       Log To Console    Power curve didnt load completedly
       Set Test Status To Fail    error_type=Power_Curve
        ...    info_text=Power curve didnt load completedly
    END

powercurve control
    [Documentation]     Control the different action of the powercurve
    ...    PLAY start playing
    ...    STOP stops playing
    ...    PAUSE pauses playing immediately
    ...    PAUSE_END pauses after curve was played
    [Arguments]    ${state}
    ${bPower_Curve_action}    bits_platform.powercurve control playback    ${state}
    IF    ${bPower_Curve_action}
       Log To Console    Power curve action ${state} happened successfully
    ELSE
       Log To Console    Power curve action ${state} was not executed successfully
       Set Test Status To Fail    error_type=Power_Curve
        ...    info_text=Power curve action ${state} was not executed successfully
    END

Check A2B voltage and funcational state
    [Documentation]    Measure the A2B voltage and check its within the expected RANGE
    [Arguments]    ${Voltage}    ${State}
    ${Read_Current_Funcational_State}    Read the system Funcational state    ${State}
    ${A2B_Voltage}    Read A2B Voltage
    Log To Console    Voltage measured is ${A2B_Voltage}
    IF    ${State} == 'In_State_A'
        Log To Console    Check sysem is in Funcational State A and A2B voltage is around 8.8V
        IF    (${A2B_Voltage} >= ${sut.power.Voltage.A2B.Higher_Threshold_lower_limit} and ${A2B_Voltage} <= ${sut.power.Voltage.A2B.Higher_Threshold_upper_limit}) and ${Read_Current_Funcational_State} == ${sut.power.DLT.Funcational_state.A}
            Log To Console     A2B Voltage measured is ${A2B_Voltage} V and Read funcational state is ${Read_Current_Funcational_State} from DLT

        ELSE IF    (${A2B_Voltage} >= ${sut.power.Voltage.A2B.Higher_Threshold_lower_limit} and ${A2B_Voltage} < ${sut.power.Voltage.A2B.Higher_Threshold_upper_limit}) and ${Read_Current_Funcational_State} != ${sut.power.DLT.Funcational_state.A}
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Voltage measured is ${A2B_Voltage} V, its in the expected 8.8v, and Read funcational state,is ${Read_Current_Funcational_State} from DLT, expected it to be ${sut.power.DLT.Funcational_state.A}

        ELSE IF    (${A2B_Voltage} > ${sut.power.Voltage.A2B.Higher_Threshold_lower_limit1} and ${A2B_Voltage} < ${sut.power.Voltage.A2B.Higher_Threshold_upper_limit1}) and ${Read_Current_Funcational_State} == ${sut.power.DLT.Funcational_state.A}
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Voltage measured is ${A2B_Voltage} V, its in the expected 8.8v, and Read funcational state,is ${Read_Current_Funcational_State} from DLT, expected it to be ${sut.power.DLT.Funcational_state.A}

        ELSE
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Voltage measured is ${A2B_Voltage} V, expected to be around 8.8v
        END

    ELSE IF    ${State} == 'Not_In_State_A'
        Log To Console    Check sysem is in Not Funcational State A and A2B voltage is not around 8.8V
        IF    (${A2B_Voltage} >= ${sut.power.Voltage.A2B.Lower_Threshold_lower_limit} and ${A2B_Voltage} <= ${sut.power.Voltage.A2B.Lower_Threshold_upper_limit} ) and ${Read_Current_Funcational_State} != ${sut.power.DLT.Funcational_state.A}
            Log To Console     A2B Voltage measured is ${A2B_Voltage} V and Read funcational state is ${Read_Current_Funcational_State} from DLT

        ELSE IF    (${A2B_Voltage} >= ${sut.power.Voltage.A2B.Lower_Threshold_upper_limit}) and ${Read_Current_Funcational_State} != ${sut.power.DLT.Funcational_state.A}
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Voltage measured ${A2B_Voltage} V is not in expected range ,and Read funcational state,is ${Read_Current_Funcational_State} from DLT, its in expected functional state

        ELSE IF    (${A2B_Voltage} >= ${sut.power.Voltage.A2B.Lower_Threshold_lower_limit} and ${A2B_Voltage} <= ${sut.power.Voltage.A2B.Lower_Threshold_upper_limit} ) and ${Read_Current_Funcational_State} != ${sut.power.DLT.Funcational_state.A}
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Voltage measured ${A2B_Voltage} V is in expected range ,and Read funcational state,is ${Read_Current_Funcational_State} from DLT, expected it to be not ${sut.power.DLT.Funcational_state.A}

        ELSE
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Both Voltage measured and Read Functional state is not in the expected range ,measured voltage is ${A2B_Voltage} V and Read funcational state,is ${Read_Current_Funcational_State}
        END

    ELSE IF    ${State} == 'In_State_C'
        Log To Console    Check sysem is in Funcational State C
         IF    (${A2B_Voltage} >= ${sut.power.Voltage.A2B.Lower_Threshold_lower_limit} and ${A2B_Voltage} <= ${sut.power.Voltage.A2B.Lower_Threshold_upper_limit} ) and ${Read_Current_Funcational_State} != ${sut.power..DLT.Funcational_state.C}
            Log To Console     A2B Voltage measured is ${A2B_Voltage} V and Read funcational state is ${Read_Current_Funcational_State} from DLT

        ELSE IF    (${A2B_Voltage} >= ${sut.power.Voltage.A2B.Lower_Threshold_upper_limit}) and ${Read_Current_Funcational_State} != ${sut.power..DLT.Funcational_state.C}
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Voltage measured ${A2B_Voltage} V is not in expected range ,and Read funcational state,is ${Read_Current_Funcational_State} from DLT, its in expected functional state

        ELSE IF    (${A2B_Voltage} >= ${sut.power.Voltage.A2B.Lower_Threshold_lower_limit} and ${A2B_Voltage} <= ${sut.power.Voltage.A2B.Lower_Threshold_upper_limit} ) and ${Read_Current_Funcational_State} != ${sut.power..DLT.Funcational_state.C}
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Voltage measured ${A2B_Voltage} V is in expected range ,and Read funcational state,is ${Read_Current_Funcational_State} from DLT, expected it to be not ${sut.power..DLT.Funcational_state.C}

        ELSE
            Set Test Status To Fail     error_type=Power_Curve
            ...    info_text=Both Voltage measured and Read Functional state is not in the expected range ,measured voltage is ${A2B_Voltage} V and Read funcational state,is ${Read_Current_Funcational_State}
        END
    END


Verify DLT keyword offline withou failing
    [Documentation]    Function to verify keywords via log file after dlt is runned.
    [Arguments]    @{keywords}

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}
    ${Temp_Log}    Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${index}    IN RANGE    0    ${pattern_length}
        Log To Console    ******${pattern_list} ${index} ${pattern_length}*******
        Log To Console    Searching for: ${pattern_list}
        ${pattern_search}    Set Variable    ${pattern_list[${index}]}

        ${Status}    Run Keyword And Return Status    Should Contain    ${Temp_Log}    ${pattern_search}
        Log To Console    ${Status}
        IF    ${Status}
            Log To Console    Keyword ${pattern_search} found!
            BREAK
        ELSE
            Log to Console    Keyword ${pattern_search} is NOT found
        END
    END
    RETURN    ${Status}

Check Temperature is +70°C
    [Documentation]    Check Temperature is +70°C
    Log To Console    Check Temperature is +70°C

UBAT voltage from 16.0V to 0.0 V
    [Arguments]    ${sSignal}
    [Documentation]    UBAT voltage from 16.0V to 0.0V and check MaaS Blade remain in normal operating voltage range
    ${Voltage}    set variable    ${sut.power.Voltage.UBAT.Upper_limit_Normalvoltage}
    FOR    ${counter}    IN RANGE    0    90
        Log    ${counter}
        prj.sut.power.add.voltage.to.dictionary.check    ${sSignal}    ${Voltage}
        Verify DLT keyword offline    ${sut.power.DLT.normalvoltage_3}
        ${Voltage}    Evaluate    ${Voltage} - 0.1
        Sleep    5s
        IF    ${Voltage} <= ${sut.power.Voltage.UBAT.Lower_limit_Normalvoltage}    BREAK
    END

    Log To Console    Entering into UnderVoltage
    ${Under_Voltage}    set variable    ${sut.power.Voltage.UBAT.Upper_limit_undervoltage}
    FOR    ${counter}    IN RANGE    0    70
        Log    ${counter}
        prj.sut.power.add.voltage.to.dictionary.check    ${sSignal}    ${Under_Voltage}    
        Verify DLT keyword offline    ${sut.power.DLT.undervoltage}
        ${Under_Voltage}    Evaluate    ${Under_Voltage} - 0.1
        Sleep    5s
        IF    ${Under_Voltage} <= ${sut.power.Voltage.UBAT.Lower_limit_undervoltage}    BREAK
    END

    Log To Console    Entering into critical undervoltage
    ${critical_undervoltage}    set variable    ${sut.power.Voltage.UBAT.Upper_limit_critical_undervoltage}
    FOR    ${counter}    IN RANGE    0    70
        Log    ${counter}
        prj.sut.power.add.voltage.to.dictionary.check    ${sSignal}    ${critical_undervoltage}    
        Verify DLT keyword offline    ${sut.power.DLT.critical_undervoltage}
        ${critical_undervoltage}    Evaluate    ${critical_undervoltage} - 0.1
        Sleep    5s
        IF    ${critical_undervoltage} <= ${sut.power.Voltage.UBAT.Lower_limit_critical_undervoltage}    BREAK
    END

    Log To Console    Entering into OFF state
    ${Shutdown_volt}    set variable    ${sut.power.Voltage.UBAT.Shutdown_start}
    FOR    ${counter}    IN RANGE    0    70
        Log    ${counter}
        prj.sut.power.add.voltage.to.dictionary.check    ${sSignal}    ${Shutdown_volt}    
        Verify DLT keyword offline    ${sut.power.DLT.critical_undervoltage}
        ${Shutdown_volt}    Evaluate    ${Shutdown_volt} - 0.1
        Sleep    5s
        IF    ${Shutdown_volt} <= ${sut.power.Voltage.UBAT.Shutdown_done}    BREAK
    END

connect disconnect PIN
    [Documentation]    Connect and disconnect PINs
    [Arguments]    ${PIN}    ${Pluge}
    ${State}    set variable    ON
    IF    ${Pluge} == Disconnect
        ${State}    set variable    OFF
    ELSE IF    ${Pluge} == Connect
        ${State}    set variable    ON
    END

    IF    ${PIN} == X1700
        Log To Console    ${State} X1700
        Bits Mux PIN select    ${PIN}    ${State}
    ELSE IF    ${PIN} == X9704
        Log To Console    ${State} X9704
        Bits Mux PIN select    ${PIN}    ${State}
    ELSE IF    ${PIN} == X5000
        Log To Console    ${State} X5000
        Bits Mux PIN select    ${PIN}    ${State}
    ELSE
        Log To Console    ${PIN} is not in the list
    END

Bits Mux PIN select
    [Documentation]    Bits Mux PIN select
    [Arguments]    ${Port}    ${State}
    FOR    ${i}    IN RANGE    0    5
        Log    Iteration: ${i}
        ${bAck}    bits_platform.output set digital signal value    ${Port}    ${State}
        Sleep    300ms
        IF    ${bAck}    BREAK
    END
    IF    ${bAck}
        Log To Console    Select MUX set Successful IN BITS     console=yes
    ELSE
        Log To Console    Select MUX didn't set Successful IN BITS     console=yes
        framework.Set Test Status To Fail    error_type=Hardware connection    info_text=Mux toggling didnt happen as expected
    END

prj.sut.Power.Check duration
    [Documentation]    Check the duration in ms Enter the time is sec formate, Enter the Expected Time in ms
    [Arguments]    ${expected_ms}    ${Level}    ${startword}    ${EndWord}    ${Range}

    ${upper_limit}    Evaluate    ${expected_ms} + (${expected_ms} * 0.1)
    ${upper_limit}    Evaluate    ${upper_limit} / 1000
    ${lower_limit}   Evaluate    ${expected_ms} - (${expected_ms} * 0.1)
    ${lower_limit}    Evaluate    ${lower_limit} / 1000
    IF    '${Level}' == 'DTL'
        Log To Console    The duration should not take longer than ${expected_ms} s
        ${actual_ms}    Calculate time from DTL time stamp    ${startword}    ${EndWord}
    ELSE IF    '${Level}' == 'CAN'
        Log To Console    The duration should around ${expected_ms}
        ${actual_ms}    Check Duration from CAN trace    ${startword}    ${EndWord}
    ELSE IF    '${Level}' == 'ETH'
        Log To Console    The duration should around ${expected_ms}
        ${actual_ms}    Check Duration from ETH trace    ${startword}    ${EndWord}
    ELSE
        framework.Set Test Status To Fail    error_type=Power time    info_text=Log file is not Selected correctly 
    END
    IF    '${Range}' == 'Within Range'
        IF    ${lower_limit} <= ${actual_ms} and ${upper_limit} >= ${actual_ms}
            Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_ms} s
        ELSE
            Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_ms} s
            framework.Set Test Status To Fail    error_type=Power time    info_text=Expected timing is ${expected_ms}±5 ms, but got ${actual_ms} s
        END
    ELSE IF    '${Range}' == 'Less Than'
        IF     ${actual_ms} <= ${expected_ms}
            Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_ms} s
        ELSE
            Log To Console    Expected ${expected_ms}±5 ms, but got ${actual_ms} s
            framework.Set Test Status To Fail    error_type=Power time    info_text=Expected timing be to lees than ${expected_ms}±5 ms, but got ${actual_ms} s
        END
    ELSE
        framework.Set Test Status To Fail    error_type=Power time    info_text=Timing Range is not Selected correctly 
    END

Calculate time from DTL time stamp
    [Documentation]    calculate time from DLT log
    [Arguments]    ${startword}    ${EndWord}
    Set Local Variable    ${actual_total_ms}    0
    Log To Console    calculate time from DLT log between ${startword} and ${EndWord} logs
    ${Time_Stamp1}    Get the Time log from DTL    ${startword}
    ${Time_Stamp2}    Get the Time log from DTL    ${EndWord}
    Log To Console    ${startword} time stamp is ${Time_Stamp1}
    Log    ${startword} time stamp is ${Time_Stamp1}
    Log To Console    ${EndWord} time stamp is ${Time_Stamp2}
    Log    ${EndWord} time stamp is ${Time_Stamp2}
    ${actual_total_ms}    subtract date from date    ${Time_Stamp2}    ${Time_Stamp1}    Number    False    %Y-%m-%d %H:%M:%S.%f    %Y-%m-%d %H:%M:%S.%f
    Log To Console    ${actual_total_ms}
    log    ${actual_total_ms}
    RETURN    ${actual_total_ms}



Get the Time log from DTL
    [Documentation]    Get the Time log from DTL
    [Arguments]    ${SEARCH_STRING}
    ${real_time}    Set Variable    0
    ${path}    Set Variable    D:/tmp/LogFile/${TEST_NAME}/log.txt
    # ${Time_Min}    Set Variable    0
    # ${Time_Sec}    Set Variable    0
    # ${Time_mSec}    Set Variable    0
    ${LogLine}    ${Serached}    prj.sut.connect.dlt.Search the DLT and return matching patterns    ${SEARCH_STRING}    ${path}
    IF    ${Serached}
        Log    ${LogLine}
        log    Split Log Line
        @{parts}    Split String    ${LogLine}    ${SPACE}
        FOR    ${LogLine}    IN    @{parts}
            Log    ${LogLine}
        END
        Log To Console    Date and Time is from log is saved
        ${Date}    Set Variable    ${parts[0]}
        ${Time}    Set Variable    ${parts[1]}
        ${Date_Time}    Catenate    ${Date}    ${Time}
        # ${Date_Time}    Replace String    ${Date_Time}    :    ${EMPTY}
        # ${timestamp}    Replace String    ${Date_Time}    ,    ${EMPTY}
        ${real_time}    subtract_time_from_date    ${Date_Time}    ${True}
        # ${real_time}    Convert Date    ${timestamp}    exclude_millis=True    date_format=%H:%M:%S
        # subtract_time_from_time

        Log    ${real_time}

    ELSE
        framework.Set Test Status To Fail    error_type=DLT_log    info_text=Expected string ${SEARCH_STRING} is not found in the DTL log
    END
    RETURN    ${real_time}

Check Duration from CAN trace
    [Documentation]    Check Duration from CAN trace
    [Arguments]    ${startword}    ${EndWord}
    ${Time1}    Get the Time log from the can Trace log    ${startword}
    ${Time2}    Get the Time log from the can Trace log    ${EndWord}

    Log    ${Time1}
    Log    ${Time2}
    ${actual_total_ms}    Evaluate    ${Time2} - ${Time1}
    log    ${actual_total_ms}
    RETURN    ${actual_total_ms}

Get the Time log from the can Trace log
    [Documentation]    Get the Time log from the can Trace log
    [Arguments]    ${SEARCH_STRING}
    ${cleaned_Timestamp}    Set Variable    0
    ${LogLine}    ${Serached}    CANlog String Search    ${SEARCH_STRING}
    IF    ${Serached}
        Log    ${LogLine}
        log    Split Log Line
        @{parts}    Split String    ${LogLine}    ${SPACE}
        FOR    ${LogLine}    IN    @{parts}
            Log    ${LogLine}
        END
        Log To Console    Date and Time is from log is saved
        ${Timestamp}    Set Variable    ${parts[0]}
        Log    ${Timestamp}
        ${clean_Timestamp}    Replace String    ${Timestamp}    System    ${EMPTY}
        ${cleaned_Timestamp}    Replace String    ${clean_Timestamp}    :    ${EMPTY}
        Log    ${cleaned_Timestamp}

    ELSE
        framework.Set Test Status To Fail    error_type=DLT_log    info_text=Expected string ${SEARCH_STRING} is not found in the DTL log
    END
    RETURN    ${cleaned_Timestamp}

CANlog String Search
    [Documentation]    Get the Whole line with string match from the CAN log
    [Arguments]    ${SEARCH_STRING}
    ${Split_word}    Set Variable    System
    ${Searched}      Set Variable    0

    ${LOG_TEXT}      OperatingSystem.Get File
    ...    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    ...    encoding=ISO-8859-1
    ${LOG_TEXT}      OperatingSystem.Get File    D:/tmp/CAN_Trace/Trace.txt    encoding=ISO-8859-1
   ${Clean_text}=    Remove String Using Regexp    ${LOG_TEXT}    [^\x20-\x7E]
    ${Clean_text}=    Replace String    ${Clean_text}    \x00    ${EMPTY}

    ${Clean_lines}=   Split String    ${Clean_text}    ${Split_word}
    # # Use a dictionary for Evaluate variables
    # ${vars}=    Create Dictionary    Clean_text=${Clean_text}    Split_word=${Split_word}

    # ${Clean_lines}=    Evaluate    Clean_text.split(Split_word)    ${vars}

    # op through each block to find the search string
    FOR    ${line}    IN    @{Clean_lines}
        ${status}    ${msg}=    Run Keyword And Ignore Error
        ...    Should Contain    ${line}    ${SEARCH_STRING}

        IF    '${status}' == 'PASS'
            ${Searched}=    Set Variable    1
            Log    Found matching line: ${line}
            RETURN    ${line}    ${Searched}
        END
    END
    RETURN    ${line}    ${Searched}

ETH Log String Search
    [Documentation]    Get the Whole line with string match from the CAN log
    [Arguments]    ${SEARCH_STRING}
    ${Searched}    Set Variable    0
    ${clean_line}    Set Variable    Empty
    ${lines}    Get File    ${ETH_TRACE_FILE}
    ${split_lines}    Split To Lines    ${lines}
    ${SEARCH_STRING}    Set Variable    ${SEARCH_STRING}
    FOR    ${lines}    IN    @{split_lines}
        IF    "${SEARCH_STRING}" in "${lines}"
            Log    ${lines}
            ${Searched}    Set Variable    1
            RETURN    ${lines}    ${Searched}
            BREAK
        END
    END
    RETURN    ${clean_line}    ${Searched}

Get the Time log from ETH Trace log
    [Documentation]    Get the Time log from the can Trace log
    [Arguments]    ${SEARCH_STRING}
    ${Time_mSec}    Set Variable    0
    ${LogLine}    ${Serached}    ETH Log String Search    ${SEARCH_STRING}
    IF    ${Serached}
        Log    ${LogLine}
        log    Split Log Line
        @{parts}    Split String    ${LogLine}    ${SPACE}
        FOR    ${LogLine}    IN    @{parts}
            Log    ${LogLine}
        END
        Log To Console    Date and Time is from log is saved
        ${Time_Msec_str}    Set Variable    ${parts[3]}
        ${Time_mSec}    Evaluate    round(float(${Time_Msec_str}) * 100000,3)
        Log    ${Time_mSec}

    ELSE
        framework.Set Test Status To Fail    error_type=DLT_log    info_text=Expected string ${SEARCH_STRING} is not found in the DTL log
    END
    RETURN    ${Time_mSec}

Check Duration from ETH trace
    [Documentation]    Check Duration from CAN trace
    [Arguments]    ${startword}    ${EndWord}
    ${Time1}    Get the Time log from ETH Trace log    ${startword}
    ${Time2}    Get the Time log from ETH Trace log    ${EndWord}
    Log    ${Time1}
    Log    ${Time2}
    ${actual_total_ms}    Evaluate    ${Time2} - ${Time1}
    log    ${actual_total_ms}
    RETURN    ${actual_total_ms}

Get Current Timestamp
    ${timestamp}=    Get Current Date
    Log    Current timestamp: ${timestamp}
    RETURN    ${timestamp}

prj.sut.Power.Start video
    [Arguments]    ${Connection}
    [Documentation]    connect to the Blade via SerialSOC in putty
    ...    0xc data should be either 0x41 or 0x43. This will indicate the connection are 
    ...    there and working as expected and 0x00 when Camera is not connected
    IF    '${Connection}' == 'Connected'
        Verify QNX keyword    ${sut.power.QNXCommand.Video_test_Reponse_connected}     command= ${sut.power.QNXCommand.Starts_Video_test}
    ELSE IF    '${Connection}' == 'Not_Connected'
        Verify QNX keyword    ${sut.power.QNXCommand.Video_test_Reponse_Notconnected}     command= ${sut.power.QNXCommand.Starts_Video_test}
    ELSE
        framework.Set Test Status To Fail    error_type=Power Video    info_text=The start video command is not selected correctly
    END

prj.sut.Power.screencap the image from camera
    [Arguments]    ${displayed_on_ABT_screen}
    [Documentation]    connect to the Blade via SerialSOC in putty
    Log To Console     Configure the camera settings
    Sleep    1s
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=${sut.power.QNXCommand.Configure_camera_settings_line1}
    Sleep    500ms
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=${sut.power.QNXCommand.Configure_camera_settings_line2}
    Sleep    500ms
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=${sut.power.QNXCommand.Configure_camera_settings_line3}
    Sleep    500ms
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=${sut.power.QNXCommand.Configure_camera_settings_line4}
    Sleep    30s
    IF    '${displayed_on_ABT_screen}' == 'Displayed'
        Verify QNX keyword    ${sut.power.QNXCommand.Starts_camera_test_Display_Reponse}    command=${sut.power.QNXCommand.Starts_camera_test_Display}
        QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=e
        Sleep    10s
    ELSE IF    '${displayed_on_ABT_screen}' == 'Not_Displayed'
        Verify QNX keyword    ${sut.power.QNXCommand.Starts_camera_test_Without_Display_Reponse}    command=${sut.power.QNXCommand.Starts_camera_test_Without_Display}
        QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=e
        Sleep    10s
    ELSE
        framework.Set Test Status To Fail    error_type=Power Video    info_text=screencap the image from camera is not selected correctly
    END

Read the Target current
    [Documentation]    Read current and check itself within the range
    [Arguments]    ${sSignal}    ${sValue}    ${condition}
    ${bAck}    ${smeasured}    bits_platform.Input Get Signal Value    ${sSignal}
    Log    ${smeasured}
    ${Int_measured}    Convert To Number    ${smeasured}    3
    Log    ${Int_measured}
    ${Int_measured}    Evaluate    ${Int_measured}
    IF    "Greaterthan" == "${condition}"
        Should Be True    ${Int_measured} >= ${sValue}
    ELSE IF    "Lessthan" == "${condition}"
        Should Be True    ${Int_measured} <= ${sValue}
    ELSE
        framework.Set Test Status To Fail    error_type=Current Measured    info_text=The condition has not been selected correctly
    END

Validate Temperature Range
    [Arguments]    ${value}
    Should Be True    ${value} >= -70 and ${value} <= 70    Temperature ${value} is out of allowed range (-70 to 70)

Extract Temperature Number
    [Arguments]    ${text}

    # Split on '=' and take the last part (handles extra '=' in the log)
    ${parts}=    Split String    ${text}    =
    ${after_equal}=    Get From List    ${parts}    -1

    # Remove any 'C' or spaces
    ${clean}=    Replace String    ${after_equal}    C    ${EMPTY}
    ${clean}=    Strip String    ${clean}

    RETURN    ${clean}


Check Test point voltage
    [Documentation]    Read the Voltage and validate based on the selected range
    [Arguments]    ${Range}    ${sSignal}

    ${bAck}    ${smeasured}    bits_platform.Input Get Signal Value    ${sSignal}

    ${Int_measured}    Convert To Number    ${smeasured}

    Log    Measured Voltage: ${Int_measured} V

    IF    "${Range}" == "equalto"
        Log    Checking whether voltage is between 7 V and 10 V
        Should Be True    ${Int_measured} >= 7 and ${Int_measured} <= 10
        ...    Voltage ${Int_measured} V is not within the expected range of 7 to 10 V

    ELSE IF    "${Range}" == "zero"
        Log    Checking whether voltage is less than 7 V
        Should Be True    ${Int_measured} < 7
        ...    Voltage ${Int_measured} V is not less than 7 V

    ELSE
        Fail    Invalid range argument passed: ${Range}
    END

prj.sut.Power.Check String is present in CAN Traces
    [Documentation]    sreach and return the data
    [Arguments]    ${String}
    ${lines}    ${Searched}    CANlog String Search    ${String}
    IF    ${Searched}
        Log To Console    Keyword ${lines} found!
    ELSE
        Log to Console    Keyword ${lines} is NOT found
    END

prj.sut.Power.DTL logs for normal funcational state of DUT
    [Documentation]    Check the DTL Sequnces for normal funcational state
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    Verify DLT keyword offline  [PowerM] KssPowerUp SwitchOnPowerRail
    Verify DLT keyword offline  [PowerM] GssPowerUp CPU Activated
    Verify DLT keyword offline    [PowerM] BswM_RequestMode [PRJ_RackMode_RUN]
    Verify DLT keyword offline  [PowerM] SendCanSignal

prj.sut.Power.Activate Big Toelner
    [Documentation]    Activate Big Toelner
    bits_platform.Output Set Analog Signal Value    Battery    0
    sleep    1s    
    bits_platform.Output Set Digital Signal Value    Big_toelner_6    ON
    sleep    1s
    bits_platform.Output Set Digital Signal Value    Big_toelner_8    ON
    sleep    1s
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12


prj.sut.Power.Deactivate Big Toelner
    [Documentation]    Deactivate Big Toelner
    bits_platform.Output Set Analog Signal Value    powercurve_battery    0
    sleep    1s
    bits_platform.Output Set Digital Signal Value    Big_toelner_6    OFF
    sleep    1s
    bits_platform.Output Set Digital Signal Value    Big_toelner_8    OFF
    sleep    1s
    bits_platform.Output Set Analog Signal Value    Battery    12
	
prj.sut.Power. camera image dump and move
    [Documentation]    Enter SOC console and request camera image dump
    [Arguments]    ${displayed_on_ABT_screen}
    Close All Connections
    Open Connection   172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    prj.sut.Power.screencap the image from camera    ${displayed_on_ABT_screen}
    log    Press ‘s’ then ENTER.
    Verify QNX keyword    Dump frames of all bufferlists    command=s
    #QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=s
    Sleep    30s
    log    Press ‘0’, then ENTER.
    Verify QNX keyword    Dumped frame at    command=0
    #QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=0
    Sleep    10s
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=\x03
    #write    find /tmp/ -name "*.raw"
    write    find /tmp/ -name "*.raw" -exec basename {} \;
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    RETURN    ${output}

delete raw and generated camera input images
    Remove Directory    ${TAF_PATH}/project/config/Camera_Input/raw_folder    recursive=True
    Remove Directory    ${TAF_PATH}/project/config/Camera_Input/gen_folder    recursive=True

Check and recreate directory
    [Arguments]    ${dir}
    ${exists}=    Run Keyword And Return Status
    ...    OperatingSystem.Directory Should Exist
    ...    ${TAF_PATH}/project/config/Camera_Input/${dir}
    IF    ${exists}
        Remove Directory    ${TAF_PATH}/project/config/Camera_Input/${dir}    recursive=True
    END
    Create Directory    ${TAF_PATH}/project/config/Camera_Input/${dir}

Generate jpg image from raw image
    [Arguments]    ${raw_file}
    Check and recreate directory    raw_folder
    Check and recreate directory    gen_folder
    ${raw_file}=    Copy the file from device to local    ${raw_file}
    ${raw_folder}=    Set Variable    ${TAF_PATH}/project/config/Camera_Input/raw_folder
    ${gen_folder}=    Set Variable    ${TAF_PATH}/project/config/Camera_Input/gen_folder
    Image_read.process_png_image    ${raw_folder}/${raw_file}    ${gen_folder}/
    ${digit}    Image_read.detect_digit    ${gen_folder}/Grey_Raw_image1.jpg
    Log    ${digit}
    IF    ${digit} == ${1} or ${digit} == ${2} or ${digit} == ${3} or ${digit} == ${4}
        Log    Image is detected
    ELSE
        #Set Test status to fail    error_type=Camera_Input    info_text=Image is not detected
        Log    Image is not detected
    END

Copy the file from device to local
    [Arguments]    ${raw_file}
    ${lines}=    Split To Lines    ${raw_file}
    ${raw_file}=    Set Variable    ${lines[0]}
    ${raw_file}=    Strip String    ${raw_file}
    Log To Console    the stripped raw file is ${raw_file} and is the in image format
    SSHLibrary.Get File    /tmp/${raw_file}    ${TAF_PATH}/project/config/Camera_Input/raw_folder/${raw_file}
    RETURN    ${raw_file}

initial condition for camera test
    [Arguments]    ${ip}    ${port}    ${usr}    ${pwd}
    Close All Connections
    Open Connection   ${ip}    None    ${port}
    Login    ${usr}    ${pwd}    allow_agent=${True}
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=${sut.power.QNXCommand.Configure_camera_settings_line1}
    Sleep    500ms
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=${sut.power.QNXCommand.Configure_camera_settings_line2}
    Sleep    500ms
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=${sut.power.QNXCommand.Configure_camera_settings_line3}
    Sleep    500ms
    QConnectBase.ConnectionManager.send_command    conn_name=${CONNECTION_NAME_QNX}    command=${sut.power.QNXCommand.Configure_camera_settings_line4}
    Sleep    5

FPS command to run camera
    ${output}=    write    ${sut.power.QNXCommand.request_camera_info};
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    RETURN    ${output}

FPS resolution validation
    [Arguments]    ${output}
    ${lines}=    Split To Lines    ${output}
    @{matches}=    Create List
    FOR    ${line}    IN    @{lines}
        Log To Console    🔍 Checking Line: ${line}
        # Step 1: Check if sensor exists
        ${has_sensor}=    Run Keyword And Return Status    Should Contain    ${line}    sensor[
        IF    not ${has_sensor}
            CONTINUE
        END
        # Step 2: Extract sensor safely (no regex)
        ${sensor}=    Evaluate    "${line}".split("sensor[")[1][0]

        # Step 3: Only sensors 0–3
        IF    '${sensor}' != '0' and '${sensor}' != '1' and '${sensor}' != '2' and '${sensor}' != '3'
            CONTINUE
        END
        # Step 4: Extract FPS and Dimension (LOOSE REGEX)
        ${fps_match}=    Get Regexp Matches    ${line}    fps.*?([0-9]+\.[0-9]+)
        ${dim_match}=    Get Regexp Matches    ${line}    Dimension.*?([0-9]+x[0-9]+)
        Log To Console    👉 Sensor=${sensor}, FPS=${fps_match}, DIM=${dim_match}
        IF    ${fps_match} and ${dim_match}
            ${fps}=    Set Variable    ${fps_match}[0]
            ${dim}=    Set Variable    ${dim_match}[0]

            # Avoid duplicates
            ${existing}=    Evaluate    [item[0] for item in ${matches}]
            IF    '${sensor}' in ${existing}
                CONTINUE
            END

            ${entry}=    Create List    ${sensor}    ${fps}    ${dim}
            Append To List    ${matches}    ${entry}

            Log To Console    ✅ MATCH: Sensor[${sensor}] FPS=${fps} DIM=${dim}
        END
    END
    Log To Console    \n==== FINAL MATCHES ====\n${matches}

    # Validate count
    Length Should Be    ${matches}    4

    # Validate correct sensors
    ${sensors_found}=    Evaluate    sorted([item[0] for item in ${matches}])
    @{expected}=    Create List    0    1    2    3
    Should Be Equal    ${sensors_found}    ${expected}
    # Validate values
    FOR    ${item}    IN    @{matches}

        ${sensor}=    Set Variable    ${item}[0]
        ${fps_raw}=       Set Variable    ${item}[1]
        ${dim_raw}=       Set Variable    ${item}[2]

        ${fps_parts}=    Split String    ${fps_raw}
        ${fps}=          Set Variable    ${fps_parts}[-1]

        ${dim_parts}=    Split String    ${dim_raw}
        ${dim}=          Set Variable    ${dim_parts}[-1]

        Log To Console    🎯 Sensor[${sensor}] → FPS=${fps}, DIM=${dim}

        Should Be Equal    ${fps}    30.000000
        Should Be Equal    ${dim}    1280x1080
    END

Command for video dump
    [Arguments]    ${cmd}
    # Step 1: Start command
    Write    ${cmd}
    Sleep    2s
    # Step 2: Read menu
    ${menu_output}=    Read
    Log To Console    \n=== MENU OUTPUT ===\n${menu_output}
    # Step 3: Select option 1
    Write    1
    Sleep    30s
    # Step 4: Capture streaming logs
    ${stream_output}=    Read
    Log To Console    \n=== STREAM OUTPUT ===\n${stream_output}
    # Step 5: Exit
    Write    e
    Sleep    30s
    # Step 6: Final output after exit
    ${final_output}=    Read
    Log To Console    \n=== FINAL OUTPUT ===\n${final_output}

delete raw and generated camera input video folders
    Remove Directory    ${TAF_PATH}/project/config/Camera_Input/raw_video_folder    recursive=True

Copy the video file from device to local
    ${file}=    Set Variable    vcd_encoded_stream_low_latency.mp4
    SSHLibrary.Get File
    ...    /tmp/${file}
    ...    ${TAF_PATH}/project/config/Camera_Input/raw_video_folder/${file}
    RETURN    ${file}

Convert Video To Playable Format
    [Arguments]    ${input_file}
    ${output_file}=    Replace String    ${input_file}    .mp4    _converted.mp4
    Log To Console    ${input_file}
    Log To Console    ${output_file}
    ${ffmpeg}=    Set Variable    C:/ffmpeg/bin/ffmpeg.exe
    ${cmd}=    Set Variable    ${ffmpeg} -i "${input_file}" -c copy "${output_file}"
    ${result}=    Process.Run Process    ${cmd}    shell=True
    Log To Console    \n=== FFMPEG OUTPUT ===
    Log To Console    RC=${result.rc}
    Log To Console    ${result.stdout}
    Log To Console    ${result.stderr}
    OperatingSystem.File Should Exist    ${output_file}
    RETURN    ${output_file}

Validate Static Video Allowed
    [Arguments]    ${conv_file}
    ${result}=    Image_read.Validate Video Static   ${conv_file}    allow_static=True
    RETURN    ${result}

Validate video dump in camera input
    [Arguments]    ${result}
    # Validate status
    Should Be Equal    ${result['status']}    PASS
    # Validate video type
    Should Contain    ['DYNAMIC', 'STATIC']    ${result['video_type']}

    # If DYNAMIC → motion_count > 2
    Run Keyword If    '${result["video_type"]}' == 'DYNAMIC'
    ...    Should Be True    ${result['motion_count']} > 2

    # Validate FPS ≈ 30 (convert to int)
    ${fps_int}=    Evaluate    int(round(${result['fps']}))
    Should Be True    ${fps_int} == 30

    # Validate frame count
    Should Be True    ${result['frame_count']} > 0

Video file check
    Write    ls -lh /tmp/vcd_encoded_stream_low_latency.mp4
    Sleep    2s
    ${file_check}=    Read
    Log To Console    \n=== FILE CHECK ===\n${file_check}
    Should Contain    ${file_check}    vcd_encoded_stream_low_latency.mp4

Configure Eload and set overcurrent
    [Arguments]    ${overcurrent}
    ${bAck}=    bits_platform.electronic load initialize device    1
    IF    ${bAck} == ${True}
        bits_platform.electronic load set parameter    1    Input_State    ON
        Sleep    1s
        ${current_bAck}=    bits_platform.electronic load set parameter    1    Current    ${overcurrent}
        IF    ${current_bAck} == ${True}
            Log    The Eload current value is set to ${overcurrent} and is in over current condition
        ELSE
            Log    The current value is not set to ${overcurrent}
            Set Test Status To Fail    error_type=Power    info_text=The current value is not set to over current value
        END
    END

Reset Eload device
    [Arguments]    ${Reset_current}
    ${current_bAck}=    bits_platform.electronic load set parameter    1    Current    ${Reset_current}
    IF    ${current_bAck} == ${True}
        ${bAck}=    bits_platform.electronic load set parameter    1    Input_State    OFF
        IF    ${bAck} == ${True}
            Log    The Eload current value is reset to default current
        ELSE
            Log    The current value is not set to default current
            Set Test Status To Fail    error_type=Power    info_text=The current value is not set to default value
        END
    END

prj.sut.dlt.disconnect.clear.connect dlt
    [Documentation]    Disconnects dlt
    ...    move the log to another folder
    ...    clear the logs
    ...    connect dlt
    Log To Console    copy the log file and clear the data
    prj.sut.disconnect.dlt
    Move file    C:/tmp/LogFile/${TEST_NAME}/log.txt    C:/tmp/LogFile/${TEST_NAME}/cleared_log.txt
    prj.sut.connect.dlt
    prj.sut.clear.logs.dlt
    Sleep    10s

### Temperature chamber code ###

Set Temperature and wait for the target temp to reach
    [Documentation]    Set Temperature to target temp
    [Arguments]    ${sUnit}    ${target}    ${sState}    ${tolerance}
    ${bAck}=    bits_platform.climate_set_temperature_and_start    ${sUnit}    ${target}    ${sState}
    ${min}=    Evaluate    ${target} - ${tolerance}
    ${max}=    Evaluate    ${target} + ${tolerance}
    FOR    ${counter}    IN RANGE    0    600
        ${temp}=    Get Temperature    ${sUnit}
        sleep    2
        Exit For Loop If    ${temp} >= ${min} and ${temp} <= ${max}
    END
    IF    ${temp} >= ${min} and ${temp} <= ${max}
        Log    The temperature targetted is set
        #${bAck}=    bits_platform.climate_set_temperature_and_start    ${sUnit}    ${target}    OFF
    ELSE
        ${bAck}=    bits_platform.climate_set_temperature_and_start    ${sUnit}    ${target}    OFF
        #Set Test status to fail    error_type=Temperature    info_text=The targetted temperature is not set in given time
    END

Get Temperature
    [Arguments]    ${sUnit}
    ${bAck}    ${sResult}=    bits_platform.climate_read_current_temperature    ${sUnit}
    RETURN    ${sResult}

prj.sut.Power.check DLT log after setting setting target temperature
    [Arguments]    ${Temperature}
    @{sensor_data}=    Create List    PMIC    VIDEO    CAM    UFS_TOP    BOT    ETH    SCC    SIP_PMA    SIP_PME    ARX_DTS    ARX_DTSC    BLADE_TOP    BLADE_BOT
    ${Temperature_readings}    Create List
    ${Temperature_Float}    Evaluate    float(${Temperature})
    ${Adjusted_Temperature_1}    Evaluate     float("%.1f" % (${Temperature_Float} - ${sut.power.Temperature_TOLERANCE_1}))
    ${Adjusted_Temperature_2}    Evaluate    float("%.1f" % (${Temperature_Float} - ${sut.power.Temperature_TOLERANCE_2}))
    ${Adjusted_Temperature_3}    Evaluate     float("%.1f" % (${Temperature_Float} + ${sut.power.Temperature_TOLERANCE_1}))
    ${Adjusted_Temperature_4}    Evaluate    float("%.1f" % (${Temperature_Float} + ${sut.power.Temperature_TOLERANCE_2}))

    Log To Console    ${Adjusted_Temperature_1} ${Adjusted_Temperature_2} ${Adjusted_Temperature_3} ${Adjusted_Temperature_4}
    Append To List    ${Temperature_readings}    ${Adjusted_Temperature_2}    ${Adjusted_Temperature_1}    ${Temperature_Float}    ${Adjusted_Temperature_3}    ${Adjusted_Temperature_4}

    ${Temp_Log}    Operatingsystem.Get File    C:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${i}    IN    ${sensor_data}
        FOR   ${j}    IN    ${Temperature_readings}
            Log To Console    Searching for: Temperature ${Temperature_readings}[${j}]
            ${pattern_search}    Set Variable    ${i} = ${Temperature_readings}[${j}]
            ${Status}    Run Keyword And Return Status    Should Contain    ${Temp_Log}    ${pattern_search}
            Log To Console    ${Status}
            IF    ${Status}
                Log To Console    Keyword ${pattern_search} found!
                BREAK
            ELSE
                Log to Console    Keyword ${pattern_search} is NOT found
            END
        END
    END
    IF    not ${Status}
        Set Test Status To Fail    error_type=Power    info_text=None of the voltage ${Temperature_readings} Match!
    END

prj.sut.Power.Validate the DLT log temperature
    [Arguments]    ${target}
    ${Safety_Temperature_output}=    prj.sut.connect.dlt.Search the DLT and return matching patterns    [PowerM] SendCanSignal Safety Temperature value    D:/tmp/LogFile/${TEST_NAME}/log.txt
    ${Safety_Temperature_value}=    Extract Temperature Number    ${Safety_Temperature_output}[0]
    Log    ${Safety_Temperature_value}
    ${low}=     Evaluate    float(${target}) - ${sut.power.Temperature_TOLERANCE_2}
    ${high}=    Evaluate    float(${target}) + ${sut.power.Temperature_TOLERANCE_2}

    IF    ${Safety_Temperature_value} >= ${low} and ${Safety_Temperature_value} <= ${high}
        Log To Console    The safety temperature is in valid range
    ELSE
        Log To Console    The safety temperature is not in valid range
        Set Test Status To Fail    error_type=Power    info_text=safety Temperatures values don't Match!
    END

    ${blade_temperature_output}=    prj.sut.connect.dlt.Search the DLT and return matching patterns    [Temperature] Send MaaS inter blade temperature (TOP NTC)    D:/tmp/LogFile/${TEST_NAME}/log.txt
    ${blade_temperature_Value}=    Extract Temperature Number    ${blade_temperature_output}[0]
    Log    ${blade_temperature_Value}
    IF  ${blade_temperature_Value} >= ${low} and ${Safety_Temperature_value} <= ${high}
        Log To Console    The blade temperature is in valid range
    ELSE
        Log To Console    The blade temperature is not in valid range
        Set Test Status To Fail    error_type=Power    info_text=Blade Temperatures values don't Match!
    END

prj.sut.Power.Temperature traces check
    [Documentation]    Move log content up to and including SEARCH_STRING into log2.txt
    [Arguments]    ${SEARCH_STRING}

    ${path}           Set Variable    D:/tmp/LogFile/${TEST_NAME}/log.txt
    ${path_filtered}  Set Variable    D:/tmp/LogFile/${TEST_NAME}/log2.txt

    ${content}=       OperatingSystem.Get File    ${path}    encoding=ISO-8859-1
    ${content}=       Replace String    ${content}    \x00    ${EMPTY}
    ${content}=       Remove String Using Regexp    ${content}    [^\x20-\x7E\n\r\t]

    @{lines}=         Split To Lines    ${content}

    ${index}=         Set Variable    -1
    FOR    ${i}    ${line}    IN ENUMERATE    @{lines}
        IF    "${SEARCH_STRING}" in """${line}"""
            ${index}=    Set Variable    ${i}
            Exit For Loop
        END
    END

    Run Keyword If    ${index} == -1    Fail    Pattern not found in log file

    # everything BEFORE and INCLUDING the matching line goes to log2
    ${top_part}=      Get Slice From List    ${lines}    0    ${index + 1}
    ${top_text}=      Catenate    SEPARATOR=\n    @{top_part}
    Create File       ${path_filtered}    ${top_text}

    # everything AFTER the matching line stays in log.txt
    ${remaining}=     Get Slice From List    ${lines}    ${index + 1}
    ${remaining_text}=    Catenate    SEPARATOR=\n    @{remaining}
    Create File       ${path}    ${remaining_text}

Check flickering on display
    [Documentation]    Using Vision module check flickering is seen or not
    [Arguments]    ${Flickering_Status}
    bits_platform.Vision Configure Blinking View Test    1    ${test_point_name_on}    ${test_point_name_off}
    bits_platform.Vision Control Blinking View Test    1    ${Flickering_Status}
    ${ack}    ${sErrorCounter}    bits_platform.Vision Read Blinking View Test Result    1
    IF    ${sErrorCounter}
        Log To Console    Flickering is detected in display during Engine Cranking
        Set Test Status To Fail    error_type=Power    info_text=Flickering is detected in display during Engine Cranking
    END
