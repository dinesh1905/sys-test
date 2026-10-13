import os
import logging
import time

from interface_handler import interface_handler

class ethswitch(interface_handler):
    """
    This library is use to flash or access registers of Marvell Automotive Switches.

    Dependencies:
    The library will communicate with ethernet firmware upgrade tool and jtag register access tool.
    Will require JTAGlive for tools that use JTAG port.
    The software can be found at following pages:

    1) Flashing via ethernet port: (DownloadImage_v2)
    \\bosch.com\DfsRB\DfsMY\LOC\Pg\CM\CM-CI1_ENG\Dept\ESS\ESS_SYT\8.0 EST_Project\8.35 ID BUZZ\14.0_Tools\DownloadImage.exe

    2) Flashing via JTAG port: (spi_flash.exe)
    \\bosch.com\DfsRB\DfsMY\LOC\Pg\CM\CM-CI1_ENG\Dept\ESS\ESS_SYT\8.0 EST_Project\8.35 ID BUZZ\14.0_Tools\SPI_Flash

    3) Register access tool via JTAG port: (jtag_rat.exe)
    \\bosch.com\DfsRB\DfsMY\LOC\Pg\CM\CM-CI1_ENG\Dept\ESS\ESS_SYT\8.0 EST_Project\8.35 ID BUZZ\14.0_Tools\JTAG_RAT
    """
    def __init__(self):
        self.logging = logging.getLogger(__name__)
        self.port = ''
        self.interface_option = []
        self.flashing_exe_path = ''
        self.register_access_exe_path = ''
        self.binary_path = ''

    def __del__(self):
        self.logging = None
        self.port = None
        self.interface_option = None
        self.flashing_exe_path = None
        self.register_access_exe_path = None
        self.binary_path = None

    def _check_prerequisite_files_exist(self):
        if self.interface_type =='ssh':
            rc1 = self.execute_command("[ -f " + self.flashing_exe_path + " ]", return_stdout=False, return_rc=True)
            rc2 = self.execute_command("[ -f " + self.binary_path + " ]", return_stdout=False, return_rc=True)
            self.logging.debug("ssh: rc1=" + str(rc1) + " rc2=" + str(rc2))
        elif self.interface_type =='cmdprompt':
            rc1 = self.execute_command("IF EXIST " + self.flashing_exe_path + " (EXIT /b 0) else (EXIT /b 1)", return_stdout=False, return_rc=True)
            rc2 = self.execute_command("IF EXIST " + self.binary_path + " (EXIT /b 0) else (EXIT /b 1)", return_stdout=False, return_rc=True)
            self.logging.debug("cmdprompt: rc1=" + str(rc1) + " rc2=" + str(rc2))
        else:
            self.logging.error("Please check `Set Flashing Interface` is set to SSH or windows command prompt")
            return False

        if rc1 == 0 and rc2 == 0:
            return True
        else:
            self.logging.error("Not found executable path or binary file")
            return False

    def _jtag_is_ready(self):
        result = self.execute_command(self.flashing_exe_path + " -showSPI", return_stdout=True, return_rc=True)
        stdout = result[0]
        rc = result[1]

        self.logging.debug("rc=" + str(rc))
        self.logging.debug(stdout)

        if rc == 0 and "CPU already running!" in stdout:
            return True
        else:
            self.logging.error("Please check JTAGlive connection.")
            return False

    def check_JTAG_connection(self):
        """
        To check JTAG live is connected and ready to be use.

        *Example*

        | ${result}= | Check JTAG Connection |

        | ${result}= True   # jtag is ready for further execution
        | ${result}= False  # jtag is not ready
        """
        if self._jtag_is_ready():
            return True
        else:
            return False

    def set_register_access_tool_path(self, path_to_executable):
        """
        Set the path to the executable file for register access tool

        Valid input are listed below

        - ``path_to_executable`` the directory path to the executable file.

        *Example*

        | Set Register Access Tool Path | C:/jtag_rat.exe |
        """
        if path_to_executable != '':
            self.register_access_exe_path = str(path_to_executable)
        else:
            self.logging.error('Not found file specified in `path_to_executable`.')

    def check_bootup_success(self):
        """
        Check the boot complete based on boot code steps performed

        *Example*

        | ${result}= | Check Bootup Success |

        | ${result}= True   # Bootup success
        | ${result}= False  # Bootup failed
        """
        if self._jtag_is_ready():
            cmd = self.register_access_exe_path + " -command=showBootPerfData"
            result = self.execute_command(cmd, return_rc=True)
            stdout = result[0]
            rc = result[1]
            self.logging.debug(stdout)
            if rc == 0 and "BOOT_COMPLETE" in stdout:
                self.logging.debug("Ethernet switch bootup success")
                return True
            else:
                raise AssertionError("Ethernet switch not bootup")
                return False
        else:
            return False

    def set_flashing_tool_path(self, path_to_executable):
        """
        Set the path to the executable file for flashing tool

        Valid input are listed below

        - ``path_to_executable`` the directory path to the executable file.

        *Example*

        | Set Flashing Tool Path | C:/DownloadImage_v2.exe |
        | Set Flashing Tool Path | spi_flash.exe |
        """
        if path_to_executable != '':
            self.flashing_exe_path = str(path_to_executable)
        else:
            self.logging.error('Not found file specified in `path_to_executable`.')

    def set_flashing_port(self, port):
        """
        Set the connected port to use for flashing

        Valid input are listed below

        - ``port`` the type of port connected to use for flashing.(options are: JTAG, Ethernet)

        *Example*

        | Set Flashing Port | JTAG |
        | Set Flashing Port | Ethernet |
        """
        port = str(port).lower()
        if port in ['jtag', 'ethernet']:
            self.port = port
            if self.port == 'jtag':
                self.interface_option = ['cmdprompt']
            else:
                self.interface_option = ['ssh', 'cmdprompt']
            return True
        else:
            self.logging.error("Ethernet flashing port can only set either to jtag or ethernet")

    def set_flashing_interface(self, interface):
        """
        Set the interface to use for flashing

        Valid input are listed below

        - ``interface`` the type of interface to use for flashing.(options are: SSH, CmdPrompt)

        *Example*

        | Set Flashing Interface | SSH |
        | Set Flashing Interface | CmdPrompt |
        """
        if self.interface_option != []:
            if str(interface).lower() in self.interface_option:
                self.set_interface_type(interface)
                result = self.execute_command("echo Hello", return_rc=True)
                rc = result[1]
                if rc == 0:
                    return True
                else:
                    self.logging.error("Failed to set interface to use for ethernet flashing.")
            else:
                self.logging.error("Ethernet flashing via " + str(self.port) + " can only be done through " + str(self.interface_option))
        else:
            self.logging.error("Flashing interface option is empty. Please ensure `Set Flashing Port` is done.")

    def flash_image(self, binary_file_path, ethernet_index=None, mac_address="1A-11-01-01-01-62"):
        """
        Perform flashing of ethernet switch with the specified binary

        Valid input are listed below

        - ``binary_file_path`` path to the ethernet switch binary

        - ``ethernet_index`` index of ethernet adapter connected to eth switch

        - ``mac_address`` MAC address of eth switch

        *Example*

        | Flash Image | C:/MAAS_ETHSWT_25.03.01_SEC_PRJ/88Q5152_flash.bin | 1 |
        | Flash Image | C:/MAAS_ETHSWT_25.03.01_SEC_PRJ/88Q5152_flash.bin |
        | Flash Image | /data/88Q5152_flash.bin | 0 |
        """
        self.binary_path = binary_file_path
        if self._check_prerequisite_files_exist():
            if self.port == 'jtag':
                if self._jtag_is_ready():
                    self.logging.info("Start flashing")
                    cmd = self.flashing_exe_path + " -jtagmode=MAX -update=SPD -fastverify -infile=" + self.binary_path
                    result = self.execute_command(cmd, return_rc=True)
                    stdout = result[0]
                    rc = result[1]
                    if rc == 0:
                        self.logging.debug("Succeed to execute:" + cmd)
                        self.logging.debug(stdout)
                    else:
                        self.logging.error("Failed to execute:" + cmd)
                        self.logging.debug(stdout)
                        return False
                    self.logging.info("Done flashing")

                    return True
                else:
                    return False
            else:
                self.logging.info("Start flash Primary Partition")
                data_type=[2, 1, 5, 3]
                image_offset=[0x0B0000, 0x030000, 0x12000, 0x10000]
                image_size=[0x50000, 0x7d000, 0x1E000, 0x2000]
                for dtype, offset, size in zip(data_type, image_offset, image_size):
                    cmd = self.flashing_exe_path + " -ii" + str(ethernet_index) + " -if" + binary_file_path + " -dt" + str(dtype) + " -io" + hex(offset) + " -is" + hex(size) + " -da" + mac_address
                    result = self.execute_command(cmd, return_rc=True)
                    stdout = result[0]
                    rc = result[1]
                    if rc == 0:
                        self.logging.debug("Succeed to execute:" + cmd)
                        self.logging.debug(stdout)
                    else:
                        self.logging.error("Failed to execute:" + cmd)
                        self.logging.debug(stdout)
                        return False
                    time.sleep(2)
                self.logging.info("Done flash Primary Partition")

                self.logging.info("Start flash Secondary Partition")
                data_type=[2, 1, 5, 4]
                image_offset=[0x1A0000, 0x120000, 0x102000, 0x100000]
                image_size=[0x50000, 0x7d000, 0x1E000, 0x2000]
                for dtype, offset, size in zip(data_type, image_offset, image_size):
                    cmd = self.flashing_exe_path + " -ii" + str(ethernet_index) + " -if" + binary_file_path + " -dt" + str(dtype) + " -io" + hex(offset) + " -is" + hex(size) + " -da" + mac_address
                    result = self.execute_command(cmd, return_rc=True)
                    stdout = result[0]
                    rc = result[1]
                    if rc == 0:
                        self.logging.debug("Succeed to execute:" + cmd)
                        self.logging.debug(stdout)
                    else:
                        self.logging.error("Failed to execute:" + cmd)
                        self.logging.debug(stdout)
                        return False
                    time.sleep(2)
                self.logging.info("Done flash Secondary Partition")

                return True
        else:
            return False

    def flash_provisioning_image(self, binary_file_path):
        """
        Perform flashing of provisioning image for ethernet switch with the specified binary

        Valid input are listed below

        - ``binary_file_path`` path to the provisioning image binary

        *Example*

        | Flash Provisioning Image | C:/MAAS_ETHSWT_25.03.01_SEC_PRJ/eHsm_DevProv_Secureboot.bin |
        """
        self.binary_path = binary_file_path
        if self._check_prerequisite_files_exist():
            if self.port == 'jtag':
                if self._jtag_is_ready():
                    self.logging.info("Start flashing")
                    cmd = self.flashing_exe_path + " -infile=" + self.binary_path + " -write -address=0x1F2000 -force"
                    result = self.execute_command(cmd, return_rc=True)
                    stdout = result[0]
                    rc = result[1]
                    if rc == 0:
                        self.logging.debug("Succeed to execute:" + cmd)
                        self.logging.debug(stdout)
                    else:
                        self.logging.error("Failed to execute:" + cmd)
                        self.logging.debug(stdout)
                        return False
                    self.logging.info("Done flashing")

                    return True
                else:
                    return False
            else:
                self.logging.error("Flash provisioning image only via JTAG port")
                return False
        else:
            return False