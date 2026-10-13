*** Settings ***
Documentation    Project specific ethernet and  CAN keywords
Resource    ${TAF_PATH}/import.resource
Library    BuiltIn
Library    Process
Library    SSHLibrary
Library    QConnectBase.ConnectionManager


*** Keywords ***
prj.sut.com.Perform Firewall Scan
    [Documentation]    This function performs a comprehensive firewall scan by executing a two-stage validation process:
    ...                first verifying network connectivity through a ping test,
    ...                then conducting a detailed Nmap scan if connectivity is confirmed.
    [Arguments]    ${ip}    ${expected_ports}    ${expected_mac}    ${scan_type}    ${validation_mode}=OPEN

    # Step 1: Run Ping Test
    ${ping_status}    ${ping_message}=    Run Keyword And Ignore Error    prj.sut.com.Run Ping Test    ${ip}
    IF    '${ping_status}' == 'PASS'
        Log To Console    Ping successful for ${ip}, proceeding with Nmap scan
        # Step 2: Run Nmap Scan
        ${nmap_status}    ${nmap_message}=    Run Keyword And Ignore Error
        ...    prj.sut.com.Run Nmap Scan    ${ip}    ${expected_ports}    ${expected_mac}    ${scan_type}    ${validation_mode}

        IF    '${nmap_status}' == 'PASS'
            Log To Console     Nmap scan completed successfully for ${ip}
            Log    Firewall scan completed successfully for ${ip}    INFO
        ELSE
            Log To Console    Nmap scan failed for ${ip}
            Log    Nmap scan failure details: ${nmap_message}    ERROR
            Set Test Status To Fail    COM_ERROR    Firewall scan failed - Nmap scan unsuccessful for ${ip}. Details: ${nmap_message}
        END
    ELSE
        Log    Ping test failed: ${ping_message}
        Set Test Status To Fail    COM_ERROR    Cannot proceed with Nmap scan - ping test failed for ${ip}
    END

prj.sut.com.Run Ping Test
    [Documentation]    This function is to ping the specified IP address and verify the response.
    [Arguments]    ${ip_address}
    ${ping_command}=    Set Variable    ping -n 4 ${ip_address}
    ${result}=    Run Process    cmd    /c    ${ping_command}    shell=True    timeout=30s
    Log    Ping command: ${ping_command}
    Log    Return code: ${result.rc} | Stdout: ${result.stdout}

    # Store lowercase output once for efficiency
    ${stdout_lower}=    Convert To Lowercase    ${result.stdout}

    # Compact validation
    IF    ${result.rc} != 0    Set Test Status To Fail    COM_ERROR    Ping command failed to execute for ${ip_address}
    IF    'destination host unreachable' in '''${stdout_lower}'''    Set Test Status To Fail    COM_ERROR    Destination ${ip_address} is unreachable
    IF    'request timed out' in '''${stdout_lower}'''    Set Test Status To Fail    COM_ERROR    Ping requests to ${ip_address} timed out
    IF    'general failure' in '''${stdout_lower}'''    Set Test Status To Fail    COM_ERROR    General network failure when pinging ${ip_address}
    IF    '0% loss' not in '''${result.stdout}'''    Set Test Status To Fail    COM_ERROR    Packet loss detected when pinging ${ip_address}
    ${timing_check}=    Evaluate    bool(re.search(r'time[<=]?\\d+ms', '''${result.stdout}'''))    modules=re
    IF    not ${timing_check}    Set Test Status To Fail    COM_ERROR    No timing information found in ping responses
    Log    Ping test successful for ${ip_address}

prj.sut.com.Run Nmap Scan
    [Documentation]    This function scans the specified IP address using Nmap and validates open ports and MAC address.
    [Arguments]    ${ip_address}    ${expected_ports}    ${expected_mac}    ${scan_type}    ${validation_mode}=OPEN

    # Step 1: Execute Nmap Command
    ${result}=    prj.sut.com.Execute Nmap Command    ${ip_address}    ${scan_type}
    # Step 2: Validate Nmap Output
    prj.sut.com.Validate Nmap Output    ${result}    ${expected_ports}    ${expected_mac}    ${ip_address}    ${validation_mode}

    Log To Console    \n Nmap scan validation completed for IP: ${ip_address}

prj.sut.com.Execute Nmap Command
    [Documentation]    Executes the Nmap command for the given IP address and scan type.
    [Arguments]    ${ip_address}    ${scan_type}
    ${start_time}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    Log    \n[${start_time}] Starting Nmap scan for IP: ${ip_address}
    ${nmap_command}=    Set Variable    nmap ${scan_type} -6 ${ip_address}
    Log    Executing command: ${nmap_command}
    ${result}=    Run Process    ${nmap_command}    shell=True    timeout=800s
    ${end_time}=    Get Current Date    result_format=%Y-%m-%d %H:%M:%S
    ${duration}=    Subtract Date From Date    ${end_time}    ${start_time}
    Log    [${end_time}] Nmap scan completed in ${duration} seconds
    Log    Return code: ${result.rc}
    Log    Stdout length: ${result.stdout.__len__()}
    Log    Nmap output: ${result.stdout}

    # Check if Nmap scan was successful (return code should be 0)
    IF    ${result.rc} != 0
        Set Test Status To Fail    COM_ERROR    Nmap scan failed for ${ip_address}. Return code: ${result.rc}, Command: ${nmap_command}, Error: ${result.stderr}
    END

    # Check if Nmap returned output
    IF    not $result.stdout
        Set Test Status To Fail    COM_ERROR    Nmap returned no output for ${ip_address}. This may indicate network issues or invalid target.
    END

    # Check for common Nmap warning patterns
    ${has_warnings}=    Run Keyword And Return Status    Should Contain    ${result.stdout}    WARNING
    IF    ${has_warnings}
        Log    Nmap completed with warnings - review output above    WARN
    END

    Log     Nmap execution successful for ${ip_address}
    RETURN    ${result}

prj.sut.com.Validate Ports
    [Documentation]    Validates ports based on validation mode: OPEN, CLOSED, or SKIP
    [Arguments]    ${nmap_output}    ${expected_ports}    ${validation_mode}=OPEN

    Log To Console    \n=== PORT VALIDATION ===

    ${mode_upper}=    Set Variable    ${validation_mode.upper()}

    IF    '${mode_upper}' == 'SKIP'
        Log Many    Port validation SKIPPED as requested
        ...         Port validation skipped by validation_mode=SKIP    console=True
        RETURN
    END

    IF    not ${expected_ports}
        Log Many    No ports specified for validation - skipping port checks
        ...         Port validation skipped: empty expected_ports list    console=True
        RETURN
    END

    ${port_count}=    Get Length    ${expected_ports}
    Log To Console    Validation Mode: ${mode_upper} | Validating ${port_count} port(s)

    IF    '${mode_upper}' == 'OPEN'
        prj.sut.com.Validate Ports Are Open    ${nmap_output}    ${expected_ports}
    ELSE IF    '${mode_upper}' == 'CLOSED'
        prj.sut.com.Validate Ports Are Closed    ${nmap_output}    ${expected_ports}
    ELSE
        Set Test Status To Fail    COM_ERROR    Invalid validation_mode: ${validation_mode}. Use OPEN, CLOSED, or SKIP
    END

prj.sut.com.Validate Ports Are Open
    [Documentation]    Validates that specified ports are OPEN (Pre-SOP scenario)
    [Arguments]    ${nmap_output}    ${expected_ports}

    Log To Console    \n--- VALIDATING PORTS ARE OPEN (Pre-SOP) ---

    FOR    ${expected_port_entry}    IN    @{expected_ports}
        Log To Console    Checking if OPEN: ${expected_port_entry}
        ${regex_pattern}=    Replace String    ${expected_port_entry}    ${SPACE}    \\s+
        ${port_found}=    Run Keyword And Return Status    Should Match Regexp    ${nmap_output}    ${regex_pattern}

        IF    ${port_found}
            Log To Console     OPEN (Expected): ${expected_port_entry}
        ELSE
            Log To Console     NOT OPEN (Unexpected): ${expected_port_entry}
        END

        Run Keyword And Continue On Failure    Should Be True    ${port_found}
        ...    msg=Expected port "${expected_port_entry}" should be OPEN but was not found in Nmap output.
    END

prj.sut.com.Validate Ports Are Closed
    [Documentation]    Validates that specified ports are CLOSED (Post-SOP scenario)
    [Arguments]    ${nmap_output}    ${expected_ports}

    Log To Console    \n--- VALIDATING PORTS ARE CLOSED (Post-SOP) ---

    FOR    ${expected_port_entry}    IN    @{expected_ports}
        Log To Console    Checking if CLOSED: ${expected_port_entry}
        ${regex_pattern}=    Replace String    ${expected_port_entry}    ${SPACE}    \\s+
        ${port_found}=    Run Keyword And Return Status    Should Match Regexp    ${nmap_output}    ${regex_pattern}
        IF    ${port_found}
            Log To Console     STILL OPEN (Unexpected): ${expected_port_entry}
        ELSE
            Log To Console     CLOSED (Expected): ${expected_port_entry}
        END
        Run Keyword And Continue On Failure    Should Not Be True    ${port_found}
        ...    msg=Expected port "${expected_port_entry}" should be CLOSED but was found OPEN in Nmap output.
    END

prj.sut.com.Validate Nmap Output
    [Documentation]    Validates the Nmap output for expected ports and MAC address.
    [Arguments]    ${result}    ${expected_ports}    ${expected_mac}    ${ip_address}    ${validation_mode}=OPEN

    # Validate expected ports with specified mode
    prj.sut.com.Validate Ports    ${result.stdout}    ${expected_ports}    ${validation_mode}

    # Validate MAC address if provided and not placeholder
    prj.sut.com.Validate MAC Address If Provided    ${result.stdout}    ${expected_mac}

prj.sut.com.Validate MAC Address If Provided
    [Documentation]    Validates the MAC address in the Nmap output if it is provided and not a placeholder.
    [Arguments]    ${nmap_output}    ${expected_mac}

    ${mac_length}=    Get Length    ${expected_mac}
    ${is_placeholder}=    Run Keyword And Return Status    Should Be Equal    ${expected_mac}    XX:XX:XX:XX:XX:XX

    # Add check for invalid MAC strings
    ${is_invalid_format}=    Run Keyword And Return Status    Should Be Equal    ${expected_mac}    []

    IF    ${mac_length} > 0 and not ${is_placeholder} and not ${is_invalid_format}
        prj.sut.com.Validate MAC Address    ${nmap_output}    ${expected_mac}
    ELSE
        Log To Console    MAC address validation skipped
    END

prj.sut.com.Validate MAC Address
    [Documentation]    Validates the MAC address in the Nmap output.
    [Arguments]    ${nmap_output}    ${expected_mac}

    ${mac_found}=    Run Keyword And Return Status    Should Contain    ${nmap_output}    ${expected_mac}

    IF    ${mac_found}
        Log To Console     MAC Address Found: ${expected_mac}
    ELSE
        Log To Console     MAC Address Not Found: ${expected_mac}
    END

    Run Keyword And Continue On Failure    Should Be True    ${mac_found}
    ...    msg=Expected MAC address "${expected_mac}" not found in Nmap output

prj.sut.com.Countdown Timer
    [Documentation]   Decrements the sleep counter.
    [Arguments]    ${seconds}
    ${countdown_seconds}=    Convert To Integer    ${seconds}
    FOR    ${i}    IN RANGE    ${countdown_seconds}    0    -1
        Log    Waiting: ${i} seconds
        Sleep    1s
    END
    Log    Waiting: 0 seconds - Done

prj.sut.com.Start iPerf Server on PC
    [Documentation]    Starts the iPerf3 server on the host computer and validates the transfer speed.
    # Start iPerf3 server and capture output (will run until client connects and completes test)
    Close All Connections
    Start Process    iperf3    -s    -6    alias=iperf_server
    Sleep    3s
    Open Connection   FD53:7CB8:0383:0016:0000:0000:0001:0268    None    22
    Login    ${sut.com.USERNAME}    password=${EMPTY}    allow_agent=${True}
    Log To Console    Connection is successful
    Get connection
    Write    iperf3 -c FD53:7CB8:0383:0016:0000:0000:0001:0267 -t 60 -i 5
    ${output}=    Read
    Log    iPerf3 Client Result:\n${output}
    Close Connection
    # Get server results
    ${server}=    Wait For Process    iperf_server
    Log    iPerf3 Server Result:\n${server.stdout}

    # Basic validation
    Should Contain    ${server.stdout}    Server listening on 5201

prj.sut.com.Start iPerf Host on QNX
    [Documentation]    Starts the iPerf3 client on the QNX host and connects to the iPerf server.
    # #Open the SSH client on the PC with following settings for (QNX)
    Open Connection   FD53:7CB8:0383:0016:0000:0000:0001:0268    None    22
    Login    root    ""    allow_agent=${True}
    Log To Console    Connection is successful
    Get connection
    Write    iperf3 -c FD53:7CB8:0383:0016:0000:0000:0001:0267 -t 60 -i 5
    ${output}=    Read
    Log to console    ${output}
    Close Connection

prj.sut.com.set Baud rate 300.channel1
    [Documentation]    Set the baud rate "300K/2M Moderate"
    # 0 = "500K/2M Conservative"
    # 1 = "300K/2M Moderate"
    # 2 = "500K/8M High Speed"
    # 3 = "1M/2M Conservative"
    # 4 = "1M/4M Standard"
    # 5 = "1M/8M High Performance"
    # 6 = "1M/5M Balanced"
    prj.sut.com.set Environment Variable  CANFDBaudrate_Channel1  1  SYSTEM  Selection

prj.sut.com.set Baud rate 300.channel2
    [Documentation]    Set the baud rate "300K/2M Moderate"
    # 0 = "500K/2M Conservative"
    # 1 = "300K/2M Moderate"
    # 2 = "500K/8M High Speed"
    # 3 = "1M/2M Conservative"
    # 4 = "1M/4M Standard"
    # 5 = "1M/8M High Performance"
    # 6 = "1M/5M Balanced"
    prj.sut.com.set Environment Variable  CANFDBaudrate_Channel2  1  SYSTEM  Selection

prj.sut.com.set Baud rate 500.channel1
    [Documentation]    Set the baud rate to 500K/2M
    # 0 = "500K/2M Conservative"
    # 1 = "300K/2M Moderate"
    # 2 = "500K/8M High Speed"
    # 3 = "1M/2M Conservative"
    # 4 = "1M/4M Standard"
    # 5 = "1M/8M High Performance"
    # 6 = "1M/5M Balanced"
    prj.sut.com.set Environment Variable  CANFDBaudrate_Channel1  0  SYSTEM  Selection

prj.sut.com.set Baud rate 500.channel2
    [Documentation]    Set the baud rate to 500K/2M
    # 0 = "500K/2M Conservative"
    # 1 = "300K/2M Moderate"
    # 2 = "500K/8M High Speed"
    # 3 = "1M/2M Conservative"
    # 4 = "1M/4M Standard"
    # 5 = "1M/8M High Performance"
    # 6 = "1M/5M Balanced"
    prj.sut.com.set Environment Variable  CANFDBaudrate_Channel2  0  SYSTEM  Selection

prj.sut.com.set Message ID Logging Active
    [Documentation]    Activate the CAN trace Logging in write window
    prj.sut.com.set Environment Variable  Message_Logging  1  SYSTEM  Activation

prj.sut.com.set Message ID Logging Deactive
    [Documentation]    Deactivate the CAN trace logging in write window
    prj.sut.com.set Environment Variable  Message_Logging  0  SYSTEM  Activation

prj.sut.com.Check Speed
    [Documentation]    To validate the speed from the output
    [Arguments]    ${output}
    ${speed_line}=    Get Lines Containing String    ${output}    sender
    ${speed_matches}=    Get Regexp Matches    ${speed_line}    (\\d+(?:\\.\\d+)?)\\s+[MG]bits/sec    1

    # Debug: Check if we found matches
    Length Should Be    ${speed_matches}    1    No speed value found in: ${speed_line}

    ${speed_num}=    Convert To Number    ${speed_matches[0]}

    # Check if Gbits or Mbits and get original unit
    ${is_gbits}=    Run Keyword And Return Status    Should Contain    ${speed_line}    Gbits/sec
    IF    ${is_gbits}
        ${speed_gbps}=    Set Variable    ${speed_num}
        ${original_unit}=    Set Variable    Gbits/sec
    ELSE
        ${speed_gbps}=    Evaluate    ${speed_num} / 1000
        ${original_unit}=    Set Variable    Mbits/sec
    END

    Should Be True    ${speed_gbps} >= 1.7    Speed too low: ${speed_num} ${original_unit} (${speed_gbps} Gbps). Required: 1.7-2.5 Gbps
    Should Be True    ${speed_gbps} <= 2.5    Speed too high: ${speed_num} ${original_unit} (${speed_gbps} Gbps). Required: 1.7-2.5 Gbps
    Log    Speed OK: ${speed_num} ${original_unit} (${speed_gbps} Gbps)

prj.sut.com.set Arbitration and Data Log to 1 channel1
    [Documentation]    Activate the CAN trace Logging in write window
    ${ack}=    bits_platform.Rbs Set Variable Value    1    SYSTEM    CANFDBaudrate_Channel1::Get    0
    Sleep    1s    Variable to set to 0
    ${ack}=    bits_platform.Rbs Set Variable Value    1    SYSTEM    CANFDBaudrate_Channel1::Get    1
    Log To Console   Environment variable Arbitration and Data value logged to 1

prj.sut.com.set Arbitration and Data Log to 0 channel1
    [Documentation]    Activate the CAN trace Logging in write window
    ${ack}=    bits_platform.Rbs Set Variable Value    1    SYSTEM    CANFDBaudrate_Channel1::Get    0
    Log To Console    Environment variable Arbitration and Data value logged to 0

prj.sut.com.set Arbitration and Data Log to 1 channel2
    [Documentation]    Activate the CAN trace Logging in write window
    ${ack}=    bits_platform.Rbs Set Variable Value    1    SYSTEM    CANFDBaudrate_Channel2::Get    0
    Sleep    1s    Variable to set to 0
    ${ack}=    bits_platform.Rbs Set Variable Value    1    SYSTEM    CANFDBaudrate_Channel2::Get    1
    Log To Console   Environment variable Arbitration and Data value logged to 1

prj.sut.com.set Arbitration and Data Log to 0 channel2
    [Documentation]    Activate the CAN trace Logging in write window
    ${ack}=    bits_platform.Rbs Set Variable Value    1    SYSTEM    CANFDBaudrate_Channel2::Get    0
    Log To Console    Environment variable Arbitration and Data value logged to 0

prj.sut.com.Connect And Test Host
    [Documentation]    Connect to host and perform basic verification
    [Arguments]    ${host}    ${host_type}

    Open Connection    ${host}    None    22
    ${login_status}=    Run Keyword And Return Status    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    IF    not ${login_status}
        Set Test Status To Fail    COM_ERROR    Failed to login to ${host_type} host
    END

    Log To Console    ${host_type} Connection successful
    Write    date
    ${output}=    Read
    Log To Console    ${output}
    Close Connection
    Sleep    1s

prj.sut.com.set Environment Variable
    [Documentation]    Set any environment variable with a given value and verify acknowledgment.
    [Arguments]    ${variable_name}    ${value}    ${system}    ${selection}
    ${ack}=    bits_platform.Rbs Set Variable Value    1    ${system}    ${variable_name}::${selection}    ${value}
    IF    not ${ack}
        Fail    Failed to set environment variable ${variable_name} to ${value} with system ${system} and selection ${selection}
    END
    Log To Console    Environment variable ${variable_name} set to ${value} successfully

# prj.sut.com.set VIN Value
#     [Documentation]    To set the VIN value with ASCII to decimal conversion
#     [Arguments]    ${vin_input}=12345678912345678
#     # Convert VIN input to individual characters and their decimal values
#     ${vin_length}=    Get Length    ${vin_input}
#     # Generate console output and set signals for each VIN position
#     FOR    ${index}    IN RANGE    1    ${vin_length + 1}
#         ${char}=    Get Substring    ${vin_input}    ${index-1}    ${index}
#         # Convert ASCII character to decimal value
#         ${decimal_value}=    Evaluate    ord('${char}')
#         # Calculate Mx value (increments every 5 positions)
#         ${mx_number}=    Evaluate    (${index} - 1) // 5
#         ${mx_value}=    Set Variable If    ${mx_number} < 10    Mx0${mx_number}    Mx${mx_number}
#         # Format console output with decimal values
#         IF    ${index} == 1
#             ${console_line}=    Set Variable    VIN_${index}_XIX_VIN_01_${mx_value}_XIX_E3V_VLAN_MPCI = ${decimal_value}
#         ELSE IF    ${index} == 2
#             ${console_line}=    Set Variable    VIN_${index}_XIX_VIN_01_${mx_value}_XIX_E3V_VLAN_MPCI = ${decimal_value}
#         ELSE
#             ${console_line}=    Set Variable    VIN_${index}_XIX_VIN_01_${mx_value}_XIX_E3V_VLAN_MPCI = ${decimal_value}
#         END
#         Log To Console    ${console_line}
#     END
#     # Set the complete VIN value in the system
#     bits_platform.Rbs Set Variable Value    1    SYSTEM     vehicle::VIN    ${vin_input}
#    Sleep    5s

prj.sut.com.set ASCII to decimal
    [Documentation]    Helper keyword to convert ASCII string to decimal values
    [Arguments]    ${ascii_string}
    ${decimal_list}=    Create List
    ${length}=    Get Length    ${ascii_string}
    FOR    ${i}    IN RANGE    ${length}
        ${char}=    Get Substring    ${ascii_string}    ${i}    ${i+1}
        ${decimal}=    Evaluate    ord('${char}')
        Append To List    ${decimal_list}    ${decimal}
    END
    RETURN    ${decimal_list}

Verify Dumper Paths
    [Documentation]    Helper keyword to verify expected paths/strings in output
    [Arguments]    ${output}    @{expected_paths}
    FOR    ${path}    IN    @{expected_paths}
        ${found}=    Run Keyword And Return Status    Should Contain    ${output}    ${path}
        IF    not ${found}
            Log    WARNING: ${path} not found    WARN
            Fail    Missing path: ${path}
        END
    END

Verify Dumper Paths1
    [Documentation]    Helper keyword to convert ASCII string to decimal values
    [Arguments]    ${output}
    @{expected_paths}    Create List    -d /var/log
    FOR    ${path}    IN    @{expected_paths}
        ${found}    Run Keyword And Return Status    Should Contain    ${output}    ${path}
        IF    not ${found}    Log    WARNING: ${path} not found    WARN
        IF    not ${found}    Fail    Missing path: ${path}
    END

Verify Dumper Paths2
    [Documentation]    Helper keyword to convert ASCII string to decimal values
    [Arguments]    ${output}
    @{expected_paths}    Create List    log
    FOR    ${path}    IN    @{expected_paths}
        ${found}    Run Keyword And Return Status    Should Contain    ${output}    ${path}
        IF    not ${found}    Log    WARNING: ${path} not found    WARN
        IF    not ${found}    Fail    Missing path: ${path}
    END

Verify Dumper Paths3
    [Documentation]    Helper keyword to convert ASCII string to decimal values
    [Arguments]    ${output}
    @{expected_paths}    Create List    ./mnt/usr/sbin/tcpdump
    FOR    ${path}    IN    @{expected_paths}
        ${found}    Run Keyword And Return Status    Should Contain    ${output}    ${path}
        IF    not ${found}    Log    WARNING: ${path} not found    WARN
        IF    not ${found}    Fail    Missing path: ${path}
    END

Verify Dumper Paths4
    [Documentation]    Helper keyword to convert ASCII string to decimal values
    [Arguments]    ${output}
    @{expected_paths}    Create List    tcpdump -i emac0 -vvv -e -n vlan 2050
    FOR    ${path}    IN    @{expected_paths}
        ${found}    Run Keyword And Return Status    Should Contain    ${output}    ${path}
        IF    not ${found}    Log    WARNING: ${path} not found    WARN
        IF    not ${found}    Fail    Missing path: ${path}
    END

prj.sut.com.CAN bus load read
    [Documentation]    Activate the CAN trace Logging in write window
    Log To Console    Bus load value is read
    bits_platform.Rbs Set Variable Value    1    SYSTEM    Can_Statistics::BusLoad_Read    0
    Sleep    3s
    bits_platform.Rbs Set Variable Value    1    SYSTEM    Can_Statistics::BusLoad_Read    1

prj.sut.com.check CAN traces
    [Documentation]    will check the CAN Traces in the simulation
    prj.sut.com.set Message ID Logging Active
    @{pattern_list}=    Create List    OPMM_Power | ID:0x010 | DLC:7
    ...    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    Global_Health_Status_DBP | ID:0x21F | DLC:4
    ...    OPMM_Network_DBP | ID:0x017 | DLC:8
    ...    OPMM_SECURITY | ID:0x014 | DLC:7
    prj.sut.com.Countdown Timer    10
    prj.sut.com.set Message ID Logging Deactive
    ${Canoe_txt}=    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}
    END

prj.sut.com.Validate BusLoad
    [Documentation]    Universal bus load validation with operator
    [Arguments]    ${trace_data}    ${operator}    ${threshold}

    @{lines}=    Split To Lines    ${trace_data}
    ${validation_passed}=    Set Variable    ${True}
    ${found_data}=    Set Variable    ${False}

    FOR    ${line}    IN    @{lines}
        ${has_busload}=    Run Keyword And Return Status    Should Contain    ${line}    BusLoad
        IF    not ${has_busload}    CONTINUE

        ${found_data}=    Set Variable    ${True}
        @{channels}=    Get Regexp Matches    ${line}    (CAN\\d+)
        @{values}=    Get Regexp Matches    ${line}    BusLoad:\\s*([\\d.]+)
        IF    not ${channels} or not ${values}    CONTINUE

        ${channel}=    Set Variable    ${channels}[0]
        ${value}=    Convert To Number    ${values}[0]

        # Evaluate condition
        ${condition_met}=    Evaluate    ${value} ${operator} ${threshold}

        IF    ${condition_met}
            Log To Console    ${channel}: ${value}% ${operator} ${threshold}% (Pass)
        ELSE
            Log To Console    ${channel}: ${value}% does NOT satisfy ${operator} ${threshold}% (Fail)
            ${validation_passed}=    Set Variable    ${False}
        END
    END

    # Check results
    IF    not ${found_data}
        Set Test Status To Fail    error_type=COM_ERROR    info_text=No bus load data found
    ELSE IF    not ${validation_passed}
        Set Test Status To Fail    error_type=COM_ERROR    
        ...    info_text=Bus load validation failed: expected ${operator} ${threshold}%
    END

prj.sut.com.Ethernet Switch Flashing
    [Documentation]    Flash the Ethernet switch with the latest firmware and verify successful update.
    [Arguments]    ${binary_dir}    ${binary_file}    ${provision_image}=${False}

    # Build paths from arguments
    ${tool_path}=    Set Variable    ${binary_dir}\\DownloadImage_v2.exe
    ${binary_path}=    Set Variable    ${binary_dir}\\${binary_file}

    # Use OperatingSystem library explicitly for local file checks
    OperatingSystem.File Should Exist    ${tool_path}
    OperatingSystem.File Should Exist    ${binary_path}

    Log    Tool Path: ${tool_path}    console=True
    Log    Binary Path: ${binary_path}    console=True

    # Set flashing configuration
    ethswitch.Set Flashing Tool Path    ${tool_path}
    ethswitch.Set Flashing Port         ethernet
    ethswitch.Set Flashing Interface    cmdprompt

    # Perform flashing
    ${status}=    ethswitch.Flash Image    ${binary_path}    5

    Log    Flash Status: ${status}    console=True
    Should Be True    ${status}    Ethernet switch flashing failed