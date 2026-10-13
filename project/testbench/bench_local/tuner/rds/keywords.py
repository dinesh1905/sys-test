"""
Project specific testbench tuner_rds module for bench_local setup. This implements all tuner_rds
commands specifically for this setup using BITS-Platform device control.
"""

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

MODULE_NAME    = "tuner_rds.py"
MODULE_VERSION = "0.0.2"
MODULE_DATE    = "25.10.2022"
MODULE         = MODULE_NAME + " v" + MODULE_VERSION + " / " + MODULE_DATE


@library
class keywords(): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ project.testbench.bench_local implementation of tuner_rds module. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = MODULE_VERSION
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    def __init__(self, this_module=MODULE):
        self.this_module = this_module
        self.module_prefix = "prj.testbench.tuner.rds."
        BuiltIn().log(self.this_module + " entered", "INFO")


    def __del__(self):
        BuiltIn().log(self.this_module + " done.", "INFO")


    @keyword
    def set_coder_defaults(self, device_id:int, frequency:float, level:float, tone:int, slot_number:int) -> bool:
        """
        Configure a RDS coder for tuner output (default settings of a tuner channel).\n
        = Interfaces =\n
        IN_1: ``device_id`` (int): Identifier of the device.\n
        IN_2: ``frequency`` (float): Frequency to set (in MHz).\n
        IN_3: ``level`` (float): Level to set (in dBuV).\n
        IN_4: ``tone`` (int): Audio feedback signal to set (in kHz).\n
        IN_5: ``slot_number`` (int): Program slot number to select.\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = False

        # string conversion because BITS-Platform accepts only strings
        device_id = str(device_id)
        frequency = str(frequency)
        level = str(level)
        tone = str(tone)
        slot_number = str(slot_number)

        # implementation using BITS-Platform as tuner test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.rdscoder_initialize_coder(unit=device_id)
        if ack:
            ack = bp_lib.rdscoder_configure_coder(unit=device_id, frequency=frequency,
                        level=level, af=tone, slot=slot_number)

        return ack


    @keyword
    def set_parameter(self, device_id:int, parameter:str, value) -> bool:
        """
        Set a single parameter of a RDS coder. Only predefined parameter of a FM_RDS
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
        ack = bp_lib.rdscoder_set_parameter(unit=device_id, parameter_name=parameter,
                    value=value)

        return ack



    @keyword
    def load_slot_list(self, device_id:int, file_path:str) -> bool:
        """
        Load a slot list into a RDS Coder.\n
        = Interfaces =\n
        IN_1: ``device_id`` (int): Identifier of the device.\n
        IN_2: ``file_path`` (str): Absolute path of the slot list (including file name).\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # string conversion because BITS-Platform accepts only strings
        device_id = str(device_id)

        # implementation using BITS-Platform as tuner test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')
        ack = bp_lib.rdscoder_load_slot_list(unit=device_id, file=file_path)

        return ack
