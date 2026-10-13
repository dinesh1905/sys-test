"""
Project specific testbench power module for bench_local setup. This implements all power
commands specifically for this setup using BITS-Platform Power Module.
"""

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

MODULE_NAME    = "power.py"
MODULE_VERSION = "0.0.3"
MODULE_DATE    = "23.06.2022"
MODULE         = MODULE_NAME + " v" + MODULE_VERSION + " / " + MODULE_DATE


@library
class keywords(): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ project.testbench.bench_local implementation of power module. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = MODULE_VERSION
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self, this_module=MODULE):

        self.this_module = this_module
        self.module_prefix = "prj.testbench.power."
        BuiltIn().log(self.this_module + " entered", "INFO")


    def __del__(self):
        BuiltIn().log(self.this_module + " done.", "INFO")


    @keyword
    def set_output_voltage(self, channel_name: str, voltage: float) -> bool:
        """
        Sets provided power output channel to a given voltage.\n
        = Interfaces =\n
        IN_1: ``channel_name`` (str): Name of the power supply output channel, e.g. BATTERY.\n
        IN_2: ``voltage`` (float): Output voltage to be set on given power supply channel. Value
        in volts [V].\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # implementation using BITS-Platform power module as power test app
        voltage_str = str(voltage)
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.output_set_analog_signal_value(signal_name = channel_name,
                                                 value = voltage_str)

        return ack


    @keyword
    def measure_current(self, channel_name: str) -> tuple[bool, float]:
        """
        Triggers a single measurement of electric current on the requested power channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the power channel to be measured.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``current`` (float): Measured value of electric current [A].
        """

        # init local variables
        ack = None
        current = -9999

        # implementation using BITS-Platform power module as power test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack, result = bp_lib.input_get_signal_value(signal_name=channel_name)
        if ack:
            current = float(result)

        return ack, current


    @keyword
    def measure_voltage(self, channel_name: str) -> tuple[bool, float]:
        """
        Triggers a single measurement of electric voltage on the requested power channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the power channel to be measured.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``voltage``(float): Measured value of electric voltage [V].
        """

        # init local variables
        ack = None
        voltage = -9999

        # implementation using BITS-Platform power module as power test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack, result = bp_lib.input_get_signal_value(signal_name=channel_name)
        if ack:
            voltage = float(result)

        return ack, voltage
