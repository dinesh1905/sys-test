""" Generic framework listener """

# import Robotframework API
from robot.running.model import Body
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn


@library
class testcase_iterator(): #pylint: disable=C0103:invalid-name
    """ Creates test cases at runtime. """

    ROBOT_LISTENER_API_VERSION = 3
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_SCOPE = 'TEST SUITE'

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self.current_suite = None
        self.ts_setup = None
        self.ts_teardown = None
        self.current_testcase = None
        self.tc_setup = None
        self.tc_teardown = None


    def start_suite(self, suite, result): #pylint: disable=W0613:unused-argument
        """ Called when a test suite starts. """
        self.current_suite = suite
        self.ts_setup = suite.setup
        self.ts_teardown = suite.teardown


    def start_test(self, test, result): #pylint: disable=W0613:unused-argument
        """ Called when a test case starts. """
        self.current_testcase = test
        self.tc_setup = test.setup
        self.tc_teardown = test.teardown


    @keyword
    def add_test_cases(self, teststeps:str, iterations:int):
        """
        Adds a specifc number of identical test cases to the current suite.\n
        Required for Reliabilty tests.\n
        = Interfaces =\n
        IN_1: ``teststeps`` (str): Name of the keyword that contain the teststeps.\n
        IN_2: ``iterations`` (int): Number of identical test cases to be created.\n
        """
        if not isinstance(iterations, int):
            try:
                iterations = int(iterations)
            except TypeError as exc_info:
                BuiltIn().log(message=exc_info, level='ERROR')
                BuiltIn().fatal_error(msg='Value for input parameter `iterations` is not valid.')
        for i in range (1, iterations + 1):
            tc = self.current_suite.tests.create(name=str(self.current_testcase)+"#"+str(i))
            tc.body.create_keyword(name=teststeps)
            tc.setup = Body().create_keyword(self.tc_setup)
            tc.teardown = Body().create_keyword(self.tc_teardown)
