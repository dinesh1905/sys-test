*** Settings ***
Documentation    Project specific testbench power module for bench_remote setup. This implements all power
...              commands specifically for this setup using BITS-Platform Power Module.

Resource   ${TAF_PATH}/import.resource
Library    BuiltIn


*** Keywords ***
prj.testbench.power: Set Output Voltage
    [Arguments]    ${s_channel_name}  ${f_voltage}
    [Documentation]    Sets the provided power supply output channel to a given voltage in volts.
    ...    Returns positive acknowledgement if this keyword was executed successfully.\n
    ...    = Interfaces =\n
    ...    IN  ``s_channel_name``(str): Name of the power supply output channel, e.g. BATTERY\n
    ...    IN  ``f_voltage``(float): Output voltage to be set on given power supply channel. Value in volts [V].\n
    ...    OUT ``b_ack``: Keyword execution acknowledgement

    # init local variables
    Set Local Variable    ${b_ack}    ${False}

    # implementation using BITS-Platform power module as power test app
    ${s_voltage}    Convert To String    ${f_voltage}
    ${b_ack}    bits_platform.Output Set Analog Signal Value    ${s_channel_name}    ${s_voltage}

    RETURN    ${b_ack}

prj.testbench.power: Measure Current
    [Arguments]    ${s_channel_name}
    [Documentation]    Triggers a single measurement of electric current on the requested power channel.\n
    ...    = Interfaces =\n
    ...    IN:    ``s_channel_name`` (str): Name of the power channel to be measured.\n
    ...    OUT_1: ``b_ack`` (bool): Keyword execution acknowledgement.\n
    ...    OUT_2: ``f_current`` (float): Measured value of electric current [A].

    # init local variables
    Set Local Variable    ${b_ack}    ${False}
    Set Local Variable    ${f_current}    ${-9999}

    # implementation using BITS-Platform power module as power test app
    ${b_ack}    ${s_result}    bits_platform.Input Get Signal Value    ${s_channel_name}

    IF    ${b_ack}
        ${f_current}    Convert To Number    ${s_result}
    END

    RETURN    ${b_ack}    ${f_current}

prj.testbench.power: Measure Voltage
    [Arguments]    ${s_channel_name}
    [Documentation]    Triggers a single measurement of electric voltage on the requested power channel.\n
    ...    = Interfaces =\n
    ...    IN:    ``s_channel_name`` (str): Name of the power channel to be measured.\n
    ...    OUT_1: ``b_ack`` (bool): Keyword execution acknowledgement.\n
    ...    OUT_2: ``f_voltage``(float): Measured value of electric voltage [V].

    # init local variables
    Set Local Variable    ${b_ack}    ${False}
    Set Local Variable    ${f_voltage} = ${-9999}

    # implementation using BITS-Platform power module as power test app
    ${b_ack}    ${s_result}    bits_platform.Input Get Signal Value    ${s_channel_name}

    IF    ${b_ack}
        ${f_voltage}    Convert To Number    ${s_result}
    END

    RETURN    ${b_ack}    ${f_voltage}
