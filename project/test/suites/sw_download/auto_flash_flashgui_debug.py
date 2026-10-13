
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
class auto_flash_flashgui_debug():
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
    def flash_gui_flash_debug(self,flash_type,com_port,baudrate,parity,data_bits,stop_bits,FOLDER_NAME,program_ucb = True,  suppress = ""):

        flashgui_drive = BuiltIn().get_variable_value("${sut.auto_flash.drive}")
        flashgui_path = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_path}")
        flashgui_dnlpath1 = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_dnlpath}")
        flashgui_dnlpathdebug = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_dnlpathdebug}")
        flashgui_ComPort1 = BuiltIn().get_variable_value("${sut.auto_flash.flashgui.flashgui_COMport}")
        JenkinsEnable = BuiltIn().get_variable_value("${sut.auto_flash.JenkinsEnable}")
        AurixDebugFolderPath = BuiltIn().get_variable_value("${FOLDER_NAME}")
        BuiltIn().log_to_console(AurixDebugFolderPath)
        def search_folder_aurix(folder_name):
            os.chdir(str('D://tmp//SWdownload//aurix//'))
            current_path = os.getcwd()
            folder_name = "CUSTOMER_HEX_FILES"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if folder_name in dirnames:
                    return os.path.join(dirpath,folder_name)
            return None
        folder_name = "CUSTOMER_HEX_FILES"
        found_path = search_folder_aurix(folder_name)
        if found_path:
            pathofcollectaurix = found_path
            BuiltIn().log_to_console(pathofcollectaurix)
        else:
            print ('did not find the path')

        def search_folder_aurixdebug(folder_name):
            os.chdir(str('D://tmp//SWdownload//aurixdebug//'))
            current_path = os.getcwd()
            folder_name = AurixDebugFolderPath
            for dirpath, dirnames, filenames in os.walk(current_path):
                if folder_name in dirnames:
                    return os.path.join(dirpath,folder_name)
            return None
        folder_name = AurixDebugFolderPath
        found_path = search_folder_aurixdebug(folder_name)
        if found_path:
            pathofcollectaurixdebug = found_path
            BuiltIn().log_to_console(pathofcollectaurixdebug)
        else:
            print ('did not find the path')
    # Find KDS flies in HEX_FILES

        def search_kdsfolder(kdsfolder_name):
            os.chdir(str('D://tmp//SWdownload//aurix//'))
            current_path = os.getcwd()
            #BuiltIn().log_to_console(current_path)
            kdsfolder_name = "HEX_FILES"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if kdsfolder_name in dirnames:
                    return os.path.join(dirpath,kdsfolder_name)
            return None
        kdsfolder_name = "HEX_FILES"
        found_path = search_kdsfolder(kdsfolder_name)
        BuiltIn().log_to_console(found_path)
        if found_path:
            pathofcollectkds = found_path
            BuiltIn().log_to_console(pathofcollectkds)
        else:
            BuiltIn().log_to_console("did not find the path for KDS file")

        if JenkinsEnable    ==   True :
              flashgui_DNLpath = pathofcollectaurixdebug + "\\UTFTestFIT\\AURIX_AR42_MAAS_UTFTestFIT_FILLED.dnl"
              flashgui_KDSpath = pathofcollectkds + "\KDS_C2.kds"
              flashgui_HSMDisablepath = pathofcollectaurix + "\LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Jenkins flashing Debug Aurix with HSM")
        elif JenkinsEnable   ==   False :
              flashgui_DNLpath = flashgui_drive + ":" + flashgui_dnlpathdebug + "\\UTFTestFIT\\AURIX_AR42_MAAS_UTFTestFIT_FILLED.dnl"
              flashgui_KDSpath = flashgui_drive + ":" + flashgui_dnlpath1 + "\KDS_C2.kds"
              flashgui_HSMDisablepath = flashgui_drive + ":" + flashgui_dnlpath1 + "LIB_MPCI_MAAS_AURIX.dnl"
              BuiltIn().log_to_console(flashgui_DNLpath)
              BuiltIn().log_to_console("Non - Jenkins flashing Debug Aurix")

        flashgui_executable_path = flashgui_drive + ":" + flashgui_path
        BuiltIn().log_to_console(flashgui_DNLpath)
        BuiltIn().log_to_console(flashgui_executable_path)
        BuiltIn().log_to_console(flash_type)
        os.chdir(str(flashgui_executable_path))
        self.com_details ="," + str(baudrate) + "," + str(parity) + "," + str(data_bits) + "," + str(stop_bits)

        # Flashing UCB with HSM_Disable binary
        if program_ucb == True :
            BuiltIn().log_to_console("UCB flashing to disable HSM start")
            BuiltIn().log_to_console(flashgui_HSMDisablepath)
            exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f ' + str(flashgui_HSMDisablepath)
            exe_cmd = exe_cmd + ' /UCBWRITE' + ' /bNone'
            BuiltIn().log_to_console(exe_cmd)
            result = os.popen(exe_cmd).read()
            time.sleep(5)
            result_file = open(flashgui_executable_path + '/Result.txt', 'r').read()
            if result.strip() == '':
                if result_file.strip() == '0x00000000':
                    BuiltIn().log_to_console("UCB flashing to disable HSM SUCCESS.Next to Erase Dataflash")
                    exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f ' + str(flashgui_HSMDisablepath)
                    exe_cmd = exe_cmd + ' /ERASEDATAFLASH' + ' /bNone'
                    BuiltIn().log_to_console(exe_cmd)
                    result = os.popen(exe_cmd).read()
                    time.sleep(5)
                    if result.strip() == '':
                        if flash_type == 'kds_dump':
                            return True
                        result_file = open(flashgui_executable_path + '/Result.txt', 'r').read()
                        if result_file.strip() == '0x00000000':
                            BuiltIn().log_to_console("Erase Dataflash Success.Now flashing Debug binary with UCB and KDS")
                            if program_ucb == True :
                                BuiltIn().log_to_console("Flashing debug aurix with UCB and KDS start")
                                exe_cmd="FlashGUI.exe /CMCR /h /"'"' +"i"""""Quad-Gen5-6Dbg C -XCG2N67R"""""+'"'+self.com_details + ' /f ' + str(flashgui_DNLpath)
                                if flash_type == 'update':
                                    exe_cmd = exe_cmd + ' /au'
                                elif flash_type == 'virgin':
                                    exe_cmd = exe_cmd + ' /av'+ ' /b 8200;4024'
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
                                    BuiltIn().log_to_console("Flashing UCB and KDS PASS")
                                elif result_file.strip() in suppress.split(","):
                                    self.log.debug('Suppressed exit code: ' + result_file.strip())
                                    BuiltIn().log_to_console("Flashing UCB and KDS FAILS")
                                    return False
                                else:
                                    self.log.error('Encounter exit code: ' + result_file.strip())
                                    BuiltIn().log_to_console("Flashing UCB and KDS FAILS")
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
