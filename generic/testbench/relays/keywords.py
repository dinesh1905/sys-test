'''
Generic testbench relays module. This implements all relays commands in generic way by means of
abstract keywords indedepended from any specific testbench setup.
'''

from enum import Enum
from robotlibcore import DynamicCore
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.testbench.relays.manager import RelaysManager
from generic.framework.framework import framework


class output(Enum): #pylint: disable=C0103:invalid-name disable=R0903:too-few-public-methods
    """ Definition of switch positions (OPEN = 0, CLOSE = 1 ). """
    OPEN = 0
    CLOSE = 1


@library
class keywords(DynamicCore): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ General library documentation. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        self.manager = RelaysManager()
        libraries = []
        DynamicCore.__init__(self, libraries)


    def check_if_channel_exists(self, channel_name) -> bool:
        """ Helper function to check if a relay channel with the given name exist. """

        if channel_name not in self.manager.relays_channels:
            return False

        return True


    @keyword
    def set_switch_position(self, channel_name: str, switch_position:str) -> bool:
        """
        Set the switch position of the requested relay channel.\n
        = Interfaces =\n
        IN_1:  ``channel_name`` (str): Name of the relay.\n
        IN_2:  ``switch_posiion`` (str): Switch position to set (as defined in output enumeration class).\n
        OUT: ``bAck`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        switch_names = [member.name for member in output]
        info_text = "Found unknown error while executing 'relays.Set Switch Position'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An relay channel with the given name is not existing.", level='WARN')
            return False

        if switch_position not in switch_names:
            BuiltIn().log(message="The given switching position is not supported.", level='WARN')
            return False

        ack = self.manager.relays_channels[channel_name].set_switch_position(switch_position)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def get_switch_position(self, channel_name:str) -> tuple[bool, str]:
        """
        Get the switch position of the requested relay channel.\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the relay.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.
        OUT_2: ``switch_position`` (str): Current switch position (as defined in output enumeration class).\n
        """

        # init local variables
        ack = None
        switch_position = None
        switch_names = [member.name for member in output]
        info_text = "Found unknown error while executing 'relays.Get Switch Position'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="An relay channel with the given name is not existing.", level='WARN')
            return False, None

        ack, switch_position = self.manager.relays_channels[channel_name].get_switch_position()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        if ack and switch_position not in switch_names:
            BuiltIn().log(message="The detected switching position is not supported.", level='WARN')
            return False, None

        return ack, switch_position
