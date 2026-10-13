""" Project specific csv_reporting module """

# import Robotframework API
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn


@library
class update(): #pylint: disable=C0103:invalid-name
    """ Project specific 'csv_reporting' keywords and methods. """

    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'

    def __init__(self, tc_name, tc_data):
        self.add_parameters(tc_name, tc_data)
        self.remove_dummy_testcase(tc_name)


    @keyword
    def add_parameters(self, tc_name:str, tc_data:dict): #pylint: disable=W0613:unused-argument
        """ This method is called by generic csv report update listener on end of test case events.\n
        It exposes an interface to the test case parameters provided by the listener API.
        Users can use it to access and add test cases related data to their csv report.\n
        = Interfaces =\n
        IN_1: ``tc_name`` (str): Name of the current test case.\n
        IN_2: ``tc_data`` (dict): Data dictionary of the current test case.
        - id: Test id in format like s1-s2-t2, s1 = parent suite id, ... and t2 = suite id.
        - longname: Test name including parent suites.
        - originalname: Test name with possible variables unresolved.
        - doc: Test documentation.
        - tags: Test tags as a list of strings.
        - template: The name of the template used for the test. An empty string if the test not templated.
        - source: An absolute path of the test case source file.
        - lineno: Line number where the test starts in the source file.
        - starttime: Test execution execution start time.
        - endtime: Test execution execution end time.
        - elapsedtime: Total execution time in milliseconds as an integer
        - status: Test status as string PASS, FAIL or SKIP.
        - message: Status message. Normally an error message or an empty string.
        """
        # example parameter added
        # BuiltIn().run_keyword("Collections.Set To Dictionary", "${dREPORTING}", "Duration_ms", tc_data['elapsedtime'])

    @keyword
    def remove_dummy_testcase(self, tc_name):
        """ Removes dummy test case entry from .CSV file -> empty line instead """
        if "#" not in str(tc_name):
            data_dict = BuiltIn().get_variable_value("${framework.report.csv}")
            for x in data_dict.keys():
                data_dict[x] = ''
