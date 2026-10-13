""" Generic teardowns module """

# import Robotframework API
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework


@library
class teardowns():  #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic teardowns keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.2.0"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self):
        self.initialized = False


    @keyword
    def tear_down_test_case(self) -> None:
        """ Standard test teardown executed in every test. """

        test_name = BuiltIn().get_variable_value("${TEST_NAME}")

        # Check for an iteration extension
        try:
            iteration = test_name.split('#')[1]
        except IndexError:
            iteration = ''

        # Update the dictionary for additional reporting
        BuiltIn().run_keyword("Collections.Set To Dictionary", "${framework.report.csv}", "TestName", test_name)
        BuiltIn().run_keyword("Collections.Set To Dictionary", "${framework.report.csv}", "Iteration", iteration)

        BuiltIn().log(message="****** [" + test_name + "] :: (Test Teardown) :G: Enter *******", level="INFO")

        # Report update
        test_case_result = framework().update_results()

        # Timestamp test case completed
        timestamp = framework().set_test_case_runtime("End")
        BuiltIn().log(message="Test case end time: " + timestamp)

        # failure teardown required?
        if test_case_result != "Pass":
            BuiltIn().log(message="failure teardown required", level="WARN")
            self.tear_down_test_case_with_failure()

        # Project specific teardown of the current testcase
        BuiltIn().run_keyword('prj.test.teardowns.tear down test case')

        BuiltIn().log(message="****** [" + test_name + "] :: (Test Teardown) :G: Exit ******", level="INFO")


    @keyword
    def tear_down_test_case_with_failure(self) -> None:
        """ Additional test teardown in case of a failure (error handling). """

        test_name = BuiltIn().get_variable_value("${TEST_NAME}")

        BuiltIn().log(message="****** [" + test_name + "] :: (Failure) :: (Test Teardown) :G: Enter ******",
                    level="INFO")

        # Project specific failure teardown for current testcase
        BuiltIn().run_keyword('prj.test.teardowns.tear down test case with failure')

        BuiltIn().log(message="****** [" + test_name + "] :: (Failure) :: (Test Teardown) :G: Exit ******",
                    level="INFO")


    @keyword
    def tear_down_test_suite(self) -> None:
        """ Standard Suite Teardown executed executed every time (= in every robot file of the suite). """

        suite_name = BuiltIn().get_variable_value("${SUITE_NAME}").rsplit('.',1)[1]

        BuiltIn().log(message="****** " + suite_name + "] :: (Suite Teardown) :G: Enter *******", level="INFO")

        # Test suite end time
        timestamp = framework().set_test_suite_runtime("End")
        BuiltIn().log(message="Test suite end time: " + timestamp)

        # Project specific teardown for current testsuite
        BuiltIn().run_keyword('prj.test.teardowns.tear down test suite')

        BuiltIn().log(message="****** [" + suite_name + "] :: (Suite Teardown) :G: Exit *******", level="INFO")


    @keyword
    def tear_down_final_test_suite(self) -> None:
        """
        Suite teardown executed in case of the robot file is the last robot file within a multi file test suite
        or in case of the robot file is the only one within the suite (in opposite to the standard Suite Teardown
        that is executed every time (= in every robot file of the suite)).
        """

        suite_name = BuiltIn().get_variable_value("${SUITE_NAME}")

        BuiltIn().log(message="****** [" + suite_name + "] :: (Final) :: (Suite Teardown) :G: Enter ******",
                    level="INFO")

        # Test suite setup completed: Switch test bench indicator light to OFF state. Stop statistic.
        if BuiltIn().get_variable_value("${testbench.bitsplatform.supported}") is True:
            bp_lib = BuiltIn().get_library_instance('bits_platform')
            bp_lib.system_set_configuration_parameter("stop_statistic", "True")
            bp_lib.system_control_flashlights("OFF")

        # Project specific teardown of final testsuite
        BuiltIn().run_keyword('prj.test.teardowns.tear down final test suite')

        BuiltIn().log(message="****** [" + suite_name + "] :: (Final) :: (Suite Teardown) :G: Exit ******",
                    level="INFO")
