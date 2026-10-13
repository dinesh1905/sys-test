*** Settings ***
Documentation       Test suite containing test cases for Communication Subsystem of the MaaS Blade.
Metadata            testtype    FULLTEST
Metadata            testarea    COMMUNICATION
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults

Resource            ${TAF_PATH}/import.resource
Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager
Library             ${TAF_PATH}/project/test/suites/com/Canoe_BITS.py


# Test Automation Framework
Suite Setup         setups.Set Up Test Suite
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case


*** Variables ***
${COUNTERPLUS1}        1


*** Test Cases ***
EnvD_SysQual_Communication_ETHNetwork_IPV4&IPV6support
    [Documentation]    The Ethernet subsystem shall support the definition of virtual LANs (VLANs)
    ...    according to IEEE 802.1Q
    [Tags]    COMMUNICATION    FID-1337817,1337819,1337731  TCID-427039    FULLTEST   Comunication_tag
    # Perform the ping test
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_qnx_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_mcu_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_linux_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_android_ipv6}
    sleep    2s

EnvD_SysQual_Communication_Firewall_Scan-LinuxGVM-OpenPort
    [Documentation]    The firewalls shall be configured such that a separation of domains (internet, vehicle,
    ...    external blades, SoC subsystem, Microcontrollersubsystem and etc) is assured and unused ports are closed
    [Tags]    COMMUNICATION    FID-1338726,1338728    TCID-377015    FULLTEST    Communication_tag
    # Perform the Ping test and firewall scan on Linux to validate the results
    prj.sut.com.Perform Firewall Scan
    ...    ${sut.com.expected_linux_ipv6}    ${sut.com.expected_linux_ports}
    ...    ${sut.com.expected_linux_mac}    -p- --open    CLOSED

EnvD_SysQual_Communication_Firewall_Scan-QNXOpenPort
    [Documentation]    This Test is to perform Firewall Scan for QNX GVM.The firewalls shall be configured such
    ...    that a separation of domains (internet, vehicle,
    ...    external blades, SoC subsystem, Microcontrollersubsystem and etc)
    ...    is assured and unused ports are closed
    [Tags]    COMMUNICATION    FID-1338726,1338728    TCID-377014    FULLTEST
    # Perform the Ping test and firewall scan on QNX to validate the results
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_qnx_ipv6}
    ...    ${sut.com.expected_qnx_ports}    ${sut.com.expected_qnx_mac}
    ...    -p- --open    OPEN

EnvD_SysQual_Communication_Firewall_Scan- MCU-OpenPort
    [Documentation]    This Test is to perform Firewall Scan for MCU GVM.The firewalls shall be configured such
    ...    that a separation of domains (internet, vehicle,
    ...    external blades, SoC subsystem, Microcontrollersubsystem and etc)
    ...    is assured and unused ports are closed
    [Tags]    COMMUNICATION    FID-1338726,1338728    TCID-377012    FULLTEST
    # Perform the Ping test and firewall scan on MCU to validate the results
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_mcu_ipv6}
    ...    ${sut.com.expected_mcu_ports}    ${sut.com.expected_mcu_mac}    -p- --open    OPEN

EnvD_SysQual_Communication_Firewall_Scan- Android-OpenPort
    [Documentation]    This Test is to perform Firewall Scan for Android GVM.The firewalls shall be configured such
    ...    that a separation of domains (internet, vehicle,
    ...    external blades, SoC subsystem, Microcontrollersubsystem and etc)
    ...    is assured and unused ports are closed
    [Tags]    COMMUNICATION    FID-1338726,1338728    TCID-377013    FULLTEST
    # Once the device is powered on , Need to wait 40sec for stabilization
    # Perform the Ping test and firewall scan on Android to validate the results
    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_android_ipv6}
    ...    ${sut.com.expected_android_ports}    ${sut.com.expected_android_mac}    -p- --open    OPEN

EnvD_SysQual_Communication_ETHNetwork_SecureCheck02
    [Documentation]    This Test is to perform Penetration Scan for QNX GVM.
    ...    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1337822,1338677,1453798,1338725,1338724    TCID-427051    FULLTEST
    # Perform the Penetration test on QNX to validate the results
    prj.sut.com.Run Nmap Scan    ${sut.com.expected_qnx_ipv6}
    ...    []    ${sut.com.expected_qnx_mac}    -sX    SKIP

EnvD_SysQual_Communication_ETHNetwork_DOIPActivation- Positive
    [Documentation]    This Test is to validate the DOIP activation for the Ethernet network.
    ...                The system may support DoIP activation via dedicated 'Activation Line' but can also
    ...                 activate the DoIP
    ...                 stack based on other events. (e.g.interface status changes from operation system)
    [Tags]    COMMUNICATION    FID-1338690    TCID-427043    FULLTEST

    prj.sut.power cycle
    Sleep    40s
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}

EnvD_SysQual_Communication_ETHNetwork_SecureCheck03
    [Documentation]    This Test is to perform Penetration Scan for Linux GVM.
    ...    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1338677,1337822,1338724,1338725,1453798     TCID-427050    FULLTEST
    # Once the device is powered on , Need to wait 40sec for stabilization
    prj.sut.com.Countdown Timer    40
    # Perform the Penetration test on QNX to validate the results
    prj.sut.com.Run Nmap Scan    ${sut.com.expected_linux_ipv6}
    ...     ${sut.com.expected_linux_ports_Xmas_scan}    ${sut.com.expected_linux_mac}    -sX -6 -Pn -v    SKIP

EnvD_SysQual_Communication_ETHNetwork_SecureCheck04
    [Documentation]    This Test is to perform Penetration Scan for Android GVM
    ...    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1338677,1337822,1338724,1338725,1453798    TCID-427045    FULLTEST
    # Perform the Penetration test on Android to validate the results
    prj.sut.com.Run Nmap Scan    ${sut.com.expected_android_ipv6}
    ...    ${sut.com.expected_android_ports_Xmas_scan}
    ...    ${sut.com.expected_android_mac}    -sX -6 -Pn -v    SKIP

EnvD_SysQual_Communication_ETHNetwork_SecureCheck05
    [Documentation]    This Test is to perform Penetration Scan for MCU.
    ...    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1338677,1337822,1338724,1338725,1453798    TCID-427044    FULLTEST
    # Perform the Penetration test on MCU to validate the results
    prj.sut.com.Run Nmap Scan    2405:201:e029:e82d:fafe:5eff:fe4c:5603
    ...    []    ${sut.com.expected_mcu_mac}    -sX -6 -Pn -v    SKIP

EnvD_SysQual_Communication_ETHNetwork_COMinterface
    [Documentation]    This Test is to perform the check  for
    ...                Ethernet communication interface to external debug subsystem
    [Tags]    COMMUNICATION    FID-1337801    TCID-427046         FULLTEST

    Log To Console    Connect 100BaseT cable from VN5620 to device's Debug Adapter.
    # Perform the ping test
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_qnx_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_mcu_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_linux_ipv6}
    sleep    2s
    Run Keyword And Continue On Failure     prj.sut.com.Run Ping Test    ${sut.com.expected_android_ipv6}
    sleep    2s

EnvD_SysQual_Communication_DoIPCommunication_SessionControlSendReceive
    [Documentation]    The system shall support DoIP communication according to standard ISO 13400-2
    [Tags]    COMMUNICATION    FID-1338689    TCID-427070    FULLTEST
    prj.sut.power cycle
    Sleep    40s
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Extended_Session_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Extended_Session_Resp}

EnvD_SysQual_Communication_ETHNetwork_disable_external_debug
    [Documentation]    The Ethernet subsystem shall ensure the connection to external debug subsystem
    ...    must be disable after start of production
    [Tags]    COMMUNICATION    FID-1338704    TCID-437829    FULLTEST
    # Perform the Ping test and firewall scan on Linux to validate the results
    Run Keyword And Continue On Failure    prj.sut.com.Perform Firewall Scan
    ...    ${sut.com.expected_linux_ipv6}    ${sut.com.expected_linux_ports}
    ...    ${sut.com.expected_linux_mac}    -p- --open    CLOSED
    # Perform the Ping test and firewall scan on QNX to validate the results
    Run Keyword And Continue On Failure    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_qnx_ipv6}
    ...    ${sut.com.expected_qnx_ports}    ${sut.com.expected_qnx_mac}
    ...    -p- --open    OPEN
    # Perform the Ping test and firewall scan on MCU to validate the results
    Run Keyword And Continue On Failure    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_mcu_ipv6}
    ...    ${sut.com.expected_mcu_ports}    ${sut.com.expected_mcu_mac}    -p- --open    OPEN
    Run Keyword And Continue On Failure    prj.sut.com.Perform Firewall Scan     ${sut.com.expected_android_ipv6}
    ...    ${sut.com.expected_android_ports}    ${sut.com.expected_android_mac}    -p- --open    OPEN


EnvD_SysQual_Communication_ETHNetwork_TCP/IP-support
    [Documentation]    The Ethernet subsystem shall support TCP/IP (TCP & UDP).
    [Tags]    COMMUNICATION    FID-1338718    TCID-427042    FULLTEST    Comunication_tag
    Close All Connections

    # Test QNX Host
    prj.sut.com.Connect And Test Host    ${sut.com.QNX_HOST}    QNX

    # Test LINUX Host
    prj.sut.com.Connect And Test Host    ${sut.com.LINUX_HOST}    LINUX

EnvD_SysQual_Communication_Ethernet_Speed
    [Documentation]    . 2.5 GB Ethernet switch is used for Ethernet network communication.
    ...    Ethernet subsystem shall support automotive Ethernet test defined by Open Alliance
    [Tags]    COMMUNICATION    FID-1338716,1039406    TCID-539197    FULLTEST    ${COMMUNICATION_TAG}
    # Perform the Ping test and firewall scan on QNX to validate the results
    # Start iPerf3 server
    Start Process    iperf3    -s    -6    alias=iperf_server
    Sleep    3s
    # Connect and run client
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -c FD53:7CB8:0383:0016:0000:0000:0001:0271 -t 60 -i 5
    prj.sut.com.Countdown Timer    100
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    Run Keyword And Ignore Error   prj.sut.com.Check Speed    ${output}
    Close Connection
    Terminate Process    iperf_server

    # Start iPerf3 server
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    ${result}    Run Process    cmd    /c    iperf3 -c FD53:7CB8:0383:0016:0000:0000:0001:0268 -t 60 -i 5
    ...    shell=True    timeout=200s
    Log To Console    Return Code: ${result.rc}
    Log To Console    STDOUT:\n${result.stdout}
    Log To Console    STDERR:\n${result.stderr}
    prj.sut.com.Check Speed     ${result.stdout}
    Close All Connections

EnvD_SysQual_Communication_CANSubsystem_ConfigurableCANbaudrate   # Testcase is updated
    [Documentation]    The baudrate of each CAN bus shall be individually configurable
    ...    via a software parameter to the pre-defined speeds.
    [Tags]    COMMUNICATION    FID-1338744,1339498    TCID-427028    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.set Message ID Logging Active
    sleep    20s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen
    prj.sut.com.set Baud rate 300.channel1
    prj.sut.com.set Baud rate 300.channel2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    'CAN 1 : Message with ID' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    CAN 1 : Message with ID is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=CAN 1 : Message with ID is not found in CAN data
        END
    END
    Log To Console    Error message is seen
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.set Message ID Logging Active
    sleep    6s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen

EnvD_SysQual_Communication_CANSubsystem_CANbaudrate
    [Documentation]    The CAN subsystem shall support the baudrate of as specified
    ...    in 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6 Chapter 3.2 CAN-Controller.
    [Tags]    COMMUNICATION    FID-1338744,1339489    TCID-427033    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    # Configuring the baud rate
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
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen

EnvD_SysQual_Communication_CANSubsystem_CANbaudrateCANFD
    [Documentation]    The baudrate of each CAN bus shall be individually configurable
    ...    via a software parameter to the pre-defined speeds.
    [Tags]    COMMUNICATION    FID-1338744,1339491    TCID-427034    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.set Message ID Logging Active
    sleep    6s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen
    prj.sut.com.set Baud rate 300.channel1
    prj.sut.com.set Baud rate 300.channel2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    'CAN 1 : Message with ID' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    CAN 1 : Message with ID is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=CAN 1 : Message with ID is not found in CAN data
        END
    END
    Log To Console    Error message is seen
    prj.sut.com.set Baud rate 500.channel1
    prj.sut.com.set Baud rate 500.channel2
    prj.sut.com.set Message ID Logging Active
    sleep    6s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    Vehicle CAN Data is seen

EnvD_SysQual_Communication_CANSubsystem_CANFD_abitrary_bitrate
    [Documentation]    The arbitration bitrate should be configurable for CANFD channels as per NIP File
    [Tags]    COMMUNICATION    FID-1340694    TCID-437648    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Baud rate 500.channel1
    sleep    2s
    prj.sut.com.set Arbitration and Data Log to 1 channel1
    prj.sut.com.set Arbitration and Data Log to 0 channel1
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END
    prj.sut.com.set Arbitration and Data Log to 1 channel2
    prj.sut.com.set Arbitration and Data Log to 0 channel2
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END
    Log To Console    Arbitration bitrate logged

EnvD_SysQual_Communication_CANSubsystem_CANFD_abitrary_bitrate_data_phase_bitrate
    [Documentation]    The arbitration & data phase bitrate should be configurable for CANFD channels as per NIP File
    [Tags]    COMMUNICATION    FID-1340696    TCID-437651    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Baud rate 500.channel1
    sleep    2s
    prj.sut.com.set Arbitration and Data Log to 1 channel1
    prj.sut.com.set Arbitration and Data Log to 0 channel1
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    ...    Data settings: baud= 2000000.000000, tseg1 = 15, tseg2= 4, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END
    prj.sut.com.set Arbitration and Data Log to 1 channel2
    prj.sut.com.set Arbitration and Data Log to 0 channel2
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    ...    Data settings: baud= 2000000.000000, tseg1 = 15, tseg2= 4, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END

EnvD_SysQual_Communication_CANSubsystem_CANFD_data_phase_bitrate
    [Documentation]    The data phase bitrate should be configurable for CANFD channels as per NIP File
    [Tags]    COMMUNICATION    FID-1340695    TCID-437652    FULLTEST    Communication_tag
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Baud rate 500.channel1
    sleep    2s
    prj.sut.com.set Arbitration and Data Log to 1 channel1
    prj.sut.com.set Arbitration and Data Log to 0 channel1
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END
    prj.sut.com.set Arbitration and Data Log to 1 channel2
    prj.sut.com.set Arbitration and Data Log to 0 channel2
    @{pattern_list}    Create List    Arbitration settings: baud= 500000.000000, tseg1 = 63, tseg2= 16, sjw = 2
    prj.sut.com.Countdown Timer    5
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    Checking if pattern "${index}" exists in CANoe log
        ${contains}    Evaluate    '''${index}''' in '''${Canoe_txt}'''
        IF    not ${contains}
            Set Test Status To Fail    error_type=COM_ERROR    info_text=Pattern "${index}" not found in CANoe log
        ELSE
            Log To Console    Pattern "${index}" found in CANoe log
        END
    END
    Log To Console    Arbitration bitrate logged

EnvD_SysQual_Communication_CANSubsystem_CANFD_maximum_payload
    [Documentation]    The CAN Subsystem shall
    ...    support maximum bytes of payload in CANFD communication as per NIP file
    [Tags]    COMMUNICATION    FID-1340692    TCID-437646    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    prj.sut.com.set Message ID Logging Active
    @{pattern_list}    Create List    OperatingMode_DRB | ID:0x01D | DLC:7
    ...   OPMM_Network_DBS | ID:0x016 | DLC:8
    ...   OPMM_Power | ID:0x010 | DLC:7
    ...   OPMM_ASW_KeepAwake_Req_Main | ID:0x103 | DLC:8
    ...   OPMM_MAIN | ID:0x013 | DLC:8
    ...   Global_Health_Status_DBS | ID:0x220 | DLC:4
    ...   OPMM_Network_DBP | ID:0x017 | DLC:8
    ...   GlobalAliveness_DBS | ID:0x223 | DLC:3
    prj.sut.com.Countdown Timer    30
    prj.sut.com.set Message ID Logging Deactive
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        Should Contain    ${Canoe_txt}    ${index}
    END
    Log To Console    CAN messages are seen   and DLC is verified

EnvD_SysQual_Communication_CANSubsystem_CAN_messages
    [Documentation]    Ensure the CAN SW stack shall provide an interface to send and receive direct CAN messages from /
    ...    to application.
    [Tags]    COMMUNICATION    FID-1340707,1340709,1340706    TCID-437644    FULLTEST
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
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
    Log To Console    Vehicle CAN data is seen

EnvD_SysQual_Communication_ETHNetwork_DOIPActivation-Negative
    [Documentation]    This Test is to validate the DOIP activation for the Ethernet network.
    ...                The system may support DoIP activation via dedicated 'Activation Line' but can also
    ...                 activate the DoIP
    ...                 stack based on other events. (e.g.interface status changes from operation system)
    [Tags]    COMMUNICATION    FID-1338690    TCID-427049    FULLTEST
 
    prj.sut.connect.dlt
    prj.sut.power cycle
    Sleep    60s
    prj.sut.can.diag.tester.present.active
    Sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}
    sleep    5s
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    ON
    sleep    10s
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    sleep    20s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline   EthMgmtLinkDownCounter:
    IF  ${Status}
        Log To Console    DLT keyword is matched
        Log To Console    Ethernet link is down
    ELSE
        Log To Console    DLT keyword not matched
        Log To Console    Ethernet link is Down
        Close All Connections
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        prj.sut.power cycle
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet link is Down.DLT keyword not matched
    END
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
    sleep    10s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline  EthMgmt_Trace_EthMgmt_vGetLinkStateCyclic: 0 1 2
 
    IF    ${Status}
        Log To Console    DLT keyword is matched
        Log To Console    Ethernet link is Up
    ELSE
        Log To Console    DLT keyword not matched
        Log To Console    Ethernet link is Down
        Close All Connections
        prj.sut.power cycle
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet link is Down.DLT keyword not matched
    END
 
EnvD_SysQual_Communication_ETHNetwork_InterfacetoSoC-Negative
    [Documentation]    Connection interface to SoC subsystem
    [Tags]    COMMUNICATION    FID-1338698  TCID-427036    FULLTEST   Comunication_tag
 
    # Perform the DoIP cable disconnection/Malfunction
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    ON
    prj.sut.com.Countdown Timer    5
    # Sleep    5s
    ${status}    Run Keyword And Return Status   prj.sut.com.Run Ping Test    ${sut.com.expected_qnx_ipv6}
    Log    Status: ${status}
    Should Be Equal    ${status}    ${False}
    ...    msg=Expected failure but ping succeeded!
    sleep    2s
    # ${status}    Run Keyword And Return Status   prj.sut.com.Run Ping Test    ${sut.com.expected_mcu_ipv6}
    # Log    Status: ${status}
    # Should Be Equal    ${status}    ${False}
    # ...    msg=Expected failure but ping succeeded!
    sleep    2s
    ${status}    Run Keyword And Return Status   prj.sut.com.Run Ping Test    ${sut.com.expected_linux_ipv6}
    Log    Status: ${status}
    Should Be Equal    ${status}    ${False}
    ...    msg=Expected failure but ping succeeded!
    sleep    2s
    ${status}    Run Keyword And Return Status   prj.sut.com.Run Ping Test    ${sut.com.expected_android_ipv6}
    Log    Status: ${status}
    Should Be Equal    ${status}    ${False}
    ...    msg=Expected failure but ping succeeded!
    sleep    2s
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
    prj.sut.com.Countdown Timer    5

EnvD_SysQual_Communication_FaultDetection_OpenLine
    [Documentation]    Connection interface to SoC subsystem
    [Tags]    COMMUNICATION    FID-1338731  TCID-427068    FULLTEST   Comunication_tag

    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    ON
    prj.sut.com.Countdown Timer    10
    ${Status}    Run Keyword And Return Status    Verify DLT keyword    EthMgmtLinkDownCounter:
    sleep    10s
    IF  ${Status}
        Log To Console    DLT keyword is matched
        Log To Console    Ethernet link is Down
    ELSE
        Log To Console    DLT keyword not matched
        Log To Console    Ethernet link is Down
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        prj.sut.power cycle
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet link is Down.DLT keyword not matched
    END
    bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
    sleep    10s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline  EthMgmt_Trace_EthMgmt_vGetLinkStateCyclic: 0 1 2
    IF    ${Status}
        Log To Console    DLT keyword is matched
        Log To Console    Ethernet link is Up
    ELSE
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        Log To Console    DLT keyword not matched
        Log To Console    Ethernet link is Down
        prj.sut.power cycle
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet link is Down.DLT keyword not matched
    END

EnvD_SysQual_Communication_ETHNetwork_Max500msStartup
    [Documentation]    The Ethernet subsystem must be active and running 300ms after system gets started up
    [Tags]    COMMUNICATION    FID-1337820    TCID-427035    FULLTEST   Comunication_tag
#   Read the current bus load
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    10s
    prj.sut.can.simulation.PowerBladeOFF
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Battery    12
    bits_platform.Output Set Analog Signal Value    Ignition    12
    ${ack}    bits_platform.rbs start test    1    TestEnvironment    Testcase1
    Should Be True    ${ack}
 
    ${verdict_ack}    ${verdict}    ${event_data}    Canoe_BITS.rbs wait for test verdict    unit=1    timeout=300
   
    # Log the results
    Log    Verdict ACK: ${verdict_ack}    console=True
    Log    Verdict: ${verdict}    console=True
    Log    Event Data: ${event_data}    console=True
   
    Should Be True    ${verdict_ack}    msg=Failed to receive test verdict
 
    IF    '${verdict}' == 'PASS'
        Log    CANoe test PASSED    level=INFO
    ELSE IF    '${verdict}' == 'FAIL'
        Log    CANoe test FAILED    level=ERROR
        Log    Event Data: ${event_data}    level=ERROR
        Fail    CANoe test execution failed
    ELSE IF    '${verdict}' == 'TIMEOUT'
        Log    Test verdict TIMEOUT    level=WARN
        Fail    Test did not complete within timeout period
    ELSE
        Log    Unexpected verdict: ${verdict}    level=ERROR
        Fail    Unexpected test verdict received
    END

EnvD_SysQual_Communication_CANSubsystem_CANBusLoad
    [Documentation]    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    ...    .CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6
    ...    but refer to Communication Value Stream on therequirements deviation list
    ...    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    [Tags]    COMMUNICATION    FID-1339503,1338744,1339501    TCID-427032    FULLTEST   Comunication_tag
#   Read the current bus load
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    Sleep    10s
    prj.sut.com.set Environment Variable    Can_Statistics    1    SYSTEM    BusLoad_Read
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    Can_Statistics    0    SYSTEM    BusLoad_Read

    ${Canoe_txt}=    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}

    # Validate: Less than 50%
    prj.sut.com.Validate BusLoad    ${Canoe_txt}    operator=<    threshold=50.0

#   SCENARIO 2: High Load Test (Bus Load > 60%)
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    Sleep    10s
    prj.sut.com.set Environment Variable    TxCtrl    1    SYSTEM    Start_3ms
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    TxCtrl    0    SYSTEM    Start_3ms
    prj.sut.com.set Environment Variable    Can_Statistics    1    SYSTEM    BusLoad_Read
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    Can_Statistics    0    SYSTEM    BusLoad_Read

    ${Canoe_txt}=    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}

    # Validate: Less than 50%
    prj.sut.com.Validate BusLoad    ${Canoe_txt}    operator=>    threshold=60.0

# # SCENARIO 3: Stress Test (Bus Load > 80%)
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.power cycle
    Sleep    10s
    prj.sut.com.set Environment Variable    TxCtrl    1    SYSTEM    Start_2ms
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    TxCtrl    0    SYSTEM    Start_2ms
    prj.sut.com.set Environment Variable    Can_Statistics    1    SYSTEM    BusLoad_Read
    prj.sut.com.Countdown Timer    5
    prj.sut.com.set Environment Variable    Can_Statistics    0    SYSTEM    BusLoad_Read

    ${Canoe_txt}=    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}

    # Validate: Less than 50%
    prj.sut.com.Validate BusLoad    ${Canoe_txt}    operator=>    threshold=80.0

EnvD_SysQual_Communication_ETHSwitch_Bank_Size_Sufficient_For_Flashing
    [Documentation]    The external flash connected to Ethernet switch shall have sufficient flash size to contain primary
    ...    and secondary Ethernet switch firmware and switch configuration image.
    [Tags]    COMMUNICATION    FID-1338705    TCID-435331    FULLTEST   Comunication_tag
    prj.sut.connect.dlt
    ${Status}    Run Keyword And Return Status    prj.sut.com.Ethernet Switch Flashing
    ...    ${sut.com.ETH_Path}    88Q5152_flash_devSigned.bin
    IF    ${Status}
        Log To Console    Ethernet Flashing is successful , Partition 1 and Partition 2 are successfully flashed
    ELSE
        Log To Console    Ethernet Flashing is unsuccessful
    END
    prj.sut.power cycle
    Sleep    20
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.com.ETH_Switch_Version}
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet sw version is not updated
    END
 
EnvD_SysQual_Communication_ETHNetwork_Diagnostic_EthernetSwitchFlashing_RMUPort
    [Documentation]    The Automotive Ethernet switch software execution shall boot and operate from external QSPI flash
    [Tags]    COMMUNICATION    FID-1338687,1338716    TCID-435332    FULLTEST   Comunication_tag    
    prj.sut.connect.dlt
    ${Status}    Run Keyword And Return Status    prj.sut.com.Ethernet Switch Flashing
    ...    ${sut.com.ETH_Path}    88Q5152_flash_devSigned.bin
    IF    ${Status}
        Log To Console    Ethernet Flashing is successful , Partition 1 and Partition 2 are successfully flashed
    ELSE
        Log To Console    Ethernet Flashing is unsuccessful
    END
    prj.sut.power cycle
    Sleep    20
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    ${sut.com.ETH_Switch_Version}
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet sw version is not updated
    END
 
EnvD_SysQual_SW_Programming_MaaSBlade_Lumclient_Startup
    [Documentation]    The MaaS Blade shall startup it's LUM client automatically after bootup
    [Tags]    COMMUNICATION    FID-4513039    TCID-    FULLTEST   Comunication_tag    
    Close All Connections
    prj.sut.connect.dlt
    # prj.sut.power cycle
    # sleep    5s
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    pidin ar| grep -i lumClient
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    rbLumClientBswAdaptorMaas /mnt/etc/lum_clientbsw_adapter/LumClientConfigMaasQnxBlade.txt
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    version is successfully verified
    Close All Connections


EnvD_SysQual_Communication_ETHNetwork_FixedIP_Errorentry
    [Documentation]    If an application tries to change the IP address in its corresponding operating system environment,
    ...    theEcosystem Network shall indicate such intrusion attempts via error memory entry,
    ...    while the number of attempts shall be registered via the event manager.
    [Tags]    COMMUNICATION    FID-4662487  TCID-569467    FULLTEST   Comunication_tag
    # Perform the ping test
    Close All Connections
    prj.sut.connect.dlt
    prj.sut.connect.QNX
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    ifconfig vdev-1
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    inet6 fd53:7cb8:383:18::1:268 prefixlen 64
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    IP is successfully verified
    # Change the ip address and do the ping test again
    write    ifconfig vdev-1 inet6 fd53:7cb8:383:18::1:700
    write    ifconfig vdev-1 inet6 fd53:7cb8:383:18::1:700
    write    ifconfig vdev-1 inet6 fd53:7cb8:383:18::1:700
    write    ifconfig vdev-1 inet6 fd53:7cb8:383:18::1:700
    write    slog2info -v | grep -i networkmanager
    sleep    10s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    [WARNING] [InterfaceMonitor::compareIpLists] IP ADDRESS change detected in vdev-1 from fd53:7cb8:383:18::1:700 to fd53:7cb8:383:18::1:268
    Verify Dumper Paths    ${output}    @{expected_paths}
    @{expected_paths}    Create List    [INFO] [InterfaceMonitor::resetIpList] Removed extra IPv6 fd53:7cb8:383:18::1:700 from vdev-1
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    ifconfig vdev-1
    sleep    5s
    ${output}    Read
    
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    inet6 fd53:7cb8:383:18::1:700
    FOR    ${path}    IN    @{expected_paths}
        ${found}    Run Keyword And Return Status    Should Contain    ${output}    ${path}
        IF    not ${found}
            Log To Console    Expected path "${path}" not found in output. The IP is automatically reset
        END
    END

EnvD_SysQual_Communication_ETHNetwork_Prioritisation
    [Documentation]    The Ecosystem Network should support prioritization stateful protocol communication based connections.
    [Tags]    COMMUNICATION    FID-4967719  TCID-539191    FULLTEST   Comunication_tag
    # Perform the ping test
    Close All Connections
    prj.sut.connect.dlt
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    tcpdump -i vdev-1 -vvv -n net fd53:7cb8:383:18::/64
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    IP6 (class 0x48, flowlabel
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    IP Header is successfully verified


EnvD_SysQual_Communication_ETHNetwork_TCP/IP-firewall
    [Documentation]    The system shall support TCP/IP (TCP & UDP) message firewalling
    [Tags]    COMMUNICATION    FID-1338677    TCID-427048    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.QNX
    prj.sut.power cycle
    Sleep    60s
    ${Status}    Run Keyword And Return Status    Verify QNX keyword    pf enabled    command=pfctl -e
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END
    ${Status}    Run Keyword And Return Status    Verify QNX keyword with long timout    packets captured    command=tcpdump -i pflog0 -vvvv & PID=$! ; sleep 60 ; kill -INT $PID
    sleep    5s
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

    ${Status}    Run Keyword And Return Status    Verify QNX keyword    pf disabled    command=pfctl -d
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END
    ${Status}    Run Keyword And Return Status    Verify QNX keyword with long timout    packets captured    command=tcpdump -i pflog0 -vvvv & PID=$! ; sleep 60 ; kill -INT $PID
    sleep    5s
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Close All Connections
        Log To Console    QNX command Successfully.
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

EnvD_SysQual_Communication_CANSubsystem_CANBuss_ShorttoUbat
    [Documentation]    CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6
    ...    but refer to Communication Value Stream on the requirements deviation list. All CAN busses of the system shall
    ...    be protected against short to Ubat up to the defined range as specified in VW80000.
    ...    The CAN subsystem shall detect CAN bus off conditions for all CAN interfaces.
    [Tags]    COMMUNICATION    FID-1338744,1339777,1340688  TCID-427026    FULLTEST   Comunication_tag

    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.com.Countdown Timer    5
    prj.sut.can.simulation.PowerBladeON
    Sleep    6s
    prj.sut.can.diag.tester.present.active
    Sleep    10s
    # Inject fault - Turn ON CAN1_Short_High_Gnd
    bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_Vbat    ON
    Sleep    3s
    # Check DTC with fault present - expecting C1 05 0F 2F
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    3s
    ${fault_active_status}    Run Keyword And Return Status
    ...    prj.sut.diag.checkbyte    C1 05 0F 2F
    IF    not ${fault_active_status}
        Log To Console    ERROR: C1 05 0F 2F not found with fault active
        bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_Vbat    OFF
        prj.sut.can.initandloadconfiguration
        prj.sut.can.simulation.Start
        prj.sut.can.simulation.PowerBladeON
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2F not detected with fault active
    END
    # Only continue if fault was detected
    IF    ${fault_active_status}
        Log To Console    C1 05 0F 2F detected with fault active
        # Remove fault - Turn OFF CAN1_Short_High_Gnd
        bits_platform.Output Set Digital Signal Value    CAN1_Short_Low_Vbat    OFF
        Sleep    3s
        # Check DTC with fault removed - expecting C1 05 0F 2E
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
        Sleep    3s
        ${fault_inactive_status}    Run Keyword And Return Status
        ...    prj.sut.diag.checkbyte    C1 05 0F 2E
        IF    not ${fault_inactive_status}
            Log To Console    ERROR: C1 05 0F 2E not found after fault removal
            Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2E not detected after fault removal
        ELSE
            Log To Console    C1 05 0F 2E detected after fault removal
        END
    END

EnvD_SysQual_Communication_CANSubsystem_DeviceSupportsCANFD
    [Documentation]    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    ...    .CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6
    ...    but refer to Communication Value Stream on therequirements deviation list
    ...    Each CAN bus shall support CAN FD according to ISO 11898-1:2015
    [Tags]    COMMUNICATION    FID-1339503,1338744,1339501    TCID-427027    FULLTEST   Comunication_tag
    # By default simulation is configured with ISO FD
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    # sleep    6s
    prj.sut.com.set Message ID Logging Active
    sleep    10s
    prj.sut.com.set Message ID Logging Deactive
    @{pattern_list}    Create List    OPMM_OperatingMode_State_PB | ID:0x01C | DLC:6
    ...    OPMM_BSW_KeepAwake_Req_Main | ID:0x104 | DLC:8
    prj.sut.com.Countdown Timer    10
    ${Canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.CAN_Tracepath}
    FOR    ${index}    IN    @{pattern_list}
        Log To Console    ${index}
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console    CAN FD is supported

EnvD_SysQual_Communication_CANSubsystem_CANhighspeed
    [Documentation]    Each CAN bus of the system shall support Highspeed CAN 2.0 according to ISO 11898-2
    ...    CAN subsystem shall comply with VWN general CAN specification
    ...    030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE_EN_V6.6 but refer to Communication Value Stream on the requirements
    ...    deviation list
    [Tags]    COMMUNICATION    FID-1338744,1339501    TCID-427030    FULLTEST   Comunication_tag

    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    @{pattern_list}    Create List    0x146 On board CAN 1057G (Highspeed)
    prj.sut.com.Countdown Timer    10
    ${canoe_txt}    OperatingSystem.Get File    ${sut.can.driveD}:${sut.can.Hardware_Tracepath}
    ${pattern_found}    Run Keyword And Return Status
    ...    Should Contain    ${canoe_txt}    @{pattern_list}
    IF    ${pattern_found}
        Log To Console    Pattern found: 0x146 On board CAN 1057G (Highspeed)
    ELSE
        # Try with regex to handle multiple spaces
        ${regex_found}    Evaluate    bool(re.search(r'0x146\\s+On board CAN 1057G \\(Highspeed\\)', '''${canoe_txt}'''))    re
        IF    ${regex_found}
            Log To Console    Pattern found with regex: 0x146 On board CAN 1057G (Highspeed)
        ELSE
            Fail    Pattern NOT found: 0x146 On board CAN 1057G (Highspeed)
        END
    END
    Log To Console    CAN FD is supported

EnvD_SysQual_Communication_CANSubsystem_CANBuss_ShorttoGND
    [Documentation]    CAN subsystem shall comply with VWN general CAN specification 030_052_LAH DUM.857.AG_Konzern_LAH_CAN_DE
    ...    _EN_V6.6 but refer to Communication Value Stream on the requirements deviation list
    ...    All CAN busses of the system shall be protected against short to GND.

    [Tags]    COMMUNICATION    FID-1338744,1339775  TCID-427031    FULLTEST   Comunication_tag
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    # Sleep    6s
    # prj.sut.can.diag.tester.present.active
    # Sleep    10s
    # Inject fault - Turn ON CAN1_Short_High_Gnd
    bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Gnd    ON
    Sleep    3s
    # Check DTC with fault present - expecting C1 05 0F 2F
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    3s
    ${fault_active_status}    Run Keyword And Return Status
    ...    prj.sut.diag.checkbyte    C1 05 0F 2F
    IF    not ${fault_active_status}
        Log To Console    ERROR: C1 05 0F 2F not found with fault active
        bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Gnd    OFF
        prj.sut.can.initandloadconfiguration
        prj.sut.can.simulation.Start
        prj.sut.can.simulation.PowerBladeON
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2F not detected with fault active
    END
    # Only continue if fault was detected
    IF    ${fault_active_status}
        Log To Console    C1 05 0F 2F detected with fault active
        # Remove fault - Turn OFF CAN1_Short_High_Gnd
        bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Gnd    OFF
        Sleep    3s
        # Check DTC with fault removed - expecting C1 05 0F 2E
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
        Sleep    3s
        ${fault_inactive_status}    Run Keyword And Return Status
        ...    prj.sut.diag.checkbyte    C1 05 0F 2E
        IF    not ${fault_inactive_status}
            Log To Console    ERROR: C1 05 0F 2E not found after fault removal
            Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2E not detected after fault removal
        ELSE
            Log To Console    C1 05 0F 2E detected after fault removal
        END
    END

EnvD_SysQual_Communication_CANSubsystem_CAN_baaudrate
    [Documentation]    The CAN Subsystem shall configure baud rate for all CAN channels as per NIP file
    [Tags]    COMMUNICATION    FID-1340692    TCID-437647    FULLTEST
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.com.Countdown Timer    5
    # prj.sut.can.simulation.PowerBladeON
    # prj.sut.com.Countdown Timer    5
    # Configuring the baud rate
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
        ${contains}    Evaluate    '${index}' in '''${Canoe_txt}'''
        IF    ${contains}
            Log To Console    ${index} is found in CAN data
        ELSE
            Set Test Status To Fail    error_type=COM_ERROR    info_text=${index} is not found in CAN data
        END
    END
    Log To Console   CAN baud rate is verified for both the CAN1 and CAN2

EnvD_SysQual_Communication_CANSubsystem_CANInterface_back_CAN1
    [Documentation]    CAN transceiver is used for CAN network communication, 2xCANFD in backplane is use for inter blades communication on rack ,
    ...    2 xCANFD is used for future CAN communication with other ECUs on vehicle
    ...    The system shall support DoIP communication via UDS according to ISO 14229-2:2013 to be used by SW applications.
    ...    2xCAN bus interface to back connector
    ...    The system shall equipped with CAN subsystem with below interface:-
    [Tags]    COMMUNICATION    FID-1039407,1340712,1338745,1338743    TCID-435334    FULLTEST
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.can.simulation.PowerBladeON
    # prj.sut.com.Countdown Timer    10
    # prj.sut.can.diag.tester.present.active
    # prj.sut.com.Countdown Timer    10
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    3s
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send tester present
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}
    Log To Console    CAN 1 device is up and running

EnvD_SysQual_Communication_CANSubsystem_CANInterface_back_CAN2
    [Documentation]    CAN transceiver is used for CAN network communication, 2xCANFD in backplane is use for inter blades communication on rack ,
    ...    2 xCANFD is used for future CAN communication with other ECUs on vehicle
    ...    The system shall support DoIP communication via UDS according to ISO 14229-2:2013 to be used by SW applications.
    ...    2xCAN bus interface to back connector
    ...    The system shall equipped with CAN subsystem with below interface:-
    [Tags]    COMMUNICATION    FID-1039407,1340712,1338745,1338743    TCID-435333    FULLTEST
    # prj.sut.can.simulation.Stop
    # prj.sut.can.simulation.Start
    # prj.sut.can.simulation.PowerBladeON
    # prj.sut.com.Countdown Timer    10
    # prj.sut.can.diag.tester.present.active
    # prj.sut.com.Countdown Timer    10
    # Go to default session
    prj.sut.can.diag.send    ${sut.diag.Default_Session_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Default_Session_Resp}
    # Send tester present
    prj.sut.can.diag.send    ${sut.diag.Tester_Present_Req}
    sleep    3s
    prj.sut.diag.compare    ${sut.diag.Tester_Present_Resp}
    Log To Console    CAN 2 device is up and running

EnvD_SysQual_Communication_CANSubsystem_recovery_from_CAN_bus_off
    [Documentation]    The CAN subsystem shall recover by itself from a CAN bus off condition.
    [Tags]    COMMUNICATION    FID-1340690  TCID-437650    FULLTEST   Comunication_tag

    bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Low    ON
    Sleep    3s
    # Check DTC with fault present - expecting C1 05 0F 2F
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
    Sleep    3s
    ${fault_active_status}    Run Keyword And Return Status
    ...    prj.sut.diag.checkbyte    C1 05 0F 2F
    IF    not ${fault_active_status}
        Log To Console   .ERROR: C1 05 0F 2F not found with fault active
        bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Gnd    OFF
        prj.sut.can.simulation.Stop
        prj.sut.can.simulation.Start
        prj.sut.can.simulation.PowerBladeON
        Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2F not detected with fault active
    END
    # Only continue if fault was detected
    IF    ${fault_active_status}
        Log To Console    C1 05 0F 2F detected with fault active
        # Remove fault - Turn OFF CAN1_Short_High_Gnd
        bits_platform.Output Set Digital Signal Value    CAN1_Short_High_Low    OFF
        Sleep    3s
        # Check DTC with fault removed - expecting C1 05 0F 2E
        prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_Req}
        Sleep    3s
        ${fault_inactive_status}    Run Keyword And Return Status
        ...    prj.sut.diag.checkbyte    C1 05 0F 2E
        IF    not ${fault_inactive_status}
            Log To Console    ERROR: C1 05 0F 2E not found after fault removal
            prj.sut.can.simulation.Stop
            prj.sut.can.simulation.Start
            prj.sut.can.simulation.PowerBladeON
            Set Test Status To Fail    error_type=DIAGNOSIS    info_text=C1 05 0F 2E not detected after fault removal
        ELSE
            prj.sut.can.simulation.Stop
            prj.sut.can.simulation.Start
            prj.sut.can.simulation.PowerBladeON
            Log To Console    C1 05 0F 2E detected after fault removal
        END
    END

EnvD_SysQual_Communication_Eth_Switch_heartbeat_To_MCU
    [Documentation]    The Ecosystem Network should support prioritization stateful protocol communication based connections.
    [Tags]    COMMUNICATION    FID-2387856  TCID-568057    FULLTEST   Comunication_tag
    # Perform the ping test
    Close All Connections
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    sleep    20s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword offline    heartbeatVersion API
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        bits_platform.Output Set Digital Signal Value    Ethernet_Connection_Open    OFF
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=Ethernet sw version is not updated
    END
EnvD_SysQual_Communication_CANSubsystem_standard_format
    [Documentation]    The CAN database in MaaS system in NIP file format shall be converted to a standard format
    ...    dbc,Autosar ECU Extract format
    [Tags]    COMMUNICATION    FID-1340691,13406989  TCID-437645    FULLTEST   Comunication_tag
    # Search for the files in the listed folder
    ${files}=    List Files In Directory    ${sut.can.filepath}
    ${arxml_found}=    Evaluate    any(f.endswith('.arxml') for f in ${files})
    IF    ${arxml_found}
        Log    .arxml file found. Test case passed.
        Pass Execution    .arxml file is present.
    ELSE
        framework.Set Test Status To Fail    error_type=COM_ERROR    info_text=No .arxml file found in ${sut.can.filepath
    END