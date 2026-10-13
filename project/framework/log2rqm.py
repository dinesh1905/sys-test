""" Generic framework listener """

# import Robotframework API
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn
from generic.framework.framework import framework
import subprocess
import  os
import shutil
import datetime

class log2rqm(): #pylint: disable=C0103:invalid-name
    """ Creates an csv file for additional reporting. """

    ROBOT_LISTENER_API_VERSION = 2
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    def __init__(self):
        self.ROBOT_LIBRARY_LISTENER = self

    def end_suite(self,name, attrs):
        global  frameworkpath
        global  outputfilepath
        global  TestPlanID
        frameworkpath = BuiltIn().get_variable_value("${TAF_PATH}")
        outputfilepath = BuiltIn().get_variable_value("${TEST_NAME}")
        TestPlanID = BuiltIn().get_variable_value("${TESTBENCH.process.TestPlanID}")
        BuiltIn().log_to_console(TestPlanID)
        return frameworkpath,outputfilepath,TestPlanID
    def close(self):
        """ Called when a test suite ends. """
        filepathtobat = "\\project\\testbench\\config\\rqm\\RobotResult2RQM.bat"
        filepathtolog2rqm = frameworkpath + filepathtobat
        outputxmlpath = frameworkpath + "\\report"
        logpath = "D:\\tmp\\LogFile"
        BuiltIn().log_to_console(filepathtolog2rqm)

        print   ("*********This is to upload into RQM**************")
        # subprocess.run([r"filepathtolog2rqm","C:\\Users\\anp1pg1\\Documents\\BITSRF\\projects\\IDBuzz\\Maas\\development\\annette\\sys_test\\report\\output.xml","111"])
        subprocess.call([filepathtolog2rqm,outputxmlpath,TestPlanID])

        print   ("*********Copy Result to Archive**************")
        # Copy result to a different folder.
        # using now() to get current time
        current_time = datetime.datetime.now()

        # Format the datetime as yyyyMMdd_HHmmss
        formatted_date = current_time.strftime("%Y%m%d_%H%M%S")

        # copy output.xml file to archive path
        archiveresult =rf"\results\archive\reportAndlog_{formatted_date}"
        archiveresult_log =rf"\results\archive\reportAndlog_{formatted_date}\LogFiles"
        archiveresultfullpath = frameworkpath + archiveresult
        archiveresultfullpath_log = frameworkpath + archiveresult_log 
        shutil.copytree(outputxmlpath,archiveresultfullpath)
        shutil.copytree(logpath,archiveresultfullpath_log)