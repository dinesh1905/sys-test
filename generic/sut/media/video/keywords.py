""" Generic sut video module """

# import Robotframework API
from robotlibcore import keyword
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


class keywords():  #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic sut video keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    @keyword
    def set_video_source(self, source:str) -> bool:
        """
        Set the active video source.\n
        = Interfaces =\n
        IN:  ``source`` (str): Name of the video source to set.\n
        OUT: ``ack`` (bool): Keyword execution acknowledgement.
        """

        # init local variable
        ack = False
        info_text = "Found unknown error while executing 'media.Set Video Source'."

        ack = BuiltIn().run_keyword('prj.sut.video: Set video source', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack


    @keyword
    def check_video_source(self, source:str) -> bool:
        """
        Check if the active video source is the expected one.\n
        = Interfaces =\n
        IN:    ``source`` (str): Name of the video source to check.\n
        OUT_1: ``ack`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``result`` (bool): Feedback if the check was successful or not.
        """

        # init local variable
        ack = False
        result = False
        info_text = "Found unknown error while executing 'media.Check Video Source'."

        ack = BuiltIn().run_keyword('prj.sut.video: Check video source', source)

        # test flow handling
        if not ack:
            framework().set_test_status_to_unknown(info_text)

        return ack, result
