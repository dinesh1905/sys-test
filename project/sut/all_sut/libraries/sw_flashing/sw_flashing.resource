*** Settings ***
Documentation    Project specific software download keywords
Resource    ${TAF_PATH}/import.resource
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_secureboot.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui.py
Library    ${TAF_PATH}/project/test/suites/sw_download/auto_flash_flashgui_archive.py


*** Variables ***
# ${PCSUTSERIALNUMBERJENKINS}    ${PCSUTSERIALNUMBERJENKINS}
# ${SUTSERIALNUMBER}    ${EMPTY}
${VOLTAGE_TOLERANCE_1}    0.1
${VOLTAGE_TOLERANCE_2}    0.2


*** Keywords ***
USB toggle to connect qualcomm
    [Documentation]    Toggling the Cleware to establish qualcomm connetion
    # Use cleware to toggle qualcomm connection to ON
    bits_platform.output set digital signal value    USB_Qualcomm    OFF
    bits_platform.output set digital signal value    USB_Qualcomm    ON

prj.sut.usb toggle debug board switch On
    [Documentation]    Toggling the debug board switch to enable flashing

    # Use Gen-5.6 to toggle H1000 to ON
    bits_platform.output set digital signal value    H1000    1
    Sleep    2s
    # Use Gen-5.6 to toggle H1005 to ON
    bits_platform.output set digital signal value    H1005    1
    Sleep    2s
    # Use Gen-5.6 to toggle H1007 to ON
    bits_platform.output set digital signal value    H1007    1
    Sleep    2s
    # Use Gen-5.6 to toggle H1008 to ON
    bits_platform.output set digital signal value    H1008    1
    Log To Console    Toggle CPU_PWR to ON
    Sleep    2s
    # Use Gen-5.6 to toggle CPU_PWR to ON
    bits_platform.output set digital signal value    CPU_PWR    1

prj.sut.usb toggle debug board switch Off
    [Documentation]    Toggling the debug board switch to disable flashing

    # Use Gen-5.6 to toggle H1000 to OFF
    bits_platform.output set digital signal value    H1000    0
    Sleep    2s
    # Use Gen-5.6 to toggle H1005 to OFF
    bits_platform.output set digital signal value    H1005    0
    Sleep    2s
    # Use Gen-5.6 to toggle H1007 to OFF
    bits_platform.output set digital signal value    H1007    0
    Sleep    2s
    # Use Gen-5.6 to toggle H1008 to OFF
    bits_platform.output set digital signal value    H1008    0
    Sleep    2s
    # Use Gen-5.6 to toggle CPU_PWR to OFF
    bits_platform.output set digital signal value    CPU_PWR    0
    Log to Console    Toggling the debug board switch to OFF (ALL)

prj.sut.usb toggle debug board switch Off &Watchdog/DNL ON
    [Documentation]    Toggling the debug board switch to disable flashing

    # Use Gen-5.6 to toggle H1000 to OFF
    bits_platform.output set digital signal value    H1000    0
    Sleep    2s
    # Use Gen-5.6 to toggle H1005 to OFF
    bits_platform.output set digital signal value    H1005    0
    Sleep    2s
    # Use Gen-5.6 to toggle H1007 to OFF
    bits_platform.output set digital signal value    H1007    1
    Sleep    2s
    # Use Gen-5.6 to toggle H1008 to OFF
    bits_platform.output set digital signal value    H1008    1
    Sleep    2s
    # Use Gen-5.6 to toggle CPU_PWR to OFF
    bits_platform.output set digital signal value    CPU_PWR    0
    Log to Console    Toggling the debug board switch to OFF
    Log to Console    Only DNL and Watchdog is ON

prj.sut.usb debug board connect
    [Documentation]    Connect Debubg Board Gen 5.6
    bits_platform.System Connect Device    Gen5_DebugBoard_1
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC Control
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=DSP/AVB-C Control
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=CPU Control
    Sleep    2s

prj.sut.boot mode on
    [Documentation]    To check if the DUT has entered boot mode.
    [Arguments]    ${SUTSERIALNUMBER}
    FOR    ${counter}    IN RANGE    0    4
        # init variable
        Log To Console    Attempt ${counter}
        Set Local Variable    ${bAck}    ${True}
        # Check current of DUT
        ${b_ack}    ${s_result}    bits_platform.input get signal value    Battery_Current
        Log To Console    The current is ${s_result} ${b_ack}
        ${s_response}    ${sDeviceState}    ${sDeviceSerial}    auto_flash_secureboot.get device state    ${SUTSERIALNUMBER}
        Log To Console    *****************The current state of DUT is : ${s_response} ${sDeviceState} ${sDeviceSerial} ${s_result}********
        IF    "0.2" <= "${s_result}" <= "1.5" and "${sDeviceState}" != " " and ${s_response} == ${True}
            #  IF    "0.2" <= "${s_result}" <= "1.5" and ${s_response} == ${True}
                Log    The current ${s_result} is more than 0.3    console=yes
                Set Local Variable    ${bAck}    ${True}
                Log To Console    Exiting for loop
                BREAK

        ELSE
                Log    Device did not go to boot mode.! Start to toggle debug board   console=yes
                # Use Gen-5.6 to toggle CPU_PWR to ON
                ${ack}    ${result}    bits_platform.System Get Connect State Device    Gen5_DebugBoard_1
                Log To Console    The Debug board is : ${result}
                IF    "${result}" == "DISCONNECT"
                    bits_platform.System Connect Device    Gen5_DebugBoard_1
                    Sleep    2s
                ELSE IF    "${result}" == "NONE"
                    Log To Console    No Debug remote control is opened
                    bits_platform.System Connect Device    Gen5_DebugBoard_1
                    Sleep    2s
                ELSE
                    bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
                    Sleep    2s
                    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC Control
                    Sleep    2s
                    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=DSP/AVB-C Control
                    Sleep    2s
                    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=CPU Control
                    Sleep    2s
                    prj.sut.usb toggle debug board switch On
                END
                bits_platform.output set digital signal value    CPU_PWR    1
                bits_platform.output set digital signal value    CPU_PWR    0
                prj.sut.power cycle
                # prj.sut.can.simulation.PowerBladeOFF
                # prj.sut.can.simulation.PowerBladeON
                Set Local Variable    ${bAck}    ${False}
        END
    END

    IF    ${bAck} == ${True}
        Log to console    DUT Went in to boot mode!
    ELSE
        framework.set test status to fail    DUT did not go into Boot Mode status.
    END

prj.sut.power cycle
    [Documentation]    Power cycle before any step of flashing.
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    prj.sut.can.simulation.Stop
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON
    Log To Console    Power cycle is done!

prj.sut.power cycle.and.wait
    [Documentation]    Power cycle before any step of flashing.
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0
    Sleep    3s
    prj.sut.can.simulation.Stop
    bits_platform.Output Set Analog Signal Value    Ignition    12
    bits_platform.Output Set Analog Signal Value    Battery    12
    prj.sut.can.simulation.Start
    prj.sut.can.simulation.PowerBladeON
    prj.sut.can.diag.tester.present.active
    Log To Console    Power cycle is done!
    Sleep    60s


prj.sut.power off
    [Documentation]    Turn OFF power supply (kl30)
    bits_platform.Output Set Analog Signal Value    Battery    0

prj.sut.power on
    [Documentation]    Turn OFF power supply (kl30)
    bits_platform.Output Set Analog Signal Value    Battery    12

prj.sut.ignition off
    [Documentation]    Turn OFF Ignition (KL.15)
    bits_platform.Output Set Analog Signal Value    Ignition    0

prj.sut.ignition on
    [Documentation]    Turn OFF Ignition (KL.15)
    bits_platform.Output Set Analog Signal Value    Ignition    12

prj.sut.toellner off
    [Documentation]    Set toellner off.
    bits_platform.Output Set Analog Signal Value    Battery    0
    bits_platform.Output Set Analog Signal Value    Ignition    0

prj.sut.toellner on
    [Documentation]    Set toellner off.
    bits_platform.Output Set Analog Signal Value    Battery    12
    bits_platform.Output Set Analog Signal Value    Ignition    12

prj.sut.load.pcanSUTserial
    [Documentation]    Choosing the right serial number for pcat flashing based on pc and sut.
    [Arguments]    ${PCSUTSERIALNUMBERJENKINS}
    IF    "${PCSUTSERIALNUMBERJENKINS}" == "${sut.auto_flash.hardware_info.pg9c0012p.sut2.pcat_serialnumber}"
        Set Global Variable    ${SUTSERIALNUMBER}    ${sut.auto_flash.hardware_info.pg9c0012p.sut2.pcat_serialnumber}
    ELSE IF    "${PCSUTSERIALNUMBERJENKINS}" == "${sut.auto_flash.hardware_info.pg1ut078c.sut1.pcat_serialnumber}"
        Set Global Variable    ${SUTSERIALNUMBER}    ${sut.auto_flash.hardware_info.pg1ut078c.sut1.pcat_serialnumber}
    ELSE IF    "${PCSUTSERIALNUMBERJENKINS}" == "${sut.auto_flash.hardware_info.pg9c001xa.sut1.pcat_serialnumber}"
        Set Global Variable    ${SUTSERIALNUMBER}    ${sut.auto_flash.hardware_info.pg9c001xa.sut1.pcat_serialnumber}
    ELSE IF    "${PCSUTSERIALNUMBERJENKINS}" == "F77C8595"
        Set Global Variable    ${SUTSERIALNUMBER}    F77C8595
    ELSE IF    "${PCSUTSERIALNUMBERJENKINS}" == "CB582FCE"
        Set Global Variable    ${SUTSERIALNUMBER}    CB582FCE
    ELSE IF    "${PCSUTSERIALNUMBERJENKINS}" == "2F9DAC6D"
        Set Global Variable    ${SUTSERIALNUMBER}    2F9DAC6D
    ELSE IF    "${PCSUTSERIALNUMBERJENKINS}" == "AF616138"
        Set Global Variable    ${SUTSERIALNUMBER}    AF616138
        Log To Console    Using other C sample to flash
    END
    RETURN    ${SUTSERIALNUMBER}

prj.sut.power.add.voltage.to.dictionary.check
    [Documentation]    Creating a range for voltage being set.
    [Arguments]    ${sSignal}    ${voltage}

    ${voltage_readings}    Create List
    ${voltage_float}    Evaluate    float(${voltage})
    ${Adjusted_Voltage_1}    Evaluate     float("%.1f" % (${voltage_float} - ${VOLTAGE_TOLERANCE_1}))
    ${Adjusted_Voltage_2}    Evaluate    float("%.1f" % (${voltage_float} - ${VOLTAGE_TOLERANCE_2}))

    Log To Console    ${Adjusted_Voltage_1} ${Adjusted_Voltage_2}
    Append To List    ${voltage_readings}    ${Adjusted_Voltage_1}    ${voltage_float}    ${Adjusted_Voltage_2}
    bits_platform.Output Set Analog Signal Value    ${sSignal}    ${voltage}
    Sleep    5s
    ${Temp_Log}    OperatingSystem.Get File    D:/tmp/LogFile/${TEST_NAME}/log.txt    encoding_errors=ignore
    FOR    ${i}    IN RANGE   0    3
        Log To Console    Searching for: UBAT voltage ${voltage_readings}[${i}]
        ${pattern_search}    Set Variable    UBAT voltage is ${voltage_readings}[${i}]
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
        Set Test Status To Fail    error_type=Power    info_text=None of the voltage ${voltage_readings} Match!
    END

prj.sut.debug connect and toggle off
    [Documentation]    Connect debug board and turn off all switch
    bits_platform.System Connect Device    Gen5_DebugBoard_1
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET REMOTEMODE=ON
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=SCC Control
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=DSP/AVB-C Control
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET CONTROL=CPU Control
    Sleep    2s
    prj.sut.usb toggle debug board switch Off

Archive.Aurix.Flashing
    [Documentation]    Flashing Aurix Debug Version
    [Tags]    AUTO_FLASHING    SWDOWNLOAD
    [Arguments]    ${KDS_FLASH}    ${HSM_ENABLE}
    #  Start flashing
    log to console    Flashing Aurix version : in archive folder
    Sleep    5s
    Log To Console    Hi! Flashing Aurix Debug is Starting.

    #  switch off debug board and power cycle before aurix flashing
    prj.sut.usb toggle debug board switch Off &Watchdog/DNL ON

    # Close Remote Debug Board program for FlashGUI to start
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_EXIT
    Sleep    2s
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_CLOSE
    Close DebugBoard RemoteControl
    prj.sut.power cycle
    prj.sut.can.simulation.Stop
    # Set Global variable for HSM_Status
    IF    "${HSM_ENABLE}" == "true"
        Set Global Variable    ${Jenkins_HSM_Status}    ${True}
    ELSE
        Set Global Variable    ${Jenkins_HSM_Status}    ${False}
    END

    IF    "${KDS_FLASH}" == "true"
               ${status}    auto_flash_flashgui_archive.flash gui flash archive    virgin    ${sut.auto_flash.flashgui.flashgui_COMport}
        ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
        ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}
        ...    ${sut.auto_flash.flashgui.flashgui_program_ucb}
    ELSE
               ${status}    auto_flash_flashgui_archive.flash gui flash archive   update    ${sut.auto_flash.flashgui.flashgui_COMport}
        ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
        ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}
        ...    ${sut.auto_flash.flashgui.flashgui_program_ucb}
    END

    IF    ${status}
        Log To Console    MCU flashing from archive folder was successful . Flashing completed.Now Power cycle to apply changes
        prj.sut.debug connect and toggle off
        prj.sut.power cycle
    ELSE
        framework.set test status to fail    Failure in MCU flash in archive folder
    END
    Log To Console    Flashing MCU from archive folder ends

Aurix.Flashing.Same.Software
    [Documentation]    Function to flash normal Aurix binary
    [Arguments]    ${KDS_FLASH}    ${HSM_ENABLE}
    #  switch off debug board and power cycle before aurix flashing
    prj.sut.usb toggle debug board switch Off &Watchdog/DNL ON

    # Close Remote Debug Board program for FlashGUI to start
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_EXIT
    bits_platform.System Send Command    Gen5_DebugBoard_1    SET PROGRAM_CLOSE
    Close DebugBoard RemoteControl
    prj.sut.power cycle
    prj.sut.can.simulation.Stop
    Log To Console    FlashGUI Aurix Flash is starting
    # Set Global variable for HSM_Status
    IF    "${HSM_ENABLE}" == "true"
        Set Global Variable    ${Jenkins_HSM_Status}    ${True}
    ELSE
        Set Global Variable    ${Jenkins_HSM_Status}    ${False}
    END
    IF    "${KDS_FLASH}" == "true"
               ${status}    auto_flash_flashgui_archive.flash gui flash samesoftware    virgin    ${sut.auto_flash.flashgui.flashgui_COMport}
        ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
        ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}
        ...    ${sut.auto_flash.flashgui.flashgui_program_ucb}
    ELSE
               ${status}    auto_flash_flashgui_archive.flash gui flash samesoftware    update    ${sut.auto_flash.flashgui.flashgui_COMport}
        ...    ${sut.auto_flash.flashgui.flashgui_baudrate}    ${sut.auto_flash.flashgui.flashgui_DataBits}
        ...    ${sut.auto_flash.flashgui.flashgui_StopBits}    ${sut.auto_flash.flashgui.flashgui_Parity}
        ...    ${sut.auto_flash.flashgui.flashgui_program_ucb}
    END

    IF    ${status} == ${True}
        Log To Console    MCU flashing was successful . Flashing completed
        prj.sut.debug connect and toggle off
        prj.sut.power cycle
    ELSE
        framework.set test status to fail    Failure in MCU flash
    END
