
#!/usr/bin/python
# Robotframework API
# -*- coding: utf-8 -*-

# **************************************************************************************************************
# Initial Library by Sathyaraj Thangaraj (MS/ECQ3-XC)
# auto_flash.py
# Modified by:
# Annette Arpana (XC-CP/ESS5-Pg)
#
# **************************************************************************************************************

sThisModuleName    = "auto_flash_flashgui.py"
sThisModuleVersion = "0.1.0"
sThisModuleDate    = "22.01.202"
sThisModule        = sThisModuleName + " v. " + sThisModuleVersion + " / " + sThisModuleDate



from robot.libraries.BuiltIn import BuiltIn
from robot.api.deco import keyword, library # required when using @keyword, @library decorators
from robot.libraries.Remote import Remote
from robot.api import logger
import json
import socket
import getopt
import re,sys
import subprocess,time,os
import platform
import logging
from _socket import timeout
from datetime import datetime
sys.path.append(os.path.join(os.environ.get('BITS_PLATFORM_INSTALL_PATH'),'interfaces\\robotframework'))
from bits_platform import bits_platform

# some global variable definitions
flashtool = ''
adb_device_id = ''
pcat_serial = ''
pcat_state = ''
hw_details_path = ''
build_sw_path = ''
taf_path = ''
@library
class auto_flash_flashgui_archive():
    """ This class contains the keywords for PCAT Auto_Flash methods and APIs to send/get data using ADB commands.
        NOTE: Always run this script with all the parameters is  mandatory.Arguments are seperated by semicolons(;)
        Usage: <python> auto_flash.py -a  <param1>;<param2>;<param3>;<param4>;<param5>
        <param1> - FlashTool (flashgui)
        <param2> - ADB Serial Number
        <param3> - Path to the Hardware Configuration file (json)
        <param4> - Path to Build Software Container
        <param4> - Path to Store Flash_Status (soc_flash_status.txt)
    """
    ROBOT_AUTO_KEYWORDS   = False # only decorated methods are keywords
    ROBOT_LIBRARY_VERSION = sThisModuleVersion
    ROBOT_LIBRARY_SCOPE   = 'GLOBAL'
    def __init__(self,sThisModule=sThisModule):
        self.sThisModule = sThisModule
        self.log = logging.getLogger(__name__)
        # self.device_id = adb_id
        # sPlatform = platform.system()
        # if (sPlatform == "Linux") :
        #     self.adb_path="/usr/bin/adb "
        # elif (sPlatform == "Windows"):
        #     self.bits_p = bits_platform()
        #     self.adb_path="adb "
        # else:
        #     sErr = f"Exception: Operating system '{sPlatform}' not supported!'{os.name}'"
        #     raise Exception(sErr)
    @keyword
    def flash_gui_flash_archive(self,flash_type,com_port,baudrate,parity,data_bits,stop_bits, program_ucb = True, suppress = ""):

        flashgui_drive = BuiltIn().get_variable_value("${sut.auto_flash.drive}")
        flashgui_path = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_path}")
        flashgui_dnlpath1 = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_dnlpatharchive}")
        flashgui_ComPort1 = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_COMport}")
        JenkinsEnable = BuiltIn().get_variable_value("${sut.auto_flash.JenkinsEnable}")
        HSM_Status = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.HSM_Status}")
        Jenkins_HSM_Status = BuiltIn().get_variable_value("${Jenkins_HSM_Status}")

        def search_folder(folder_name):
            os.chdir(str('D://tmp//SWdownload//aurix_archive//'))
            current_path = os.getcwd()
            folder_name = "CUSTOMER_HEX_FILES"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if folder_name in dirnames:
                    return os.path.join(dirpath,folder_name)
            return None
        folder_name = "CUSTOMER_HEX_FILES"
        found_path = search_folder(folder_name)
        if found_path:
            pathofcollect = found_path
            BuiltIn().log_to_console(pathofcollect)
        else:
            print ('did not find the path')

    # Find KDS flies in HEX_FILES

        def search_kdsfolder(kdsfolder_name):
            os.chdir(str('D://tmp//SWdownload//aurix//'))
            current_path = os.getcwd()
            kdsfolder_name = "HEX_FILES"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if kdsfolder_name in dirnames:
                    return os.path.join(dirpath,kdsfolder_name)
            return None
        kdsfolder_name = "HEX_FILES"
        found_path = search_kdsfolder(kdsfolder_name)
        if found_path:
            pathofcollectkds = found_path
            BuiltIn().log_to_console(pathofcollectkds)
        else:
            BuiltIn().log_to_console("did not find the path for KDS file")

        BuiltIn().log_to_console("JenkinsEnablevalueis")
        BuiltIn().log_to_console(JenkinsEnable)
        BuiltIn().log_to_console("Jenkins_HSM_Statusis")
        BuiltIn().log_to_console(Jenkins_HSM_Status)
        if JenkinsEnable    ==   True :
            if Jenkins_HSM_Status    ==   True :
              flashgui_DNLpath = pathofcollect + "\LIB_MPCI_MAAS_AURIX_SIGNED_FULL_HSM_ENABLE.dnl"
              flashgui_KDSpath = pathofcollectkds + "\KDS_C2.kds"
              flashgui_DNLpath_HSMDisable = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Jenkins flashing Aurix with HSM in archive folder 25.4_RC10.1")
            else :
              flashgui_DNLpath = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              flashgui_KDSpath = pathofcollectkds + "\KDS_C2.kds"
              flashgui_DNLpath_HSMDisable = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Jenkins flashing Aurix without HSM in archive folder 25.4_RC10.1")
        elif JenkinsEnable   ==   False :
            if HSM_Status   ==  True :
              flashgui_DNLpath = flashgui_drive + ":" + flashgui_dnlpath1 + "LIB_MPCI_MAAS_AURIX.dnl"
              flashgui_DNLpath = flashgui_drive + ":" + flashgui_dnlpath1 + "KDS_C2.kds"
              flashgui_DNLpath_HSMDisable = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Non-Jenkins flashing Aurix with HSM in archive folder 25.4_RC10.1")
            else :
              flashgui_DNLpath = flashgui_drive + ":" + flashgui_dnlpath1 + "LIB_MPCI_MAAS_AURIX.dnl"
              flashgui_KDSpath = flashgui_drive + ":" + flashgui_dnlpath1 + "KDS_C2.kds"
              flashgui_DNLpath_HSMDisable = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Non-Jenkins flashing Aurix without HSM in archive folder 25.4_RC10.1")

        flashgui_executable_path = flashgui_drive + ":" + flashgui_path
        BuiltIn().log_to_console(flashgui_DNLpath)
        BuiltIn().log_to_console(flashgui_executable_path)
        BuiltIn().log_to_console(flash_type)
        os.chdir(str(flashgui_executable_path))
        self.com_details ="," + str(baudrate) + "," + str(parity) + "," + str(data_bits) + "," + str(stop_bits)

        # Flashing UCB with HSM_Disable binary
        if program_ucb == True :
            BuiltIn().log_to_console("UCB flashing to disable HSM start")
            BuiltIn().log_to_console(flashgui_DNLpath_HSMDisable)
            exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f' + str(flashgui_DNLpath_HSMDisable)
            exe_cmd = exe_cmd + ' /UCBWRITE'+ ' /bNone'
            BuiltIn().log_to_console(exe_cmd)
            result = os.popen(exe_cmd).read()
            time.sleep(5)
            BuiltIn().log_to_console("UCB flashing to disable HSM ends. Checking for flashing result")
            result_file = open(flashgui_executable_path + '/Result.txt', 'r').read()
            if result.strip() == '':
                if result_file.strip() == '0x00000000':
                    BuiltIn().log_to_console("UCB flashing to disable HSM SUCCESS.Next to Erase Dataflash")
                    BuiltIn().log_to_console(flashgui_DNLpath)
                    exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f ' + str(flashgui_DNLpath_HSMDisable)
                    exe_cmd = exe_cmd + ' /DATAFLASHERASE' + ' /bNone'
                    BuiltIn().log_to_console(exe_cmd)
                    result = os.popen(exe_cmd).read()
                    time.sleep(5)
                    if result.strip() == '':
                        if flash_type == 'kds_dump':
                            return True
                        result_file = open(flashgui_executable_path + '/Result.txt', 'r').read()
                        if result_file.strip() == '0x00000000':
                            BuiltIn().log_to_console("Flashing to HSM enable sw PASS")
                            if program_ucb == True :
                                BuiltIn().log_to_console("Flashing Archive Aurix with UCB and KDS start")
                                BuiltIn().log_to_console(flashgui_KDSpath)
                                BuiltIn().log_to_console(flashgui_DNLpath)
                                exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f ' + str(flashgui_DNLpath)
                                if flash_type == 'update':
                                    exe_cmd = exe_cmd + ' /au'
                                elif flash_type == 'virgin':
                                    exe_cmd = exe_cmd + ' /av'+ ' /b 8200;4021;4023;4024;4026;4033;4062;4064;406A;406C;406E'
                                elif flash_type == 'kds_dump':
                                    exe_cmd = exe_cmd + ' /KDS_DUMP'
                                else:
                                    self.log.error('Unknown type of flashing')
                                    return False
                                BuiltIn().log_to_console("flash_type is")
                                BuiltIn().log_to_console(flash_type)
                                exe_cmd = exe_cmd + ' /UCBWRITE'
                                exe_cmd = exe_cmd + ' /KDS ' + str(flashgui_KDSpath)
                                BuiltIn().log_to_console(exe_cmd)
                                result = os.popen(exe_cmd).read()
                                time.sleep(5)
                                if result_file.strip() == '0x00000000':
                                    BuiltIn().log_to_console("Flashing UCB sw PASS")
                                elif result_file.strip() in suppress.split(","):
                                    self.log.debug('Suppressed exit code: ' + result_file.strip())
                                    BuiltIn().log_to_console("Flashing to HSM enable sw FAILS")
                                    return False
                                else:
                                    self.log.error('Encounter exit code: ' + result_file.strip())
                                    BuiltIn().log_to_console("Flashing to HSM enable sw FAILS")
                                    return False
                            else :
                                BuiltIn().log_to_console("No UCB Flashing. Flashing Aurix without UCB")
                                result = subprocess.Popen(exe_cmd, shell=True)
                            return True
                        elif result_file.strip() in suppress.split(","):
                            self.log.debug('Suppressed exit code: ' + result_file.strip())
                            BuiltIn().log_to_console("Flashing to HSM enable sw FAILS")
                            return False
                        else:
                            self.log.error('Encounter exit code: ' + result_file.strip())
                            BuiltIn().log_to_console("Flashing to HSM enable sw FAILS")
                            return False
                    else:
                        self.log.error(result)
                        BuiltIn().log_to_console("No result file is found")
                        return False
                elif result_file.strip() in suppress.split(","):
                                self.log.debug('Suppressed exit code: ' + result_file.strip())
                                BuiltIn().log_to_console("UCB flashing to disable HSM FAILS")
                                return False
                else:
                                self.log.error('Encounter exit code: ' + result_file.strip())
                                BuiltIn().log_to_console("UCB flashing to disable HSM FAILS")
                                return False
            else:
                            self.log.error(result)
                            BuiltIn().log_to_console("No result file is found")
                            return False

        else :
            BuiltIn().log_to_console("No UCB Flashing")
            BuiltIn().log_to_console("UCB flashing needs to be enabled!")
            return False


    @keyword
    def flash_gui_flash_samesoftware(self,flash_type,com_port,baudrate,parity,data_bits,stop_bits, program_ucb = True, suppress = ""):

        flashgui_drive = BuiltIn().get_variable_value("${sut.auto_flash.drive}")
        flashgui_path = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_path}")
        flashgui_dnlpath1 = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_dnlpath}")
        flashgui_ComPort1 = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_COMport}")
        JenkinsEnable = BuiltIn().get_variable_value("${sut.auto_flash.JenkinsEnable}")
        HSM_Status = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.HSM_Status}")
        Jenkins_HSM_Status = BuiltIn().get_variable_value("${Jenkins_HSM_Status}")

        def search_folder(folder_name):
            os.chdir(str('D://tmp//SWdownload//aurix//'))
            current_path = os.getcwd()
            folder_name = "CUSTOMER_HEX_FILES"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if folder_name in dirnames:
                    return os.path.join(dirpath,folder_name)
            return None
        folder_name = "CUSTOMER_HEX_FILES"
        found_path = search_folder(folder_name)
        BuiltIn().log_to_console(found_path)
        if found_path:
            pathofcollect = found_path
            BuiltIn().log_to_console(pathofcollect)
        else:
            print ('did not find the path')

    # Find KDS flies in HEX_FILES

        def search_kdsfolder(kdsfolder_name):
            os.chdir(str('D://tmp//SWdownload//aurix//'))
            current_path = os.getcwd()
            kdsfolder_name = "HEX_FILES"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if kdsfolder_name in dirnames:
                    return os.path.join(dirpath,kdsfolder_name)
            return None
        kdsfolder_name = "HEX_FILES"
        found_path = search_kdsfolder(kdsfolder_name)
        if found_path:
            pathofcollectkds = found_path
            BuiltIn().log_to_console(pathofcollectkds)
        else:
            BuiltIn().log_to_console("did not find the path for KDS file")

        BuiltIn().log_to_console("JenkinsEnable value is")
        BuiltIn().log_to_console(JenkinsEnable)
        BuiltIn().log_to_console("Jenkins_HSM_Status is")
        BuiltIn().log_to_console(Jenkins_HSM_Status)
        if JenkinsEnable    ==   True :
            if Jenkins_HSM_Status    ==   True :
              flashgui_DNLpath = pathofcollect + "\LIB_MPCI_MAAS_AURIX_SIGNED_FULL_HSM_ENABLE.dnl"
              flashgui_KDSpath = pathofcollectkds + "\KDS_C2.kds"
              flashgui_DNLpath_HSMDisable = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("status is true for HSM")
              BuiltIn().log_to_console("Jenkins flashing Aurix with HSM with same sw")
            else :
              flashgui_DNLpath = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              flashgui_KDSpath = pathofcollectkds + "\KDS_C2.kds"
              flashgui_DNLpath_HSMDisable = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Jenkins flashing Aurix without HSM with same sw")
        elif JenkinsEnable   ==   False :
            if HSM_Status   ==  True :
              flashgui_DNLpath = flashgui_drive + ":" + flashgui_dnlpath1 + "LIB_MPCI_MAAS_AURIX_SIGNED_FULL_HSM_ENABLE.dnl"
              flashgui_DNLpath = flashgui_drive + ":" + flashgui_dnlpath1 + "KDS_C2.kds"
              flashgui_DNLpath_HSMDisable = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Non-Jenkins flashing Aurix with HSM with same sw")
            else :
              flashgui_DNLpath = flashgui_drive + ":" + flashgui_dnlpath1 + "LIB_MPCI_MAAS_AURIX.dnl"
              flashgui_KDSpath = flashgui_drive + ":" + flashgui_dnlpath1 + "KDS_C2.kds"
              flashgui_DNLpath_HSMDisable = pathofcollect + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Non-Jenkins flashing Aurix without HSM with same sw")

        flashgui_executable_path = flashgui_drive + ":" + flashgui_path
        BuiltIn().log_to_console(flashgui_DNLpath)
        BuiltIn().log_to_console(flashgui_executable_path)
        BuiltIn().log_to_console(flash_type)
        os.chdir(str(flashgui_executable_path))
        self.com_details ="," + str(baudrate) + "," + str(parity) + "," + str(data_bits) + "," + str(stop_bits)
        #exe_cmd = '"' + flashgui_executable_path + 'FlashGUI.exe" /CMCR /h /i' + self.com_details + ' /f ' + str(flashgui_DNLpath)

        # Flashing UCB with HSM_Disable binary
        if program_ucb == True :
            BuiltIn().log_to_console("UCB flashing to disable HSM start")
            BuiltIn().log_to_console(flashgui_DNLpath_HSMDisable)
            exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f' + str(flashgui_DNLpath_HSMDisable)
            exe_cmd = exe_cmd + ' /UCBWRITE' + ' /bNone'
            BuiltIn().log_to_console(exe_cmd)
            result = os.popen(exe_cmd).read()
            time.sleep(5)
            BuiltIn().log_to_console("UCB flashing to disable HSM ends. Checking for flashing result")
            result_file = open(flashgui_executable_path + '/Result.txt', 'r').read()
            if result.strip() == '':
                if result_file.strip() == '0x00000000':
                    BuiltIn().log_to_console("UCB flashing to disable HSM SUCCESS.Next to Erase Dataflash")
                    BuiltIn().log_to_console(flashgui_DNLpath)
                    exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f ' + str(flashgui_DNLpath_HSMDisable)
                    exe_cmd = exe_cmd + ' /DATAFLASHERASE' + ' /bNone'
                    BuiltIn().log_to_console(exe_cmd)
                    result = os.popen(exe_cmd).read()
                    time.sleep(5)
                    if result.strip() == '':
                        if flash_type == 'kds_dump':
                            return True
                        result_file = open(flashgui_executable_path + '/Result.txt', 'r').read()
                        if result_file.strip() == '0x00000000':
                            BuiltIn().log_to_console("Erase Dataflash Success.Now flashing binary with UCB and KDS")
                            if program_ucb == True :
                                BuiltIn().log_to_console("Flashing Aurix with UCB and KDS start")
                                BuiltIn().log_to_console(flashgui_KDSpath)
                                BuiltIn().log_to_console(flashgui_DNLpath)
                                exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f ' + str(flashgui_DNLpath)
                                if flash_type == 'update':
                                    exe_cmd = exe_cmd + ' /au'
                                elif flash_type == 'virgin':
                                    exe_cmd = exe_cmd + ' /av'+ ' /b 8200;4021;4023;4024;4026;4033;4062;4064;406A;406C;406E'
                                elif flash_type == 'kds_dump':
                                    exe_cmd = exe_cmd + ' /KDS_DUMP'
                                else:
                                    self.log.error('Unknown type of flashing')
                                    return False
                                BuiltIn().log_to_console("flash_type is")
                                BuiltIn().log_to_console(flash_type)
                                exe_cmd = exe_cmd + ' /UCBWRITE'
                                exe_cmd = exe_cmd + ' /KDS ' + str(flashgui_KDSpath)
                                BuiltIn().log_to_console(exe_cmd)
                                result = os.popen(exe_cmd).read()
                                time.sleep(5)
                                BuiltIn().log_to_console("UCB and KDS flashing ends. Checking the result")
                                if result_file.strip() == '0x00000000':
                                    BuiltIn().log_to_console("Flashing UCB sw PASS")
                                elif result_file.strip() in suppress.split(","):
                                    self.log.debug('Suppressed exit code: ' + result_file.strip())
                                    BuiltIn().log_to_console("Flashing to HSM enable sw FAILS")
                                    return False
                                else:
                                    self.log.error('Encounter exit code: ' + result_file.strip())
                                    BuiltIn().log_to_console("Flashing to HSM enable sw FAILS")
                                    return False
                            else :
                                BuiltIn().log_to_console("No UCB Flashing. Flashing Aurix without UCB")
                                result = subprocess.Popen(exe_cmd, shell=True)
                            return True
                        elif result_file.strip() in suppress.split(","):
                            self.log.debug('Suppressed exit code: ' + result_file.strip())
                            BuiltIn().log_to_console("Flashing to HSM enable sw FAILS")
                            return False
                        else:
                            self.log.error('Encounter exit code: ' + result_file.strip())
                            BuiltIn().log_to_console("Flashing to HSM enable sw FAILS")
                            return False
                    else:
                        self.log.error(result)
                        BuiltIn().log_to_console("No result file is found")
                        return False
                elif result_file.strip() in suppress.split(","):
                                self.log.debug('Suppressed exit code: ' + result_file.strip())
                                BuiltIn().log_to_console("UCB flashing to disable HSM FAILS")
                                return False
                else:
                                self.log.error('Encounter exit code: ' + result_file.strip())
                                BuiltIn().log_to_console("UCB flashing to disable HSM FAILS")
                                return False
            else:
                            self.log.error(result)
                            BuiltIn().log_to_console("No result file is found")
                            return False

        else :
            BuiltIn().log_to_console("No UCB Flashing")
            BuiltIn().log_to_console("UCB flashing needs to be enabled!")
            return False
