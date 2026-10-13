""" Generic framework module """

# import standard Python modules
import os
import time
import uuid

# import Robotframework API
from enum import Enum
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn, RobotNotRunningError

import RobotFramework_TestsuitesManagement

class error_definitions(Enum): #pylint: disable=C0103:invalid-name disable=R0903:too-few-public-methods
    """ Define all error types """
    UNSPECIFIED = 0
    AUDIO = 1
    BLANK_SCREEN = 2
    BREAK = 3
    CURRENT = 4
    DIAGNOSIS = 5
    HMI = 6
    KEYPAD = 7
    NETWORK = 8
    PERFORMANCE = 9
    REANIMATION = 10
    RESET = 11
    SDS = 12
    SPI = 13
    SELFTEST = 14
    SOFTWARE_UPDATE = 15
    SOURCE = 16
    USER_SPECIFIC = 17
    V2X = 18


class error_stats(): #pylint: disable=C0103:invalid-name
    """ Manages the available error types. """

    def __init__(self):

        self.type_names = [member.name for member in error_definitions]
        self.error_types = {}
        self.create_error_types()


    def create_error_types(self) -> None:
        """ Initializes the 'error_types' dictionary with valid key/value pairs """

        for key_name in self.type_names:
            self.error_types.update({key_name:0})


    def check_if_error_type_exists(self, error_type:str) -> bool:
        """ Helper function to check if an error type with the given name exist. """

        if error_type not in self.error_types:
            return False

        return True


    def get_error_count(self, error_type:str) -> int:
        """ Get the value of an existing error type. """

        value = self.error_types.get(error_type)

        return value


    def get_all_error_count(self) -> int:
        """ Get the numer of all existing error types """

        count = sum(self.error_types.values())

        return count


    def add_errors(self, error_type:str, error_count:int) -> None:
        """ Update an error type value in the 'error_types' dictionary. """

        value = self.get_error_count(error_type)
        self.error_types.update({error_type:value+error_count})


    def reset_errors(self, error_type:str) -> None:
        """ Reset the value of an error type in the 'error_types' dictionary. """

        self.error_types.update({error_type:0})


    def reset_stats(self) -> None:
        """ Reset the complete 'error_types' dictionary. """

        self.error_types.clear()
        self.create_error_types()


@library
class framework():  #RF convention: class name must be equal to module name->pylint: disable=C0103
    """ Generic framework keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = "0.0.4"
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'


    def __init__(self):
        try:
            # get framework instance created by RF
            lib = BuiltIn().get_library_instance('framework')
            for item in dir(lib):
                try:
                    # forwarding attributes from self to framework lib object
                    exec(f"self.{item} = lib.{item}") #pylint: disable=W0122:exec-used
                except AttributeError:
                    pass

        except (RuntimeError, RobotNotRunningError): # 'RobotNotRunningError' is required for unit tests
            # framework lib not available and needs to be instanciated by RF
            self.test_suite_errors = error_stats()
            self.test_suite_results = {"Pass":0,"Fail":0,"Unknown":0}
            self.test_suite_runtime = {"Start":'',"End":''}

            self.test_case_errors = error_stats()
            self.test_case_error_info = ""
            self.test_case_result = None
            self.test_case_control = True
            self.test_case_runtime = {"Start":'',"End":''}

        try:
            # Get UUID from test execution panel or generate it
            self.uuid = BuiltIn().get_variable_value("${Process_id}")
            if self.uuid is None:
                self.uuid = str(uuid.uuid1())[1:-1]
        except (RuntimeError, RobotNotRunningError):
            pass


    def add_to_test_suite_results(self, result:str) -> None:
        """ Add test case result to test suite results dictionary """

        value = self.test_suite_results.get(result)
        self.test_suite_results.update({result:value+1})


    def add_to_error_info(self, info_text:str) -> None:
        """ Add text to the error infor mation string. """

        if len(self.test_case_error_info) > 0:
            self.test_case_error_info += " | "
        self.test_case_error_info += info_text

    def get_number_executed_test_cases(self) -> int:
        """ Get the number of currently executed test cases. """

        return self.test_suite_results.get("Pass")+self.test_suite_results.get("Fail")+self.test_suite_results.get("Unknown")

# ####################### FRAMEWORK KEYWORDS ####################### #

    @keyword
    def init_runtime_attributes(self) -> None:
        """ Set the runtime attributes to their default values """

        self.test_case_errors.reset_stats()
        self.test_case_error_info = ""
        self.test_case_result = None
        self.test_case_control = True
        self.test_case_runtime = {"Start":'',"End":''}

    @keyword
    def get_reset_count(self) -> int:
        """ Get the reset count of the current test case. """

        reset_count = self.test_case_errors.get_error_count("RESET")

        return reset_count


    @keyword
    def set_test_suite_runtime(self, key_name:str) -> str:
        """ Set a test suite runtime value.\n
        = Interfaces =\n
        IN:  ``key_name`` (str): 'Start' or 'End'.\n
        OUT: ``datetime`` (str): Generated timestamp.
        """

        datetime = time.strftime('%Y-%m-%d %H:%M:%S')
        self.test_suite_runtime.update({key_name:datetime})

        return datetime


    @keyword
    def set_test_case_runtime(self, key_name:str) -> str:
        """ Set a test case runtime value.\n
        = Interfaces =\n
        IN:  ``key_name`` (str): 'Start' or 'End'.\n
        OUT: ``datetime`` (str): Generated timestamp.
        """

        datetime = time.strftime('%Y-%m-%d %H:%M:%S')
        self.test_case_runtime.update({key_name:datetime})

        return datetime


    @keyword
    def set_test_status_to_fail(self, error_type='UNSPECIFIED', info_text=None) -> None:
        """
        Set the result of a running test case to 'FAIL' and stop the execution of the test case.
        Finally the teardown is executed.\n
        = Interfaces =\n
        IN_1: ``error_type`` (str): Indicates the type of error  (optional, default is 'UNSPECIFIED').\n
        IN_2: ``info_text`` (str): Error description to be displayed.
        """

        BuiltIn().log(message="An '" + str(error_type) + "' error has occured!", level="ERROR")

        # set framework test result
        self.test_case_result = "Fail"

        # increase error counter if error type is valid
        check = self.test_case_errors.check_if_error_type_exists(error_type)
        if check is False:
            BuiltIn().log(message="No entry found for given error type. No error counter update possible.",
                        level="WARN")
        else:
            self.test_case_errors.add_errors(error_type, 1)
            self.test_suite_errors.add_errors(error_type, 1)

        if info_text is not None:
            if isinstance(info_text, str):
                BuiltIn().log(message=info_text, level="INFO")
                self.add_to_error_info(info_text)
                BuiltIn().fail(msg=info_text)
        else:
            # set test result to 'FAIL' and stop the test case
            BuiltIn().fail(msg="The test result is set to 'FAIL' and the test case will be stopped.")



    @keyword
    def set_test_status_to_fail_and_continue(self, error_type='UNSPECIFIED', info_text=None) -> None:
        """
        Set the result of a running test case to 'FAIL' and continue the execution of the test case.\n
        = Interfaces =\n
        IN_1: ``error_type`` (str): Indicates the type of error  (optional, default is 'UNSPECIFIED').\n
        IN_2: ``info_text`` (str): Error description to be displayed.
        """

        BuiltIn().log(message="An '" + str(error_type) + "' error has occured!", level="ERROR")

        # set framework test result
        self.test_case_result = "Fail"

        # increase error counter if error type is valid
        check = self.test_case_errors.check_if_error_type_exists(error_type)
        if check is False:
            BuiltIn().log(message="No entry found for given error type. No error counter update possible.",
                        level="WARN")
        else:
            self.test_case_errors.add_errors(error_type, 1)
            self.test_suite_errors.add_errors(error_type, 1)

        if info_text is not None:
            if isinstance(info_text, str):
                BuiltIn().log(message=info_text, level="INFO")
                self.add_to_error_info(info_text)
                BuiltIn().fail(info_text,"robot:recursive-continue-on-failure")
        else:
            # set test result to 'FAIL' and continue the test case
            BuiltIn().fail("The test result is set to 'FAIL' but the test case will be continued.", "robot:recursive-continue-on-failure")



    @keyword
    def set_test_status_to_unknown(self, info_text=None) -> None:
        """
        Set the result of a running test case to 'UNKNOWN' and stop the execution of the test case.
        Finally the teardown is executed.\n
        = Interfaces =\n
        IN: ``info_text`` (str): Error description to be displayed.
        """

        BuiltIn().log(message="An exception has occurred.", level="ERROR")

        if info_text is not None:
            if isinstance(info_text, str):
                BuiltIn().log(message=info_text, level="INFO")
                self.add_to_error_info(info_text)
                BuiltIn().unknown(msg=info_text)
        else:
            BuiltIn().unknown(msg="The test result is set to 'UNKNOWN' and the test case will be stopped.")
        # increase error counter
        self.test_case_errors.add_errors("UNSPECIFIED", 1)
        self.test_suite_errors.add_errors("UNSPECIFIED", 1)

        # set test result to 'UNKNOWN' and stop the test case
        self.test_case_result = "Unknown"
        


    @keyword
    def abort_test_run(self, info_text=None) -> None:
        """
        In case of a fatal error abort the complete execution (test run).\n
        = Interfaces =\n
        IN: ``info_text`` (str): Error description to be displayed.
        """

        BuiltIn().log(message="A fatal error has occurred.", level="ERROR")

        # set framework test result
        self.test_case_result = "Fail"

        if info_text is not None:
            if isinstance(info_text, str):
                BuiltIn().log(message=info_text, level="INFO")
                self.add_to_error_info(info_text)

        # set test result to 'FAIL' and stop test execution
        BuiltIn().fatal_error(msg="The test result is set to 'FAIL' and the test execution will be aborted.")


    @keyword
    def update_results(self) -> str:
        """ Update the result data within the framework module. """

        BuiltIn().log(message='****** (Framework) :G: Update Results :: Enter ******')

        # Update test case result ('Fail' and 'Unknown' are set by keywords)
        if self.test_case_result is None:
            self.test_case_result = "Pass"

        if isinstance(self.test_case_result,str):
            BuiltIn().log(message="Test case result is: '" + self.test_case_result + "'")

        # Update test suite results
        if self.test_case_result in self.test_suite_results:
            self.add_to_test_suite_results(self.test_case_result)

        BuiltIn().log(message="Passed test cases: " + str(self.test_suite_results.get("Pass")) +
                    "; Failed test cases: " + str(self.test_suite_results.get("Fail")) +
                    "; Unknown test cases: " + str(self.test_suite_results.get("Unknown")))

        # Update the dictionary for additional reporting
        BuiltIn().run_keyword("Collections.Set To Dictionary", "${framework.report.csv}",
                              "StartTime", self.test_case_runtime["Start"],
                              "TestResult", self.test_case_result,
                              "ErrorInfo", self.test_case_error_info)

        BuiltIn().log(message='****** (Framework) :G: Update Results :: Exit ******')

        return self.test_case_result


    @keyword
    def load_configuration(self, config_file, config_name) -> None:
        """ Loads a configuration from a testsuites config_file """

        RobotFramework_TestsuitesManagement.CTestsuitesCfg.oConfig.sConfigName = config_name

        testsuites_lib = BuiltIn().get_library_instance("testsuites")
        testsuites_lib.testsuite_setup(config_file)


    @keyword
    def print_all_test_case_error_counters(self):
        """ Output all test case error counters and the runtime. """

        BuiltIn().log(message="Test case error counters:")

        for err_type in self.test_case_errors.type_names:
            value = self.test_case_errors.get_error_count(err_type)
            BuiltIn().log(message=err_type + ": " + str(value))

        BuiltIn().log(message=self.test_case_runtime)


    @keyword
    def print_all_test_suite_error_counters(self):
        """ Output all test suite error counters. """

        BuiltIn().log(message="Test suite error counters:")

        for err_type in self.test_suite_errors.type_names:
            value = self.test_suite_errors.get_error_count(err_type)
            BuiltIn().log(message=err_type + ": " + str(value))


    @keyword
    def reset_single_error_counter(self, error_type:str):
        """ Reset a specified test case error counter """

        self.test_case_errors.reset_errors(error_type)
        BuiltIn().log(message="Error counter for '" + error_type + "' will be reset.")

# ################### EXECUTION CONTROL KEYWORDS ################### #

    @keyword
    def pause_test_execution(self):
        """ Pause the test execution by creating a control file. """

        try:
            control_path = BuiltIn().get_variable_value("${TAF_PATH}") + "/control/"
            with open(control_path+"pause_"+self.uuid, "x", encoding="utf-8") as f:
                f.close()
        except (OSError, AttributeError):
            pass


    @keyword
    def resume_test_execution(self):
        """ Resume the test execution by creating deleting a control file. """

        try:
            control_path = BuiltIn().get_variable_value("${TAF_PATH}") + "/control/"
            os.remove(control_path+"pause_"+self.uuid)
        except (OSError, AttributeError):
            pass


    @keyword
    def stop_test_execution(self):
        """ Stop the test execution by creating a control file. """

        try:
            control_path = BuiltIn().get_variable_value("${TAF_PATH}") + "/control/"
            with open(control_path+"stop_"+self.uuid, "x", encoding="utf-8") as f:
                f.close()
        except (OSError, AttributeError):
            pass
