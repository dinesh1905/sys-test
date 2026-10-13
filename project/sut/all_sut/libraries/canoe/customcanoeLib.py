import os
import clr
import time
import threading
import win32com.client
import pywintypes
import winerror
import logging
import pythoncom
import ctypes
import subprocess

# clr.AddReference("System.Reflection") # This line might not be needed if set_reference handles it
# from System.Reflection import BindingFlags # This line might not be needed if set_reference handles it
from win32com.client import Dispatch, WithEvents

test_completed = threading.Event()
test_success = threading.Event()

class CanoeEventHandler(object):
  def __init__(self):
    self.logging = logging.getLogger(__class__.__name__)
  def OnStart(self):
    self.logging.debug("OnStart")
    test_success.clear()
    pass
  def OnStop(self, reason):
    self.logging.debug("OnStop: " + str(reason))
    test_completed.set()
    if reason == 0:
      test_success.set()

class customcanoeLib:
  def __init__(self):
    self.logging = logging.getLogger(__name__)
    self.app = None

  def set_logging(self, logging):
    self.logging = logging.getLogger(__name__)

  def set_reference(self, reference):
    """
    Set reference of Vector.CANoe.Interop.dll
    - ``reference`` - path of Vector.CANoe.Interop.dll
    *Examples*
    | Set Reference | /path/to/Vector.CANoe.Interop.dll |
    """
    clr.AddReference(reference)
    self.logging.debug("Initializing application")
    # This line should ideally be creating the app object if not already done
    if self.app is None:
        self.app = win32com.client.Dispatch("CANoe.Application")

  def load_simulation(self, simulation):
    """
    Loads a simulation file (cfg) and waits until it is fully loaded.
    """
    if self.app is None:
        raise RuntimeError("CANoe not open.")

    simulation_path = os.path.abspath(simulation).lower()
    if self.app.Configuration and self.app.Configuration.FullName.lower() == simulation_path:
        self.logging.info(f"Configuration '{simulation}' is already loaded.")
        return

    self.logging.info(f"Opening configuration '{simulation}'...")
    self.app.Open(simulation, False, False)

    max_wait_time = 60
    start_time = time.time()
    load_success = False
    self.logging.info("Waiting for configuration to finish loading...")
    while time.time() - start_time < max_wait_time:
        try:
            if self.app.Configuration.FullName.lower() == simulation_path:
                self.logging.info("[SUCCESS] Configuration has been loaded.")
                load_success = True
                break
        except Exception:
            pass
        time.sleep(1)

    if not load_success:
        raise RuntimeError(f"Failed to load configuration in time.")

  def compile_capl(self):
    """
    Compile CAPL of the loaded simulation
    *Examples*
    | Compile CAPL |
    """
    try:
      self.logging.debug("CAPL compiling")
      if self.app is None: raise RuntimeError("CANoe not open.")
      self.app.CAPL.Compile()
      self.logging.debug("CAPL compile success")
      return True
    except pywintypes.com_error as e:
      self.logging.error("CAPL compile error: " + str(e))
      if self.app is not None and self.app.CAPL is not None and self.app.CAPL.CompileResult is not None:
          self.logging.error("Error message: " + str(self.app.CAPL.CompileResult.ErrorMessage))
      return False

  def save_simulation(self, new_filepath=None, ver_major=16, ver_minor=0):
    """
    Save simulation file (cfg)
    *Examples*
    | Save Simulation | |
    """
    if self.app is None:
      raise RuntimeError("CANoe is not open, unable to Save")
    
    if not self.app.Measurement.Running:
        self.logging.debug("Saving configuration...")
        # Save the current configuration. Set promptUser to False to avoid dialogs.
        self.app.Configuration.Save(promptUser=False)
        self.logging.debug("Configuration saved.")

        if new_filepath is not None:
            self.logging.debug(f"Saving configuration as new file: {new_filepath}")
            current_major = self.app.Version.major
            current_minor = self.app.Version.minor
            
            # If specified version differs or new_filepath is different, use SaveAs
            if new_filepath != self.app.Configuration.FullName or current_major != ver_major or current_minor != ver_minor:
                self.app.Configuration.SaveAs(Name=new_filepath, major=ver_major, minor=ver_minor, promptUser=False)
                self.logging.debug(f"Configuration saved as '{new_filepath}'.")
            else:
                self.logging.debug("New filepath is same as current, no SaveAs needed.")
        else:
            if self.app.Version.major != ver_major or self.app.Version.minor != ver_minor:
                self.logging.error("Need to provide new .cfg filename to save as different version")
    else:
        self.logging.warning("Measurement is running, unable to save simulation.")
  def call_capl_function(self, function_name, *params):
    if self.app is None:
        raise RuntimeError("CANoe not open. Cannot call CAPL function.")
    
    self.logging.info(f"Calling CAPL function '{function_name}' with parameters: {params}")
    
    # --- THIS IS THE FINAL, CORRECT METHOD ---
    # 1. Get the CAPL object.
    capl = self.app.CAPL
    # 2. Get the collection of functions from the CAPL object.
    functions = capl.Functions
    # 3. Get the specific function object you want to call from the collection by its name.
    target_function = functions.Item(function_name)
    # 4. Now, call the .Call() method on the function object itself.
    target_function.Call(*params)
    # --- END OF CORRECTION ---
    
    self.logging.info(f"[SUCCESS] Called CAPL function '{function_name}'.")


  def check_logging_active(self, block_name):
    try:
        status = self.get_system_variable("LoggingState", block_name)
        if status == 1:
            self.logging.info(f"Check status: Logging block '{block_name}' is already ACTIVE.")
            return True
        else:
            self.logging.info(f"Check status: Logging block '{block_name}' is INACTIVE.")
            return False
    except pywintypes.com_error:
        self.logging.warning(f"Could not find system variable 'LoggingState::{block_name}'. Assuming INACTIVE.")
        return False
  def load_test_environment(self, test_environment):
    """
    Load test environment file (tse)
    - ``test_environment`` - path of test environment tse file
    *Examples*
    | Load Test Environment | /path/to/test_environment.tse |
    """
    test_environment = os.path.abspath(test_environment)
    self.logging.debug("Test Environment: " + test_environment)
    if self.app != None:
      self.app.Configuration.TestSetup.TestEnvironments.Add(test_environment)
    else:
      raise RuntimeError("CANoe is not open, unable to load test environment")
  # In customcanoeLib.py, inside the canoe class:

  # In customcanoeLib.py, inside the canoe class:

  def set_can_baudrate(self, can_id, baudrate_in_kbs):
    """
    Set CAN Controller baudrate in kBaud/s by Id
    - ``can_id`` - CAN Controller Id
    ``baudrate_in_kbs`` - Baudrate in kBaud/s
    *Examples*
    | Set CAN Baudrate | 1 | 500 |
    """
    if self.app is None: raise RuntimeError("CANoe not open.")
    self.app.Configuration.GeneralSetup.ControllerSetup(1, can_id).Baudrate = baudrate_in_kbs

  def set_can_fd_baudrate(self, can_id, baudrate, datarate):
    """
    Set CAN FD Controller baudrate and datarate in bits/s by Id
    - ``can_id`` - CAN Controller Id
    - ``baudrate`` - Baudrate in bits/s
    - ``datarate`` - Datarate in bits/s
    *Examples*
    | Set CAN FD Baudrate | 1 | 500 | 1000 |
    """
    if self.app is None: raise RuntimeError("CANoe not open.")
    controller = self.app.Configuration.GeneralSetup.ControllerSetup(1, can_id)
    controller.CANSetFDArbPhaseConfig(baudrate, 5, 2, 2, 0)
    controller.CANSetFDDataPhaseConfig(datarate, 5, 2, 2, 0)

  def start_simulation(self):
    """
    Start simulation / Start measurement
    *Examples*
    | Start Simulation |
    """
    if self.app is None: raise RuntimeError("CANoe not open.")
    if not self.app.Measurement.Running:
      self.logging.debug("Start simulation")
      self.app.Measurement.Start()
    else:
        self.logging.info("Measurement is already running.")

  def stop_simulation(self):
    """
    Stop simulation / Stop measurement
    *Examples*
    | Stop Simulation |
    """
    if self.app is None: raise RuntimeError("CANoe not open.")
    if self.app.Measurement.Running:
      self.logging.debug("Stop simulation")
      self.app.Measurement.StopEx()     # Deferred stop. if something delay the stop
      time.sleep(3)
      for i in range(3):
        if not self.app.Measurement.Running:
          break
        else:
          self.logging.debug("Stop simulation, but still running. Wait another 3 seconds")
        time.sleep(3)
      if self.app.Measurement.Running:
        self.app.Measurement.StopEx()   # full stop
    else:
        self.logging.info("Measurement is not running.")

  def quit_application(self, save_on_quit=False):
    """
    Quits CANoe, with an option to save changes without a user prompt,
    and a fallback to forcefully terminate the process.
    """
    if self.app is None:
        self.logging.info("CANoe application is not open.")
        return

    if save_on_quit:
        try:
            self.logging.info("Saving configuration silently before quitting...")
            # The promptUser=False argument is essential for automation.
            self.app.Configuration.Save(promptUser=False)
            self.logging.info("[SUCCESS] Configuration saved.")
            # Give CANoe a moment to finish writing to disk.
            time.sleep(2) 
        except Exception as e:
            self.logging.error(f"Failed to save configuration before quitting: {e}")
    
    try:
        self.logging.info("Attempting to quit CANoe cleanly...")
        self.app.Quit()
        self.app = None
        self.logging.info("[SUCCESS] CANoe quit cleanly.")
    except Exception as e:
        self.logging.warning(f"Clean quit failed (this is common): {e}. Will now forcefully terminate the process.")
        subprocess.run(['taskkill', '/F', '/IM', 'CANoe64.exe'], check=False, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        self.app = None
        self.logging.info("[SUCCESS] CANoe process forcefully terminated.")

  def activate_end_block(self, block_name, activate=True):
    """
    Activate or Deactivate Block in Measurement Setup. This function only supported by CANoe version 16 SP 2 and above.
    - ``block_name`` - The name of the block in Measurement Setup. Example Logging.
    - ``activate`` - To activate or deactivate the block. Default value is True.
    *Examples*
    | Activate End Block | Logging | | | #Activate the Logging block |
    | Activate End Block | Logging | ${True} | | #Activate the Logging block |
    | Activate End Block | Logging | ${False} | | #Deactivate the Logging block |
    """
    if self.app is None: raise RuntimeError("CANoe not open.")
    if self.app.Version.major >= 16:
        self.logging.debug(f"Activating/Deactivating end block '{block_name}': {activate}")
        self.app.Configuration.OnlineSetup.ActivateEndBlock(block_name, activate)
    else:
        self.logging.error(r'This function "Activate End Block" require CANoe version 16 SP 2 and above.')

  def set_trace_logging(self, log_file_path, canoe_logging_block=1):
    """
    Set the filepath for the logging
    - ``log_file_path`` - The filepath for the log file
    - ``canoe_logging_block`` - Specify which logging block to set the filepath. Default value is 1 for first logging block.
    """
    if self.app is None:
        raise RuntimeError("CANoe not open.")
    
    # This function should ONLY set the path.
    canoe_logging = self.app.Configuration.OnlineSetup.LoggingCollection(canoe_logging_block)
    canoe_logging.FullName = log_file_path
    
    # It should NOT try to set .Enabled here.
    
    self.trigger_logging = canoe_logging.Trigger

  def start_trace_logging(self):
    """
    Start logging
    *Examples*
    | Start Trace Logging |
    """
    if self.trigger_logging != None:
      if self.trigger_logging.Active:
        self.logging.debug('Trace logging already started.')
      else:
        self.trigger_logging.Start()
        self.logging.debug('Starting trace logging.')
    else:
      self.logging.error('Trace logging not set, unable to start logging')

  def stop_trace_logging(self):
    """
    Stop logging
    *Examples*
    | Stop Trace Logging |
    """
    if self.trigger_logging != None:
      if self.trigger_logging.Active:
        self.trigger_logging.Stop()
        self.logging.debug('Stop trace logging.')
      else:
        self.logging.debug('Trace logging not started')
    else:
      self.logging.error('Trace logging not set, unable to stop logging')

  def get_write_window_logging(self):
    """
    Get the write window logs
    """
    if (self.app != None):
      result = self.app.UI.Write.Text
      return str(result)
    else:
      raise RuntimeError("CANoe is not open, unable to get write window logging")

  def get_signal(self, bus_type,channel_num,msg_name,sig_name):
    """
    Get the value of a raw CAN signal on the CAN simulation bus
    - ``bus_type`` - Bus type e.g. "CAN", "LIN" and etc.
    - ``channel_num`` - Which channel we will read the signal, usually start from 1, Check with CANoe can channel setup.
    - ``msg_name`` - Message name to which the signal belong. Check DBC setup.
    - ``sig_name`` - String value of the signal to be read
    *Examples*
    | Get Signal | CAN | 1 | msg_name | sig_name |
    """
    if (self.app != None):
      result = self.app.GetBus(bus_type).GetSignal(channel_num, msg_name, sig_name)
      self.logging.debug("Get signal: %s:%s:%s:%s = %s", bus_type,channel_num,msg_name,sig_name, result.Value)
      return result.Value
    else:
      raise RuntimeError("CANoe is not open,unable to GetVariable")

  def set_signal(self,bus_type,channel_num,msg_name,sig_name,value):
    """
    Set the value of a raw CAN signal on the CAN simulation bus
    - ``bus_type`` - Bus type e.g. "CAN", "LIN" and etc.
    - ``channel_num`` - Which channel we will read the signal, usually start from 1, Check with CANoe can channel setup.
    - ``msg_name`` - Message name to which the signal belong. Check DBC setup.
    - ``sig_name`` - String value of the signal to be read
    - ``value`` - String value wanted to set
    *Examples*
    | Set Signal | CAN | 1 | msg_name | sig_name | 1 |
    """
    if (self.app != None):
      result = self.app.GetBus(bus_type).GetSignal(channel_num, msg_name, sig_name)
      self.logging.debug("Get signal: %s:%s:%s:%s = %s", bus_type,channel_num,msg_name,sig_name, result.Value)
      result.Value = value
      time.sleep(1)
      checker = self.get_signal(bus_type,channel_num,msg_name,sig_name)
      self.logging.debug("checker=%s, set value=%s",checker,value)
      if(str(checker)!=str(value)):
        self.logging.error("Unable to set the value of signal '%s:%s:%s:%s' to %s", bus_type,channel_num,msg_name,sig_name, value)
      else:
        self.logging.debug("Set the value of signal '%s:%s:%s:%s' to %s", bus_type,channel_num,msg_name,sig_name, value)
    else:
      raise RuntimeError("CANoe is not open,unable to GetVariable")
    pass

  def get_environment_variable(self, variable):
    """
    Get the value of environment variable
    - ``variable`` - variable name
    *Examples*
    | Get Environment Variable | var |
    """
    if (self.app != None):
      result = self.app.Environment.GetVariable(variable)
      self.logging.debug("Environment variable: %s = %s", variable,result)
      return (result.Value)
    else:
      raise RuntimeError("CANoe is not open,unable to GetVariable")

  def set_environment_variable(self, variable, value):
    """
    Set the value of environment variable
    - ``variable`` - variable name
    - ``value`` - value of variable to set
    *Examples*
    | Set Environment Variable | var | 1 |
    """
    if (self.app != None):
      result = self.app.Environment.GetVariable(variable)
      result.Value = value
      time.sleep(1)
      checker = self.get_environment_variable(variable)
      self.logging.debug("checker=%s, set value=%s",checker,value)
      if(str(checker)!=str(value)):
        self.logging.error("Unable to set the value of environment variable '%s' to %s", variable, value)
      else:
        self.logging.debug("Set the value of environment variable '%s' to %s", variable, value)
    else:
      raise RuntimeError("CANoe is not open, unable to SetVariable")

  def get_system_variable(self, ns_name, sysvar_name):
    """
    Get system variable
    - ``ns_name`` - system name space
    - ``sysvar_name`` - system variable name
    *Examples*
    | Get System Variable | namespace | sysvar |
    """
    if (self.app != None):
      systemCAN = self.app.System.Namespaces
      sys_namespace = systemCAN(ns_name)
      sys_value = sys_namespace.Variables(sysvar_name)
      self.logging.debug("System variable: %s:%s = %s", ns_name,sysvar_name,sys_value.Value)
      return sys_value.Value
    else:
      raise RuntimeError("CANoe is not open,unable to GetVariable")

  def set_system_variable(self, ns_name, sysvar_name, value):
    """
    Set system variable
    - ``ns_name`` - system namespace
    - ``sysvar_name`` - system variable name
    - ``value`` - value of the system variable to set
    *Examples*
    | Set System Variable | namespace | sysvar | 1 |
    """
    if (self.app != None):
      systemCAN = self.app.System.Namespaces
      sys_namespace = systemCAN(ns_name)
      sys_value = sys_namespace.Variables(sysvar_name)
      sys_value.Value = value
      time.sleep(1)
      checker = self.get_system_variable(ns_name, sysvar_name)
      self.logging.debug("checker=%s, set value=%s",checker,value)
      if(str(checker)!=str(value)):
        raise AssertionError("Unable to set the system variable '" + str(sysvar_name) + "' to " + str(value))
      else:
        self.logging.debug("Set the value of system variable '%s' to %s", sysvar_name, value)
    else:
      raise RuntimeError("CANoe is not open,unable to GetVariable")

  def get_system_variable_diag(self, ns_name, sysvar_name, hex_val=False):
    """
    Get system variable diag (additional conversion to unsigned int and option to return hex)
    - ``ns_name`` - system name space
    - ``sysvar_name`` - system variable name
    - ``hex_val`` - return variable in hex form
    *Examples*
    | Get System Variable Diag | namespace | sysvar | ${True}
    """
    if (self.app != None):
      systemCAN = self.app.System.Namespaces
      sys_namespace = systemCAN(ns_name)
      sys_value = win32com.client.CastTo(sys_namespace.Variables(sysvar_name), "IVariable12")
      sys_value_new = []
      sys_value_new_hex = []
      # Convert signed value to unsigned
      if sys_value.IsArray:
        for i in range (len(sys_value.Value)):
          if (sys_value.Value[i] < 0):
            unsigned = ctypes.c_uint8(sys_value.Value[i])
            val = unsigned.value
          else:
            val = sys_value.Value[i]
          sys_value_new.append(val)
          sys_value_new_hex.append(hex(val))
      else:
        if sys_value.IsSigned:
          unsigned = ctypes.c_uint8(sys_value.Value)
          val = unsigned.value
        else:
          val = sys_value.Value
        sys_value_new = val
        sys_value_new_hex= hex(val)
      if hex_val:
        return_val = sys_value_new_hex
      else:
        return_val = sys_value_new
      self.logging.debug("System variable: %s:%s = %s", ns_name,sysvar_name,return_val)
      return return_val
    else:
      raise RuntimeError("CANoe is not open,unable to GetVariable")

  def set_system_variable_diag(self, ns_name, sysvar_name, value):
    """
    Set system variable diag
    - ``ns_name`` - system namespace
    - ``sysvar_name`` - system variable name
    - ``value`` - value of the system variable to set
    *Examples*
    | Set System Variable Diag | namespace | sysvar | 1 |
    """
    if (self.app != None):
      systemCAN = self.app.System.Namespaces
      sys_namespace = systemCAN(ns_name)
      sys_value = sys_namespace.Variables(sysvar_name)
      sys_value.Value = value
      time.sleep(1)
      checker = self.get_system_variable_diag(ns_name, sysvar_name)
      self.logging.debug("checker=%s, set value=%s",checker,value)
      if(str(checker)!=str(value)):
        raise AssertionError("Unable to set the system variable '" + str(sysvar_name) + "' to " + str(value))
      else:
        self.logging.debug("Set the value of system variable '%s' to %s", sysvar_name, value)
    else:
      raise RuntimeError("CANoe is not open,unable to GetVariable")

  def get_all_system_variable(self, ns_name):
    """
    Get all system variable
    - ``ns_name`` - system namespace
    *Examples*
    | Get All System Variable | namespace |
    """
    if (self.app != None):
      sysvars={}
      systemCAN = self.app.System.Namespaces
      sys_namespace = systemCAN(ns_name)
      sys_value = sys_namespace.Variables
      self.logging.debug("get_all_system_variable for '%s'", ns_name)
      for sys in sys_value:
        sysvars[sys.Name] = sys.Value
      return sysvars
    else:
      raise RuntimeError("CANoe is not open,unable to GetVariable")

  def add_measurement_port(self, networkname="Eth", portname="Port1", segmentname="Switch1"):
    """
    Add ethernet measurement port. This only needed for ethernet bus when in Network-based Access mode.
    - ``networkname`` - Ethernet network name based on name configured in Vector Hardware Manager
    - ``portname`` - Port name based on name configured in Vector Hardware Manager
    - ``segmentname`` - Segment name based on name configured in Vector Hardware Manager
    *Examples*
    | Add Measurement Port | Eth | Port2 | Switch
    """
    if (self.app != None):
      activated = False
      portslist = None
      buses = self.app.Configuration.SimulationSetup.Buses
      # Go through available buses and get the list of activated ports for specified network name
      for x in range(1, buses.Count + 1):
        bus = win32com.client.CastTo(buses.Item(x), "IBusVB6")
        if bus.Name == networkname:
          portslist = bus.Ports
          break;
      #Go through list of activated ports
      if portslist != None:
        if portslist.IsPortBasedConfig:
          for index in range(1, portslist.Count + 1):
            port = win32com.client.CastTo(portslist.Item(index), "IPort2")
            if(port.Name == portname):
              # portname exist in list of activated ports.
              self.logging.debug(port.Name + " available and active is " + str(port.IsActive))
              activated = True
          # portname not exist in list of activated ports.
          if not activated:
            self.logging.debug(portname + " not available. Add to measurement port")
            eth_port=win32com.client.CastTo(portslist.Add(portname, segmentname), "IPort2")
            eth_port.IsActive = True
            eth_port.IsSimulated = False
          return True
        else:
          self.logging.error('This function "Add Measurement Port" only applicable to Network-based Access mode.')
          return False
      else:
          self.logging.error('Network name "' + networkname + '" not available. Thus, no portslist.')
          return False
    else:
      raise RuntimeError("CANoe is not open, unable to add measurement port")

  def run_test_module(self, test_module_name, detail = False, timeout = 60, test_folder_name = None):
    """
    Run test module and get overall test module result
    - ``test_module_name`` - test module name
    - ``detail`` - return with details or overall result, default is False
    - ``timeout`` - test module execution time limit (in seconds), default is 60
    - ``test_folder_name`` - test folder name which contain the test module
    *Examples*
    | Run Test Module | test1 |
    | Run Test Module | test2 | ${True} | 30
    | Run Test Module | test3 | ${True} | 30 | Keyword
    """
    for i in range(1, self.app.Configuration.TestSetup.TestEnvironments.Count + 1):
      test_environment = win32com.client.CastTo(self.app.Configuration.TestSetup.TestEnvironments.Item(i), "ITestEnvironment2")
      test_module_exist = False
      if test_folder_name != None:
        # test module in folder
        for j in range(1, test_environment.Folders.Count + 1):
          test_folder = test_environment.Folders.Item(j)
          if test_folder.Name == test_folder_name:
            for k in range(1, test_folder.TestModules.Count + 1):
              test_module = test_folder.TestModules.Item(k)
              if test_module.Name == test_module_name and test_module.Enabled:
                test_module_exist = True
                break
      else:
        # test module not in folder
        for j in range(1, test_environment.TestModules.Count + 1):
          test_module = test_environment.TestModules.Item(j)
          if test_module.Name == test_module_name and test_module.Enabled:
            test_module_exist = True
            break
      if test_module_exist :
        win32com.client.WithEvents(test_module, CanoeEventHandler)
        self.logging.debug("Start test: %s" % (os.path.basename(test_module.FullName)))
        test_completed.clear()
        test_module.Start()
        start_time = time.time()
        while not test_completed.is_set():
          pythoncom.PumpWaitingMessages()
          time.sleep(1)
          if time.time() - start_time > timeout:
            self.logging.debug("Test timeout")
            test_module.Stop()
            break
            # if detail:
            #   return []
            # else:
            #   return False
          self.logging.debug("sleep")
        self.logging.debug("Write Windows Logging:\n" + str(self.get_write_window_logging()))
        #self.logging.debug("Test report: " + str(test_module.Report.LastWrittenFullName))
        if test_module.Verdict == 1 and test_success.is_set():
          self.logging.debug("CANoe Test Module passed: " + test_module.Name)
          if detail:
            return self._get_test_module_details(test_module)
          else:
            return True
        else:
          raise AssertionError("CANoe Test Module failed: " + test_module.Name)
          if detail:
            return self._get_test_module_details(test_module)
          else:
            return False
      else:
        raise AssertionError("CANoe Test Module not found in test environment: " + test_module_name)
        return False
  def add_capl_node(self, capl_file_path):
    if self.app is None:
        raise RuntimeError("CANoe not open.")

    self.logging.info(f"Adding CAPL node: {capl_file_path}")
    sim_setup = self.app.Configuration.SimulationSetup
    node_name = os.path.splitext(os.path.basename(capl_file_path))[0]

    node_exists = False
    for i in range(1, sim_setup.Nodes.Count + 1):
        if sim_setup.Nodes.Item(i).Name == node_name:
            self.logging.warning(f"Node '{node_name}' already exists. Re-using it.")
            node_exists = True
            break
    
    if not node_exists:
        # The single-step Add(name, path) command is the key.
        sim_setup.Nodes.Add(node_name, capl_file_path)
        self.logging.debug("Node added successfully in one step.")
    
    self.compile_capl()
    self.logging.info(f"[SUCCESS] CAPL node '{node_name}' is present and compiled.")
  def _get_test_module_details(self, item):
    """
    Private function to return details of test case of test module
    - ``item`` - TestModule object
    """
    details = []
    for i in range(1, item.Sequence.Count + 1):
      try:
        test_case = win32com.client.CastTo(item.Sequence.Item(i), "ITestCase")
        details.append({ "name": test_case.Name, "ident": test_case.Ident, "verdict": test_case.Verdict })
      except pywintypes.com_error as ex:
        if ex.args[0] == winerror.DISP_E_MEMBERNOTFOUND: # -2147352573 / item has no verdict, should be test group
          #not supporting ITestGroup for time being
          #test_group = win32com.client.CastTo(item.Sequence.Item(i), "ITestGroup")
          raise ex
        elif ex.args[0] == winerror.DISP_E_EXCEPTION: # -2147352567 / item has no ident
          details.append({ "name": test_case.Name, "ident": "", "verdict": test_case.Verdict })
        else:
          raise ex
    return details
