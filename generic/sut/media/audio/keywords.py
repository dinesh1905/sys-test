""" Generic sut audio module """

# import Robotframework API
from robotlibcore import keyword
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


class keywords():  #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic sut audio keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    @keyword
    def set_volume_to_value(self, volume=10) -> bool:
        """
        Set the audio volume of the SUT to a specific value.\n
        = Interfaces =\n
        IN (opt.):  ``volume``(int):  The value you want to set (must be an integer, default is 10).\n
        OUT:        ``ack``(bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'media.Set Volume To Value'."

        ack = BuiltIn().run_keyword('prj.sut.audio: Set volume to value', volume)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def increase_volume_stepwise(self) -> bool:
        """
        Increase the audio volume of the SUT by one step.\n
        = Interfaces =\n
        OUT ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'media.Increase Volume Stepwise'."

        ack = BuiltIn().run_keyword('prj.sut.audio: Increase volume stepwise')

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def decrease_volume_stepwise(self) -> bool:
        """
        Decrease the audio volume of the SUT by one step.\n
        = Interfaces =\n
        OUT ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'media.Decrease Volume Stepwise'."

        ack = BuiltIn().run_keyword('prj.sut.audio: Decrease volume stepwise')

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_volume_value(self, volume:int) -> tuple[bool, bool]:
        """
        Check if the audio volume of the SUT has an expected value.\n
        = Interfaces =\n
        IN:    ``volume`` (int): The expected value (must be an integer).\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init local variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'media.Check Volume Value'."

        ack, result = BuiltIn().run_keyword('prj.sut.audio: Check volume value', volume)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result
