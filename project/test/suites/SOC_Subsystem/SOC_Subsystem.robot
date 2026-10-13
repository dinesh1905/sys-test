*** Settings ***
Documentation       Test suite containing test cases for SOC Main Subsystem of the MaaS Blade.
Metadata            testtype    FULLTEST
Metadata            testarea    SOC
Metadata            requirements    no requirements
Metadata            preconditions    no preconditions
Metadata            actions    no actions
Metadata            expectedresults    no expectedresults
Resource            ${TAF_PATH}/import.resource
Library             Screenshot
Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             ${TAF_PATH}/project/test/suites/SOC_Subsystem/CPU_Load.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         setups.Set Up Test Suite
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Variables ***
${SOC_VERSION}    ${SOC_VERSION}

*** Test Cases ***
EnvD_SysQual_MainSoCSubsystem_MSoC_EthernetInterface-RGMII-SGMII
    [Documentation]    Ethernet interface on RGMII (up until max 1000Mbps) and SGMII(up until 2.5Gbps)
    ...   MSoC shall provide SGMII interface to communicate with Ethernet Switch
    ...   MSoC subsystem shall support below hardware elements with same architecture for system in order to support a common
    ...   software implementation.
    ...   SGMII baud rate shall able to support 2.5GBit/s
    [Tags]    SOC    FID-1378827,1592421,1378728,1592423  TCID-296576    FULLTEST
    prj.sut.power off
    prj.sut.connect.dlt
    prj.sut.connect.QNX
    prj.sut.can.simulation.Stop
    prj.sut.can.simulation.Start
    prj.sut.power on
    prj.sut.can.simulation.PowerBladeON
    sleep    10s
    Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Start Process    iperf3    -s    alias=iperf_server
    Sleep    3s
    # Connect and run client
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    iperf3 -c FD53:7CB8:0383:0018:0000:0000:0001:0271 -t 60 -i 5
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
    ${result}    Run Process    cmd    /c    iperf3 -c FD53:7CB8:0383:0018:0000:0000:0001:0268 -t 60 -i 5
    ...    shell=True    timeout=200s
    Log To Console    Return Code: ${result.rc}
    Log To Console    STDOUT:\n${result.stdout}
    Log To Console    STDERR:\n${result.stderr}
    prj.sut.com.Check Speed    ${result.stdout}
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-RemoteDebuggingSubsystemShallSupportRemoteAccesstoShellofOS
    [Documentation]    The remote debugging subsystem shall support remote access to the shell of the Operating System.
    [Tags]    SOC    FID-2510890  TCID-369374    FULLTEST
    Close All Connections
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    sleep    5s
    Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Log To Console    SOC startup is correct
    Sleep    10s
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    cat mnt/Buildinfo.txt
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    ${SOC_VERSION}
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    version is successfully verified
    Close All Connections

EnvD_SysQual_MainSoCSubsystem_MSoC_ExternalMemoryInterface_NORFlash_OctalSPI_QuadSPI
    [Documentation]    External memory interface to NOR flash via Octal-SPI or Quad-SPI
    ...    MSoC subsystem shall support below hardware elements with same architecture for system in order to support
    ...    a common software implementation:-
    [Tags]    SOC    FID-1378822,1378728  TCID-296582    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.connect.SAIL
    prj.sut.connect.QNX
    prj.sut.power cycle
    sleep    5s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Log To Console    SOC startup is correct
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

    Sleep    10s
    Verify SAIL keyword offline   SAIL image id:
    Log To Console    SAIL trace is coming
    Verify QNX keyword    ${SOC_VERSION}    command=cat mnt/Buildinfo.txt
    Sleep    30s
    ${Status}    Run Keyword And Return Status    Verify QNX keyword    ${SOC_VERSION}    command=cat mnt/Buildinfo.txt
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.Test Case PASS
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

EnvD_SysQual_MainSoCSubsystem_MSoC_ExternalMemoryInterface_UFS3.1
    [Documentation]    External memory Interface to up until UFS3.1 memory
    ...    MSoC subsystem shall support below hardware elements with same architecture for system in order to support
    ...    a common software implementation:-
    [Tags]    SOC    FID-1378749,1378728  TCID-296584    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.connect.QNX
    prj.sut.power cycle
    sleep    5s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Log To Console    SOC startup is correct
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

    Sleep    10s
    ${Status}    Run Keyword And Return Status    Verify QNX keyword offline    Boot Interface: UFS
    ...    UFS INQUIRY ID: SAMSUNG KLUFGAUHYB-B0EQ 5300
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    QNX command Successfully.Test Case PASS
    ELSE
        Log To Console    QNX command Failed
        Close All Connections
        framework.Set Test Status To Fail    power    QNX
    END

EnvD_SysQual_MainSoCSubsystem_MSoC_SupportCPUProcessingUnit
    [Documentation]    CPU processing unit
    ...    MSoC subsystem shall support below hardware elements with same architecture for system in order to support
    ...    a common software implementation:-
    [Tags]    SOC    FID-1378823,1378728  TCID-296579    FULLTEST
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    sleep    10s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Log To Console    SOC startup is correct
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    power    dlt
    END
    sleep    5s
    ${Status}    Run Keyword And Return Status    Verify DLT keyword    \\[StmProxy\\] Send ALIVE_REQUEST to soc \\[INC\\]
    Log To Console    The status of verified step is "${Status}"
    IF    ${Status}
        Log To Console    DLT keyword is matched
    ELSE
        Log To Console    DLT keyword not matched
        Close All Connections
        framework.Set Test Status To Fail    power    dlt
    END

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-DebuggingSubsystemMechanismStoreDumpPersistenly
    [Documentation]    The debugging subsystem shall provide a mechanism to retrieve the dump from the device.
    ...   The debugging subsystem shall provide a mechanism to store dump persistently.
    [Tags]    SOC    FID-2510957,2510956  TCID-369379    FULLTEST
    Close All Connections
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    find -name dumper
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    ./proc/dumper    ./mnt/bin/dumper    ./ifs/bin/dumper
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    pidin -fA | grep dumper
    sleep    10s
    @{expected_paths}    Create List    -d /var/log
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    cd /var/
    sleep    1s
    write    ls -l
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    log
    Verify Dumper Paths    ${output}    @{expected_paths}
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-DebuggingSubsystemProvideDebuggingTools-TCPDumper
    [Documentation]    The debugging subsystem shall provide debugging tools in the device.
    ...    (e.g. tcpdump, valgrind and etc)
    [Tags]    SOC    FID-2510958  TCID-369376    FULLTEST
    Close All Connections
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    tcpdump -i emac0 -vvv -e -n vlan 2050
    sleep    5s
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    find -name tcpdump
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    ./mnt/usr/sbin/tcpdump
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    pidin -fA | grep tcpdump
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    tcpdump -i emac0 -vvv -e -n vlan 2050
    Verify Dumper Paths    ${output}    @{expected_paths}
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-DebuggingSubsystemProvideDebuggingTools-valgrind
    [Documentation]    Ethernet interface on RGMII (up until max 1000Mbps) and SGMII(up until 2.5Gbps)
    ...   MSoC shall provide SGMII interface to communicate with Ethernet Switch
    [Tags]    SOC    FID-2510958,  TCID-369371    FULLTEST
    Close All Connections
    Open Connection   FD53:7CB8:0383:0018:0000:0000:0001:0268    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    find -name valgrind
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    ./mnt/usr/bin/valgrind    ./mnt/usr/lib64/valgrind
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    valgrind --help
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    --version                 show version
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    valgrind --version
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    valgrind-3.14.0
    Verify Dumper Paths    ${output}    @{expected_paths}
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-DebuggingSubsystemProvideDebuggingTools-backtrace
    [Documentation]     The debugging subsystem shall provide debugging tools in the device
    ...    . (e.g. tcpdump, valgrind and etc)
    [Tags]    SOC    FID-2510958  TCID-369372    FULLTEST
    Close All Connections
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    find -name backtrace
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    backtrace
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    pidin -fA | grep backtrace
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    -d /var/log
    Verify Dumper Paths    ${output}    @{expected_paths}
    write    cd /var/
    sleep    1s
    write    ls -l
    sleep    5s
    ${output}    Read
    @{expected_paths}    Create List    log
    Verify Dumper Paths    ${output}    @{expected_paths}
    Close All Connections

EnvD_SysQual_MainSoCSubsystem_MSoC_PowerManagementUnit-PMIC
    [Documentation]    Power management unit and PMIC that manage the external
    ...    power that supply to SoC subsystem.MSoC subsystem shall support 
    ...    below hardware elements with same architecture for system in order 
    ...    to support a common software implementation:-

    [Tags]    SOC    FID-1378835,1378728  TCID-369374    FULLTEST
    Close All Connections
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.dlt
    prj.sut.power cycle
    sleep    5s
    Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Log To Console    SOC startup is correct
    Sleep    10s
    # Verify console able to send command and receive response
    Open Connection   ${sut.com.QNX_HOST}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    write    cat mnt/Buildinfo.txt
    sleep    5s
    ${output}    Read
    Log To Console   Complete Test Output:\n${output}
    @{expected_paths}    Create List    ${SOC_VERSION}
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    version is successfully verified
    Verify DLT keyword    Eth Klima_Sensor_01_XIX_E3V_VLAN_MPCI Received
    Log To Console    Etherent signal is verified
    Close All Connections

EnvD_SysQual_MSoCSubsystemSupportInterface_MSoC-Provide-Mechanism-Persistenly-Log-Data-at-Runtime
    [Documentation]    1338698: b. Connection interface to SoC subsystem
    ...    The logging subsystem shall provide a mechanism to persistently log data at runtime.

    [Tags]    SOC    FID-1398698,2510837  TCID-329835    FULLTEST
    Close All Connections
    # prj.sut.can.simulation.PowerBladeOFF
    # prj.sut.connect.dlt
    # prj.sut.power cycle
    # sleep    5s
    # Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    # Log To Console    SOC startup is correct
    Sleep    10s
    Close All Connections
    ${proc}    Start Process    ${sut.soc.DLT_VIEWER_EXE}    -p    ${sut.soc.DLP_FILE}
    ...    cwd=${sut.soc.DLT_VIEWER_PATH}    shell=True    stdout=PIPE    stderr=PIPE

    # do whatever checks you need here (sleep, wait for UI, take screenshot, etc.)
    Sleep    5s
    Take Screenshot    ${sut.soc.SCREENSHOT_PATH}
    Log    <img src="${sut.soc.SCREENSHOT_PATH}">    HTML
    Log    Linux trace is seen in the log
    Terminate Process    ${proc}    kill=True

EnvD_SysQual_MainSoCSubsystem_MSoC_USB2&3.1-Interface
    [Documentation]    Check recent SOC MAIN flashed version.MSoC subsystem shall support USB2 USB3.1 interface
    [Tags]    SOC    FULLTEST    FID-159246   TCID-435421
    prj.sut.power cycle
    Sleep    40s
    prj.sut.connect.QNX
    Sleep    3s
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    Sleep    3s
    prj.sut.disconnect.QNX

EnvD_SysQual_MainSoCSubsystem_MSoC_USBInterface-USB3.1Gen2-USB2.0
    [Documentation]    USB interfaces that can support USB 3.1 Gen 2 (HS + SS, support device and host modes)
    ...    and USB2.0 (HS, support device and host modes).: MSoC subsystem shall support below hardware elements with
    ...    same architecture for system in order to support a common software implementation
    [Tags]    SOC    FULLTEST    FID-1378828,1378728   TCID-296572
    Close All Connections
    prj.sut.can.simulation.PowerBladeOFF
    prj.sut.connect.QNX
    Sleep    3s
    prj.sut.connect.dlt
    Sleep    3s
    prj.sut.power cycle
    sleep    30s
    Verify DLT keyword    \\[PowerM]  SendCanSignal [STATE_INTERNAL_RUN]
    Log To Console    SOC startup is correct
    Sleep    10s
    Verify QNX keyword    ${SOC_VERSION}    command= cat /mnt/Buildinfo.txt
    Sleep    3s
    prj.sut.disconnect.QNX
    Close All Connections
    

EnvD_SysQual_MainSoCSubsystem_MSoC_JTAGConnectorExistence
    [Documentation]    1592420: JTAG interface to program and debug the SoC shall connected to MSoC
    [Tags]    SOC    FID-1592420  TCID-435420    FULLTEST
    ${result}    Run Process
    ...    fwupdate.bat
    ...    ${sut.can.IMAGE}
    ...    cwd=${sut.can.FLASH_TOOL_PATH}
    ...    shell=True
    ...    stdout=PIPE
    ...    stderr=PIPE
    Log    ${result.stdout}
    ${output}    Set Variable    ${result.stdout}
    Log    ${output}
    Should Contain    ${output}    Successfully updated firmware!
    Should Contain    ${output}    Marvell JTAG SPI Flash Programmer finished successfully.
    Should Contain    ${output}    Successfully verified Primary partition!
    Should Contain    ${output}    Successfully verified Secondary partition!
    Should Contain    ${output}    Successfully verified Data partition!
    prj.sut.power cycle
    Verify DLT keyword offline    ${sut.soc.ETH_Switch_Version}
 
EnvD_SysQual_MainSoCSubsystem_MSoC_A2Binterface
    [Documentation]    MSoC subsystem shall support A2B interface.The Main-SOC subsystem shall provide an audio subsystem
    ...    capable of managing, handling, and processing all audio streams and use cases.The MSoC subsystem  shall be capable
    ...    of performing asynchrone sample rate conversion of the different clock domains of audio sources and
    ...    sinks from Microphone and speaker through audio booster
    [Tags]    SOC    FID-1601595,1601597,1592430  TCID-435419    FULLTEST

    prj.sut.power inital precondition for big toelner    powercurve_battery    12.0
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    Verify DLT keyword offline  [PowerM] KssPowerUp SwitchOnPowerRail
    Verify DLT keyword offline  [PowerM] GssPowerUp CPU Activated
    Verify DLT keyword offline    [PowerM] BswM_RequestMode
    Verify DLT keyword offline  [PowerM] SendCanSignal
    #    prj.sut.thread.A2BVoltageCheck
    Verify QNX Command Has No Output    command=mount -o remount, rw /mnt
    Verify QNX keyword    Repeat playing    command=wave -d -a OpCall_Out /ifs/etc/car2-chime.wav &
    Verify QNX keyword    js:JSequencerManager:Exited    command=jstreamer -v -S -p /mnt/ExternalPrioOCall.seq
    Audio validation    Play
    prj.sut.soc.Run And Kill Wave On QNX Console
    Close All Connections

EnvD_SysQual_MainSoCSubsystem_MSoC_MainSubsytemCheck-A2B
    [Documentation]    Main System-on-Chip (MSoC) shall provide A2B interface
    [Tags]    SOC    FID-1601597,1592407,1601595,1592408,1592428,1592430    TCID-435417    FULLTEST
    Close All Connections
    prj.sut.power inital precondition for big toelner    powercurve_battery    12.0
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    Verify DLT keyword offline  [PowerM] KssPowerUp SwitchOnPowerRail
    Verify DLT keyword offline  [PowerM] GssPowerUp CPU Activated
    Verify DLT keyword offline    [PowerM] BswM_RequestMode
    Verify DLT keyword offline  [PowerM] SendCanSignal
    #    prj.sut.thread.A2BVoltageCheck
    Verify QNX Command Has No Output    command=mount -o remount, rw /mnt
    Verify QNX keyword    Repeat playing    command=wave -d -a OpCall_Out /ifs/etc/car2-chime.wav &
    Verify QNX keyword    js:JSequencerManager:Exited    command=jstreamer -v -S -p /mnt/ExternalPrioOCall.seq
    Audio validation    Play
    prj.sut.soc.Run And Kill Wave On QNX Console
    Close All Connections

EnvD_SysQual_MainSoCSubsystem_MSoC_CameraInterface
    [Documentation]    MSoC subsystem shall support below hardware elements with same architecture for system in order
    ...    to support a common software implementation:
    ...    Camera intreface
    [Tags]    SOC    FID-1378728,1378746    TCID-296583    FULLTEST
    prj.sut.power inital precondition for big toelner    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}


EnvD_SysQual_MainSoCSubsystem_MSoC_SupportImageProcessingUnit
    [Documentation]    MSoC subsystem shall support below hardware elements with same architecture for system in order
    ...    to support a common software implementation:
    ...    Image Processing Unit
    [Tags]    SOC    FID-1378820,1378728    TCID-296581    FULLTEST
    prj.sut.power inital precondition for big toelner    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}

EnvD_SysQual_MainSoCSubsystem_MSoC_SupportImageProcessingUnit2
    [Documentation]    MSoC subsystem shall support below hardware elements with same architecture for system in order
    ...    to support a common software implementation:
    ...    Image Processing Unit
    [Tags]    SOC    FID-1378820,1378728    TCID-435413    FULLTEST
    prj.sut.power inital precondition for big toelner    powercurve_battery    12.0
    Sleep    10s
    prj.sut.Power.DTL logs for normal funcational state of DUT
    ${raw_file}=    prj.sut.Power. camera image dump and move    Not_Displayed_1camera
    Log To Console    the raw file is ${raw_file} and is the in image format
    Generate jpg image from raw image    ${raw_file}
    

EnvD_SysQual_MainSoCSubsystem_MSoC_VideoCPULoad
    [Documentation]    The Main-SOC subsystem  shall support decoding of min. four Full HD streams at 60 fps
    ...    in parallel and with low CPU load (e.g. by using special function blocks).
    [Tags]    SOC    FID-1601594    TCID-435411    FULLTEST
    Close All Connections
    Open Connection   ${sut.soc.TARGET_IP1}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Write    top -i 10
    Sleep    30s
    ${before_output}=    Read
    ${before}=    get average cpu user percent    ${before_output}
    # Open Connection   ${TARGET_IP1}    None    22
    # Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    # Write    dtach -a /tmp/la_gvm.sock
    # Sleep    2s
    # Write    am start -n com.android.gallery3d/.app.MovieActivity -d ./data/waterdrop.mp4
    # Sleep    4s
    # Write    am start -n com.android.gallery3d/.app.MovieActivity -d ./data/waterdrop.mp4
    prj.sut.soc.ADB Connect With Retry
    prj.sut.soc.ADB Root
    prj.sut.soc.Verify Device Online
    prj.sut.soc.Remount Vendor RW
    prj.sut.soc.Set SELinux Permissive
    prj.sut.soc.Launch Video On Gallery
    Open Connection   ${sut.soc.TARGET_IP1}    None    22
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Write    top -i 10
    Sleep    30s
    ${during_output}=    Read
    ${during}=    get average cpu user percent    ${during_output}
    Validate Cpu Load Difference    ${before}    ${during}

EnvD_SysQual_MainSoCSubsystem_MSoC_SupportDisplayProcessingUnit
    [Documentation]    MSoC subsystem shall support below hardware elements with same architecture for system in order to
    ...    support a common software implementation:Display Processing Unit
    [Tags]    SOC    FID-1378821,1378728    TCID-296578    FULLTEST
 
    prj.sut.connect.dlt
    prj.sut.power inital precondition for big toelner    powercurve_battery    13.0
    Sleep    10s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    20s
    Close All Connections
    Open Connection    ${sut.soc.TARGET_IP1}
    Login    ${sut.com.USERNAME}    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    i2cdbgr -D /dev/i2c2 -s 0x14 -r -b1 -o 0x0c -i 6 -v
    ${output}    Read  delay=10s
    Log To Console    ${output}
    Sleep    20s
    @{expected_paths}    Create List    addr: 0xc data : 0x41
    ...    addr: 0xd data : 0x0
    ...    addr: 0xe data : 0x0
    ...    addr: 0xf data : 0x0
    ...    addr: 0x10 data : 0x0
    ...    addr: 0x11 data : 0x0
    Verify Dumper Paths    ${output}    @{expected_paths}
    prj.sut.soc.ADB Media Push And SELinux Permissive Setup
    Log to console    Video is played in all the 5 displays

EnvD_SysQual_MainSoCSubsystem_MSoC_VideoOutputInterface
    [Documentation]    MSoC subsystem shall support video output interfaces (e.g. HDMI, DP, eDP, MIPI-DSI)
    [Tags]    SOC    FID-1378824,1378728  TCID-296580    FULLTEST
    Close All Connections
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    powercurve_battery    0
    sleep    5s
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    sleep    60s
    Open Connection    ${sut.soc.TARGET_IP1}
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    i2cdbgr -D /dev/i2c2 -s 0x14 -r -b1 -o 0x0c -i 6 -v
    ${output}    Read  delay=10s
    Log To Console    ${output}
    @{expected_paths}    Create List    addr: 0xc data : 0x41
    ...    addr: 0xd data : 0x0
    ...    addr: 0xe data : 0x0
    ...    addr: 0xf data : 0x0
    ...    addr: 0x10 data : 0x0
    ...    addr: 0x11 data : 0x0
    Verify Dumper Paths    ${output}    @{expected_paths}
    Write    screentest -d 0 -p styx
    ${output}    Read  delay=10s
    Log To Console    ${output}
    @{expected_paths}    Create List
    ...    display #0  mode  1920x1080@57
    ...    display #1  mode  1280x720@60
    ...    display #2  mode  1280x720@60
    ...    display #3  mode  1280x720@60
    ...    DDEBUG:  227
    ...    DDEBUG:  258
    ...    buffer stride = 7680
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    Screen test is played in ABT screen
    Write    \x03
    sleep    3s
    Write    echo -n "pattern1" > /dev/kdisplay/secondary/serializer_pattern
    ${output}    Read  delay=10s
    Log To Console    Video is played in passenger screens as per input command
    Write    echo -n "disable" > /dev/kdisplay/secondary/serializer_pattern 
    ${output}    Read  delay=10s
    Log To Console    Video is  stopped played on the passenger displays as per input command
    prj.sut.soc.ADB Connect With Retry
    prj.sut.soc.ADB Root
    prj.sut.soc.Verify Device Online
    prj.sut.soc.Remount Vendor RW
    # --- Phase 4: SELinux Permissive && Launch video ---
    prj.sut.soc.Set SELinux Permissive
    prj.sut.soc.Launch Video On Gallery
    Log To Console   Waterdrop  Video is played on all the screens


EnvD_SysQual_MainSoCSubsystem_MSoC_SupportVideoProcessingUnit
    [Documentation]    MSoC subsystem shall support below hardware elements with same architecture for system in order to support a common software implementation:
    ...    Video Processing Unit
    [Tags]    SOC    FID-1601599,1601598,1378728,1601600,1378732  TCID-296571    FULLTEST
    prj.sut.power inital precondition for big toelner    powercurve_battery    12.0
    sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    Sleep    1s
    Verify DLT keyword offline  [PowerM] KssPowerUp SwitchOnPowerRail
    Verify DLT keyword offline  [PowerM] GssPowerUp CPU Activated
    Verify DLT keyword offline    [PowerM] BswM_RequestMode
    Verify DLT keyword offline  [PowerM] SendCanSignal

    prj.sut.soc.ADB Connect With Retry
    prj.sut.soc.ADB Root
    prj.sut.soc.Verify Device Online
    prj.sut.soc.Remount Vendor RW
    # --- Phase 4: SELinux Permissive && Launch video ---
    prj.sut.soc.Set SELinux Permissive
    prj.sut.soc.Launch Video On Gallery
    Log To Console   Waterdrop  Video is played on all the screens
    sleep    10s
    Log To Console   Waterdrop  Video is exited on all the screens

    Open Connection    ${sut.soc.TARGET_IP1}
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    i2cdbgr -D /dev/i2c2 -s 0x14 -r -b1 -o 0x0c -i 6 -v
    ${output}    Read  delay=10s
    Log To Console    ${output}
    @{expected_paths}    Create List    addr: 0xc data : 0x41
    ...    addr: 0xd data : 0x0
    ...    addr: 0xe data : 0x0
    ...    addr: 0xf data : 0x0
    ...    addr: 0x10 data : 0x0
    ...    addr: 0x11 data : 0x0
    Verify Dumper Paths    ${output}    @{expected_paths}

#   To generate Graphic in 4x displays
    Write    echo -n "pattern1" > /dev/kdisplay/secondary/serializer_pattern
    ${output}    Read  delay=10s
    Log To Console    Video is played in passenger screens as per input command
    Write    echo -n "disable" > /dev/kdisplay/secondary/serializer_pattern 
    ${output}    Read  delay=10s
    Log To Console    Video is  stopped played on the passenger displays as per input command

#   To use Screen test to generate image in the display
    Write    screentest -d 0 -p image /mnt/etc/config/display-infrastructure/splash/logo.png
    ${output}    Read  delay=10s
    Log To Console   Android Logo is overlapping the screen
    Write    \x03
    Log To Console   Screentest is exited

    Write    screentest -d 0 -p image /mnt/etc/config/display-infrastructure/splash/welcome.png &
    ${output}    Read  delay=10s
    @{expected_paths}    Create List
    ...    display #0  mode  1920x1080@57
    ...    display #1  mode  1280x720@60
    ...    display #2  mode  1280x720@60
    ...    display #3  mode  1280x720@60
    Verify Dumper Paths    ${output}    @{expected_paths}

    Write    slog2info -w | grep RGB
    ${output}    Read  delay=10s
    @{expected_paths}    Create List
    ...    QDI_PIXEL_FORMAT_ARGB_8888_32BPP
    Verify Dumper Paths    ${output}    @{expected_paths}
    Write    slay -f screentest

EnvD_SysQual_MainSoCSubsystem_MSoC_SupportGraphicProcessingUnit_ABTScreen
    [Documentation]    MSoC subsystem shall support below hardware elements with same architecture for system in order to 
    ...    support a common software implementation:Graphic Processing Unit
    [Tags]    SOC    FID-1601594    TCID-377809    FULLTEST

    prj.sut.power inital precondition for big toelner    powercurve_battery    12.0
    sleep    30s
    Verify DLT keyword offline    [PowerM] KssPowerUp SwitchOnPowerRail
    Verify DLT keyword offline    [PowerM] GssPowerUp CPU Activated
    Verify DLT keyword offline    [PowerM] BswM_RequestMode
    Verify DLT keyword offline    [PowerM] SendCanSignal
    Open Connection    ${sut.soc.TARGET_IP1}
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    i2cdbgr -D /dev/i2c2 -s 0x14 -r -b1 -o 0x0c -i 6 -v
    ${output}    Read  delay=10s
    Log To Console    ${output}
    @{expected_paths}    Create List
    ...    addr: 0xC  data\s*:\s*0x(41|43)
    ...    addr: 0xD  data : 0x0
    ...    addr: 0xE  data : 0x0
    ...    addr: 0xF  data : 0x0
    ...    addr: 0x10 data : 0x0
    ...    addr: 0x11 data : 0x0
    Write    screentest -d 0 -p styx
    ${output}    Read  delay=10s
    Log To Console    ${output}
    @{expected_paths}    Create List
    ...    display #0  mode  1920x1080@57
    ...    display #1  mode  1280x720@60
    ...    display #2  mode  1280x720@60
    ...    display #3  mode  1280x720@60
    ...    DDEBUG:  227
    ...    DDEBUG:  258
    ...    buffer stride = 7680
    Verify Dumper Paths    ${output}    @{expected_paths}
    Log To Console    Screen test is played in ABT screen
    Write    \x03
    sleep    5s
    Write    screentest -d 0 -p colorbars
    ${output}    Read  delay=10s
    Log To Console    ${output}
    @{expected_paths}    Create List
    ...    display #0  mode  1920x1080@57
    ...    display #1  mode  1280x720@60
    ...    display #2  mode  1280x720@60
    ...    display #3  mode  1280x720@60
    ...    DDEBUG:  227
    ...    DDEBUG:  258
    ...    buffer stride = 7680
    Verify Dumper Paths    ${output}    @{expected_paths}
    Write    \x03 
    Log To Console    Screen test is exited

EnvD_SysQual_MainSoCSubsystem_MSoC_MainSubsytemCheck-PassengerDisplay
    [Documentation]    The Main-SOC subsystem shall be able to drive simultaneously for 5 displays to follow customer
    ...    displays for central display via Video Converter ECU and passenger display specification. 
    ...    MSoC shall support at least 4 video outputs to passenger displays
    ...    MSoC shall support HMI, complex software handling, complex infotainment signal processing and jobs that require
    ...    high CPU processing
    [Tags]    SOC    FID-1601598,1592411,1592428    TCID-435414    FULLTEST

    prj.sut.power inital precondition for big toelner    powercurve_battery    12.0
    sleep    30s
    Verify DLT keyword offline    [PowerM] KssPowerUp SwitchOnPowerRail
    Verify DLT keyword offline    [PowerM] GssPowerUp CPU Activated
    Verify DLT keyword offline    [PowerM] BswM_RequestMode
    Verify DLT keyword offline    [PowerM] SendCanSignal
    Open Connection    ${sut.soc.TARGET_IP1}
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    i2cdbgr -D /dev/i2c2 -s 0x14 -r -b1 -o 0x0c -i 6 -v
    ${output}    Read  delay=10s
    Log To Console    ${output}
    @{expected_paths}    Create List
    ...    addr: 0xC  data\s*:\s*0x(41|43)
    ...    addr: 0xD  data : 0x0
    ...    addr: 0xE  data : 0x0
    ...    addr: 0xF  data : 0x0
    ...    addr: 0x10 data : 0x0
    ...    addr: 0x11 data : 0x0
#   To generate Graphic in 4x displays
    Write    echo -n "pattern1" > /dev/kdisplay/secondary/serializer_pattern
    ${output}    Read  delay=10s
    Log To Console    Video is played in passenger screens as per input command
    Write    echo -n "disable" > /dev/kdisplay/secondary/serializer_pattern 
    ${output}    Read  delay=10s
    Log To Console    Video is  stopped played on the passenger displays as per input command