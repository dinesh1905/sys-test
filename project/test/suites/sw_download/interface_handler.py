import logging
import time
import re
from robot.libraries.BuiltIn import BuiltIn

class interface_handler:
    """
    This library is a base class for other library to inherit. It can be use to execute linux shell command and handle its replies via different interface.
    """

    def __init__(self):
        self.logging = logging.getLogger(__name__)

    def __del__(self):
        self.logging = None

    def _execute_command_ssh(self, cmd, sudo_var, stdout_var, rc_var):
        ssh_lib = BuiltIn().get_library_instance("SSHLibrary")
        
        if sudo_var == True:
            cmd = 'sudo ' + cmd

        if rc_var == False:
            ssh_lib.write(cmd)
            return ssh_lib.read_until_prompt(strip_prompt=True).strip()
        else:
            ssh_lib.write(cmd)
            output = ssh_lib.read_until_prompt(strip_prompt=True).strip()
            
            ssh_lib.write('echo $?')
            rc = int(ssh_lib.read_until_prompt(strip_prompt=True).strip())

            if stdout_var == False:
                return rc
            else:
                return [output, rc]

    def _execute_command_serial(self, cmd, sudo_var, stdout_var, rc_var):
        serial = BuiltIn().get_library_instance("SerialLibrary")
        
        if sudo_var == True:
            cmd = 'sudo ' + cmd

        if rc_var == False:
            serial.write_data(cmd + "\n")
            time.sleep(1)
            output = serial.read_all_data().strip(' #')
            return output.replace(cmd + '\r\r\n', '').strip()
        else:
            serial.write_data(cmd + "\n")
            time.sleep(1)
            output = serial.read_all_data().strip(' #')
            output = output.replace(cmd + '\r\r\n', '').strip()
            
            serial.write_data('echo $?' + "\n")
            time.sleep(1)
            rc = serial.read_all_data().strip(' #')
            rc = int(rc.replace('echo $?\r\r\n',''))

            if stdout_var == False:
                return rc
            else:
                return [output, rc]

    def _execute_command_adb(self, cmd, sudo_var, stdout_var, rc_var):
        adb = BuiltIn().get_library_instance("interface_adb")
        
        if sudo_var == True:
            cmd = 'sudo ' + cmd

        if rc_var == False:
            return adb.shell(cmd).strip()
        else:
            output = adb.shell(cmd + ';echo [[$?]]').strip()
            
            if output != None:
                rc = re.search('\[\[[0-9]*\]\]', output).group().strip('[]')
                output = output.replace('[[' + rc + ']]','').strip()
                
                if stdout_var == False:
                    return int(rc)
                else:
                    return [output, int(rc)]
            else:
                return ''

    def _execute_command_cmdprompt(self, cmd, sudo_var, stdout_var, rc_var):
        os_lib = BuiltIn().get_library_instance("OperatingSystem")

        if sudo_var == True:
            self.logging.error("This library doesn't support command with elevated privileges for windows cmd prompt.")
            return

        if rc_var == False:
            return os_lib.run(cmd).strip()
        else:
            result = os_lib.run_and_return_rc_and_output(cmd)
            rc = result[0]
            output = result[1].strip()

            if stdout_var == False:
                return int(rc)
            else:
                output = result[1].strip()
                return [output, int(rc)]

    def set_interface_type(self, interface_type):
        """
        To execute linux shell command via specific interface

        Valid input are listed below

        - ``interface_type`` the interface this library support. Currently only support ADB, SSH, Serial and Windows Command Prompt

        *Examples*

        | Set Interface Type | ADB |
        | Set Interface Type | SSH |
        | Set Interface Type | Serial |
        | Set Interface Type | Cmdprompt |
        """
        supported_interface = ['ssh', 'serial', 'adb', 'cmdprompt']

        if str(interface_type).lower() in supported_interface:
            self.interface_type = str(interface_type).lower()
        else:
            self.logging.error("This library doesn't support this interface type.")
    
    def execute_command(self, cmd, sudo = False, return_stdout = True, return_rc = False):
        """
        Execute a linux shell command and wait for its return output

        Valid input are listed below

        - ``cmd`` the linux shell command
        - ``sudo`` execute the command with sudo
        - ``return_stdout`` show the output of the command executed
        - ``return_rc`` show the return code of the command executed

        *Examples*

        | ${output}= | Execute Command | ls | | | | #get stdout |
        | ${output}= | Execute Command | ls | True | True | True | #execute via sudo, get stdout and return code |
        | ${output}= | Execute Command | ls | False | False | True | #only get the return code |
        """

        if isinstance(sudo, bool) and isinstance(return_stdout, bool) and isinstance(return_rc, bool):
            if self.interface_type == 'ssh':
                return self._execute_command_ssh(str(cmd), sudo, return_stdout, return_rc)
            elif self.interface_type == 'serial':
                return self._execute_command_serial(str(cmd), sudo, return_stdout, return_rc)
            elif self.interface_type == 'adb':
                return self._execute_command_adb(str(cmd), sudo, return_stdout, return_rc)
            elif self.interface_type == 'cmdprompt':
                return self._execute_command_cmdprompt(str(cmd), sudo, return_stdout, return_rc)
            else:
                self.logging.error("This Library doesn't support this interface type.")
        else:
            self.logging.error("sudo, return_stdout, return_rc only accept boolean value.")