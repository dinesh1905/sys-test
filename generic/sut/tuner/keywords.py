""" Generic sut tuner module """

from robotlibcore import DynamicCore
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from am.keywords import keywords as am
from fm.keywords import keywords as fm
# from dab.keywords import keywords as dab


@library
class keywords(DynamicCore): #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic sut media keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.1"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        libraries = [am(), fm()] # dab()]
        DynamicCore.__init__(self, libraries)


    @keyword
    def tuner_module_details(self):
        """ Shows more detailed information about the sut tuner module and its libraries. """

        BuiltIn().log(message="Detailed informtion about the sut tuner module and its components.",
                    level="INFO")
