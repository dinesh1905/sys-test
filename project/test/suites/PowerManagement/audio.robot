*** Settings ***
# Documentation       Example script to set and get voltage
# Metadata            testtype    example
# Metadata            testarea    power
# Metadata            requirements    no requirements
# Metadata            preconditions    no preconditions
# Metadata            actions    no actions
# Metadata            expectedresults    no expectedresults
Library    OperatingSystem

Resource            ${TAF_PATH}/import.resource
# Library             ${TAF_PATH}/project/framework/log2rqm.py
Library             QConnectBase.ConnectionManager

# Test Automation Framework
Suite Setup         run keywords    setups.Set Up Test Suite    prj.sut.disconnect.safety
Suite Teardown      teardowns.Tear Down Test Suite
Test Setup          setups.Set Up Test Case
Test Teardown       teardowns.Tear Down Test Case

*** Test Cases ***
EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_A2BPhantomPowerSupply
    [Documentation]    Set KL15 on power blade to ON to trigger start up on MaaS Blade. 
    ...    Make sure A2B booster are connected
    ...    Open putty.exe and load SoC session and click open
    ...    To Check A2B network node discovery.
    ...    In the SOC putty:
    ...    inject : slog2info -w | grep -e ASC -e A2B"
    ...    To capture audio: (input)
    ...    inject : mount -o remount, rw /mnt"
    ...    inject : waverec -a eight_channel_a2bc -r 48000 -n 8 -t 10 /mnt/etc/test_audio.wav
    ...    Speak to the LINDa module microphone
    ...    Control + C to stop capturing audio.
    ...    "To playback audio : (output)
    ...    wave -d -c1=11111111,2=11111111 -a eight_channel_a2bp /ifs/etc/test_audio.wav"
    ...    Confirm that sound is audible through the speakers, indicating successful audio output from the A2B Booster.
    ...    Measure voltage on each camera with digital multimeter. 
    [Tags]    POWER    FID-462078.1275433    TCID-408440    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Close All Connections
    Open Connection   172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    mount -o remount, rw /mnt
    Sleep    2s
    Write    wave -d -a QNX_IntExt_1 /ifs/etc/car2-chime.wav
    Sleep    10s
    ${chime_wave}    Read
    Should Contain    ${chime_wave}    Repeat playing
    Write    jstreamer -v -S -p /mnt/ExternalPrioOCall.seq
    Sleep    1s
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Play
    Write    jstreamer -v -S -p /mnt/InternalPrioOCall.seq
    Sleep    1s
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_3}    Play
    Sleep    10
    Write    pidin ar | grep wave
    Sleep    2s
    ${pid_output}=    Read
    ${lines}=    Split To Lines    ${pid_output}
    FOR    ${line}    IN    @{lines}
        IF    'wave -d -a QNX_IntExt_1' in '${line}'
            ${pid}=    Fetch From Left    ${line}    wave
            ${pid}=    Strip String    ${pid}
            Write    kill -9 ${pid}
        END
    END

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_MaasHVIA2BStandbyModeRecovery
    [Documentation]    "Set KL15 on power blade to ON to trigger start up on MaaS Blade. "
    ...    Make sure A2B booster are connected
    ...    Increase the power supply to MaasBlade to 18V
    ...    Open putty.exe and load SoC session and click open
    ...    "To Check A2B network node discovery.
    ...    In the SOC putty:
    ...    inject : slog2info -w | grep -e ASC -e A2B"
    ...    "To capture audio: (input)
    ...    inject : mount -o remount, rw /mnt"
    ...    inject : waverec -a eight_channel_a2bc -r 48000 -n 8 -t 10 /mnt/etc/test_audio.wav
    ...    Control + C to stop capturing audio.
    ...    "To playback audio : (output)
    ...    wave -d -c1=11111111,2=11111111 -a eight_channel_a2bp /ifs/etc/test_audio.wav"
    ...    Confirm that NO sound is audible through the speakers, indicating A2B Booster is in standby mode.
    ...    Decrease the power supply to MaasBlade back to 18V
    ...    "To Check A2B network node discovery.
    ...    In the SOC putty:
    ...    inject : slog2info -w | grep -e ASC -e A2B"
    ...    "To capture audio: (input)
    ...    inject : mount -o remount, rw /mnt"
    ...    inject : waverec -a eight_channel_a2bc -r 48000 -n 8 -t 10 /mnt/etc/test_audio.wav
    ...    Speak to the LINDa module microphone
    ...    Control + C to stop capturing audio.
    ...    "To playback audio : (output)
    ...    wave -d -c1=11111111,2=11111111 -a eight_channel_a2bp /ifs/etc/test_audio.wav"
    ...    Confirm that sound is audible through the speakers, indicating successful audio output from the A2B Booster.
    [Tags]    POWER    FID-462078.1275441    TCID-408442    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Close All Connections
    Open Connection   172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    mount -o remount, rw /mnt
    Sleep    2s
    Write    wave -d -a QNX_IntExt_1 /ifs/etc/car2-chime.wav
    Sleep    10s
    ${chime_wave}    Read
    Should Contain    ${chime_wave}    Repeat playing
    Write    jstreamer -v -S -p /mnt/ExternalPrioOCall.seq
    Sleep    1s
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Play
    Sleep    10s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    21
    sleep    50
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_disabled}
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Pause
    sleep    5s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12
    sleep    50
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Play
    Sleep    10
    Write    pidin ar | grep wave
    Sleep    2s
    ${pid_output}=    Read
    ${lines}=    Split To Lines    ${pid_output}
    FOR    ${line}    IN    @{lines}
        IF    'wave -d -a QNX_IntExt_1' in '${line}'
            ${pid}=    Fetch From Left    ${line}    wave
            ${pid}=    Strip String    ${pid}
            Write    kill -9 ${pid}
        END
    END

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_MaasLVIA2BStandbyModeRecovery
    [Documentation]    "Set KL15 on power blade to ON to trigger start up on MaaS Blade."
    ...    Make sure A2B booster are connected
    ...    Decrease the power supply to MaasBlade to 8V
    ...    Open putty.exe and load SoC session and click open
    ...    "To Check A2B network node discovery.
    ...    In the SOC putty:
    ...    inject : slog2info -w | grep -e ASC -e A2B"
    ...    "To capture audio: (input)
    ...    inject : mount -o remount, rw /mnt"
    ...    inject : waverec -a eight_channel_a2bc -r 48000 -n 8 -t 10 /mnt/etc/test_audio.wav
    ...    Control + C to stop capturing audio.
    ...    "To playback audio : (output)
    ...    wave -d -c1=11111111,2=11111111 -a eight_channel_a2bp /ifs/etc/test_audio.wav"
    ...    Confirm that NO sound is audible through the speakers, indicating A2B Booster is in standby mode.
    ...    Increase the power supply to MaasBlade back to 18V
    ...    "To Check A2B network node discovery.
    ...    In the SOC putty:
    ...    inject : slog2info -w | grep -e ASC -e A2B"
    ...    "To capture audio: (input)
    ...    inject : mount -o remount, rw /mnt"
    ...    inject : waverec -a eight_channel_a2bc -r 48000 -n 8 -t 10 /mnt/etc/test_audio.wav
    ...    Speak to the LINDa module microphone
    ...    Control + C to stop capturing audio.
    ...    "To playback audio : (output)
    ...    wave -d -c1=11111111,2=11111111 -a eight_channel_a2bp /ifs/etc/test_audio.wav"
    ...    Confirm that sound is audible through the speakers, indicating successful audio output from the A2B Booster.
    [Tags]    POWER    FID-462078.1275440    TCID-408437    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Close All Connections
    Open Connection   172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    mount -o remount, rw /mnt
    Sleep    2s
    Write    wave -d -a QNX_IntExt_1 /ifs/etc/car2-chime.wav
    Sleep    10s
    ${chime_wave}    Read
    Should Contain    ${chime_wave}    Repeat playing
    Write    jstreamer -v -S -p /mnt/ExternalPrioOCall.seq
    Sleep    1s
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Play
    Sleep    5s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    8    
    sleep    50
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_disabled}
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Pause
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12
    sleep    50
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Play

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_MICPhantomPowerSupply
    [Documentation]    "Set KL15 on power blade to ON to trigger start up on MaaS Blade."
    ...    Make sure A2B booster are connected
    ...    Open putty.exe and load SoC session and click open
    ...    "To Check A2B network node discovery.
    ...    In the SOC putty:
    ...    inject : slog2info -w | grep -e ASC -e A2B"
    ...    "To capture audio: (input)
    ...    inject : mount -o remount, rw /mnt"
    ...    inject : waverec -a eight_channel_a2bc -r 48000 -n 8 -t 10 /mnt/etc/test_audio.wav
    ...    Speak to the LINDa module microphone
    ...    Control + C to stop capturing audio.
    ...    "To playback audio : (output)
    ...    wave -d -c1=11111111,2=11111111 -a eight_channel_a2bp /ifs/etc/test_audio.wav"
    ...    Confirm that sound is audible through the speakers, indicating successful audio output from the A2B Booster.
    ...    Measure voltage on the Linda Module with digital multimeter. 
    [Tags]    POWER    FID-462078.1039429    TCID-408438    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Close All Connections
    Open Connection   172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    Write    mount -o remount, rw /mnt
    Sleep    2s
    Write    wave -d -a QNX_IntExt_1 /ifs/etc/car2-chime.wav
    Sleep    10s
    ${chime_wave}    Read
    Should Contain    ${chime_wave}    Repeat playing
    Write    jstreamer -v -S -p /mnt/ExternalPrioOCall.seq
    Sleep    1s
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Play
    Write    jstreamer -v -S -p /mnt/InternalPrioOCall.seq
    Sleep    1s
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_3}    Play
    Sleep    10
    Write    pidin ar | grep wave
    Sleep    2s
    ${pid_output}=    Read
    ${lines}=    Split To Lines    ${pid_output}
    FOR    ${line}    IN    @{lines}
        IF    'wave -d -a QNX_IntExt_1' in '${line}'
            ${pid}=    Fetch From Left    ${line}    wave
            ${pid}=    Strip String    ${pid}
            Write    kill -9 ${pid}
        END
    END

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_MaasLVIA2BStandbyMode
    [Documentation]    "Set KL15 on power blade to ON to trigger start up on MaaS Blade."
    ...    Make sure A2B booster are connected
    ...    Decrease the power supply to MaasBlade to 8V
    ...    Open putty.exe and load SoC session and click open
    ...    "To Check A2B network node discovery.
    ...    In the SOC putty:
    ...    inject : slog2info -w | grep -e ASC -e A2B"
    ...    "To capture audio: (input)
    ...    inject : mount -o remount, rw /mnt"
    ...    inject : waverec -a eight_channel_a2bc -r 48000 -n 8 -t 10 /mnt/etc/test_audio.wav
    ...    Control + C to stop capturing audio.
    ...    "To playback audio : (output)
    ...    wave -d -c1=11111111,2=11111111 -a eight_channel_a2bp /ifs/etc/test_audio.wav"
    ...    Confirm that NO sound is audible through the speakers, indicating A2B Booster is in standby mode.
    [Tags]    POWER    FID-462078.1275440    TCID-408441    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Close All Connections
    Open Connection   172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    prj.sut.power inital preconditions     powercurve_battery    8
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_disabled}
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Pause
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12
    Sleep    10
    Write    pidin ar | grep wave
    Sleep    2s
    ${pid_output}=    Read
    ${lines}=    Split To Lines    ${pid_output}
    FOR    ${line}    IN    @{lines}
        IF    'wave -d -a QNX_IntExt_1' in '${line}'
            ${pid}=    Fetch From Left    ${line}    wave
            ${pid}=    Strip String    ${pid}
            Write    kill -9 ${pid}
        END
    END
EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_MaasHVIA2BStandbyMode
    [Documentation]    Set KL15 on power blade to ON to trigger start up on MaaS Blade. 
    ...    Make sure A2B booster are connected
    ...    Increase the power supply to MaasBlade to 18V
    ...    Open putty.exe and load SoC session and click open
    ...    "To Check A2B network node discovery.
    ...    In the SOC putty:
    ...    inject : slog2info -w | grep -e ASC -e A2B"
    ...    "To capture audio: (input)
    ...    inject : mount -o remount, rw /mnt"
    ...    inject : waverec -a eight_channel_a2bc -r 48000 -n 8 -t 10 /mnt/etc/test_audio.wav
    ...    Control + C to stop capturing audio.
    ...    "To playback audio : (output)
    ...   wave -d -c1=11111111,2=11111111 -a eight_channel_a2bp /ifs/etc/test_audio.wav"
    ...    Confirm that NO sound is audible through the speakers, indicating A2B Booster is in standby mode.
    [Tags]    POWER    FID-462078.1275441    TCID-408439    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Close All Connections
    Open Connection   172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Connection is successful
    Get Connection
    prj.sut.power inital preconditions     powercurve_battery    21
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_disabled}
    Audio validation    ${sut.audio.unit1}    ${sut.audio.Channel_2}    Pause
    Sleep    1s
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    12
    Sleep    10
    Write    pidin ar | grep wave
    Sleep    2s
    ${pid_output}=    Read
    ${lines}=    Split To Lines    ${pid_output}
    FOR    ${line}    IN    @{lines}
        IF    'wave -d -a QNX_IntExt_1' in '${line}'
            ${pid}=    Fetch From Left    ${line}    wave
            ${pid}=    Strip String    ${pid}
            Write    kill -9 ${pid}
        END
    END

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_LineFaultDetection
    [Documentation]    "Set KL15 on power blade to ON to trigger start up on MaaS Blade."
    ...    Short Vcc of A2B Booster to its GND and look for error code in Fault memory.
    ...    Unshort Vcc of A2B Booster to its GND and look for error code in Fault memory.
    [Tags]    POWER    FID-462078.1275443,462078.1275447    TCID-411863    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    Check Test point voltage    equalto    audio_VDC
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    bits_platform.Output Set Digital Signal Value    audio_short_ground    ON
    Sleep    20s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_a2b_bus_defect_master_short_to_ground_bn_Resp}
    bits_platform.Output Set Digital Signal Value    audio_short_ground    OFF
    Sleep    20s



EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_PowerFaultDetection(OpenCircuit)
    [Documentation]    "Set KL15 on power blade to ON to trigger start up on MaaS Blade."
    ...    "Plug in A2B lines to MaaS Blade. 
    ...    Reboot MaaS Blade if required."
    [Tags]    POWER    FID-462078.1275443,462078.1275444,462078.1275445    TCID-411864    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    Check Test point voltage    equalto    audio_VDC
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    bits_platform.Output Set Digital Signal Value    audio_disconnected    ON
    Sleep    20s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    Sleep    5s
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_a2b_bus_connection_fault_open_wire_node_Resp}
    bits_platform.Output Set Digital Signal Value    audio_disconnected    OFF
    Sleep    20s

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_PowerFaultDetection(ShortToBattery)
    [Documentation]    "Set KL15 on power blade to ON to trigger start up on MaaS Blade."
    ...    Short Vcc of A2B Booster to battery anode terminal (positive terminal) and look for error code in Fault memory.
    ...    Unshort Vcc of A2B Booster to battery anode terminal and look for error code in Fault memory.
    [Tags]    POWER    FID-462078.1275443,462078.1275444,462078.1275446    TCID-411862    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    Check Test point voltage    equalto    audio_VDC
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    bits_platform.Output Set Digital Signal Value    audio_short_battery    ON
    Sleep    20s
    prj.sut.can.diag.send    ${sut.diag.ClearDiagnosticsService_Req}
    Sleep    3s
    prj.sut.diag.compare    ${sut.diag.ClearDiagnosticsService_Resp}
    Sleep    5
    # Send Check DTC command
    prj.sut.can.diag.send    ${sut.diag.ReportDTCByStatusMask_SafetyDTC_Req}
    prj.sut.diag.compare.byte.range    ${sut.diag.ReportDTCByStatusMask_Resp}    0    8
    prj.sut.diag.checkbyte    ${sut.diag.ReportDTCByStatusMask_a2b_bus_defect_master_short_to_vbat_bn_Resp}
    bits_platform.Output Set Digital Signal Value    audio_short_battery    OFF
    Sleep    20s

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_PhantomSupply
    [Documentation]    "Set KL15 on power blade to ON to trigger start up on MaaS Blade."
    ...    Measure the A2B voltage supplied from A2B terminal.
    [Tags]    POWER    FID-462078.1275436,462078.1275435,462078.1275434    TCID-411861    FULLTEST

    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    Check Test point voltage    equalto    audio_VDC

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_VmaxVminForA2B
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade. 
    ...    Set KL30 voltage to 9.0V, 14.0V and 16.0V. Monitor voltage to A2B.
    [Tags]    POWER    FID-462078.1275437,462078.1275438    TCID-432803    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    9.0
    Sleep    50s
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    Check Test point voltage    equalto    audio_VDC
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    14    
    Sleep    50s
    Check Test point voltage    equalto    audio_VDC
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}
    prj.sut.connect.dlt.Verify DLT keyword not present in log    ${sut.power.DTL_log.A2B_disabled}
    prj.sut.power.add.voltage.to.dictionary.check    powercurve_battery    16    
    sleep    50s
    Check Test point voltage    equalto    audio_VDC
    Verify DLT keyword offline  ${sut.power.DTL_log.A2B_enabled}

EnvD_SysQual_PowerManagementSubsystem_PowerSupplyForA2BBooster_PowerFaultDetection(OverCurrent)
    [Documentation]    Click "Startup/shutdown" on CAN simulation to trigger startup on MaaS Blade. 
    ...    Use ELoad to trigger current load to more than 300mA and look for error code in Fault memory.
    [Tags]    POWER    FID-462078.1275443,462078.1275448    TCID-432802    FULLTEST
    prj.sut.power inital preconditions    powercurve_battery    12.0
    Sleep    30s
    Verify DLT keyword offline  ${sut.power.DLT.normalvoltage_2}
    prj.sut.Power.DTL logs for normal funcational state of DUT
    Log    Use ELoad to trigger current load to more than 300mA but the testcase is obselete

