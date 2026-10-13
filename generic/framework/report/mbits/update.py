""" Generic mbits report listener. """

# import Robotframework API
from robot.libraries.BuiltIn import BuiltIn

class update(): #pylint: disable=C0103:invalid-name
    """ Creates all database entries for mbits reporting. """

    ROBOT_LISTENER_API_VERSION = 2
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self.db_support = None
        self.dbc_lib = None
        self.test_type = None

    def start_suite(self, name, attrs): #pylint: disable=W0613:unused-argument
        """ Called when a test suite starts. """

        # Dictionary is not existing when the event is called for the first time
        if self.db_support is None:
            try:
                self.db_support = BuiltIn().get_variable_value("${framework.report.mbits.supported}")
            except AttributeError:
                pass

        # Continue only if the db_support is enabled
        if self.db_support is True:

            # Continue only if the event is called by a .robot file
            if attrs['source'].endswith('.robot'):
                # Database interface 'TEST_INIT'
                bp_version = None
                if BuiltIn().get_variable_value("${testbench.bitsplatform.supported}") is True:
                    bp_lib = BuiltIn().get_library_instance('bits_platform')
                    bp_version = bp_lib.system_get_configuration_parameter("version")[1]
                additional_info = None
                suite_metadata = attrs['metadata']
                if len(suite_metadata) > 0:
                    if 'testtype' in suite_metadata:
                        self.test_type = suite_metadata['testtype']
                    if 'additionalinfo' in suite_metadata:
                        info = suite_metadata['additionalinfo']
                        if info != 'no additionalinfo':
                            additional_info = info
                dict_TEST_INIT = {'project':BuiltIn().get_variable_value("${framework.project}"),
                         'variant':BuiltIn().get_variable_value("${sut.system.variant}"),
                         'test_name':name,
                         'version_sw_target':BuiltIn().get_variable_value("${sut.system.software.version}"),
                         'version_sw_virtual':None,
                         'bt_address':None,
                         'wifi_address':None,
                         'testbench_label':BuiltIn().get_variable_value("${framework.testbench.label}"),
                         'test_system':'BITS:RF',
                         'additional_information':additional_info,
                         'bitf_version':BuiltIn().get_variable_value("${framework.version.number}"),
                         'platform_version':bp_version}
                self.dbc_lib = BuiltIn().get_library_instance('db_client_interface')
                self.dbc_lib.send_command("TEST_INIT", dict_TEST_INIT)


    def start_test(self, name, attrs): #pylint: disable=W0613:unused-argument
        """ Called when a test case starts. """

        # Continue only if the db_support is enabled
        if self.db_support is True:
            # Database interface 'ITERATION_START'
            dict_ITERATION_START = {'iteration_name':name,
                                   'subtype':self.test_type}
            self.dbc_lib.send_command("ITERATION_START", dict_ITERATION_START)

            ack = self.dbc_lib.get_status()
            if ack is not True:
                BuiltIn().log(message="==== !!! The database interface has been switched off !!!")
                BuiltIn().log(message="==== For details please refer to the logfile of this test suite.")


    def end_test(self, name, attrs): #pylint: disable=W0613:unused-argument
        """ Called when a test case ends. """

        # Continue only if the db_support is enabled
        if self.db_support is True:
            # Database interface 'ITERATION_END'
            test_case_result = BuiltIn().get_library_instance('framework').test_case_result
            iteration_result = None
            if test_case_result == "Pass":
                iteration_result = "Passed"
            elif test_case_result == "Fail":
                iteration_result = "Failed"
            elif test_case_result == "Unknown":
                iteration_result = "unknown"
            dict_ITERATION_END = {'iteration_result':iteration_result,
                                 'error_resets':0,
                                 'failure_flow':None}
            self.dbc_lib.send_command("ITERATION_END", dict_ITERATION_END)


    def end_suite(self, name, attrs): #pylint: disable=W0613:unused-argument
        """ Called when a test suite ends. """

        # Continue only if the db_support is enabled
        if self.db_support is True:

            # Continue only if the event is called by a .robot file
            if attrs['source'].endswith('.robot'):
                # Database interface 'TEST_END'
                self.dbc_lib.send_command("TEST_END")

            # Continue only if the event is called by the first child suite
            if attrs['id'] == 's1-s1':
                # Database interface 'EXIT'
                self.dbc_lib.send_command("EXIT")
