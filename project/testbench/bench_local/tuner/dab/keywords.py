"""
Project specific testbench tuner_dab module for bench_local setup. This implements all tuner_dab
commands specifically for this setup using BITS-Platform device control.
"""

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

MODULE_NAME    = "tuner_dab.py"
MODULE_VERSION = "0.0.2"
MODULE_DATE    = "25.10.2022"
MODULE         = MODULE_NAME + " v" + MODULE_VERSION + " / " + MODULE_DATE


@library
class keywords(): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ project.testbench.bench_local implementation of tuner_dab module. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = MODULE_VERSION
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    def __init__(self, this_module=MODULE):
        self.this_module = this_module
        self.module_prefix = "prj.testbench.tuner.dab."
        BuiltIn().log(self.this_module + " entered", "INFO")


    def __del__(self):
        BuiltIn().log(self.this_module + " done.", "INFO")


    @keyword
    def set_generator_defaults(self, device_id:int, frequency:float, level:float) -> bool:
        """
        Configure a signal generator for tuner output (default settings of a tuner channel).\n
        = Interfaces =\n
        IN_1: ``device_id`` (int): Identifier of the device.\n
        IN_2: ``frequency`` (float): Frequency to set (in MHz).\n
        IN_3: ``level`` (float): Level to set (in dBuV).\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = False

        # string conversion because BITS-Platform accepts only strings
        device_id = str(device_id)
        frequency = str(frequency)
        level = str(level)

        # implementation using BITS-Platform as tuner test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.dab_initialize_device(device_id)
        if ack:
            ack = bp_lib.dab_set_main_configuration(unit=device_id, frequency=frequency,
                        level=level, output='ON')

        return ack


    @keyword
    def set_parameter(self, device_id:int, parameter:str, value) -> bool:
        """
        Set a single parameter of a signal generator. Only predefined parameter of a FM
        tuner channel can be modified with this keyword.\n
        = Interfaces =\n
        IN_1: ``device_id`` (int): Identifier of the device.\n
        IN_2: ``parameter`` (str): Name of the parameter.\n
        IN_3: ``value`` (Any): Value to set (data type is depending on ``parameter``).\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = False

        # string conversion because BITS-Platform accepts only strings
        device_id = str(device_id)
        value = str(value)

        # implementation using BITS-Platform as tuner test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.dab_set_parameter(unit=device_id, parameter_name=parameter,
                    value=value)

        return ack
