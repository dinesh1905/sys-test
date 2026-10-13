*** Settings ***
Documentation    Project specific software download keywords
Resource    ${TAF_PATH}/import.resource
Library    OperatingSystem
Library    String
Library     QConnectBase.ConnectionManager



*** Variables ***
${CONNECTION_NAME}     TEST_CONN
${CONNECTION_NAME_QNX}     TEST_CONN_QNX
${CONNECTION_NAME_SAFETY}     TEST_CONN_SAFETY
${CONNECTION_NAME_SAIL}     TEST_CONN_SAIL


*** Keywords ***
prj.sut.connect.dlt
    [Documentation]    Connecting DLT
    # Create config for connection.
    prj.sut.disconnect.dlt
    Close DLT
    Sleep    2s
    ${test_name_log}        Set Variable        ${TEST_NAME}
    ${config_string}     catenate
    ...           {
    ...           "port" : "${sut.auto_flash.hardware_info.dltportnumber}",
    ...           "baudrate" : 115200,
    ...           "bytesize" : 8,
    ...           "stopbits" : 1,
    ...           "parity" : "N",
    ...           "rtscts" : false,
    ...           "xonxoff" : false,
    ...           "logfile": "D:/tmp/LogFile/${test_name_log}/log.txt"
    ...           }
    log to console     \nConnecting with configurations:\n ${config_string}
    ${config}      evaluate     json.loads('''${config_string}''')     json

    QConnectBase.ConnectionManager.Connect     conn_name=${CONNECTION_NAME}
    ...     conn_type=SerialClient
    ...     conn_conf=${config}
    log to console     Connection to ${CONNECTION_NAME} successful!

prj.sut.connect.QNX
    [Documentation]    Connecting QNX COM15 SCC
    # Create config for connection.
    prj.sut.disconnect.QNX
    Close DLT
    Sleep    2s
    ${test_name_log}        Set Variable        ${TEST_NAME}
    ${config_string}     catenate
    ...          {
    ...          "port" : "${sut.auto_flash.hardware_info.dltportnumber_QNX}",
    ...          "baudrate" : 115200,
    ...          "bytesize" : 8,
    ...          "stopbits" : 1,
    ...          "parity" : "N",
    ...          "rtscts" : "RTS",
    ...          "xonxoff" : "None",
    ...          "logfile": "D:/tmp/LogFile/${test_name_log}/log_QNX.txt"
    ...          }
    log to console     \nConnecting with configurations:\n ${config_string}
    ${config}      evaluate     json.loads('''${config_string}''')     json

    QConnectBase.ConnectionManager.Connect     conn_name=${CONNECTION_NAME_QNX}
    ...     conn_type=SerialClient
    ...     conn_conf=${config}
    log to console     Connection to QNX ${CONNECTION_NAME_QNX} successful!

prj.sut.disconnect.dlt
    [Documentation]    Disconnecting dlt.

    QConnectBase.ConnectionManager.disconnect      ${CONNECTION_NAME}

prj.sut.disconnect.QNX
    [Documentation]    Disconnecting dlt.

    QConnectBase.ConnectionManager.disconnect      ${CONNECTION_NAME_QNX}
    Log to console     Disconnect current connection to ${CONNECTION_NAME_QNX}

prj.sut.disconnect.safety
    [Documentation]    Disconnecting dlt.

    QConnectBase.ConnectionManager.disconnect      ${CONNECTION_NAME_SAFETY}
    Log to console     Disconnect current connection to ${CONNECTION_NAME_SAFETY}

prj.sut.connect.dlt.safety
    [Documentation]    Connecting DLT
    # Create config for connection.
    prj.sut.disconnect.safety
    Close DLT
    Sleep    2s
    ${test_name_log}        Set Variable        ${TEST_NAME}
    ${config_string}     catenate
    ...           {
    ...           "com_port" : "${sut.auto_flash.hardware_info.dltportnumber}",
    ...           "baudrate" : 115200,
    ...           "mode" : 1,
    ...           "ecu":"SCC",
    ...           "trcfile": "D:/tmp/Safety/Scc_Dlt_Common.trc",
    ...           "logfile": "D:/tmp/LogFile/${test_name_log}/log_safety.txt"
    ...           }
    log to console     \nConnecting with configurations:\n ${config_string}
    ${config}      evaluate     json.loads('''${config_string}''')     json

    QConnectBase.ConnectionManager.Connect     conn_name=${CONNECTION_NAME_SAFETY}
    ...     conn_type=DLT
    ...     conn_mode=dltconnector
    ...     conn_conf=${config}
    log to console     Connection to ${CONNECTION_NAME_SAFETY} successful!

Verify DLT keyword
    [Documentation]    Function to verify keywords via DLT connection
    [Arguments]    @{keywords}

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}

    FOR    ${index}    IN RANGE    0    ${pattern_length}
        # Log To Console    Now searching for keyword "${pattern_list[${index}]}"
        ${Status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME}
        ...    search_pattern=${pattern_list[${index}]}
        ...    timeout= 60
        IF    "${Status}" == "True"
            Log to Console    Keyword Matched for "${pattern_list[${index}]}"
        ELSE
            ${Keyword_var}        Set Variable        ${pattern_list[${index}]}
            Set Test Status To Fail    error_type=DLT    info_text=Keyword "${Keyword_var}" is not found
            Log To Console    Keyword "${Keyword_var}" is not found
        END
    END

Verify SAIL keyword
    [Documentation]    Function to verify keywords via DLT connection
    [Arguments]    @{keywords}

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}

    FOR    ${index}    IN RANGE    0    ${pattern_length}
        # Log To Console    Now searching for keyword "${pattern_list[${index}]}"
        ${Status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME_SAIL}
        ...    search_pattern=${pattern_list[${index}]}
        ...    timeout= 60
        IF    "${Status}" == "True"
            Log to Console    Keyword Matched for "${pattern_list[${index}]}"
        ELSE
            ${Keyword_var}        Set Variable        ${pattern_list[${index}]}
            Set Test Status To Fail    error_type=DLT    info_text=Keyword "${Keyword_var}" is not found
            Log To Console    Keyword "${Keyword_var}" is not found
        END
    END

Verify DLT keyword offline
    [Documentation]    Function to verify keywords via log file after dlt is runned.
    [Arguments]    @{keywords}

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}
    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
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
    IF    not ${Status}
        Set Test Status To Fail    error_type=Power    info_text=Keyword ${pattern_search} not Match!
    END

Verify QNX keyword
    [Documentation]    Function to verify keywords via DLT connection
    [Arguments]    @{keywords}    ${command}=

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}

    FOR    ${index}    IN RANGE    0    ${pattern_length}
        Log To Console    Now searching for keyword "${pattern_list[${index}]}"
        ${Status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME_QNX}
        ...    search_pattern=${pattern_list[${index}]}
        ...    timeout=60
        ...    send_cmd=${command}
        IF    "${Status}" == "True"
            Log to Console    Keyword Matched for "${pattern_list[${index}]}"
        ELSE
            ${Keyword_var}        Set Variable        ${pattern_list[${index}]}
            Set Test Status To Fail    error_type=DLT    info_text=Keyword "${Keyword_var}" is not found
            Log To Console    Keyword "${Keyword_var}" is not found
        END
    END

# prj.sut.connect.dlt.Search the DLT and return matching patterns
#     [Documentation]    Search the DLT and return matching patterns
#     [Arguments]    ${SEARCH_STRING}
#     ${Searched}    Set Variable    0
#     ${clean_line}    Set Variable    Empty
#     ${lines}     OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding=ISO-8859-1
#     # ${lines}     OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt
#     ${split_lines}    Split To Lines    ${lines}
#     ${SEARCH_STRING}    Set Variable    ${SEARCH_STRING}
#     FOR    ${lines}    IN    @{split_lines}
#         # ${clean_line1}    Replace String Using Regexp    ${lines}    \\[SER-1\\s*\\]    [SER-1]
#         # ${clean_line}    Replace String Using Regexp    ${clean_line1}    [^\x20-\x7E]+    ${EMPTY}
#         Log    ${SEARCH_STRING}
#         Log    ${lines}
#         IF    '${SEARCH_STRING}' in '${lines}'
#             Log    xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
#             Log    ${lines}
#         END
#     END

prj.sut.connect.dlt.Search the DLT and return matching patterns
    [Documentation]    Search the DLT and return matching patterns
    [Arguments]    ${SEARCH_STRING}
    ${clean_line}    Set Variable    ${EMPTY}
    ${section}    Set Variable    None
    ${Searched}    Set Variable    0
    ${content}     OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding=ISO-8859-1
    ${clean_line}    Replace String    ${content}    \x00    ${EMPTY}
    ${clean_line}    Replace String    ${clean_line}    \    ${EMPTY}
    ${clean_line}    Remove String Using Regexp    ${clean_line}    [^\x20-\x7E]
    ${split_logs}    Evaluate    re.split(r'(?=\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2},\\d{3})', """${clean_line}""")
    FOR    ${section}    IN    @{split_logs}
        IF    "${SEARCH_STRING}" in """${section}"""
            Log To Console    Found line: ${section}
            ${Searched}    Set Variable    1
            RETURN    ${section}    ${Searched}
            # Log To Console    Overall temperature is ${data}
            BREAK
        END
    END
    RETURN    ${section}    ${Searched}

prj.sut.connect.SAIL
    [Documentation]    Connecting SAIL
    # Create config for connection.
    prj.sut.disconnect.sail
    Close DLT
    Sleep    2s
    ${test_name_log}        Set Variable        ${TEST_NAME}
    ${config_string}     catenate
    ...           {
    ...           "port" : "${sut.auto_flash.hardware_info.dltportnumber_SAIL}",
    ...           "baudrate" : 115200,
    ...           "bytesize" : 8,
    ...           "stopbits" : 1,
    ...           "parity" : "N",
    ...           "rtscts" : false,
    ...           "xonxoff" : false,
    ...           "logfile": "D:/tmp/LogFile/${test_name_log}/log_SAIL.txt"
    ...           }
    log to console     \nConnecting with configurations:\n ${config_string}
    ${config}      evaluate     json.loads('''${config_string}''')     json

    QConnectBase.ConnectionManager.Connect     conn_name=${CONNECTION_NAME_SAIL}
    ...     conn_type=SerialClient
    ...     conn_conf=${config}
    log to console     Connection to ${CONNECTION_NAME_SAIL} successful!

prj.sut.disconnect.SAIL
    [Documentation]    Disconnecting SAIL.
    QConnectBase.ConnectionManager.disconnect      ${CONNECTION_NAME_SAIL}

Verify SAIL keyword offline
    [Documentation]    Function to verify keywords via log file after dlt is runned.
    [Arguments]    @{keywords}

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}
    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log_SAIL.txt    encoding_errors=ignore
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
    IF    not ${Status}
        Set Test Status To Fail    error_type=Power    info_text=Keyword ${pattern_search} not Match!
    END

Verify QNX keyword offline
    [Documentation]    Function to verify keywords via log file after dlt is runned.
    [Arguments]    @{keywords}

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}
    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log_QNX.txt    encoding_errors=ignore
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
    IF    not ${Status}
        Set Test Status To Fail    error_type=Power    info_text=Keyword ${pattern_search} not Match!
    END

prj.sut.clear.logs.dlt
    [Documentation]    Clears the content of the log file without deleting the file.
    ${log_file_path}    Set Variable    D:/tmp/LogFile/${TEST_NAME}/log.txt
    Run Keyword And Return Status    Evaluate    open('${log_file_path}', 'w').close()

prj.sut.clear.logs.qnx
    [Documentation]    Clears the content of the log file without deleting the file.
    ${log_file_path}    Set Variable    D:/tmp/LogFile/${TEST_NAME}/log_QNX.txt
    Run Keyword And Return Status    Evaluate    open('${log_file_path}', 'w').close()

prj.sut.get current Timedata
    [Documentation]    Gives current time data.
    ${timestamp}    Get Current Date
    Log    Current timestamp: ${timestamp}
    RETURN    ${timestamp}

prj.sut.get time log from dlt
    [Documentation]    Get the Time log from Dlt
    [Arguments]    ${SEARCH_STRING}
    ${real_time}    Set Variable    0
    ${LogLine}    ${Searched}    prj.sut.connect.dlt.Search the DLT and return matching patterns    ${SEARCH_STRING}
    IF    ${Searched}
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
        ${real_time}    subtract_time_from_date    ${Date_Time}    ${True}
        Log    ${real_time}
    ELSE
        framework.Set Test Status To Fail    error_type=DLT_log    info_text=Expected string ${SEARCH_STRING} is not found in the DTL log
    END
    RETURN    ${real_time}

Verify QNX keyword with long timout
    [Documentation]    Function to verify keywords via DLT connection
    [Arguments]    @{keywords}    ${command}=

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}

    FOR    ${index}    IN RANGE    0    ${pattern_length}
        Log To Console    Now searching for keyword "${pattern_list[${index}]}"
        ${Status}    Run Keyword And Return Status    Verify    conn_name=${CONNECTION_NAME_QNX}
        ...    search_pattern=${pattern_list[${index}]}
        ...    timeout=600
        ...    send_cmd=${command}
        IF    "${Status}" == "True"
            Log to Console    Keyword Matched for "${pattern_list[${index}]}"
        ELSE
            ${Keyword_var}        Set Variable        ${pattern_list[${index}]}
            Set Test Status To Fail    error_type=DLT    info_text=Keyword "${Keyword_var}" is not found
            Log To Console    Keyword "${Keyword_var}" is not found
        END
    END

prj.sut.connect.dlt.Verify DLT keyword not present in log
    [Documentation]    Function to check keywords Should not Contain via log file after dlt is runned.
    [Arguments]    @{keywords}

    ${pattern_list}    Create List    @{keywords}
    ${pattern_length}    Get Length    ${pattern_list}
    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${index}    IN RANGE    0    ${pattern_length}
        Log To Console    ******${pattern_list} ${index} ${pattern_length}*******
        Log To Console    Searching for: ${pattern_list}
        ${pattern_search}    Set Variable    ${pattern_list[${index}]}

        ${Status}    Run Keyword And Return Status    Should not Contain    ${Temp_Log}    ${pattern_search}
        Log To Console    ${Status}
        IF    ${Status}
            Log To Console    Keyword ${pattern_search} found!
            BREAK
        ELSE
            Log to Console    Keyword ${pattern_search} is NOT found
        END
    END
    IF    not ${Status}
        Set Test Status To Fail    error_type=Power    info_text=Keyword ${pattern_search} Match!
    END

prj.sut.connect.dlt.Get all matching patterns
    [Documentation]    Return all matching DLT sections
    [Arguments]    ${SEARCH_STRING}

    @{Matched_Logs}    Create List
    ${Searched}        Set Variable    0

    ${content}     OperatingSystem.Get File
    ...    D:/tmp/LogFile/${TEST_NAME}/log.txt
    ...    encoding=ISO-8859-1

    ${clean_line}    Replace String    ${content}    \x00    ${EMPTY}
    ${clean_line}    Replace String    ${clean_line}    \    ${EMPTY}
    ${clean_line}    Remove String Using Regexp    ${clean_line}    [^\x20-\x7E]

    ${split_logs}    Evaluate
    ...    re.split(r'(?=\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2},\\d{3})', """${clean_line}""")
    ...    re

    FOR    ${section}    IN    @{split_logs}

        IF    "${SEARCH_STRING}" in """${section}"""

            Append To List    ${Matched_Logs}    ${section}

            ${Searched}    Set Variable    1

            Log To Console    Found line: ${section}

        END

    END

    RETURN    ${Matched_Logs}    ${Searched}

prj.sut.get all time logs from dlt
    [Documentation]    Extract all timestamps from matching DLT logs
    [Arguments]    ${SEARCH_STRING}

    @{real_time_list}    Create List

    @{LogLines}    ${Searched}
    ...    prj.sut.connect.dlt.Get all matching patterns
    ...    ${SEARCH_STRING}

    IF    ${Searched}

        FOR    ${LogLine}    IN    @{LogLines}

            @{parts}    Split String    ${LogLine}    ${SPACE}

            ${Date}    Set Variable    ${parts}[0]
            ${Time}    Set Variable    ${parts}[1]

            ${Date_Time}    Catenate    ${Date}    ${Time}

            ${real_time}
            ...    subtract_time_from_date
            ...    ${Date_Time}
            ...    ${True}

            Append To List    ${real_time_list}    ${real_time}

            Log    Extracted time: ${real_time}

        END

    ELSE

        framework.Set Test Status To Fail
        ...    error_type=DLT_log
        ...    info_text=Expected string ${SEARCH_STRING} is not found in the DTL log

    END

    RETURN    ${real_time_list}

prj.sut.validate overall temperature interval
    [Documentation]    Validate Overall Temperature interval is less than 50ms

    @{time_list}
    ...    prj.sut.get all time logs from dlt
    ...    Overall temperature

    ${prev_time}    Set Variable    None

    FOR    ${curr_time}    IN    @{time_list}

        IF    '${prev_time}' != 'None'

            ${diff}    Evaluate    ${curr_time} - ${prev_time}

            Log To Console    Difference is ${diff} ms

            Should Be True
            ...    ${diff} < 50
            ...    Difference between consecutive Overall temperature logs is greater than 50ms

        END
        ${prev_time}    Set Variable    ${curr_time}
    END