""" Generic sut media module """

from robotlibcore import DynamicCore
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from audio.keywords import keywords as audio
from image.keywords import keywords as image
from video.keywords import keywords as video


@library
class keywords(DynamicCore): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic sut media keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        libraries = [audio(),image(),video()]
        DynamicCore.__init__(self, libraries)


    @keyword
    def media_module_details(self):
        """ Shows more detailed information about the sut media module and its libraries. """

        BuiltIn().log(message="Detailed informtion about the sut media module and its components.",
                    level="INFO")
