"""
Project specific testbench tuner_fm module for bench_remote setup. This implements all tuner_fm
commands specifically for this setup using BITS-Platform device control.
"""

from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

MODULE_NAME    = "tuner_fm.py"
MODULE_VERSION = "0.0.3"
MODULE_DATE    = "14.09.2023"
MODULE         = MODULE_NAME + " v" + MODULE_VERSION + " / " + MODULE_DATE


@library
class tuner_fm(): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ project.testbench.bench_remote implementation of tuner_fm module. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = MODULE_VERSION
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    def __init__(self, this_module=MODULE):
        self.this_module = this_module
        self.module_prefix = "prj.testbench.tuner.fm."
        BuiltIn().log(self.this_module + " entered", "INFO")


    def __del__(self):
        BuiltIn().log(self.this_module + " done.", "INFO")


    @keyword
    def set_generator_defaults(self, device_id:int, frequency:float, level:float, tone:int, deviation:int) -> bool:
        """
        Configure a signal generator for tuner output (default settings of a tuner channel).\n
        = Interfaces =\n
        IN_1: ``device_id`` (int): Identifier of the device.\n
        IN_2: ``frequency`` (float): Frequency to set (in MHz).\n
        IN_3: ``level`` (float): Level to set (in dBuV).\n
        IN_4: ``tone`` (int): Audio feedback signal to set (in kHz).\n
        IN_5: ``deviation`` (int): Deviation of the modulated signal.\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = False

        # string conversion because BITS-Platform accepts only strings
        sUnit = str(device_id)
        sModulationType = 'FM'
        sModulation = 'ON'
        sModulationSource = 'int'
        sFrequency = str(frequency)
        sLevel = str(level)
        sTone = str(tone)
        sHub = str(deviation)
        sOutput = 'ON'

        # implementation using BITS-Platform as tuner test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')

        ack = bp_lib.run_keyword('rfgenerator_configure_device', [sUnit, sModulationType,
            sModulation, sModulationSource, sFrequency, sLevel, sTone, sHub, sOutput], None)

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
        sUnit = str(device_id)
        sParameterName = str(parameter)
        sValue = str(value)

        # implementation using BITS-Platform as tuner test app
        bp_lib = BuiltIn().get_library_instance('bits_platform')

        ack = bp_lib.run_keyword('rfgenerator_set_parameter', [sUnit, sParameterName, sValue], None)

        return ack
