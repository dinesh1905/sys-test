*** Settings ***
Documentation    Project specific ethernet and  CAN keywords
Resource    ${TAF_PATH}/import.resource
Library    BuiltIn
Library    Process
Library    SSHLibrary
Library    QConnectBase.ConnectionManager
Library    ${TAF_PATH}/project/test/suites/sw_download/ethswitch.py


*** Keywords ***
prj.sut.soc.Run And Kill Wave On QNX Console
    [Documentation]    Helper Keyword to kill the wave process
    Open Connection    172.21.0.10    None    22
    Login    root    maasdev    allow_agent=${True}
    Log To Console    Initiate the kill action
    Sleep    1s

    Write    pidin ar | grep wave
    Sleep    1s
    ${pid_result}    Read
    Log To Console    pidin output: ${pid_result}

    ${lines}    Split To Lines    ${pid_result}
    FOR    ${line}    IN    @{lines}
        ${is_wave}    Run Keyword And Return Status    Should Contain    ${line}    wave -d -a
        IF    ${is_wave}
            ${parts}    Split String    ${line}
            ${pid}    Set Variable    ${parts}[0]
            ${pid}    Strip String    ${pid}
            Log To Console    Killing wave PID: ${pid}
            Write    kill -9 ${pid}
            Sleep    1s
            BREAK
        END
    END

prj.sut.soc.Run ADB Command
    [Documentation]    Runs an adb command and returns stdout. Fails on non-zero RC.
    [Arguments]    ${cmd}
    Log    Executing: adb ${cmd}
    ${result}=    Run Process    adb    {cmd.split()}
    ...           cwd=${sut.soc.ADB_PATH}    stdout=PIPE    stderr=PIPE    shell=False
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Should Be Equal As Integers    ${result.rc}    0
    ...    msg=ADB command failed: adb ${cmd}\nSTDERR: ${result.stderr}
    RETURN    ${result.stdout}

prj.sut.soc.Run ADB Command With Args
    [Documentation]    Runs adb with a pre-split argument list.
    [Arguments]    @{args}
    ${adb_exe}=    Set Variable    ${sut.soc.ADB_PATH}${/}adb.exe
    Log    Executing: ${adb_exe} ${args}
    ${result}=    Run Process    ${adb_exe}    @{args}
    ...           stdout=PIPE    stderr=PIPE    shell=False
    Log    STDOUT: ${result.stdout}
    Log    STDERR: ${result.stderr}
    Should Be Equal As Integers    ${result.rc}    0
    ...    msg=ADB command failed\nSTDERR: ${result.stderr}
    RETURN    ${result.stdout}

prj.sut.soc.ADB Connect
    [Arguments]    ${ip}
    Log    Connecting to ${ip}
    ${out}=    prj.sut.soc.Run ADB Command With Args    connect    ${ip}


    Should Contain    ${out}    connected
    ...    msg=ADB connect failed: ${out}

prj.sut.soc.ADB Root
    Log    Gaining root access
    ${out}=    prj.sut.soc.Run ADB Command With Args    root
    Log    ${out}
    # Allow adbd to restart as root
    Sleep    5s

prj.sut.soc.ADB devices
    Log    Find adb devices
    ${out}=    prj.sut.soc.Run ADB Command With Args    devices
    Log    ${out}
    Sleep    5s
    
prj.sut.soc.Verify Device Online
    [Documentation]    Confirms device is in adb devices, auto-recovers once if missing.
    [Arguments]    ${recovery_attempt}=${0}
    Log    Verifying device is listed in adb devices    console=True
    ${out}=    prj.sut.soc.Run ADB Command With Args    devices
    Log    ADB devices output: ${out}    console=True

    ${device_present}=    Run Keyword And Return Status
    ...    Should Contain    ${out}    ${sut.soc.TARGET_IP}

    IF    ${device_present} == ${FALSE}
        IF    ${recovery_attempt} >= 2
            Fail    Device ${sut.soc.TARGET_IP} not reachable after ${recovery_attempt} recovery attempts. Check hardware/network.
        END
        ${next_attempt}=    Evaluate    ${recovery_attempt} + 1
        Log    Device missing — recovery attempt ${next_attempt}...    console=True
        prj.sut.soc.ADB Connect With Retry
        prj.sut.soc.ADB Root
        prj.sut.soc.Verify Device Online    recovery_attempt=${next_attempt}
    ELSE
        Log    Device ${sut.soc.TARGET_IP} confirmed online    console=True
    END

prj.sut.soc.ADB Push Media File
    Log    Pushing ${sut.soc.MEDIA_FILE} to /data/
    prj.sut.soc.Run ADB Command With Args    push    ${sut.soc.MEDIA_FILE}    ./data

prj.sut.soc.ADB Disable Verity
    Log    Disabling verity
    ${out}=    prj.sut.soc.Run ADB Command With Args    disable-verity
    Log    ${out}

prj.sut.soc.ADB Reboot And Power Cycle
    Log    Rebooting device...
    prj.sut.soc.Run ADB Command With Args    reboot
    Log    Waiting ${sut.soc.WAIT_REBOOT} for device to shut down and reboot
    Sleep    ${sut.soc.WAIT_REBOOT}
    prj.sut.disconnect.dlt
    bits_platform.Output Set Analog Signal Value    powercurve_battery    0
    Sleep    10s
    prj.sut.connect.QNX
    prj.sut.connect.dlt
    bits_platform.Output Set Analog Signal Value    powercurve_battery    12
    Sleep    10s
    # Wait for device to come back online after power cycle
    Sleep    60s
    Log    Waiting for device to come back online

prj.sut.soc.Remount Vendor RW
    Log    Remounting /vendor as read-write
    prj.sut.soc.Run ADB Command With Args    shell    mount -o rw,remount /vendor

prj.sut.soc.Set SELinux Permissive
    [Documentation]    Sets SELinux to Permissive and validates output is Permissive.
    Log    Setting SELinux to Permissive
    ${out}=    prj.sut.soc.Run ADB Command With Args
    ...    shell    setenforce 0; getenforce
    Log    SELinux status: ${out}
    Should Contain    ${out}    Permissive
    ...    msg=SELinux did not switch to Permissive! Got: ${out}

prj.sut.soc.Launch Video On Gallery
    [Documentation]    Launches waterdrop.mp4 inside adb shell via Gallery3D MovieActivity.
    Log    Launching video player on device
    prj.sut.soc.Run ADB Command With Args
    ...    shell    am start -n com.android.gallery3d/.app.MovieActivity -d /data/waterdrop.mp4

prj.sut.soc.ADB Connect With Retry
    [Documentation]    Retries adb connect until device is online or timeout is reached.
    [Arguments]    ${timeout}=120s    ${retry_interval}=5s
    ${adb_exe}=    Set Variable    ${sut.soc.ADB_PATH}${/}adb.exe
    Log    Attempting ADB connect to ${sut.soc.TARGET_IP} with retry (timeout=${timeout})    console=True
    ${timeout_secs}=       Convert Time    ${timeout}
    ${interval_secs}=      Convert Time    ${retry_interval}
    ${elapsed}=            Set Variable    ${0}
    ${connected}=          Set Variable    ${FALSE}

    WHILE    ${connected} == ${FALSE}
        ${result}=    Run Process
        ...    ${adb_exe}    connect    ${sut.soc.TARGET_IP}
        ...    stdout=PIPE    stderr=PIPE    shell=False
        Log    Attempt output: ${result.stdout}    console=True

        ${connected}=    Run Keyword And Return Status
        ...    Should Contain    ${result.stdout}    connected

        IF    ${connected} == ${TRUE}
            Log    Successfully connected to ${sut.soc.TARGET_IP}    console=True
        ELSE
            ${elapsed}=    Evaluate    ${elapsed} + ${interval_secs}
            IF    ${elapsed} >= ${timeout_secs}
                Fail    ADB connect timed out after ${timeout}. Device not reachable at ${sut.soc.TARGET_IP}.
            END
            Log    Not connected yet. Retrying in ${retry_interval}... (${elapsed}s elapsed)    console=True
            Sleep    ${retry_interval}
        END
    END

prj.sut.soc.ADB Media Push And SELinux Permissive Setup
    [Documentation]    Full setup: connect, push media, disable-verity, reboot,
    ...                remount vendor, set SELinux Permissive, launch video.
    [Tags]    ADB    MediaSetup    SELinux

    # --- Phase 1: Initial connect and push ---
     
    prj.sut.soc.ADB Connect    ${sut.soc.TARGET_IP}
    prj.sut.soc.ADB Root
    prj.sut.soc.ADB Push Media File
    prj.sut.soc.ADB Disable Verity

    # --- Phase 2: Reboot and power cycle ---

    prj.sut.soc.ADB Reboot And Power Cycle

    # --- Phase 3: Reconnect and configure ---
    prj.sut.soc.ADB Connect With Retry
    prj.sut.soc.ADB Root
    prj.sut.soc.Verify Device Online
    prj.sut.soc.Remount Vendor RW

    # --- Phase 4: SELinux Permissive && Launch video ---
    prj.sut.soc.Set SELinux Permissive
    prj.sut.soc.Launch Video On
