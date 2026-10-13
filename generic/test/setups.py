""" Generic setups module """

# import Robotframework API
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


@library
class setups():  #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic setups keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.2.0"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        self.initialized = False


    @keyword
    def set_up_initial_test_suite(self) -> None:
        """
        Suite Setup executed in case of the robot file is the first robot file within a multi file test suite
        or in case of the robot file is the only one within the suite (in opposite to the standard Suite Setup
        that is executed every time (= in every robot file of the suite)).
        """

        suite_name = BuiltIn().get_variable_value("${SUITE_NAME}")

        BuiltIn().log(message="****** [" + suite_name + "] :: (Initial) :: (Suite Setup) :G: Enter ******",
                    level="INFO")

        # Project specific setup for initial testsuite
        BuiltIn().run_keyword('prj.test.setups.set up initial test suite')

        BuiltIn().log(message="****** [" + suite_name + "] :: (Initial) :: (Suite Setup) :G: Exit ******",
                    level="INFO")


    @keyword
    def set_up_test_suite(self) -> None:
        """ Standard Suite Setup executed executed every time (= in every robot file of the suite). """

        suite_name = BuiltIn().get_variable_value("${SUITE_NAME}").rsplit('.',1)[1]

        BuiltIn().log(message="****** [" + suite_name + "] :: (Suite Setup) :G: Enter ******",
                    level="INFO")

        suite_metadata = BuiltIn().get_variable_value("${SUITE_METADATA}")

        # Log the suite metadata (if existing)
        if BuiltIn().get_length(suite_metadata) > 0:
            BuiltIn().log(message="==== Test suite metadata:", level="INFO")
            for data in suite_metadata:
                value = BuiltIn().get_variable_value("${SUITE METADATA['" + data + "']}")
                BuiltIn().log(message=data + ": " + value, level="INFO")

        # Test suite start time
        timestamp = framework().set_test_suite_runtime("Start")
        BuiltIn().log(message="Test suite start time: " + timestamp)

        # Project specific setup for testsuite under execution
        BuiltIn().run_keyword('prj.test.setups.set up test suite')

        BuiltIn().log(message="****** [" + suite_name + "] :: (Suite Setup) :G: Exit ******",
                    level="INFO")


    @keyword
    def set_up_test_case(self) -> None:
        """ Standard Test Setup executed in every test. """

        test_name = BuiltIn().get_variable_value("${TEST_NAME}")

        BuiltIn().log(message="****** [" + test_name + "] :: (Test Setup) :G: Enter *******", level="INFO")

        # Reset all test case variables
        framework().init_runtime_attributes()

        # Test case start time
        timestamp = framework().set_test_case_runtime("Start")
        BuiltIn().log(message="Test case start time: " + timestamp)

        # BITS-Platform setup actions
        # if BuiltIn().get_variable_value("${testbench.bitsplatform.supported}") is True:
        #     bp_lib = BuiltIn().get_library_instance('bits_platform')
        #     bp_lib.system_control_flashlights("GREEN")

        # Test case setup completed: Switch test bench indicator light to green flashing state
        # if BuiltIn().get_variable_value("${testbench.bitsplatform.supported}") is True:
        #     bp_lib = BuiltIn().get_library_instance('bits_platform')
        #     bp_lib.system_control_flashlights("GREEN_FLASH")

        # Project specific setup for testcase under execution
        BuiltIn().run_keyword('prj.test.setups.set up test case')

        BuiltIn().log(message="****** [" + test_name + "] :: (Test Setup) :G: Exit ******",
                    level="INFO")
