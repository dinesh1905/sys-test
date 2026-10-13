""" Generic sut image module """

# import Robotframework API
from robotlibcore import keyword
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


class keywords():  #RF convention: class name must be equal to module name ->pylint: disable=C0103 disable=R0903:too-few-public-methods
    """ Generic sut image keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    @keyword
    def check_if_hmi_shows_view(self, view_name:str, timeout=0) -> tuple[bool, bool, int]:
        """
        Check if the displayed view is the expected one.\n
        IN_1:         ``view_name`` (str):  The expected view that should be displayed.\n
        IN_2 (opt.):  ``timeout`` (int): Wait time in seconds before the displayed view is checked (default is 0s).\n
        OUT_1:        ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2:        ``result`` (bool): Feedback if the check was successful or not.\n
        OUT_3:        ``seconds`` (int): Time until the expected view was displayed.
        """

        # init local variable
        ack = False
        result = False
        seconds = -9999
        info_text = "Found unknown error while executing 'media.Check If HMI Shows View'."

        ack, result, seconds = BuiltIn().run_keyword('prj.sut.image: Check If HMI Shows View', view_name, timeout)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result, seconds
