"""
Generic csv report listener. Creates csv report sheet on start of test suite event, i.e.
csv file is created and column headers (test parameters) are added as per configuration.
Updates the created sheet, i.e. adds a new row of test parameter values for each test case.
User have to provide a valid configuration and make sure that report parameters values are
updated during the test cases' sequences.
"""

import csv

# import Robotframework API
from robot.libraries.BuiltIn import BuiltIn
from project.framework.report.csv.update import update as project_report_update


class update(): #pylint: disable=C0103:invalid-name
    """ Creates an csv file for additional reporting. """

    ROBOT_LISTENER_API_VERSION = 2
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self
        self.file_existing = False
        self.text_headers = []
        self.outpath = None


    def start_suite(self, name, attrs): #pylint: disable=W0613:unused-argument
        """ Called when a test suite starts. """

        data_dict = BuiltIn().get_variable_value("${framework.report.csv}")
        # Check is required because the first suite setup is called before the dictionary is created
        if data_dict:
            # The .csv file should be created only once for every test run
            if not self.file_existing:
                # Get the 'OUTPUT_DIR' only once
                if not self.outpath:
                    self.outpath = BuiltIn().get_variable_value("${OUTPUT_DIR}")
                with open(self.outpath + "/output.csv", "w", newline='', encoding="utf-8") as f:
                    writer = csv.writer(f, delimiter=';')
                    # Get a list of dictionary keys sorted by the respective values
                    self.text_headers = [k for k, v in sorted(data_dict.items(), key=lambda item: item[1])]
                    writer.writerow(self.text_headers)
                # Reset all dictionary values
                for x in self.text_headers:
                    data_dict[x] = 'n/a'
                # Mark csv file as `created`
                self.file_existing = True


    def end_test(self, name, attrs): #pylint: disable=W0613:unused-argument
        """ CSV updates performed at the end every test case """

        data_dict = BuiltIn().get_variable_value("${framework.report.csv}")
        # Check if the dictionary is existing
        if data_dict:
            # run project specific report updates
            project_report_update(name, attrs)

            # update paramters values to csv file
            data_dict = BuiltIn().get_variable_value("${framework.report.csv}")
            with open(self.outpath + "/output.csv", "a", newline='', encoding="utf-8") as f:
                writer = csv.writer(f, delimiter=';')
                row_data = []
                for x in self.text_headers: # for x in data_dict.keys():
                    row_data.append(data_dict[x])
                writer.writerow(row_data)
            # Reset all dictionary values
            for x in self.text_headers: # for x in data_dict.keys():
                data_dict[x] = 'n/a'
