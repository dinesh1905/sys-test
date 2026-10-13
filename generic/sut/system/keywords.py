""" Generic sut system module """

# import Robotframework API
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


@library
class keywords():  #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic sut system keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    @keyword
    def turn_on_the_sut(self, curve=None) -> bool:
        """
        Turn on the Sut (including the related components) and execute a power curve (optional).\n
        = Interfaces =\n
        IN (opt.): ``curve``(str): Name and path of the power curve.\n
        OUT:       ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'system.Turn On The Sut'."

        ack = BuiltIn().run_keyword('prj.sut.system: Turn On The Sut', curve)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_if_the_sut_is_on(self) -> tuple[bool, bool]:
        """
        Check basic functionality (e.g. HMI, audio) that indicates that the Sut is turned on.\n
        = Interfaces =\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init local variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'system.Check If The Sut Is On'."

        ack, result = BuiltIn().run_keyword('prj.sut.system: Check If The Sut Is On')

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result


    @keyword
    def turn_off_the_sut(self) -> bool:
        """
        Turn off the Sut (including the related components).\n
        = Interfaces \n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'system.Turn Off The Sut'."

        ack = BuiltIn().run_keyword('prj.sut.system: Turn Off The Sut')

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_if_the_sut_is_off(self) -> tuple[bool, bool]:
        """
        Check basic functionality (e.g. HMI, audio, current consumption) that indicates
        that the Sut is turned off.\n
        = Interfaces =\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init local variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'system.Check If The Sut Is Off'."

        ack = BuiltIn().run_keyword('prj.sut.system: Check If The Sut Is Off')

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result


    @keyword
    def check_if_the_sut_enter_sleep_mode(self, max_current=0, wait_time=60) -> tuple[bool, bool]:
        """
        Check if the Sut has entered sleep mode within a specific time.\n
        = Interfaces =\n
        IN_1 (opt.):  ``max_current``(float): Current that indicates that the Sut has entered sleep mode (default is 0A).\n
        IN_2 (opt.):  ``wait_time`` (int): Time until Sut must be in sleep mode (default is 60s).\n
        OUT_1:        ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2:        ``result`` (bool): Feedback if the check was successful or not.
        """

        # init lacal variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'system.Check If The Sut Enter Sleep Mode'."

        ack, result = BuiltIn().run_keyword('prj.sut.system: Check If The Sut Enter Sleep Mode', max_current, wait_time)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result
