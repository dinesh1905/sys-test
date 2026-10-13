"""
Project specific testbench robotarm module for bench_remote setup. This implements all robotarm
commands specifically for this setup using BITS-Platform robotarm control.
"""

from time import sleep
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn

MODULE_NAME    = "robotarm.py"
MODULE_VERSION = "0.0.1"
MODULE_DATE    = "22.09.2022"
MODULE         = MODULE_NAME + " v" + MODULE_VERSION + " / " + MODULE_DATE


@library
class robotarm(): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ project.testbench.bench_remote implementation of robot module. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = MODULE_VERSION
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    def __init__(self, this_module=MODULE):
        self.this_module = this_module
        self.module_prefix = "prj.testbench.robot."
        BuiltIn().log(self.this_module + " entered", "INFO")


    def __del__(self):
        BuiltIn().log(self.this_module + " done.", "INFO")


    @keyword
    def press_and_release_softkey(self, softkey_name: str, hold_time: int) -> bool:
        """
        Moves robot arm to position of defined softkey and presses .. holds and releases it with the manipulator.\n
        = Interfaces =\n
        IN_1:  ``softkey_name`` (str): Name of the softkey.\n
        IN_2:  ``hold_time`` (int): Hold time between press and release events in milliseconds.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None

        # implementation using BITS-Platform as relays test app

        # ack = bits_platform.output_set_digital_signal_value(sSignalName=softkey_name,sState='ON')
        ack = BuiltIn().run_keyword('bits_platform.output_set_digital_signal_value', softkey_name, 'ON')
        sleep(float(hold_time/1000))
        # ack = bits_platform.output_set_digital_signal_value(sSignalName=softkey_name,sState='OFF')
        ack = BuiltIn().run_keyword('bits_platform.output_set_digital_signal_value', softkey_name, 'OFF')

        return ack
