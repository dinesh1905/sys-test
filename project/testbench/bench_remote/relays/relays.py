"""
Project specific testbench relays module for bench_remote setup. This implements all relays
commands specifically for this setup using BITS-Platform relay control.
"""

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

MODULE_NAME    = "relays.py"
MODULE_VERSION = "0.0.2"
MODULE_DATE    = "23.06.2022"
MODULE         = MODULE_NAME + " v" + MODULE_VERSION + " / " + MODULE_DATE


@library
class relays(): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ project.testbench.bench_remote implementation of relays module. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = MODULE_VERSION
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    def __init__(self, this_module=MODULE):
        self.this_module = this_module
        self.module_prefix = "prj.testbench.relays."
        BuiltIn().log(self.this_module + " entered", "INFO")


    def __del__(self):
        BuiltIn().log(self.this_module + " done.", "INFO")


    @keyword
    def set_switch_position(self, channel_name: str, switch_position: str) -> bool:
        """
        Set the switch position of the requested relay channel.\n
        = Interfaces =\n
        IN_1:  ``channel_name`` (str): Name of the relay.\n
        IN_2:  ``switch_posiion`` (str): Switch position to set (as defined in output enumeration class).\n
        OUT: ``bAck`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # implementation using BITS-Platform as relays test app
        if switch_position == "OPEN":
            switch_position = "OFF"
        else:
            switch_position = "ON"
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.output_set_digital_signal_value(sSignalName=channel_name,sState=switch_position)

        return ack


    @keyword
    def get_switch_position(self, channel_name:str) -> tuple[bool, str]:
        """
        Get the switch position of the requested relay channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the relay.\n
        OUT_1: ``switch_position`` (str): Current switch position (as defined in output enumeration class).\n
        OUT_2: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        switch_position = None

        # implementation using BITS-Platform as relays test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack, result = bp_lib.input_get_digital_signal_value(sSignalName=channel_name)
        if ack:
            # float conversion, because BITS-Platform always return string values
            if float(result) == 0:
                switch_position = "OPEN"
            else:
                switch_position = "CLOSE"

        return ack, switch_position
