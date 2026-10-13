'''
Generic testbench robotarm module. This implements all robotarm commands in generic way by means of
abstract keywords indedepended from any specific testbench setup.
'''

from robotlibcore import DynamicCore
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


@library
class keywords(DynamicCore): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ General library documentation. """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        libraries = []
        DynamicCore.__init__(self, libraries)


    def check_if_channel_exists(self, channel_name) -> bool:
        """ Helper function to check if a relay channel with the given name exist. """

        if channel_name not in self.manager.relays_channels:
            return False

        return True


    @keyword
    def press_and_release_softkey(self, softkey_name: str, hold_time:int) -> bool:
        """
        Moves robot arm to position of defined softkey and presses .. holds and releases it with the manipulator.\n
        = Interfaces =\n
        IN_1:  ``softkey_name`` (str): Name of the softkey.\n
        IN_2:  ``hold_time`` (str): Hold time between press and release events in milliseconds.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'robotarm.Press And Release Softkey'."

        ack = BuiltIn().run_keyword('prj.testbench.robotarm.press and release softkey', softkey_name, hold_time)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack
