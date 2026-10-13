""" Generic testbench tuner rds (fm) module. """

from pathlib import Path
from robotlibcore import DynamicCore
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.testbench.tuner.manager import TunerManager
from generic.framework.framework import framework


@library
class keywords(DynamicCore): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic testbench FM_RDS tuner module keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.2"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        self.manager = TunerManager('RDS')
        libraries = []
        DynamicCore.__init__(self, libraries)


    def check_if_channel_exists(self, channel_name) -> bool:
        """ Helper function to check if an tuner channel with the given name exist.\n
        = Interfaces = \n
        IN: ``channel_name`` (str): Name of the tuner channel.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        if channel_name not in self.manager.tuner_channels:
            return False

        return True

############################# Tuner FM RDS keywords ##############################

    @keyword
    def set_coder_defaults(self, channel_name:str) -> bool:
        """
        Configure a RDS coder for tuner output (default settings of tuner channel).\n
        = Interfaces =\n
        IN: ``channel_name`` (str): Name of the tuner channel.\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'tuner_rds.Set Defaults'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A tuner channel with the given name is not existing.", level="WARN")
            return False

        ack = self.manager.tuner_channels[channel_name].set_coder_defaults()

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)
        return ack


    @keyword
    def set_parameter(self, channel_name:str, parameter:str, value) -> bool:
        """
        Set a single parameter of a RDS coder. Only predefined parameter of a FM_RDS
        tuner channel can be modified with this keyword.\n
        = Interfaces =\n
        IN_1: ``channel_name`` (str): Name of the tuner channel.\n
        IN_2: ``parameter`` (str): Name of the parameter.\n
        IN_3: ``value`` (Any): Value to set (data type is depending on ``parameter``).\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'tuner_rds.Set Parameter'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A tuner channel with the given name is not existing.", level="WARN")
            return False

        check, result = self.manager.set_channel_property(channel_name, parameter, value)
        if not check:
            BuiltIn().log(message=result, level='WARN')
            return False

        ack = self.manager.tuner_channels[channel_name].set_parameter(parameter, value)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def load_slot_list(self, channel_name:str, file_path:str) -> bool:
        """
        Load a slot list into a RDS Coder.\n
        = Interfaces =\n
        IN_1: ``channel_name`` (str): Name of the tuner channel.\n
        IN_2: ``file_path`` (str): Absolute path of the slot list (including file name).\n
        OUT:  ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variables
        ack = None
        info_text = "Found unknown error while executing 'tuner_rds.Load Slot List'."

        if not self.check_if_channel_exists(channel_name):
            BuiltIn().log(message="A tuner channel with the given name is not existing.", level="WARN")
            return False

        path = Path(file_path)
        if not path.exists() or not path.is_file():
            BuiltIn().log(message="No slot list is existing at the given file path.", level="WARN")
            return False

        ack = self.manager.tuner_channels[channel_name].load_slot_list(file_path)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack
