
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

sThisModuleName    = "auto_flash.py"
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
class auto_flash_secureboot():
    """ This class contains the keywords for PCAT Auto_Flash methods and APIs to send/get data using ADB commands.
        NOTE: Always run this script with all the parameters is  mandatory.Arguments are seperated by semicolons(;)
        Usage: <python> auto_flash.py -a  <param1>;<param2>;<param3>;<param4>;<param5>
        <param1> - FlashTool (PCAT)
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
    def check_device_connection(self):
        """
        Check the ADB device and state\n
        = Interfaces =\n
        OUT_1: ``result`` (bool): Keyword execution acknowledgement.\n
        """
        result = False
        cmd=self.adb_path+"devices"
        proc = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        try:
            outs, errs = proc.communicate(timeout=15)
            errorcode=proc.returncode
        except subprocess.TimeoutExpired as errs:
            outs = str(errs)
            errorcode=1
            proc.kill()
        outs = str(outs).replace("List of devices attached","").strip()
        output=re.search("\\\\r\\\\n("+self.device_id+")\\\\t(\w+)",str(outs))
        
        if output is None:
            BuiltIn().log("Devices not found",'INFO',False,True)
            return False
        else:
            #check device state
            if errorcode == 0 and output.group() is not None:
                id_adb = output.group(1)
                adb_state = output.group(2)
                if id_adb == self.device_id and adb_state == 'device':
                    result = True
                    BuiltIn().log(f"Device is normal:{id_adb}",'INFO',False,True)
                elif id_adb == self.device_id and adb_state == 'recovery':
                    result = False
                    BuiltIn().log(f"Device in recovery:{id_adb}",'INFO',False,True)
                elif id_adb == self.device_id and adb_state == 'unauthorized':
                    result = True
                    BuiltIn().log(f"Device in unauthorized:{id_adb}",'INFO',False,True)
                else:
                    BuiltIn().log("Device not detected "+str(outs),'INFO',False,True)
        return result
    @keyword
    def set_preconditions(self,hw_details_path):
        """
        Sets the preconditions before auto_flash device\n
        = Interfaces =\n
        IN: ``hw_details_path`` (str): hw configuration file path .\n
        OUT_1: ``bAck`` (bool): Keyword execution acknowledgement.\n
        OUT_1: ``sut_relay_port`` (bool): Keyword execution acknowledgement.\n
        """
        bAck = False
        sut_relay_port = ''
        # get hostname
        host = socket.gethostname()
        try:
            relay_port = self.get_hardwaredetails(hardware_details_path=hw_details_path, field='relay_no')
            if relay_port is not None:
                if  relay_port == "SUT2":
                    bAck = self.bits_p.configure_tcpip_connection(sHost=host,nPort=4001)
                    time.sleep(0.1)
                    if bAck is True:
                        BuiltIn().log(f"*******BITS Platform with host:'{host}' and port 4001 is Set*******", 'INFO', False, True)
                elif  relay_port == "SUT3":
                    bAck = self.bits_p.configure_tcpip_connection(sHost=host,nPort=4002)
                    time.sleep(0.1)
                    if bAck is True:
                        BuiltIn().log(f"*******BITS Platform with host:'{host}' and port 4002 is Set*******", 'INFO', False, True)
                elif  relay_port == "SUT1":
                    BuiltIn().log(f"*******BITS Platform with host:'{host}' and default port 4000 is Set*******", 'INFO', False, True)
                    bAck = True
                else:
                    pass
                # sut relay details
                sut_relay_port = relay_port
        except Exception as errs:
            BuiltIn().log("ERROR at set_preconditions: " + str(errs), 'INFO', False, True)
        return bAck,sut_relay_port
    @keyword
    def trigger_sut_reboot(self,off_wait=20,on_wait=75):
        """
        Trigger the SUT reboot via relays to restart device\n
        = Interfaces =\n
        IN: ``off_wait`` (int): wait time after turn off relays .\n
        IN: ``on_wait`` (int): wait time after turn off relays .\n
        OUT_1: ``bAck`` (bool): Keyword execution acknowledgement.\n
        """
        bAck = False
        bCheck = False
        try:
            relay_port = self.get_hardwaredetails(hardware_details_path=hw_details_path, field='relay_no')
            if relay_port is not None:
                #turn off relays
                bCheck = self.bits_p.output_set_digital_signal_value(sSignalName=relay_port+'_ACC',sState='OFF')
                time.sleep(2)
                bCheck = self.bits_p.output_set_digital_signal_value(sSignalName=relay_port+'_IGN',sState='OFF')
                time.sleep(2)
                bCheck = self.bits_p.output_set_digital_signal_value(sSignalName=relay_port+'_Battery',sState='OFF')
                time.sleep(off_wait)
                #now turn on
                bCheck = self.bits_p.output_set_digital_signal_value(sSignalName=relay_port+'_Battery',sState='ON')
                time.sleep(2)
                bCheck = self.bits_p.output_set_digital_signal_value(sSignalName=relay_port+'_IGN',sState='ON')
                time.sleep(2)
                bCheck = self.bits_p.output_set_digital_signal_value(sSignalName=relay_port+'_ACC',sState='ON')
                BuiltIn().log("Wait for the device after reboot...", 'INFO', False, True)
                time.sleep(on_wait)
                if bCheck is not False:
                    bAck = True
        except Exception as errs:
            BuiltIn().log("ERROR at trigger_sut_reboot: " + str(errs), 'INFO', False, True)
        return bAck
    def get_hardwaredetails(self,hardware_details_path,field):
        result = ''
        try:
            with open(hardware_details_path) as hw_details:
                data = json.load(hw_details)
                result = data[str(socket.gethostname())][str(self.device_id)][str(field)]
                BuiltIn().log(field+"is: "+result)
            hw_details.close()
        except Exception as errs:
            BuiltIn().log("ERROR at get_hardwaredetails: " + str(errs), 'INFO', False, True)
        return result
    def flash_status_update(self,file,status):
        try:
            with open(file,'w') as flash_state:
                flash_state.write(status)
                time.sleep(0.05)
            flash_state.close()
        except Exception as errs:
            BuiltIn().log("ERROR at flash_status_update: " + str(errs), 'INFO', False, True)
    def send_command(self,cmd=None, outtime=15):
        cmd=self.adb_path+"-s "+self.device_id+' '+cmd.replace('$',' ')
        outtime = int(outtime)
        BuiltIn().log("Received timeout set to "+str(outtime))
        errorcode = 0
        proc = subprocess.Popen(cmd, shell=True)
        try:
            outs, errs = proc.communicate(timeout=outtime)
            returncode = proc.returncode
        except subprocess.TimeoutExpired as errs:
            outs = [errs]
            returncode=1
            errorcode = 1
        BuiltIn().log("Subprocess output "+ str(outs))
        BuiltIn().log("Result for command : "+ cmd+ "is "+ str(returncode))
        if errorcode == 0 and returncode == 0 :
            result="True"
        else:
            result="False"
        return  result
    def wipe_data(self, qdl_flash_path):
        try:
            print("Wipe data on the Target start")
            os.chdir(qdl_flash_path)
            flashCmd = qdl_flash_path + "/flash_with_qdl.sh -w"
            proc = subprocess.Popen(flashCmd, shell=True)
            try:
                outs, errs = proc.communicate(timeout=300)
                errorcode = proc.returncode
                print("Response : ",outs)
                print("The Error Code is : ",errs)
            except subprocess.TimeoutExpired as errs:
                outs = [errs]
                errorcode = 1
                proc.kill()
            print("sleeping for 10s")
            time.sleep(10)
            print(errorcode)
            print("Response : ",outs)
            if errorcode == 0:
                print("Wiped data on the Target")
                return True, str(outs)
            else:
                print("wipe data failed")
                return False, str(outs)
        except Exception as error:
            print("The Error Code is : ",error)
            return False, "Device failed to boot after data wipe"
    def qdl_flash(self, qdl_flash_path, hw_details_directory):
        product_xml = self.get_hardwaredetails(str(hw_details_directory),"product_xml")
        print("Default Product Sample is: ",product_xml)
        try:
            print("EDL mode is entered forcefuly via DEBUG Command")
            os.chdir(qdl_flash_path)
            flashCmd = qdl_flash_path +"/flash_with_qdl.sh -p  "+product_xml
            proc = subprocess.Popen(flashCmd, shell=True)
            try:
                outs, errs = proc.communicate(timeout=1200)
                errorcode=proc.returncode
                print("Response : ",outs)
                print("The Error Code is : ",errs)
            except subprocess.TimeoutExpired as errs:
                outs = [errs]
                errorcode=1
                proc.kill()
            print("sleeping for 10s")
            time.sleep(10)
            print("The Error Code is : ",errorcode)
            print("Response : ",outs)
            if errorcode == 0 :
                return True,str(outs)
            else:
                print("flashing failed")
                return False,str(outs)
        except Exception as error:
            print (error)
            return False,"Device failed to boot to EDL mode"
    @keyword
    def get_edl_mode(self):
        """
        Force the device to enter EDL mode.\n
        = Interfaces =\n
        OUT_1: ``result`` (bool): Keyword execution acknowledgement.\n
        """
        BuiltIn().log("Set Device to EDL mode..", 'INFO', False, True)
        edl_cmd=self.adb_path+"-s "+self.device_id+' '+"reboot edl"
        proc = subprocess.Popen(edl_cmd, shell=True)
        try:
            outs, errs = proc.communicate(timeout=15)
            errorcode=proc.returncode
            result = True
        except subprocess.TimeoutExpired as errs:
            outs = [errs]
            errorcode=1
            proc.kill()
            result = False
        BuiltIn().log("get_edl_mode Error Code is : "+str(errorcode))
        BuiltIn().log("Response : "+str(outs))
        return result
    @keyword
    def get_device_state(self,pcat_serial):
        """
        Get the PCAT device state and Serial.\n
        = Interfaces =\n
        IN: ``hw_config_details`` (str): hw configuration file path .\n
        OUT_1: ``result`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``sDeviceState`` (str): PCAT Device mode.\n
        OUT_3: ``sDeviceSerial`` (str): PCAT Device Serial.
        """
        sDeviceState = ""
        sDeviceSerial= ""
        #pcat_serial = self.get_hardwaredetails(str(hw_config_details),"pcat_serial")
        dev_cmd="pcat -DEVICES"
        proc = subprocess.Popen(dev_cmd, shell=True,stdout=subprocess.PIPE)
        # proc = subprocess.Popen(str(cmd), stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True) 
        # stdout, stderr = proc.communicate()
        try:
            outs, errs = proc.communicate()
            errorcode=proc.returncode
            print("The Error Code is : ",str( outs))
            print("The Error Code is : ",str(errs))
            print("The Error Code is : ",str(errorcode))
            out=re.search("(\n|)\|\s{2}([A-Z+]+)\s*\|\s*("+pcat_serial+")\s*\|\s*(.\w+)\s*",str(outs))
        except subprocess.TimeoutExpired as errs:
            outs = [errs]
            errorcode=1
            proc.kill()
        # Stabilization for 5s
        time.sleep(5)
        if out is None:
            return False,sDeviceState,pcat_serial
        else:
            #extract details from out
            if out.group() != None:
                #print("Out_Result : ",out.group().strip())
                if out.group(2).strip() == "NORMAL":
                    if pcat_serial == out.group(3).strip():
                        sDeviceState = out.group(2).strip()
                        sDeviceSerial = out.group(3).strip()
                if out.group(2).strip() == "EDL":
                    if pcat_serial == out.group(3).strip():
                        sDeviceState = out.group(2).strip()
                        sDeviceSerial = out.group(3).strip()
                return True,sDeviceState,sDeviceSerial
            else:
                return False,sDeviceState,pcat_serial
    def qdl_flash_normal_mode(self, qdl_flash_path):
        try:
            print("EDL mode is entered forcefuly via DEBUG Cmd")
            os.chdir(qdl_flash_path)
            flashCmd = qdl_flash_path+"/flash_with_qdl.sh"
            print("qdlFlash_Command",flashCmd)
            proc = subprocess.Popen(flashCmd, shell=True)
            try:
                outs, errs = proc.communicate(timeout=1200)
                errorcode=proc.returncode
                print("Response : ",outs)
                print("The Error Code is : ",errs)
            except subprocess.TimeoutExpired as errs:
                outs = [errs]
                errorcode=1
                proc.kill()
            print("Sleeping for 10s")
            time.sleep(10)
            print("The Error Code is : ",errorcode)
            print("Response : ",outs)
            if errorcode == 0 :
                return True,str(outs)
            else:
                for i in range(0,5):
                    print("Retry : Sleeping for 10s")
                    time.sleep(10)
                    os.chdir(qdl_flash_path)
                    flash_Cmd = qdl_flash_path+"/flash_with_qdl.sh"
                    proc = subprocess.Popen(flash_Cmd, shell=True)
                    try:
                        outs, errs = proc.communicate(timeout=1200)
                        error_code=proc.returncode
                        print("Retry_Response : ",outs)
                        print("Error_Code is : ",errs)
                    except subprocess.TimeoutExpired as errs:
                        outs = [errs]
                        error_code =1
                        proc.kill()
                    if error_code == 0:
                        return True,str(outs)
                        break
                print("Flashing failed")
                return False,str(outs)
        except Exception as error:
            print (error)
            return False,"Device failed to boot to EDL mode"

    
    @keyword
    def pcat_flash_CDT(self,pcat_serialnumber,memory_type_ufs,memory_flavorCDT):

        pcat_flash_path = BuiltIn().get_variable_value("${sut.auto_flash.pcat_path}")
        pcat_flash_drive = BuiltIn().get_variable_value("${sut.auto_flash.drive}")
        cdtpath = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c0012p.sut2.cdt_path}")
        contents_xml = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c0012p.sut2.contents_xml}")
        cdtfullpath = pcat_flash_drive + ":" + cdtpath
        JenkinsEnable = BuiltIn().get_variable_value("${sut.auto_flash.JenkinsEnable}")

        def search_folder(folder_name):
            os.chdir(str('D://tmp//SWdownload//soc//'))
            current_path = os.getcwd()
            #BuiltIn().log_to_console(current_path)
            folder_name = "out-collect"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if folder_name in dirnames:
                    return os.path.join(dirpath,folder_name)
            return None
        folder_name = "out-collect"
        found_path = search_folder(folder_name)
        BuiltIn().log_to_console(found_path)
        if found_path:
            pathofcollect = found_path
            BuiltIn().log_to_console(pathofcollect)
        else:
            print ('did not find the path')

        if JenkinsEnable    ==   True :
            # pcat_path = "D://tmp//SWdownload//soc//" + BuiltIn().get_variable_value("${SOC_VERSION}") + "//out-collect"
            pcat_path = pathofcollect
            BuiltIn().log_to_console(pcat_path)
        else:
            pcat_path = pcat_flash_drive + ":" + pcat_flash_path
            BuiltIn().log_to_console(pcat_path)
        try:
            os.chdir(str(pcat_path ))
            BuiltIn().log_to_console(pcat_path)
            flash_Cmd="pcat -plugin SD -device "+pcat_serialnumber+ " -build" +" "+contents_xml + " " + "-memorytype" + " " +memory_type_ufs + " " + "-flavor" + " " +memory_flavorCDT
            # flash_Cmd="pcat -plugin SD -device "+pcat_serialnumber+ " -build" +" "+pcat_path  + " " + "-memorytype" + " " +memory_type_ufs + " " + "-flavor" + " " +memory_flavorCDT
            proc = subprocess.Popen(flash_Cmd, shell=True)
            try:
                outs, errs = proc.communicate(timeout=1200)
                errorcode=proc.returncode
                #BuiltIn().log("The Error Code is : ",errs)
            except subprocess.TimeoutExpired as errs:
                outs = [errs]
                errorcode=1
                proc.kill()
            BuiltIn().log("Sleeping for 5s")
            time.sleep(5)
            BuiltIn().log("PCAT_F Error Code : "+str(errorcode))
            if errorcode == 0 :
                return True,str(outs)
            else:
                return False,str(outs)
        except Exception as error:
            BuiltIn().log("ERROR at PCAT_FLASH : "+ str(error), 'INFO', False, True)
            return False,"Device Flash failed"


    @keyword
    def pcat_flash_SOC_Sail(self):
        """
        Flash Device with SOC SAIL via PCAT tool.\n
        = Interfaces =\n
        IN1: ``pcat_flash_path`` (str): Software build path.\n
        IN1: ``pcat_serialnumber`` (str): PCAT Serial Number of the device .\n
        IN1: ``hw_config_details`` (str): hw configuration file path .\n
        OUT_1: ``result`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``sDeviceState`` (str): Device Flash Status.\n
        """
        pcat_flash_drive = BuiltIn().get_variable_value("${sut.auto_flash.drive}")
        pcat_flash_path = BuiltIn().get_variable_value("${sut.auto_flash.pcat_path}")
        pcat_flash_fullpath = pcat_flash_drive + ":" + pcat_flash_path + "contents.xml"
        pcat_serialnumber = BuiltIn().get_variable_value("${SUTSERIALNUMBER}")
        memory_typeSail_Flatbuild = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c0012p.sut2.memory_typeSail}")
        #memory_flavor = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c0012p.sut2.memory_flavor}")
        #contents_xml = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c0012p.sut2.contents_xml}")
        JenkinsEnable = BuiltIn().get_variable_value("${sut.auto_flash.JenkinsEnable}")
        BuiltIn().log_to_console(JenkinsEnable)
        # os.chdir(str('D://tmp//SWdownload//soc//'))
        # current_path = os.getcwd()
        # BuiltIn().log_to_console(current_path)

        def search_folder(folder_name):
            os.chdir(str('D://tmp//SWdownload//soc//'))
            current_path = os.getcwd()
            #BuiltIn().log_to_console(current_path)
            folder_name = "out_sail_nor_lemans_flat"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if folder_name in dirnames:
                    return os.path.join(dirpath,folder_name)
            return None
        folder_name = "out_sail_nor_lemans_flat"
        found_path = search_folder(folder_name)
        BuiltIn().log_to_console(found_path)
        if found_path:
            pathofcollect = found_path
            BuiltIn().log_to_console(pathofcollect)
        else:
            print ('did not find the path')
        #BuiltIn().log_to_console(pathofcollect)
        if JenkinsEnable    ==   True :
            # pcat_path = "D://tmp//SWdownload//soc//" + BuiltIn().get_variable_value("${SOC_VERSION}") + "//out-collect"
            #pcat_path = "D://tmp//SWdownload//soc//" + "//out-collect"
            BuiltIn().log_to_console("going in try0")
            pcat_path = pathofcollect
            BuiltIn().log_to_console(pcat_path)
        else:
            pcat_path = pcat_flash_drive + ":" + pcat_flash_path
            BuiltIn().log_to_console(pcat_path)

        try:
            os.chdir(str(pcat_path))
            BuiltIn().log_to_console("going in try")
            #flash_Cmd="pcat -plugin SD -device "+pcat_serialnumber+ " -build" +" "+contents_xml + " " + "-memorytype" + " " +memory_typeSail + " " + "-flavor" + " " +memory_flavor
            flash_Cmd="pcat -plugin SD -device "+pcat_serialnumber+ " -BUILD" + " " +pathofcollect + " " + "-MEMORYTYPE " +memory_typeSail_Flatbuild + " -ERASE FALSE" + " -chaineddigest" + " " +pathofcollect + "\chainedtableofdigests.bin" + " -signeddigest" + " " + pathofcollect + "\DigestsToSign.bin.mbn"
            proc = subprocess.Popen(flash_Cmd, shell=True)
            try:
                outs, errs = proc.communicate(timeout=1200)
                errorcode=proc.returncode
                #BuiltIn().log("The Error Code is : ",errs)
            except subprocess.TimeoutExpired as errs:
                outs = [errs]
                errorcode=1
                proc.kill()
            BuiltIn().log("Sleeping for 5s")
            time.sleep(5)
            BuiltIn().log("PCAT_F Error Code : "+str(errorcode))
            if errorcode == 0 :
                return True,str(outs)
            else:
                return False,str(outs)
        except Exception as error:
            BuiltIn().log("ERROR at PCAT_FLASH : "+ str(error), 'INFO', False, True)
            return False,"Device Flash failed"

    @keyword
    def pcat_flash_SOC_Main(self):
        """
        Flash Device with SOC MAIN via PCAT tool.\n
        = Interfaces =\n
        IN1: ``pcat_flash_path`` (str): Software build path.\n
        IN1: ``pcat_serialnumber`` (str): PCAT Serial Number of the device .\n
        IN1: ``hw_config_details`` (str): hw configuration file path .\n
        OUT_1: ``result`` (bool): Keyword execution acknowledgement.\n
        OUT_2: ``sDeviceState`` (str): Device Flash Status.\n
        """
        pcat_flash_drive = BuiltIn().get_variable_value("${sut.auto_flash.drive}")
        pcat_flash_path = BuiltIn().get_variable_value("${sut.auto_flash.pcat_path}")
        pcat_flash_fullpath = pcat_flash_drive + ":" + pcat_flash_path + "contents.xml"
        # pcat_path = pcat_flash_drive + ":" + pcat_flash_path
        # BuiltIn().log_to_console(pcat_flash_fullpath)
        # BuiltIn().log_to_console(pcat_path)
        pcat_serialnumber = BuiltIn().get_variable_value("${SUTSERIALNUMBER}")
        memory_typeMainSW_flatbuild = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c001xa.sut2.memory_typeMainSW_flatbuild}")
        #memory_flavorMainSW = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c001xa.sut2.memory_flavorMainSW_flatbuild}")
        #contents_xml_flatbuild = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c001xa.sut2.contents_xml_flatbuild}")
        JenkinsEnable = BuiltIn().get_variable_value("${sut.auto_flash.JenkinsEnable}")
        BuiltIn().log_to_console(JenkinsEnable)

        def search_folder(folder_name):
            os.chdir(str('D://tmp//SWdownload//soc//'))
            current_path = os.getcwd()
            #BuiltIn().log_to_console(current_path)
            folder_name = "out_8255_mgvm_flat"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if folder_name in dirnames:
                    return os.path.join(dirpath,folder_name)
            return None
        folder_name = "out_8255_mgvm_flat"
        found_path = search_folder(folder_name)
        BuiltIn().log_to_console(found_path)
        if found_path:
            pathofcollect = found_path
            BuiltIn().log_to_console(pathofcollect)
        else:
            print ('did not find the path')

        if JenkinsEnable    ==   True :
            # pcat_path = "D://tmp//SWdownload//soc//" + BuiltIn().get_variable_value("${SOC_VERSION}") + "//out-collect"
            pcat_path = pathofcollect
            BuiltIn().log_to_console(pcat_path)
        else:
            pcat_path = pcat_flash_drive + ":" + pcat_flash_path
            BuiltIn().log_to_console(pcat_path)
        try:
            os.chdir(str(pcat_path))
            #BuiltIn().log_to_console(pcat_flash_fullpath)
            #flash_Cmd="pcat -plugin SD -device "+pcat_serialnumber+ " -build" +" "+contents_xml_flatbuild + " " + "-memorytype" + " " +memory_typeMainSW_flatbuild + " " + "-flavor" + " " +memory_flavorMainSW +"-erase false "
            flash_Cmd="pcat -plugin SD -device "+pcat_serialnumber+ " -build" + " " +pathofcollect + " " + "-memorytype" + " " +memory_typeMainSW_flatbuild + " -ERASE FALSE" + " -chaineddigest" + " " +pathofcollect + "\chainedtableofdigests.bin" + " -signeddigest" + " " + pathofcollect + "\DigestsToSign.bin.mbn"

            proc = subprocess.Popen(flash_Cmd, shell=True)
            try:
                outs, errs = proc.communicate(timeout=1200)
                errorcode=proc.returncode
                #BuiltIn().log("The Error Code is : ",errs)
            except subprocess.TimeoutExpired as errs:
                outs = [errs]
                errorcode=1
                proc.kill()
            BuiltIn().log("Sleeping for 5s")
            time.sleep(5)
            BuiltIn().log("PCAT_F Error Code : "+str(errorcode))
            if errorcode == 0 :
                return True,str(outs)
            else:
                return False,str(outs)
        except Exception as error:
            BuiltIn().log("ERROR at PCAT_FLASH : "+ str(error), 'INFO', False, True)
            return False,"Device Flash failed"

    @keyword
    def pcat_flash_UFS_provinsioning(self,pcat_serialnumber,memory_type_ufs):

        #' -UFSPROV TRUE -UFSPROVXML "' + str(provision_file_path) + '"'
        pcat_flash_drive = BuiltIn().get_variable_value("${sut.auto_flash.drive}")
        pcat_flash_path = BuiltIn().get_variable_value("${sut.auto_flash.pcat_path}")
        xmlpath = BuiltIn().get_variable_value("${sut.auto_flash.hardware_info.pg9c0012p.sut2.Provisioning_xmlpath}")
        Provisioning_xmlpath = pcat_flash_drive + ":" + xmlpath
        pcat_path = pcat_flash_drive + ":" + pcat_flash_path
        JenkinsEnable = BuiltIn().get_variable_value("${sut.auto_flash.JenkinsEnable}")
        BuiltIn().log_to_console(JenkinsEnable)

        def search_folder(folder_name):
            os.chdir(str('D://tmp//SWdownload//soc//'))
            current_path = os.getcwd()
            #BuiltIn().log_to_console(current_path)
            folder_name = "out-collect"
            for dirpath, dirnames, filenames in os.walk(current_path):
                if folder_name in dirnames:
                    return os.path.join(dirpath,folder_name)
            return None
        folder_name = "out-collect"
        found_path = search_folder(folder_name)
        BuiltIn().log_to_console(found_path)
        if found_path:
            pathofcollect = found_path
            BuiltIn().log_to_console(pathofcollect)
        else:
            print ('did not find the path')

        if JenkinsEnable    ==   True :
            # pcat_path = "D://tmp//SWdownload//soc//" + BuiltIn().get_variable_value("${SOC_VERSION}") + "//out-collect"
            pcat_path = pathofcollect
            Provisioning_xmlpath = pcat_path + "//common//config//ufs//provision//provision_default.xml"
            BuiltIn().log_to_console(pcat_path)
        else:
            pcat_path = pcat_flash_drive + ":" + pcat_flash_path
            BuiltIn().log_to_console(pcat_path)

        try:
            os.chdir(str(pcat_path))
            flash_Cmd="pcat -plugin SD -device "+pcat_serialnumber+ " -build" +" "+pcat_path + " " + "-memorytype" + " " +memory_type_ufs + ' -UFSPROV TRUE -UFSPROVXML "' + str(Provisioning_xmlpath) + '"'
            proc = subprocess.Popen(flash_Cmd, shell=True)
            try:
                outs, errs = proc.communicate(timeout=1200)
                errorcode=proc.returncode
                #BuiltIn().log("The Error Code is : ",errs)
            except subprocess.TimeoutExpired as errs:
                outs = [errs]
                errorcode=1
                proc.kill()
            BuiltIn().log("Sleeping for 5s")
            time.sleep(5)
            BuiltIn().log("PCAT_F Error Code : "+str(errorcode))
            if errorcode == 0 :
                return True,str(outs)
            else:
                return False,str(outs)
        except Exception as error:
            BuiltIn().log("ERROR at PCAT_FLASH : "+ str(error), 'INFO', False, True)
            return False,"Device Flash failed"


